#!/bin/bash
# Parsing configuration
config_filepath="$XDG_CONFIG_HOME/megasync/settings.json"
config_data=$(cat "$config_filepath")

echo "============================="
echo "*** Parsing configuration ***"
echo "============================="
if [ ! -f "$config_filepath" ]; then
	echo "ERROR: Configuration file: \$XDG_CONFIG_HOME/megasync/settings.json was not found."
	exit 1
fi

# check if mega-cmd-server is running
MEGASRV="mega-cmd-server"
running=false

echo "===================="
echo "*** Mega Server ***"
echo "==================="
echo "Is mega-cmd-server running?"

if pgrep -x "$MEGASRV" >/dev/null; then
	echo "yes"
	running=true
else
	echo "no"
fi

if [[ "$running" == false ]]; then
	echo "Launching megaCMD server..."
	nohup mega-cmd-server &>/dev/null &
fi

echo " "

# check if logged in with mega-login command
output_login="$(mega-login)"
regxp_login='^\[API:err: (((([0-1][0-9])|(2[0-3])):?[0-5][0-9]:?[0-5][0-9]+))\] Already logged in. Please log out first.$'
logged_in=false

echo "============="
echo "*** Login ***"
echo "============="
while IFS= read -r line; do
	if [[ "$line" =~ $regxp_login ]]; then
		echo "Already logged in."
		logged_in=true
	fi
done <<<"$output_login"

if [[ "$logged_in" == false ]]; then
	echo "Please provide credentials for login."
	read -rp 'Email: ' mega_email
	read -rsp 'Password: ' mega_passwd
	mega-login "$mega_email" "$mega_passwd"
fi

echo " "

# check direcotries configuration
echo "======================================"
echo "*** Check sync directories mapping ***"
echo "======================================"

echo "The following directories will be synced:"
echo " "

while read -r directory; do
	src=$(echo "$directory" | jq -r .src)
	dest=$(echo "$directory" | jq -r .dest)

	echo "*  [source] ${src} => [destination] ${dest}"
done < <(echo "$config_data" | jq -c '.directories[]')

while true; do
	read -r -p "Do you want to proceed? (y/n) " yn

	case $yn in
	[yY])
		echo ""
		break
		;;
	[nN])
		echo ""
		echo exiting...
		exit
		;;
	*) echo invalid response ;;
	esac
done

# check if directories from json conf are created
# if not create them
regxp_sync_error='^\[API:err: (((([0-1][0-9])|(2[0-3])):?[0-5][0-9]:?[0-5][0-9]+))\] Failed to sync folder: Already exists. Active sync same path$'

while read -r directory; do
	src=$(echo "$directory" | jq -r .src)
	dest=$(echo "$directory" | jq -r .dest)

	echo "syncing: ${src} => ${dest}"

	if [[ ! -e $dest ]]; then
		echo "creating folder $dest"
		mkdir -p "$dest"
	fi

	mega-sync "$dest" "$src"

	echo " "
done < <(echo "$config_data" | jq -c '.directories[]')
