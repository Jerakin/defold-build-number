# Defold Build Number

# Install
You can use the these editor scripts in your own project by adding this project as a Defold library dependency. Open your game.project file and in the dependencies field under project add:

`https://github.com/Jerakin/defold-build-number/archive/main.zip`

# Setup

Add a `hooks.editor_script` in your project. Add one of the life time functions. 
`M.on_build_started(opts)` and/or `M.on_bundle_started(opts)`. You can then use these to
add a version file or overwriting the game.project file directly.

```lua
local build_number = require "defold-build-number.build_number"

local M = {}

function M.on_bundle_started(opts)
    build_number.write_version_to_game_project()
end

function M.on_build_started(opts)
    build_number.write_version_file("main/version.lua")
end

return M
```

# Usage

### `build_number.write_version_to_game_project(options)`
Write the version directly into your projects version at

```ini
[project]
version = 0.1.0
```

### `build_number.write_version_file(file_name, options)`
Write the version to a file. The file will be overwritten. The content of the file is 

```
local M = {}
M.version = "0.1.0"
return M
```

### `build_number.get_version(options)`
Returns the new version number, you can do whatever you want with this I guess.


# Options
You can pass in a table with the following entries to customize how you want your version to look like.
You build the strings up with `placeholders`.

### `distance`
Format used when there have been commits since the most recent tag

**Default**: 
`"{next_version}.dev{distance}+{vcs}{rev}"`

#### `dirty`
Format used when there are uncommitted changes

**Default**: 
`"{base_version}+d{build_date}"`

#### `distance_dirty`
Format used when there are both commits and uncommitted changes

**Default**: 
`"{next_version}.dev{distance}+{vcs}{rev}.d{build_date}"`

#### `game_project`
Name of your project file.

**Default**: 
`"game.project"`


## placeholders
* `{base_version}` The version extracted from the most recent tag.
* `{new_version}` The next release version. This will always increment the smallest number (patch or pre-release number).
* `{distance}` The number of commits since the most recent tag.
* `{vcs}` The first letter of the name of the VCS (only [g]it is supported).
* `{rev}` The abbreviated hash of the HEAD commit.
* `{build_date}` The (current) date in a %Y%m%d format.
