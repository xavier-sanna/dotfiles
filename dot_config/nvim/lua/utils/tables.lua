local tables = {}

function tables.check(item, haystack)
	for _, v in ipairs(haystack) do
		if v == item then
			return true
		end
	end

	return false
end

function tables.merge(into, from)
	local stack = {}
	local node1 = into
	local node2 = from
	while true do
		for k, v in pairs(node2) do
			if type(v) == "table" and type(node1[k]) == "table" then
				table.insert(stack, { node1[k], node2[k] })
			else
				node1[k] = v
			end
		end
		if #stack > 0 then
			local t = stack[#stack]
			node1, node2 = t[1], t[2]
			stack[#stack] = nil
		else
			break
		end
	end
	return into
end

function tables.merge_simple(a, b)
	local c = {}
	for k, v in pairs(a) do
		c[k] = v
	end
	for k, v in pairs(b) do
		c[k] = v
	end
	return c
end

return tables
