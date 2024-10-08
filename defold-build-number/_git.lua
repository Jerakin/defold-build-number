local _string = require "defold-build-number._string"

local M = {}

function M.is_shallow()
	local attributes = editor.external_file_attributes(".git/shallow")
	return attributes.exists
end


function M.fetch_shallow()
	local status = editor.execute("git", "fetch", "--unshallow", {
		reload_resources = false,
		out = "capture"
	})
	return status
end


function M.is_git_repository()
	local attributes = editor.external_file_attributes(".git")
	return attributes.exists
end


function M.get_git_describe()
	local status = editor.execute("git", "describe", "--dirty", "--tags", "--long","--match", "*[0-9]*", {
		reload_resources = false,
		out = "capture"
	})
	return status
end


function M.parse_git_describe(describe_output)
	local tag, distance, sha, dirty
	if _string.endswith(describe_output, "-dirty") then
		dirty = true
		describe_output = string.gsub(describe_output,  "-dirty", "")
	else
		dirty = false
	end

	local split = _string.split(describe_output, "%-") -- split on "-"
	if #split < 3 then
		tag = describe_output
		distance = "0"
		sha = nil
	else
		distance = split[#split+1-2]
		sha = split[#split+1-1]
		if #split >=4 then
			table.remove(split, #split+1-2)
			table.remove(split, #split+1-1)
			tag = table.concat(split,"-")
		else
			tag = split[1]
		end
	end
	return tag, distance, sha, dirty
end

return M