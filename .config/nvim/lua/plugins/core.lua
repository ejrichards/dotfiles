return {
	{ 'mbbill/undotree' },
	{ 'numToStr/Comment.nvim',   config = true },
	{ 'NvChad/nvim-colorizer.lua', config = true },
	{
		'folke/which-key.nvim',
		event = "VeryLazy",
		config = true
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
		opts = {
			options = { theme = 'tokyonight' }
		}
	},
	{
		'stevearc/dressing.nvim',
		opts = {
			input = {
				get_config = function()
					-- Don't seem to play well
					if vim.api.nvim_buf_get_option(0, "filetype") == "NvimTree" then
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
	}
}
