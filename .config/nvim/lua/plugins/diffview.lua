return {
	'sindrets/diffview.nvim',
	config = function()
		vim.keymap.set('n', '<leader>gs', "<Cmd>DiffviewOpen<CR>");
		vim.keymap.set('n', '<leader>gh', "<Cmd>DiffviewFileHistory<CR>");
		vim.keymap.set('n', '<leader>gd', "<Cmd>DiffviewFileHistory %<CR>");
		vim.keymap.set('n', '<leader>gt', "<Cmd>DiffviewFileHistory -g --range=stash<CR>");

		local actions = require("diffview.actions")
		require("diffview").setup({
			keymaps = {
				view = {
					["<tab>"] = false,
					{ "n", "<s-tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
				},
				file_panel = {
					["<tab>"] = false,
					{ "n", "<s-tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
					{ "n", "o", function ()
						actions.goto_file_edit()
						vim.cmd.tabclose('#')
					end, { desc = "Open the file and close this tab" } },
				},
				file_history_panel = {
					["<tab>"] = false,
					{ "n", "<s-tab>", actions.select_next_entry, { desc = "Open the diff for the next file" } },
					{ "n", "o", function ()
						actions.goto_file_edit()
						vim.cmd.tabclose('#')
					end, { desc = "Open the file and close this tab" } },
				},
				option_panel = {
					["<tab>"] = false,
					{ "n", "<CR>", actions.select_entry, { desc = "Change the current option" } },
				},
			}
		})
	end
}
