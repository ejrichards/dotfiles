return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require('tokyonight').setup({
			style = "night",
			transparent = not vim.g.neovide,
			styles = {
				comments = { italic = false },
				keywords = { italic = false },
			}
		})
		vim.cmd [[colorscheme tokyonight]]
	end,
}
