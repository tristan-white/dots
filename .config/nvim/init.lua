vim.g.mapleader = " " -- Sets the leader key to space

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.relativenumber = true

vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",

	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/catppuccin/nvim",
	"https://github.com/karb94/neoscroll.nvim",

	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
})

-- Add nvim-lspconfig path to
-- package.path = package.path .. ";/home/tristan/.config/nvim/lsp/?.lua"

-- These are probably settings you'll want for autocomplete.
-- For info see: https://neovim.io/doc/user/options/#'completeopt'
vim.opt.completeopt = { "menuone", "noselect", "fuzzy" }

-- Config source: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ty.lua
ty_conf = {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	root_markers = { "ty.toml", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },

	-- This is needed for autocompletion
	--
	on_attach = function(client, bufnr)
		vim.lsp.completion.enable(true, client.id, bufnr, {
			autotrigger = true,
			convert = function(item)
				return { abbr = item.label:gsub("%b()", "") }
			end,
		})
		vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
	end,
}

vim.lsp.config("ty", ty_conf)

vim.lsp.enable("ty")

-- vim.cmd.colorscheme("catppuccin")
vim.cmd.colorscheme("habamax")

-- Need to call this for neoscroll to work.
require("neoscroll").setup()

-- Only thing we have to do after installing nvim tree
require("nvim-tree").setup()

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
