local M = {}

---@class build_number.version_data
---@field base_version string
---@field distance string
---@field rev string
---@field dirty string
---@field format fun()

local function guess_next(version)
	local t = {}
	-- Find all numbers
	for str in string.gmatch(version, "%d+") do
		table.insert(t, str)
	end
	local lastn = t[#t]
	local guessed_version = version:reverse():gsub("^"..lastn, tostring(tonumber(lastn)+1)):reverse()
	if guessed_version == version then
		-- If our version doesn't end on a number then it should means it's a pre-release if it's
		-- a pre-release without a number then the next pre-release should just have a .1 added
		return guessed_version .. ".1"
	end
	return guessed_version
end


---@param self build_number.version_data
---@param options build_number.options
local function format(self, options)
	local pattern = "{base_version}"
	if self.dirty then
		pattern = options.dirty
		if self.distance ~= "0" then
			pattern = options.distance_dirty
		end
	else
		if self.distance ~= "0" then  -- With zero and dirty it means we are on a tagged commit.
			pattern = options.dirty
		end
	end
	local formatted = pattern:gsub("{base_version}", self.base_version)
	formatted = formatted:gsub("{next_version}", guess_next(self.base_version))
	formatted = formatted:gsub("{distance}", self.distance)
	formatted = formatted:gsub("{vcs}", "g")
	formatted = formatted:gsub("{rev}", self.rev)
	formatted = formatted:gsub("{build_date}", os.date("%Y%m%d"))
	
	return formatted
end


function M.version(tag, distance, sha, dirty)
	local data = {
		base_version=tag,
		distance=distance,
		rev=sha,
		dirty=dirty,
		format=format
	}
	return data
end

return M