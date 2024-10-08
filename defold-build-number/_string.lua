local M = {}

function M.split(input, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(input, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end


function M.endswith(input, suffix)
	return string.sub(input, -#suffix) == suffix
end

return M