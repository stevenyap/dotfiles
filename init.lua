-- TODO Good way to restructure this file: https://gist.github.com/carderne/0dc6eb6ecc48a25192687ab533f71cc7

-- Using lazy.nvim to manage our plugins
-- https://github.com/folke/lazy.nvim
-- :Lazy home
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable-next-line: undefined-field (This is default code instruction from Lazy)
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Lua extracted out of this file lives in nvim/ next to it.
-- stdpath("config") is the ~/.config symlink, so resolve it to the repo path;
-- $MYVIMRC is not set yet while this file is being sourced.
-- package.path rather than rtp: lazy.nvim resets the runtimepath in setup().
local dotfiles_dir = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.stdpath("config") .. "/init.lua"), ":h")
package.path = dotfiles_dir .. "/nvim/?.lua;" .. package.path

-- NeoVim Settings
vim.g.python3_host_prog = dotfiles_dir .. "/pyenv/bin/python"
vim.g.loaded_perl_provider = 0
vim.o.syntax = "on"
vim.cmd("filetype plugin indent on")

-- Fix corrupted shada in multiple neovim/tmux sessions
vim.opt.shadafile = vim.fn.stdpath("state") .. "/shada/main.shada"
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
	callback = function()
		vim.cmd("silent! wshada")
	end,
})

-- Editor behavior and appearance settings
vim.opt.switchbuf = "useopen,usetab" -- Controls buffer switching behavior, 'useopen' finds existing window, 'usetab' switches tabs
vim.opt.splitbelow = true -- split and focus
vim.opt.splitright = true -- split and focus
vim.opt.hlsearch = true -- Highlights matches of the last searched pattern
vim.opt.incsearch = true -- Shows incremental search highlights as you type
vim.opt.wrap = false -- Disables text wrapping
vim.opt.clipboard = "unnamed" -- System clipboard integration
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo" -- Save all undo
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.history = 500
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Down and up: <c-j>/<c-k> fall through to them at the end of a list, <c-w>j/<c-w>k always
vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "Window left" })
vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "Window right" })

local jump = require("jump")
vim.keymap.set("n", "<c-j>", jump.hunk_or_diagnostic("next"), {
	desc = "Jump: next hunk/diagnostic, then the window below, then wrap to the first",
})
vim.keymap.set("n", "<c-k>", jump.hunk_or_diagnostic("prev"), {
	desc = "Jump: previous hunk/diagnostic, then the window above, then wrap to the last",
})

-- Shift + Enter = Esc
vim.keymap.set({ "i", "n", "v", "c", "t" }, "<S-CR>", "<Esc>", { silent = true, desc = "Escape" })

-- Switch between relative and absolute line numbers
vim.opt.relativenumber = true -- Show relative numbers by default
vim.opt.signcolumn = "yes" -- Always display the sign column, prevents text shifting when signs are displayed
vim.opt.number = true -- Enables line numbers on the left side of the window
vim.opt.cursorline = true -- Highlights the line under the cursor

-- File type overrides
vim.api.nvim_create_augroup("FileTypeOverrides", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.purs",
	command = "set filetype=purescript",
	group = "FileTypeOverrides",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.txt", "*.md", "*.snippets" },
	command = "setlocal wrap tabstop=2 shiftwidth=2 expandtab nofoldenable",
	group = "FileTypeOverrides",
})

-- Mappings
-- Rule: nothing shadows a native Vim command that does something j and k
-- cannot. Anything Vim does not ship lives under <Leader>, grouped by its
-- second key:
--   l? = LSP + logs   g? = git (incl. hunks)   t? = toggle   y? = yank   m? = AI
-- The exception is GRAMMAR, which cannot work behind a leader: hunk motions
-- ([h ]h [H ]H) and the hunk text object (ih) sit in Vim's own motion and
-- text-object namespaces, in slots Vim leaves empty.
-- Neovim's own gr*/]d/[d and every Vim g?/z? command are left untouched. The
-- one shadow taken on purpose is <c-j>/<c-k>, bought back from window down/up.
-- <Leader>? lists everything.
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set("n", "<Leader>s", ":wa<CR>", { desc = "Save all buffers" })
vim.keymap.set("n", "<Leader>/", ":nohlsearch<CR>", { desc = "Clear search highlight" })
vim.keymap.set("n", "<Leader>k", "i<CR><esc>", { desc = "Split line at cursor" })
vim.keymap.set("n", "<Leader>K", "0i<CR><esc>", { desc = "Split line at column 0" })
vim.keymap.set("n", "<Leader>lm", "<cmd>messages<CR>", { desc = "LSP/log: messages" })
vim.keymap.set("n", "<Leader>ya", "mcggVGy`c", { desc = "Yank: whole file" })
vim.keymap.set("n", "<Leader>tw", ":set wrap!<CR>", { desc = "Toggle: wrap" })
vim.keymap.set("n", "<Leader>tn", ":set relativenumber!<CR>", { desc = "Toggle: relative line numbers" })

--------------------
--- The plugins ----
--------------------
require("lazy").setup({
	-- Default is stdpath("config"), i.e. ~/.config/nvim, where only init.lua is
	-- symlinked -- the lockfile would never be committable. Keep it in the repo.
	lockfile = dotfiles_dir .. "/lazy-lock.json",

	-- LuaLS incorrectly inferred `dev` as boolean from lazydev plugin instead of lazy plugin
	---@diagnostic disable-next-line: assign-type-mismatch
	dev = {
		path = "~/Workspace/neovim",
	},

	spec = {
		-- AI Plugin
		-- Predictive AI Completion Plugin: https://github.com/monkoose/neocodeium
		-- Run `:NeoCodeium auth` to authenticate
		-- Register an account at https://windsurf.com/
		{
			"monkoose/neocodeium",
			event = "VeryLazy",
			config = function()
				local neocodeium = require("neocodeium")
				neocodeium.setup({
					-- If `false`, then would not start windsurf server (disabled state)
					-- You can manually enable it at runtime with `:NeoCodeium enable`
					enabled = true,
					-- Set to `false` to disable showing the number of suggestions label in the line number column
					show_label = true,
					-- Set to `true` to enable suggestions debounce
					debounce = false,
					-- Maximum number of lines parsed from loaded buffers (current buffer always fully parsed)
					-- Set to `0` to disable parsing non-current buffers (may lower suggestion quality)
					-- Set it to `-1` to parse all lines
					max_lines = 10000,
					-- Set to `true` to disable some non-important messages, like "NeoCodeium: server started..."
					silent = false,
					-- Set to `false` to enable suggestions in special buftypes, like `nofile` etc.
					disable_in_special_buftypes = true,
					-- Set `enabled` to `true` to enable single line mode.
					-- In this mode, multi-line suggestions would collapse into a single line and only
					-- shows full lines when on the end of the suggested (accepted) line.
					-- So it is less distracting and works better with other completion plugins.
					single_line = {
						enabled = false,
						label = "...", -- Label indicating that there is multi-line suggestion.
					},
					-- Set to `false` to disable suggestions in buffers with specific filetypes
					-- You can still enable disabled by this option buffer with `:NeoCodeium enable_buffer`
					filetypes = {
						help = false,
						gitcommit = false,
						gitrebase = false,
						["."] = false,
					},
					-- List of directories and files to detect workspace root directory for Windsurf Chat
					root_dir = { ".git", "package.json" },
				})
				vim.keymap.set("i", "<C-l>", neocodeium.accept, { desc = "AI: accept suggestion" })
				vim.keymap.set("i", "<C-g>l", neocodeium.accept_word, { desc = "AI: accept one word" })
				vim.keymap.set("i", "<C-g>j", function()
					neocodeium.cycle(1)
				end, { desc = "AI: next suggestion" })
				vim.keymap.set("i", "<C-g>k", function()
					neocodeium.cycle(-1)
				end, { desc = "AI: previous suggestion" })
			end,
		},

		-- https://github.com/dlants/magenta.nvim/blob/main/lua/magenta/options.lua
		{
			"dlants/magenta.nvim",
			lazy = false, -- you could also bind to <leader>mt
			build = "npm run build",
			config = function()
				require("magenta").setup({
					profiles = {
						{
							name = "claude-opus",
							provider = "anthropic",
							model = "claude-opus-4-8",
							fastModel = "claude-haiku-4-5",
							apiKeyEnvVar = "ANTHROPIC_API_KEY",
						},
					},
					sidebarPosition = "right",
					bellOnNotify = false,
					maxConcurrentSubagents = 5,
					picker = "fzf-lua",
					defaultKeymaps = true,
					sidebarKeymaps = {
						normal = {
							["<CR>"] = ":Magenta send<CR>",
						},
					},
					inlineKeymaps = {
						normal = {
							["<CR>"] = function(target_bufnr)
								vim.cmd("Magenta submit-inline-edit " .. target_bufnr)
							end,
						},
					},
					autoContext = {
						"README.md",
						".ai/*.md",
					},
				})

				-- Read all keymaps here:
				-- https://github.com/dlants/magenta.nvim/blob/main/lua/magenta/keymaps.lua
			end,
		},

		-- Mini.nvim Plugin
		-- https://github.com/echasnovski/mini.nvim
		{
			"echasnovski/mini.nvim",
			version = false,
		},
		{
			-- Display git diffs in Neovim
			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-diff.md
			-- NOTE Neo-Tree lists the changed files instead (<Leader>gn)
			-- :ReviewBase origin/development -> hunks are the branch's changes
			-- :ReviewBase                    -> hunks are my own uncommitted edits
			"echasnovski/mini.diff",
			config = function()
				local diff = require("mini.diff")
				local review_base = require("review_base")

				review_base.setup()
				vim.keymap.set("n", "<Leader>gr", ":ReviewBase origin/", { desc = "Git: set review base" })

				diff.setup({
					source = { review_base.source, diff.gen_source.git() },
					view = {
						style = "sign",
						signs = { add = "+", change = "C", delete = "-" },
						priority = 199,
					},
					mappings = {
						-- Apply hunks inside a visual/operator region
						apply = "<Leader>ga",

						-- Reset hunks inside a visual/operator region
						reset = "<Leader>gu",

						-- Hunk range textobject to be used inside operator
						-- Differs from apply/reset so it works in Visual mode too
						textobject = "ih",

						-- Go to hunk range in corresponding direction
						goto_first = "[H",
						goto_last = "]H",
						goto_prev = "[h",
						goto_next = "]h",
					},
				})

				-- Overlay colours: sourcetree_diff_overlay in the modus-themes spec

				vim.keymap.set("n", "<Leader>tg", function()
					diff.toggle_overlay(0)
				end, { desc = "Toggle: diff overlay (hunks)" })
			end,
		},

		-- https://github.com/esmuellert/codediff.nvim
		-- SourceTree in neovim
		{
			"esmuellert/codediff.nvim",
			cmd = "CodeDiff",
		},

		-- https://github.com/FabijanZulj/blame.nvim
		-- Now we can git blame
		{
			{
				"FabijanZulj/blame.nvim",
				lazy = false,
				config = function()
					require("blame").setup()
					vim.keymap.set("n", "<Leader>gb", "<cmd>BlameToggle<CR>", { silent = true, desc = "Git: blame" })
				end,
			},
		},

		-- Markdown rendering Plugin
		-- https://github.com/MeanderingProgrammer/render-markdown.nvim
		{
			"MeanderingProgrammer/render-markdown.nvim",
			dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
			ft = { "markdown", "text" },
			opts = {
				anti_conceal = {
					enabled = true, -- to disable for Airon chat buffer
				},
			},
			config = function()
				require("render-markdown").setup({
					latex = { enabled = false },
				})
				vim.keymap.set(
					"n",
					"<Leader>tm",
					"<cmd>RenderMarkdown buf_toggle<CR>",
					{ silent = true, desc = "Toggle: markdown render" }
				)
			end,
		},

		-- colorscheme
		-- https://github.com/miikanissi/modus-themes.nvim
		{
			"miikanissi/modus-themes.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				-- mini.diff's own defaults link a change to DiffText/DiffChange,
				-- which modus paints amber; a change reads as a red old line plus
				-- a green new line instead, the way SourceTree shows it.
				local sourcetree_diff_overlay = function(highlights, colors)
					highlights.MiniDiffOverDelete = { fg = colors.fg_removed, bg = colors.bg_removed }
					highlights.MiniDiffOverContext = { fg = colors.fg_removed, bg = colors.bg_removed }
					highlights.MiniDiffOverChange = { fg = colors.fg_removed_intense, bg = colors.bg_removed_refine }
					highlights.MiniDiffOverAdd = { bg = colors.bg_added }
					highlights.MiniDiffOverContextBuf = { bg = colors.bg_added }
					highlights.MiniDiffOverChangeBuf = { bg = colors.bg_added_refine }
				end

				require("modus-themes").setup({ on_highlights = sourcetree_diff_overlay })
				vim.o.termguicolors = true
				vim.o.background = "light" -- modus_operandi; 'dark' switches to modus_vivendi
				vim.cmd.colorscheme("modus_operandi")
			end,
		},

		-- Syntax Highlight
		-- https://github.com/nvim-treesitter/nvim-treesitter
		-- brew install tree-sitter
		-- brew install tree-sitter-cli
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "main",
			lazy = false,
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter").install({
					"bash",
					"html",
					"lua",
					"markdown",
					"markdown_inline",
					"rust",
					"purescript",
					"terraform",
					"typescript",
					"vimdoc",
					"yaml",
				})

				vim.api.nvim_create_autocmd("FileType", {
					group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
					callback = function(args)
						pcall(vim.treesitter.start, args.buf)
					end,
				})
			end,
		},

		-- File explorer
		-- https://github.com/nvim-neo-tree/neo-tree.nvim
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- Requires: `brew tap homebrew/cask-fonts && brew install font-fira-code-nerd-font`
				"MunifTanjim/nui.nvim",
			},
			config = function()
				require("neo-tree").setup({
					window = {
						width = 40,
						mappings = {
							["o"] = "open",
							-- Unset these so "o" is faster
							["oc"] = "",
							["od"] = "",
							["og"] = "",
							["om"] = "",
							["on"] = "",
							["os"] = "",
							["ot"] = "",
						},
					},
					filesystem = {
						filtered_items = {
							visible = true,
							hide_dotfiles = false,
							hide_gitignored = true,
						},
					},
				})

				vim.keymap.set("n", "<Leader>n", ":Neotree source=filesystem toggle<CR>", { desc = "File tree" })
				vim.keymap.set("n", "<Leader>gn", function()
					if vim.g.review_base_rev then
						vim.cmd("Neotree source=git_status git_base=" .. vim.g.review_base_rev)
					else
						vim.cmd("Neotree source=git_status git_base=HEAD toggle")
					end
				end, { desc = "Git: changed-file tree" })
			end,
		},

		-- Status line Plugin
		-- https://github.com/nvim-lualine/lualine.nvim
		{
			"nvim-lualine/lualine.nvim",
			dependencies = {
				-- Requires: `brew tap homebrew/cask-fonts && brew install font-fira-code-nerd-font`
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("lualine").setup({
					options = { theme = "auto" },
				})
			end,
		},

		-- Indent lines Plugin
		-- https://github.com/nvimdev/indentmini.nvim
		{
			"shellRaining/hlchunk.nvim",
			event = { "UIEnter" },
			config = function()
				require("hlchunk").setup({
					indent = {
						chars = { "·", "¦" }, -- more code can be found in https://unicodeplus.com/

						style = {
							"#f2f2f2", -- modus bg_dim, faint on the white background
						},
					},
					chunk = {
						enable = true,
						use_treesitter = true,
						style = {
							{ fg = "#884900" }, -- modus yellow_warmer
						},
					},
					blank = {
						enable = false,
					},
				})
			end,
		},

		-- Find files Plugin
		-- https://github.com/ibhagwan/fzf-lua
		-- Requires:
		-- brew install fzf
		-- brew install fd
		-- brew install bat
		-- brew install ripgrep
		-- brew install git-delta
		{
			"ibhagwan/fzf-lua",
			-- optional for icon support
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				-- calling `setup` is optional for customization
				require("fzf-lua").setup({})
				require("fzf-lua").register_ui_select()
				local fzf = require("fzf-lua")
				vim.keymap.set("n", "<c-p>", fzf.files, { silent = true, desc = "Find: files" })
				vim.keymap.set("n", "<c-b>", fzf.buffers, { silent = true, desc = "Find: buffers" })
				vim.keymap.set("n", "<c-f>", fzf.live_grep, { silent = true, desc = "Find: grep" })
				vim.keymap.set("n", "<c-s>", fzf.git_status, { silent = true, desc = "Find: changed files" })
				vim.keymap.set("n", "<Leader>gc", fzf.git_commits, { silent = true, desc = "Git: commits" })
				vim.keymap.set("n", "<Leader>?", fzf.keymaps, { silent = true, desc = "Search all keymaps" })
				vim.keymap.set("i", "<c-f>", function()
					require("fzf-lua").complete_path()
				end, { silent = true, desc = "Fuzzy complete path" })
			end,
		},

		-- Auto-pair Plugin
		-- https://github.com/windwp/nvim-autopairs
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		},

		-- Surround Plugin
		-- https://github.com/kylechui/nvim-surround
		{
			"kylechui/nvim-surround",
			version = "*", -- Use for stability; omit to use `main` branch for the latest features
			event = "VeryLazy",
			config = function()
				require("nvim-surround").setup({
					-- Configuration here, or leave empty to use defaults
				})
			end,
		},

		-- Comment Plugin
		-- https://github.com/numToStr/Comment.nvim
		{
			"numToStr/Comment.nvim",
			lazy = false,
			opts = {
				-- add any options here
			},
		},

		-- UI to LSP Plugin
		-- https://nvimdev.github.io/lspsaga/
		-- TODO Change this to telescope? neovim default?
		{
			"nvimdev/lspsaga.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				local noremapsilent = { noremap = true, silent = true }

				require("lspsaga").setup({
					symbol_in_winbar = {
						enable = false, -- We using utilyre/barbecue.nvim
					},
					lightbulb = {
						enable = false,
					},
					finder = {
						keys = {
							toggle_or_open = "<CR>",
						},
					},
				})
				-- <Leader>l? = LSP. Vim's g?/z? and Neovim's gr*/]d/[d are all
				-- left as they ship, so nothing here changes what a stock editor does.
				local function saga(lhs, subcommand, desc, modes)
					vim.keymap.set(modes or "n", "<Leader>" .. lhs, "<Cmd>Lspsaga " .. subcommand .. "<CR>", {
						noremap = true,
						silent = true,
						desc = desc,
					})
				end

				saga("ld", "goto_definition", "LSP: definition")
				saga("lh", "hover_doc", "LSP: hover docs")
				saga("lp", "peek_definition", "LSP: peek definition")
				saga("lr", "finder ref", "LSP: references")
				saga("ln", "rename", "LSP: rename")
				saga("la", "code_action", "LSP: code action", { "n", "x" })
				saga("le", "show_line_diagnostics", "LSP: errors on this line")
			end,
		},

		-- winbar Plugin (bar at the top of the editor)
		-- https://github.com/utilyre/barbecue.nvim
		{
			"utilyre/barbecue.nvim",
			name = "barbecue",
			version = "*",
			dependencies = {
				"SmiteshP/nvim-navic",
				"nvim-tree/nvim-web-devicons",
				"miikanissi/modus-themes.nvim", -- We using the colors function
			},
			opts = {},
			config = function()
				local colors = require("modus-themes.colors").setup()
				require("barbecue").setup({
					theme = {
						dirname = { fg = colors.fg_dim },
					},
				})
			end,
		},

		-- CodeLen Plugin
		-- https://git.sr.ht/~whynothugo/lsp_lines.nvim
		{
			"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
			config = function()
				require("lsp_lines").setup({})
				vim.diagnostic.config({
					virtual_lines = false,
					virtual_text = false,
				})

				vim.keymap.set("n", "<Leader>tl", require("lsp_lines").toggle, { desc = "Toggle: inline diagnostics" })
			end,
		},

		-- Snippet Plugin
		-- https://github.com/L3MON4D3/luasnip
		-- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/global.json
		{
			"L3MON4D3/LuaSnip",
			dependencies = {
				"rafamadriz/friendly-snippets",
			},
			version = "v2.*",
			build = "make install_jsregexp",
			config = function()
				-- require("luasnip").log.set_loglevel("debug")
				-- Run :lua require("luasnip").log.open()
				-- Add working directory's .ai for AI prompting snippets
				vim.opt.rtp:prepend(vim.fn.getcwd() .. "/.ai")
				vim.opt.rtp:prepend(vim.fn.getcwd() .. "/.editor")
				require("luasnip.loaders.from_vscode").load()
				require("luasnip.loaders.from_snipmate").load()

				-- See other keymaps of LuaSnip in nvim-cmp
				vim.keymap.set({ "i" }, "<C-h>", function()
					require("luasnip").expand({})
				end, { silent = true, desc = "Expand snippet" })
			end,
		},

		-- Autocomplete Plugin
		-- https://github.com/hrsh7th/nvim-cmp
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"onsails/lspkind.nvim",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
			},
			config = function()
				local cmp = require("cmp")
				local lspkind = require("lspkind")
				local luasnip = require("luasnip")

				cmp.setup({
					sources = {
						{
							name = "lazydev",
							group_index = 0, -- set group index to 0 to skip loading LuaLS completions
						},
						{ name = "copilot" },
						{ name = "nvim_lsp" },
						{ name = "buffer" },
						{ name = "luasnip" },
					},
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					mapping = {
						["<CR>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								if luasnip.expandable() then
									luasnip.expand({})
								else
									cmp.confirm({
										select = true,
									})
								end
							else
								fallback()
							end
						end),

						["<C-j>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.locally_jumpable(1) then
								luasnip.jump(1)
							else
								fallback()
							end
						end, { "i", "s" }),

						["<C-k>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.locally_jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
						["<C-Space>"] = cmp.mapping.complete(),
						["<C-e>"] = cmp.mapping.abort(),
					},
					formatting = {
						format = lspkind.cmp_format({ with_text = true, maxwidth = 50 }),
					},
				})

				vim.cmd([[
        set completeopt=menuone,noinsert,noselect
        highlight! default link CmpItemKind CmpItemMenuDefault
      ]])
			end,
		},

		-- Code Formatter Plugin
		-- https://github.com/stevearc/conform.nvim
		-- brew install stylua
		-- npm install -g @fsouza/prettierd
		{
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			config = function()
				require("conform").setup({
					formatters_by_ft = {
						lua = { "stylua" },
						json = { "prettier", "prettierd", stop_after_first = true },
						javascript = { "prettier", "prettierd", stop_after_first = true },
						javascriptreact = { "prettier", "prettierd", stop_after_first = true },
						typescript = { "prettier", "prettierd", stop_after_first = true },
						typescriptreact = { "prettier", "prettierd", stop_after_first = true },
						markdown = { "prettier", "prettierd", stop_after_first = true },
						rust = { "rustfmt" },
						purescript = { "purs-tidy" },
						terraform = { "terraform_fmt" },
						xml = { "xmllint" },
					},
					format_on_save = {
						timeout_ms = 500,
						lsp_fallback = true,
					},
				})
			end,
		},

		-- Allows renaming of files to trigger LSP
		-- https://github.com/antosha417/nvim-lsp-file-operations
		{
			"antosha417/nvim-lsp-file-operations",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-neo-tree/neo-tree.nvim", -- neo-tree must load before this plugin
			},
			config = function()
				require("lsp-file-operations").setup({
					-- used to see debug logs in file `vim.fn.stdpath("cache") .. lsp-file-operations.log`
					debug = false,
					-- select which file operations to enable
					operations = {
						willRenameFiles = true,
						didRenameFiles = true,
						willCreateFiles = true,
						didCreateFiles = true,
						willDeleteFiles = true,
						didDeleteFiles = true,
					},
					-- how long to wait (in milliseconds) for file rename information before cancelling
					timeout_ms = 10000,
				})
			end,
		},

		-- LSP Config Plugin
		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"antosha417/nvim-lsp-file-operations",
				"hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				local capabilities = vim.tbl_deep_extend(
					"force",
					vim.lsp.protocol.make_client_capabilities(),
					require("lsp-file-operations").default_capabilities(),
					require("cmp_nvim_lsp").default_capabilities()
				)

				vim.keymap.set(
					"n",
					"<Leader>lS",
					"<Cmd>LspRestart<CR>",
					{ silent = true, noremap = true, desc = "LSP: restart the Server" }
				)

				-- TypeScript LSP
				-- We are using pmizio/typescript-tools.nvim plugin
				-- which installs itself directly so we don't configure it here

				-- Eslint LSP
				-- npm i -g vscode-langservers-extracted
				vim.lsp.config("eslint", {
					root_dir = function(_, on_dir)
						-- A hack to workaround the root_dir issue where the plugin cannot detect the root directory correctly
						-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/eslint.lua#L89
						on_dir(vim.fn.getcwd())
					end,
				})
				vim.lsp.enable("eslint")

				-- Purescript LSP
				-- npm i -g purescript-language-server purs-tidy
				vim.lsp.config("purescriptls", {
					-- https://github.com/nwolverson/purescript-language-server?tab=readme-ov-file#neovims-built-in-language-server--nvim-lspconfig
					capabilities = capabilities,
					settings = {
						purescript = {
							addSpagoSources = true, -- e.g. any purescript language-server config here
							formatter = "purs-tidy",
						},
					},
					flags = {
						debounce_text_changes = 150,
					},
				})
				vim.lsp.enable("purescriptls")

				-- Lua LSP
				-- brew install lua-language-server
				vim.lsp.config("lua_ls", {
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				})
				vim.lsp.enable("lua_ls")

				-- Rust LSP
				-- Install rust-analyzer: rustup component add rust-analyzer
				vim.lsp.config("rust_analyzer", {
					capabilities = capabilities,
					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
							},
							check = {
								command = "clippy",
							},
						},
					},
				})
				vim.lsp.enable("rust_analyzer")

				-- Terraform LSP
				-- brew install hashicorp/tap/terraform-ls
				vim.lsp.config("terraformls", {
					capabilities = capabilities,
					filetypes = { "terraform", "terraform-vars", "tf" },
				})
				vim.lsp.enable("terraformls")
			end,
		},

		-- TypeScript LSP
		-- https://github.com/pmizio/typescript-tools.nvim
		-- npm install -g typescript typescript-language-server
		-- Note that this doesn't support eslint
		{
			"pmizio/typescript-tools.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"neovim/nvim-lspconfig",
				"antosha417/nvim-lsp-file-operations",
			},
			opts = {
				code_lens = "all", -- "off" | "all" | "implementations_only" | "references_only"
			},
			config = function()
				require("typescript-tools").setup({
					capabilities = vim.tbl_deep_extend(
						"force",
						vim.lsp.protocol.make_client_capabilities(),
						require("lsp-file-operations").default_capabilities(),
						require("cmp_nvim_lsp").default_capabilities()
					),
					on_attach = function(client)
						-- Disable formatting from the language server
						-- We use stevearc/conform.nvim
						client.server_capabilities.documentFormattingProvider = false
						client.server_capabilities.documentRangeFormattingProvider = false
					end,
				})
			end,
		},

		-- Purescript
		-- https://github.com/purescript-contrib/purescript-vim
		{ "purescript-contrib/purescript-vim" },
	},
})

-- Neovide MacOS GUI app settings
-- https://neovide.dev/configuration.html
if vim.g.neovide then
	vim.opt.guifont = { "FiraCode Nerd Font Mono", ":h18" }
	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_input_use_logo = true
	-- Deliberately overrides magenta's global <D-v>; its clipboard paste is <Leader>mp
	vim.keymap.set("n", "<D-v>", '"+P', { silent = true, desc = "Paste from system clipboard" })
	vim.keymap.set({ "i", "c", "v", "t" }, "<D-v>", "<C-R>+", { silent = true, desc = "Paste from system clipboard" })
end

-- Ask XiaoSteve about code he cannot see
vim.keymap.set(
	{ "n", "x" },
	"<Leader>yr",
	require("code_reference").copy,
	{ desc = "Yank: code reference (repo/branch/commit/path) for XiaoSteve" }
)
