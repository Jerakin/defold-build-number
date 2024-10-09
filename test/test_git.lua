local git = require "defold-build-number._git"


return function()
	describe("git describe parse", function()
		test("On release tag", function()
			assert(git.parse_git_describe("1.0.0-0-g4ac2448") == "1.0.0", "0", "g4ac2448", false)
		end)
		test("On prerelease tag", function()
			assert(git.parse_git_describe("1.0.0-alpha.1-0-g4ac2448") == "1.0.0-alpha.1", "0", "g4ac2448", false)
		end)
		test("On dirty release tag", function()
			assert(git.parse_git_describe("1.0.0-0-gc6c29c3-dirty") == "1.0.0", "0", "g4ac2448", true)
		end)
		test("On distance release tag", function()
			assert(git.parse_git_describe("1.0.0-1-gfb6eb15") == "1.0.0", "1", "gfb6eb15", false)
		end)
		test("prefixed release tag", function()
			assert(git.parse_git_describe("v1.0.0-0-gfb6eb15") == "v1.0.0", "1", "gfb6eb15", false)
		end)
	end)
end