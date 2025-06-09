-- Using lazy.nvim to manage our plugins
-- https://github.com/folke/lazy.nvim
-- :Lazy home
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

-- NeoVim Settings
vim.g.python3_host_prog = "./pyenv/bin/python"
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
vim.opt.history = 500
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Move around Windows
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")

-- Insert a line break above
vim.keymap.set("n", "K", "0i<cr><esc>")

-- Shift + Enter = Esc
vim.api.nvim_set_keymap("i", "<S-CR>", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<S-CR>", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<S-CR>", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<S-CR>", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<S-CR>", "<Esc>", { noremap = true, silent = true })

-- Switch between relative and absolute line numbers
vim.opt.relativenumber = true -- Show relative numbers by default
vim.opt.signcolumn = "yes" -- Always display the sign column, prevents text shifting when signs are displayed
vim.opt.number = true -- Enables line numbers on the left side of the window
vim.opt.cursorline = true -- Highlights the line under the cursor
vim.keymap.set("n", "<c-n>", ":set norelativenumber!<CR>")

-- File type overrides
vim.api.nvim_create_augroup("FileTypeOverrides", { clear = true })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.purs",
	command = "set filetype=purescript",
	group = "FileTypeOverrides",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.txt", "*.md" },
	command = "setlocal wrap tabstop=2 shiftwidth=2 expandtab",
	group = "FileTypeOverrides",
})

-- Leader Mappings
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set("n", "<Leader>s", ":w<CR>")
vim.keymap.set("n", "<Leader>/", ":nohlsearch<CR>")
vim.keymap.set("n", "<Leader>k", "i<CR><esc>")
vim.keymap.set("n", "<Leader>y", "mcggVGy`c")
vim.keymap.set("n", "<Leader>l", ":vsp<CR>")
vim.keymap.set("n", "<Leader>j", ":sp<CR>")
vim.keymap.set("n", "<Leader>w", ":set wrap!<CR>")

--------------------
--- The plugins ----
--------------------
require("lazy").setup({
	dev = {
		path = "~/Workspace/neovim",
	},

	spec = {
		-- AI Plugin
		-- GitHub Copilot plugin
		{
			"github/copilot.vim",
			config = function()
				vim.g.copilot_no_tab_map = true

				vim.keymap.set("i", "<C-w>", "<Plug>(copilot-accept-word)")
				vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', {
					expr = true,
					replace_keycodes = false,
					desc = "Accept Copilot completion",
				})
				vim.keymap.set("i", "<C-g>j", "<Plug>(copilot-previous)")
				vim.keymap.set("i", "<C-g>k", "<Plug>(copilot-next)")
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
			-- NOTE we can also use Neo-Tree to view git status (<Leader>z)
			"echasnovski/mini.diff",
			config = function()
				require("mini.diff").setup({
					view = {
						style = "sign",
						signs = { add = "+", change = "C", delete = "-" },
						priority = 199,
					},
					mappings = {
						-- Apply hunks inside a visual/operator region
						apply = "zs",

						-- Reset hunks inside a visual/operator region
						reset = "zu",

						-- Hunk range textobject to be used inside operator
						-- Works also in Visual mode if mapping differs from apply and reset
						textobject = "zo",

						-- Go to hunk range in corresponding direction
						goto_first = "zh",
						goto_last = "zl",
						goto_prev = "zk",
						goto_next = "zj",
					},
				})

				local colors = require("solarized.utils").get_colors()
				vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { fg = colors.green, bg = colors.base02 })
				vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { fg = colors.red, bg = colors.base01 })

				-- Highlight for deleted line in a change line git diff
				vim.api.nvim_set_hl(0, "MiniDiffOverContext", { fg = colors.red, bg = colors.base02 })
				-- Highlight for changed characters in the new line in a change line git diff
				vim.api.nvim_set_hl(0, "MiniDiffOverChange", { fg = colors.base03, bg = colors.base01 })

				vim.keymap.set("n", "zg", function()
					require("mini.diff").toggle_overlay(0)
				end, { desc = "Toggle mini.diff overlay" })
			end,
		},

		-- https://github.com/aspeddro/gitui.nvim
		-- brew install gitui
		{
			"aspeddro/gitui.nvim",
			config = function()
				require("gitui").setup({
					window = {
						options = {
							width = 100,
							height = 100,
							border = "single",
						},
					},
				})
				vim.keymap.set("n", "<leader>g", "<cmd>Gitui<CR>", { silent = true })
			end,
		},

		-- https://github.com/FabijanZulj/blame.nvim
		-- Now we can git blame
		{
			{
				"FabijanZulj/blame.nvim",
				lazy = false,
				config = function()
					require("blame").setup({})
					vim.keymap.set("n", "zb", "<cmd>BlameToggle<CR>", { silent = true })
				end,
			},
		},

		-- Markdown rendering Plugin
		-- https://github.com/MeanderingProgrammer/render-markdown.nvim
		{
			"MeanderingProgrammer/render-markdown.nvim",
			dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
			ft = { "markdown" },
			opts = {},
		},

		-- colorscheme
		-- https://github.com/maxmx03/solarized.nvim
		{
			"maxmx03/solarized.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("solarized").setup({
					palette = "solarized",
					variant = "autumn",
					on_highlights = function(colors)
						-- Solarized colors: https://ethanschoonover.com/solarized/
						return {
							Visual = { bg = colors.yellow, fg = colors.base03 },
							Search = { bg = colors.yellow, fg = colors.base03 },
							CurSearch = { bg = colors.orange, fg = colors.base03 },

							-- NeoTree colorscheme: https://github.com/loctvl842/monokai-pro.nvim/blob/master/lua/monokai-pro/theme/plugins/neo-tree.lua
							NeoTreeRootName = { fg = colors.blue },
							NeoTreeDirectoryIcon = { fg = colors.blue },
							NeoTreeDirectoryName = { fg = colors.blue },
						}
					end,
				})
				vim.o.termguicolors = true
				vim.o.background = "dark" -- or 'light'
				vim.cmd.colorscheme("solarized")
			end,
		},

		-- Syntax Highlight
		-- https://github.com/nvim-treesitter/nvim-treesitter
		-- brew install tree-sitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#supported-languages
					ensure_installed = {
						"bash",
						"html",
						"lua",
						"markdown",
						"markdown_inline",
						"purescript",
						"typescript",
						"vimdoc",
						"yaml",
					},
					sync_install = true,
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = false,
					},
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
							["oc"] = false,
							["od"] = false,
							["og"] = false,
							["om"] = false,
							["on"] = false,
							["os"] = false,
							["ot"] = false,
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

				vim.keymap.set("n", "<Leader>n", ":Neotree source=filesystem toggle<CR>")
				vim.keymap.set("n", "<Leader>z", ":Neotree source=git_status toggle<CR>")
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
					options = { theme = "codedark" },
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
							"#002b36", -- base03
						},
					},
					chunk = {
						enable = true,
						use_treesitter = true,
						style = {
							{ fg = "#b58900" },
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
				vim.keymap.set("n", "<c-p>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
				vim.keymap.set("n", "<c-b>", "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true })
				vim.keymap.set("n", "<c-f>", "<cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true })
				vim.keymap.set("n", "<c-s>", "<cmd>lua require('fzf-lua').git_status()<CR>", { silent = true })
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
				vim.keymap.set("n", "gj", "<Cmd>Lspsaga diagnostic_jump_next<CR>", noremapsilent)
				vim.keymap.set("n", "gk", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", noremapsilent)
				vim.keymap.set("n", "gh", "<Cmd>Lspsaga hover_doc<CR>", noremapsilent)
				vim.keymap.set("n", "gd", "<Cmd>Lspsaga goto_definition<CR>", noremapsilent)
				vim.keymap.set("n", "gr", "<Cmd>Lspsaga finder ref<CR>", noremapsilent)
				vim.keymap.set("n", "gn", "<Cmd>Lspsaga rename<CR>", noremapsilent)
				vim.keymap.set("n", "ga", "<Cmd>Lspsaga code_action<CR>", noremapsilent)
				vim.keymap.set("n", "gl", "<Cmd>Lspsaga preview_definition<CR>", noremapsilent)
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
				"maxmx03/solarized.nvim", -- We using the colors function
			},
			opts = {},
			config = function()
				local colors = require("solarized.utils").get_colors()
				require("barbecue").setup({
					theme = {
						dirname = { fg = colors.base01 },
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

				vim.keymap.set("", "<Leader>e", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
			end,
		},

		-- Snippet Plugin
		-- https://github.com/L3MON4D3/luasnip
		-- Run :lua require("luasnip").log.open()
		-- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/global.json
		{
			"L3MON4D3/LuaSnip",
			dependencies = {
				"rafamadriz/friendly-snippets",
			},
			version = "v2.*",
			build = "make install_jsregexp",
			config = function()
				-- Add working directory's .ai for AI prompting snippets
				vim.opt.rtp:prepend(vim.fn.getcwd() .. "/.ai")
				require("luasnip.loaders.from_vscode").load()

				-- See other keymaps of LuaSnip in nvim-cmp
				vim.keymap.set({ "i" }, "<C-h>", function()
					require("luasnip").expand()
				end, { silent = true })
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
									luasnip.expand()
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
						purescript = { "purs-tidy" },
						xml = { "xmllint" },
					},
					format_on_save = {
						timeout_ms = 500,
						lsp_fallback = true,
					},
				})
			end,
		},

		-- LSP Config Plugin
		-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
		{
			"neovim/nvim-lspconfig",
			config = function()
				local lspconfig = require("lspconfig")
				local capabilities = require("cmp_nvim_lsp").default_capabilities()

				-- TypeScript LSP
				-- We are using pmizio/typescript-tools.nvim plugin
				-- which installs itself directly so we don't configure it here

				-- Purescript LSP
				-- npm i -g purescript-language-server purs-tidy
				lspconfig.purescriptls.setup({
					-- https://github.com/nwolverson/purescript-language-server?tab=readme-ov-file#neovims-built-in-language-server--nvim-lspconfig
					settings = {
						capabilities = capabilities,
						purescript = {
							addSpagoSources = true, -- e.g. any purescript language-server config here
							formatter = "purs-tidy",
						},
					},
					flags = {
						debounce_text_changes = 150,
					},
				})

				-- Lua LSP
				-- brew install lua-language-server
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				})
			end,
		},

		-- TypeScript LSP
		-- https://github.com/pmizio/typescript-tools.nvim
		-- npm install -g typescript typescript-language-server
		-- Note that this doesn't support eslint
		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			opts = {
				code_lens = "all", -- "off" | "all" | "implementations_only" | "references_only"
			},
			config = function()
				require("typescript-tools").setup({
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
	vim.g.neovide_scale_factor = 1.5
	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_input_use_logo = true
	vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<D-v>", '"+P', { noremap = true, silent = true })
	vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
end
