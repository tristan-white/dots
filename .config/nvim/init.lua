-- Mostly from https://cznolan.github.io/2024/08/31/neovim-python-basic-setup.html

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0 -- set to 0 to default to tabstop value

-- Bootstrap lazy.nvim
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- add your plugins here
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
		},
		"https://github.com/nvim-lua/plenary.nvim",
		-- "https://github.com/Mofiqul/dracula.nvim",
		"https://github.com/nvim-treesitter/nvim-treesitter",
		{
			"https://github.com/nvim-treesitter/nvim-treesitter-context",
			opts = function(_, opts)
				require("nvim-treesitter.install").prefer_git = true
			end,
			lazy = false,
			buld = ":TSUpdate",
		},
		"https://github.com/neovim/nvim-lspconfig",
		"https://github.com/ibhagwan/fzf-lua",
		"https://github.com/karb94/neoscroll.nvim",
		"https://github.com/ruifm/gitlinker.nvim",
		"https://github.com/tpope/vim-fugitive",

		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
			},
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				-- Snippet engine & associated nvim-cmp source
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lsp",
				-- Additional user-friendly snippets
				"rafamadriz/friendly-snippets",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				require("luasnip.loaders.from_vscode").lazy_load()
				luasnip.config.setup({})

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					completion = {
						completeopt = "menu,menuone,noinsert",
					},
					mapping = cmp.mapping.preset.insert({
						["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
						["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
						["<C-b>"] = cmp.mapping.scroll_docs(-4), -- scroll backward
						["<C-f>"] = cmp.mapping.scroll_docs(4), -- scroll forward
						["<C-Space>"] = cmp.mapping.complete({}), -- show completion suggestions
						["<CR>"] = cmp.mapping.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = true,
						}),
						-- Tab through suggestions or when a snippet is active, tab to the next argument
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_locally_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end, { "i", "s" }),
						-- Tab backwards through suggestions or when a snippet is active, tab to the next argument
						["<S-Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.locally_jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" }, -- lsp
						{ name = "luasnip" }, -- snippets
						{ name = "buffer" }, -- text within current buffer
						{ name = "path" }, -- file system paths
					}),
					window = {
						-- Add borders to completions popups
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
					},
				})
			end,
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- run `.setup` on plugins that require it
-- require("dracula").setup({})
-- vim.cmd[[colorscheme dracula]]
vim.cmd.colorscheme("catppuccin")

-- require'nvim-treesitter'.install {'html', 'markdown', 'javascript', 'python', 'zig'}

-- Frist enable Mason, then mason-lspconfig, then langauge servers
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "pyright" } })

vim.lsp.config("pyright", {
	on_attach = on_attach,
	filetypes = { "python" },
	settings = { pyright = { autoImportCompletion = true } },
})
