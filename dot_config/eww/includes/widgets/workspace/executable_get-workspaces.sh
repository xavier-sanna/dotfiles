#!/bin/bash

workspaces() {
	workspaces_json=$(hyprctl workspaces -j)
	workspacerules_json=$(hyprctl workspacerules -j)
	monitors_json=$(hyprctl monitors -j)
	binds_json=$(hyprctl binds -j)
	clients_json=$(hyprctl clients -j)
	clients_config_json=$(jq -r '.' ~/.config/eww/includes/widgets/workspace/clients-config.json)

	# Build the clients class/title => icon map
	clients_map=$(jq --argjson config "$clients_config_json" --argjson workspaces "$workspaces_json" '
	 reduce .[] as $item (
   {}; .[$item.workspace.id|tostring] += [{ 
     name: (
	       if $config[$item.class] | type == "object"
	       then
           (
             $config[$item.class].extra[] as {$title, $name} |
             if 
               ($item.title | test($title)) 
             then 
               $name 
             else 
               empty 
             end
           ) // $config[$item.class].defaultName
	       else
	          $config[$item.class] // $config["defaultName"]
	       end
     ),
     lastActive: (
     if $workspaces | .[] | select((.id == $item.workspace.id) and (.lastwindow == $item.address))
       then
         true
       else
         empty
       end // false
     ) 
   }]
	)' <<<"$clients_json")

	# Create the initial structure from monitors
	initial_structure=$(jq '
  map({
    key: (.id | tostring),
    value: {
      name: .name,
      workspaces: []
    }
  }) | from_entries' <<<"$monitors_json")

	# Create a mapping of monitor names to IDs
	monitor_map=$(jq '
  map({
    (.name): {id: .id, activeWorkspaceId: .activeWorkspace.id},
  }) | add' <<<"$monitors_json")

	# Populate workspaces from rules
	workspaces_populated=$(jq --argjson initial "$initial_structure" --argjson monitor_map "$monitor_map" --argjson clients "$clients_map" '
  reduce .[] as $item ($initial;
    .[$monitor_map[$item.monitor].id | tostring].workspaces += [{
      id: ($item.workspaceString | tonumber),
      name: $item.workspaceString,
      active: false,
      empty: true,
      clients: ($clients[$item.workspaceString] // [])
    }]
  )' <<<"$workspacerules_json")

	# Update states with monitor maps and busy workspaces
	workspaces_stateful=$(jq --argjson ws_populated "$workspaces_populated" --argjson monitor_map "$monitor_map" '
  reduce .[] as $item ($ws_populated;
    .[$item.monitorID | tostring].workspaces |= map(
      if (.id | tostring) == ($item.id | tostring) then
        . + {
          active: ($monitor_map[$item.monitor | tostring].activeWorkspaceId == $item.id),
          empty: false
        }
      else
        .
      end
    )
  )' <<<"$workspaces_json")

	# Build a map of workspace binds with their key
	workspace_keys_map=$(jq '
	     map(select(.dispatcher == "workspace")) |
	     map(select(.description|test("select workspace:"))) |
	     map({workspaceID: .arg, key: .key})
	   ' <<<"$binds_json")

	# Update workspace names with keys from the additional dataset
	workspaces_keys=$(jq --argjson stateful "$workspaces_stateful" --argjson keys "$workspace_keys_map" '
  . as $in
  | $keys as $keysData
  | $keysData
  | reduce .[] as $keyItem ($stateful; 
      . as $wsStateful 
      | reduce ($wsStateful | to_entries)[] as $monEntry (
          $wsStateful;
          .[$monEntry.key].workspaces |= map(
              if .id == ($keyItem.workspaceID | tonumber) then
                  .name = $keyItem.key
              else
                  .
              end
          )
      )
  )' <<<"$workspaces_stateful")

	echo "$workspaces_keys" | jq -c
}

workspaces
socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | while read -r; do
	workspaces
done
