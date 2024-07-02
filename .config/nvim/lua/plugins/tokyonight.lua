return {
	"folke/tokyonight.nvim",
	version = "*",
	lazy = false,
	priority = 1000,
	config = function()
		require('tokyonight').setup({
			style = "night",
			plugins = {
				auto = true
			},
			transparent = not vim.g.neovide,
			styles = {
				comments = { italic = false },
				keywords = { italic = false },
			}
		})
		vim.cmd [[colorscheme tokyonight]]
	end,
}
