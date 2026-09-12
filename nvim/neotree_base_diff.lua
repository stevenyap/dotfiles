-- neo-tree's git.status (lua/neo-tree/git/init.lua) returns early without the
-- diff against git_base when `git status` output is unchanged since the last
-- call, so a git_status tree opened a second time shows "working tree clean".
-- Delete once that cached branch returns the base diff upstream.
local M = {}

function M.setup()
	local git = require("neo-tree.git")
	local status_that_drops_base_diff_on_cache_hit = git.status
	git.status = function(path, base_lookup, skip_bubbling, status_opts)
		local git_status, worktree_root, diff_over_base =
			status_that_drops_base_diff_on_cache_hit(path, base_lookup, skip_bubbling, status_opts)
		local base = worktree_root and base_lookup and base_lookup[worktree_root]
		if base and diff_over_base == nil then
			diff_over_base = require("neo-tree.git.diff").diff_name_status(worktree_root, base, skip_bubbling)
			git.worktrees[worktree_root].status_diff[base] = diff_over_base
		end
		return git_status, worktree_root, diff_over_base
	end
end

return M
