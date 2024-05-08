return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons"
	},
	config = function()
		require("aerial").setup({
			layout = {
				default_direction = "float"
			},
			close_automatic_events = { "unfocus" }
		})

		vim.keymap.set("n", "go", "<Cmd>AerialNavOpen<CR>")
		vim.keymap.set("n", "gO", "<Cmd>AerialOpen<CR>")
	end
}
