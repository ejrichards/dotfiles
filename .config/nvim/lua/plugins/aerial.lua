return {
	"stevearc/aerial.nvim",
	version = "*",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons"
	},
	opts = {
		layout = {
			default_direction = "float"
		},
		close_automatic_events = { "unfocus" },
		on_attach = function(bufnr)
			vim.keymap.set("n", "go", "<Cmd>AerialNavOpen<CR>", { buffer = bufnr })
			vim.keymap.set("n", "gO", "<Cmd>AerialOpen<CR>", { buffer = bufnr })
		end,
		keymaps = {
			["<Esc>"] = "actions.close",
		},
		nav = {
			keymaps = {
				["<Esc>"] = "actions.close",
				["q"] = "actions.close",
			}
		},
	}
}
