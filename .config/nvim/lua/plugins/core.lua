return {
	{ 'mbbill/undotree' },
	{ 'brenoprata10/nvim-highlight-colors', config = true },
	{
		'folke/which-key.nvim',
		version = '*',
		event = "VeryLazy",
		config = true
	},
	{
		'stevearc/dressing.nvim',
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
		config = true
	},
	{
		"folke/ts-comments.nvim",
		version = "*",
		event = "VeryLazy",
		config = true,
	}
}
