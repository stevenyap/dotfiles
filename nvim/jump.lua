-- Walk the hunks under review or the buffer's diagnostics, then step to the
-- neighbouring window, then wrap to the far end of the list.
local M = {}

local function show_diagnostic_float(diagnostic, bufnr)
	if diagnostic == nil then
		return
	end
	vim.diagnostic.open_float({ bufnr = bufnr, scope = "line" })
end

-- An exhausted direction is this mapping's cue to leave the window, so
-- mini.diff announcing it would be reporting a non-event
local function without_notifications(action)
	local notify = vim.notify
	vim.notify = function() end
	local ok, err = pcall(action)
	vim.notify = notify
	if not ok then
		error(err)
	end
end

local function buffer_is_under_review()
	if not require("review_base").is_active() then
		return false
	end
	return require("mini.diff").get_buf_data(0) ~= nil
end

local function jumped_to_hunk(direction, wrap)
	local diff = require("mini.diff")
	local line_before = vim.api.nvim_win_get_cursor(0)[1]
	without_notifications(function()
		diff.goto_hunk(direction, { wrap = wrap })
	end)
	return vim.api.nvim_win_get_cursor(0)[1] ~= line_before
end

local function jumped_to_diagnostic(step, wrap)
	local search = step > 0 and vim.diagnostic.get_next or vim.diagnostic.get_prev
	local diagnostic = search({ wrap = wrap })
	if diagnostic == nil then
		return false
	end
	vim.diagnostic.jump({ diagnostic = diagnostic, on_jump = show_diagnostic_float })
	return true
end

local function moved_to_window(towards)
	local window_before = vim.api.nvim_get_current_win()
	vim.cmd.wincmd(towards)
	return vim.api.nvim_get_current_win() ~= window_before
end

function M.hunk_or_diagnostic(direction)
	local step = direction == "next" and 1 or -1
	local neighbouring_window = direction == "next" and "j" or "k"

	local function jumped_to_item(wrap)
		if buffer_is_under_review() then
			return jumped_to_hunk(direction, wrap)
		end
		return jumped_to_diagnostic(step, wrap)
	end

	return function()
		if jumped_to_item(false) then
			return
		end
		if moved_to_window(neighbouring_window) then
			return
		end
		jumped_to_item(true)
	end
end

return M
