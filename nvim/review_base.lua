-- Diff every buffer against a branch base instead of the git index.
--   :ReviewBase origin/development  -> hunks are the branch's changes
--   :ReviewBase                     -> hunks are my own uncommitted edits
local M = {}

local function set_ref_text_from_rev(buf, rev)
	local diff = require("mini.diff")
	local file = vim.api.nvim_buf_get_name(buf)
	if file == "" then
		return diff.fail_attach(buf)
	end
	local dir = vim.fn.fnamemodify(file, ":h")
	vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--verify", "--quiet", rev .. "^{commit}" })
	if vim.v.shell_error ~= 0 then
		return diff.fail_attach(buf)
	end
	local text_at_rev = vim.fn.systemlist({ "git", "-C", dir, "show", rev .. ":./" .. vim.fn.fnamemodify(file, ":t") })
	local file_is_new_on_branch = vim.v.shell_error ~= 0
	diff.set_ref_text(buf, file_is_new_on_branch and {} or text_at_rev)
end

M.source = {
	name = "review-base",
	attach = function(buf)
		-- Failing here hands the buffer down to the git source
		if vim.g.review_base_rev == nil then
			return false
		end
		vim.schedule(function()
			set_ref_text_from_rev(buf, vim.g.review_base_rev)
		end)
	end,
}

local function restart_diff_in_all_buffers()
	local diff = require("mini.diff")
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
			pcall(diff.disable, buf)
			pcall(diff.enable, buf)
		end
	end
end

function M.setup()
	vim.api.nvim_create_user_command("ReviewBase", function(opts)
		vim.g.review_base_rev = opts.args ~= "" and opts.args or nil
		restart_diff_in_all_buffers()
		vim.notify("mini.diff ref: " .. (vim.g.review_base_rev or "git index"))
	end, { nargs = "?", desc = "Diff every buffer against a base revision" })
end

return M
