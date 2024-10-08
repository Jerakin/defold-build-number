local git = require "defold-build-number._git"
local version = require "defold-build-number._version"
local inifile = require "defold-build-number.inifile"

local M = {}

---@class build_number.options
---@field distance string Format used when there have been commits since the most recent tag
---@field dirty string Format used when there are uncommitted changes
---@field distance_dirty string Format used when there are both commits and uncommitted changes

local _default_options = {
	distance = "{next_version}.dev{distance}+{vcs}{rev}",
	dirty = "{base_version}+d{build_date}",
	distance_dirty = "{next_version}.dev{distance}+{vcs}{rev}.d{build_date}",
	game_project = "game.project"
}

local function get_version()
	if not git.is_git_repository() then
		return nil, "fatal: not a git repository"
	end

	if git.is_shallow() then
		git.fetch_shallow()
	end

	local status, result = pcall(git.get_git_describe)
	if status then
		return version.version(git.parse_git_describe(result))
	else
		-- No tags found
		return nil, "fatal: no tags found"
	end
end

local function _merge_options(options)
	options = options or {}
	for key, value in pairs(_default_options) do
		if options[key] == nil then
			options[key] = value
		end
	end
	return options
end

--- Returns the formated version, or nil if an error occured.
---@param options? build_number.options
---@return string?, string? The version number if successful, nil and error message pair if not.
function M.get_version(options)
	options = _merge_options(options)
	local version_, error = get_version()
	if version_ == nil then
		return version_, error
	else
		return version_:format(options)
	end
end


--- Writes the version number directly to the game project file
---@param options? build_number.options
---@return nil
function M.write_version_to_game_project(options)
	options = _merge_options(options)
	local new_version, error = M.get_version(options)
	if new_version == nil then
		print(error)
		return
	end
	local file = editor.external_file_attributes(options.game_project)
	local ini = inifile.parse(file.path)
	if ini.project.version ~= new_version then
		ini.project.version = new_version
		inifile.save(file.path, ini)
	end
end


--- Writes the version number to the file specified. This should be a lua module.
---@param options? build_number.options
---@return nil
function M.write_version_file(file_path, options)
	options = _merge_options(options)
	local new_version, error = M.get_version(options)
	if new_version == nil then
		print(error)
		return
	end
	local resolved_path = editor.external_file_attributes(file_path).path
	local file = assert(io.open(resolved_path, "w"))
	file:write('local M = {}\n\nM.version = "'.. new_version .. '"\n\nreturn M')
	file:close()
end

return M