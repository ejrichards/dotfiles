return {
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local trouble = require('trouble')
			trouble.setup({})
			vim.keymap.set('n', 'ge', function() trouble.toggle('document_diagnostics') end, { desc = 'Diag Document' })
			vim.keymap.set('n', 'gE', function() trouble.toggle('workspace_diagnostics') end, { desc = 'Diag Workspace' })
		end,
	},
	{
		'folke/todo-comments.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function ()
			local todo = require("todo-comments")
			todo.setup({ signs = false })
			vim.keymap.set('n', '<leader>td', '<Cmd>TodoTrouble<CR>');
		end
	}
}
