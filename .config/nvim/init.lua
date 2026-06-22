vim.g.mapleader = " " -- Sets the leader key to space

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.relativenumber = true
vim.opt.termguicolors = true

vim.opt.clipboard = "unnamedplus"

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- vim.pack.add docs: https://neovim.io/doc/user/pack/#vim.pack.add()
vim.pack.add({
	"https://github.com/github/copilot.vim",

	"https://github.com/numToStr/Comment.nvim",

	"https://github.com/Saghen/blink.cmp",
	"https://github.com/Saghen/blink.lib",

	"https://github.com/romgrk/barbar.nvim",

	"https://github.com/tpope/vim-fugitive",

	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",

	"https://github.com/morhetz/gruvbox",

	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/MeanderingProgrammer/render-markdown.nvim",

	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",

	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/karb94/neoscroll.nvim",

	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-lualine/lualine.nvim",
})

-- Sensible settings for autocomplete.
-- See here for more info: https://neovim.io/doc/user/options/#'completeopt'
-- vim.opt.completeopt = { "menuone", "noselect", "fuzzy"}

-- ty lsp
-- https://docs.astral.sh/ty/editors/#vs-code
-- ty_conf = {
-- 	cmd = { "ty", "server" },
-- 	filetypes = { "python" },
-- 	root_markers = { "ty.toml", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },

	-- This is needed for autocompletion
	--
	-- on_attach = function(client, bufnr)
	-- 	vim.lsp.completion.enable(true, client.id, bufnr, {
	-- 		autotrigger = true,
	-- 		convert = function(item)
	-- 			return { abbr = item.label:gsub("%b()", "") }
	-- 		end,
	-- 	})
	--
	-- 	-- Triggers autocompletion in insert mode with Ctrl+Space
	-- 	vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
	--
	-- 	-- Jumps to code definition when pressing gd in normal mode
	-- 	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to code definition' })
	-- end
-- }
-- vim.lsp.config("ty", ty_conf)
--
vim.lsp.enable("ty")

-- gruvbox
vim.cmd.colorscheme("gruvbox")
-- vim.cmd.colorscheme("cyberdream")

-- neoscroll
require("neoscroll").setup()

-- nvim-tree
require("nvim-tree").setup()
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>gr", builtin.lsp_references, { desc = "Lists LSP references for word under the cursor" })
vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, {
	desc = "Goto the definition of the word under the cursor, if there's only one, otherwise show all options in Telescope",
})
vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Show git status" })
-- You must manually build fzf after vim.pack downloads it:
-- 1) Go to: ~/.local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim
-- 2) Run `make`
require("telescope").load_extension("fzf")

-- Add a keymap to toggle spell checker
vim.api.nvim_set_keymap("n", "<leader>s", ":set spell!<CR>", { noremap = true })

-- lualine
require("lualine").setup()

-- barbar
vim.api.nvim_set_keymap("n", "<A-,>", "<Cmd>BufferPrevious<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-.>", "<Cmd>BufferNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-c>", "<Cmd>BufferClose<CR>", { noremap = true, silent = true })

-- blink.cmp
-- For this to work, you must run `cargo build --release` in
-- $data/.local/share/nvim/site/pack/core/opt/blink.cmp
-- (run :echo stdpath('data') in neovim to see $data path)

require("blink.cmp").setup({
	keymap = {
		preset = "enter",
		["<Tab>"] = { "accept", "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
	},
	completion = {
		documentation = { auto_show = false },
	},
})
