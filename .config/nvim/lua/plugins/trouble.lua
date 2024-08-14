return {
	{
		"folke/trouble.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local trouble = require("trouble")
			trouble.setup({
				auto_refresh = false,
				focus = true,
			})
			vim.keymap.set("n", "ge", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Diag Document" })
			vim.keymap.set("n", "gE", "<Cmd>Trouble diagnostics toggle<CR>", { desc = "Diag Workspace" })
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local todo = require("todo-comments")
			todo.setup({ signs = false })
			vim.keymap.set("n", "<leader>td", "<Cmd>Trouble todo<CR>")
		end,
	},
}
