return {
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			modes = { "n", "i", "c" },
			hybrid_modes = { "i" },
		},
	},
	{
		--[[
	dir = "~/Workspace/github/obsidian.nvim",
	]]
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-treesitter/nvim-treesitter",
		},
		lazy = true,
		ft = "markdown",
		opts = {
			ui = { enable = false },
			disable_frontmatter = true,
			picker = { name = "fzf-lua" },
			mappings = {
				["<leader>ef"] = {
					action = function()
						vim.api.nvim_command("ObsidianQuickSwitch")
					end,
					opts = { buffer = true },
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
			},
		},
	},
}
