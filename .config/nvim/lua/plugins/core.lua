return {
	{ "mbbill/undotree" },
	{ "brenoprata10/nvim-highlight-colors", config = true },
	{
		"folke/which-key.nvim",
		version = "*",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			delay = function(ctx)
				return ctx.plugin and 0 or 500
			end,
		},
	},
	{
		"stevearc/dressing.nvim",
		opts = {
			input = {
				get_config = function()
					-- Don't seem to play well
					if vim.api.nvim_get_option_value("filetype", { buf = 0 }) == "NvimTree" then
						return { enabled = false }
					end
				end,
			},
		},
	},
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
			}
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
