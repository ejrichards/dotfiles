return {
	--[[
	dir = "~/Workspace/github/obsidian.nvim",
	]]
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	lazy = true,
	ft = "markdown",
	opts = {
		disable_frontmatter = true,
		mappings = {
			["<C-e>"] = {
				action = function()
					vim.api.nvim_command('ObsidianQuickSwitch')
				end,
				opts = { buffer = true }
			},
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
		},
		workspaces = {
			{
				name = "buf-parent",
				path = function()
					return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
				end,
			},
		}
	},
}
