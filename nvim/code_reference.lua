-- Yank the current lines with a repo/branch/commit/path header, so XiaoSteve
-- can be asked about code he cannot see. Works in Normal and Visual mode.
local M = {}

local function git_line(dir, args)
	local out = vim.fn.systemlist(vim.list_extend({ "git", "-C", dir }, args))
	if vim.v.shell_error ~= 0 then
		return nil
	end
	return out[1]
end

local function code_reference()
	local start_line, end_line = vim.fn.line("v"), vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end
	local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

	local file = vim.api.nvim_buf_get_name(0)
	local dir = vim.fn.fnamemodify(file, ":h")
	local toplevel = git_line(dir, { "rev-parse", "--show-toplevel" })
	if toplevel == nil then
		return table.concat(lines, "\n")
	end

	local remote = git_line(dir, { "remote", "get-url", "origin" })
	local repo = remote and remote:gsub("%.git$", ""):gsub(".*[/:]", "") or vim.fn.fnamemodify(toplevel, ":t")
	local branch = git_line(dir, { "rev-parse", "--abbrev-ref", "HEAD" }) or "?"
	local commit = git_line(dir, { "rev-parse", "--short", "HEAD" }) or "?"
	local path = file:sub(#toplevel + 2)

	local working_state = ""
	if vim.bo.modified then
		working_state = " [UNSAVED buffer]"
	elseif git_line(dir, { "status", "--porcelain", "--", file }) then
		working_state = " [uncommitted]"
	end

	return table.concat({
		repo .. " @ " .. branch .. " " .. commit .. working_state,
		path .. ":" .. start_line .. "-" .. end_line,
		"",
		"```" .. vim.bo.filetype,
		table.concat(lines, "\n"),
		"```",
	}, "\n")
end

function M.copy()
	local reference = code_reference()
	vim.fn.setreg("+", reference)
	vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "n", false)
	vim.notify("Copied code reference (" .. #vim.split(reference, "\n") .. " lines)")
end

return M
