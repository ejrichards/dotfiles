return {
	{
		"https://git.sr.ht/~ejri/javelin.nvim",
		keys = {
			{ "<leader>j", function() require("javelin").open() end, desc = "Javelin Open" },
			{ "<leader>a", function() require("javelin").add() end, desc = "Javelin Add" },
			{ "<C-j>", function() require("javelin").select(1) end, desc = "Javelin Select 1" },
			{ "<C-k>", function() require("javelin").select(2) end, desc = "Javelin Select 2" },
			{ "<C-l>", function() require("javelin").select(3) end, desc = "Javelin Select 3" },
			{ "<C-;>", function() require("javelin").select(4) end, desc = "Javelin Select 4" },
		},
		config = true,
	},
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
