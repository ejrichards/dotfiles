return {
	{ "mbbill/undotree" },
	{ "brenoprata10/nvim-highlight-colors", config = true },
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		opts = {
			keymaps = {
				normal = "s",
				normal_cur = "ss",
				normal_line = "S",
				normal_cur_line = "SS",
			},
		},
	},
	{
		"folke/ts-comments.nvim",
		version = "*",
		event = "VeryLazy",
		config = true,
	},
	{
		"natecraddock/workspaces.nvim",
		event = "VeryLazy",
		config = function()
			local workspaces = require("workspaces")
			workspaces.setup({
				auto_dir = true,
			})
			vim.keymap.set("n", "<leader>ew", workspaces.open)
		end,
	},
}
