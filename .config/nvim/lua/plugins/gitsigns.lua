return {
	'lewis6991/gitsigns.nvim',
	opts = {
		on_attach = function()
			local gitsigns = require('gitsigns')

			vim.keymap.map('n', ']c', function()
				if vim.wo.diff then
					vim.cmd.normal({ ']c', bang = true })
				else
					gitsigns.nav_hunk('next')
				end
			end, { desc = 'Previous Hunk' })

			vim.keymap.map('n', '[c', function()
				if vim.wo.diff then
					vim.cmd.normal({ '[c', bang = true })
				else
					gitsigns.nav_hunk('prev')
				end
			end, { desc = 'Next Hunk' })

			vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage Hunk' })
			vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset Hunk' })
			vim.keymap.set('v', '<leader>hs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
				{ desc = 'Stage Hunk' })
			vim.keymap.set('v', '<leader>hr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
				{ desc = 'Reset Hunk' })
			vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage the whole buffer' })
			vim.keymap.set('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
			vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview Hunk' })
			vim.keymap.set('n', '<leader>hd', gitsigns.toggle_deleted, { desc = 'Toggle Deleted' })
			vim.keymap.set('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'Blame' })
			vim.keymap.set('n', '<leader>gm', function() gitsigns.blame_line { full = true } end,
				{ desc = 'Git Message' })
		end
	}
}
