return {
	{ "mbbill/undotree" },
	{ "brenoprata10/nvim-highlight-colors", config = true },
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {
			keymaps = {
				normal = "gs",
				normal_cur = "gss",
				normal_line = "gS",
				normal_cur_line = "gSS",
			},
		},
	},
	{
		"folke/ts-comments.nvim",
		version = "*",
		event = "VeryLazy",
		opts = {
			lang = {
				elvish = '# %s'
			},
		},
	},
	{
		"natecraddock/workspaces.nvim",
		enabled = false,
		event = "VeryLazy",
		config = function()
			local workspaces = require("workspaces")
			workspaces.setup({
				auto_dir = true,
			})
			vim.keymap.set("n", "<leader>ew", workspaces.open)
		end,
	},
	{
		"folke/which-key.nvim",
		version = "*",
		event = "VeryLazy",

		---@module 'which-key'
		---@type wk.Config
		opts = {
			preset = "modern",
			delay = function(ctx)
				return ctx.plugin and 0 or 500
			end,
			spec = {
				{ "<leader>b", group = "Buffer" },
				{ "<leader>c", group = "CD / Code Action" },
				{ "<leader>e", group = "Pickers" },
				{ "<leader>g", group = "Git", icon = { name = "git", cat = "filetype" } },
				{ "<leader>h", group = "Hunks" },
				{ "<leader>l", group = "View Toggles" },
				{ "<leader>p", group = "Paste" },
				{ "<leader>P", group = "Paste" },
			},
		},
	},
}
