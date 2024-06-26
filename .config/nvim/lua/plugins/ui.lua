return {
	{
		"rcarriga/nvim-notify",
		version = "*",
		opts = {
			on_open = function(win)
				vim.api.nvim_win_set_config(win, { focusable = false })
			end,
		}
	},
	{
		"folke/noice.nvim",
		version = "*",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
			{
				'nvim-lualine/lualine.nvim',
				dependencies = {
					'nvim-tree/nvim-web-devicons',
				}
			},
		},
		config = function()
			local noice = require("noice")
			local lualine = require("lualine")

			noice.setup({
				messages = {
					view_search = false
				},
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
				},
				routes = {
					{
						view = "mini",
						filter = { cmdline = "^:w" },
					},
					{
						view = "mini",
						filter = { cmdline = "^:cd" },
					},
				},
				redirect = {
					view = "mini",
					filter = { event = "msg_show" },
				},
			})

			vim.keymap.set('n', '<leader>cd', function()
				vim.cmd.CD()
				noice.redirect('pwd')
			end, { desc = ':cd to current buffer' })

			vim.opt.showmode = false
			-- Trying no showcmd for now
			-- vim.opt.showcmdloc = 'statusline'
			vim.opt.showcmd = false
			lualine.setup({
				options = { theme = 'tokyonight' },
				sections = {
					lualine_b = {
						function()
							if vim.env.GIT_DIR ~= nil and vim.env.GIT_WORK_TREE ~= nil then
								return 'Baredot'
							end
							return ''
						end,
						'branch', 'diff', 'diagnostics'
					},
					lualine_c = {
						'filename',
						{
							require("noice").api.status.search.get,
							cond = require("noice").api.status.search.has,
							color = { fg = "#ff9e64" },
						},
					},
					lualine_x = {
						-- '%S',
						{
							noice.api.status.mode.get,
							cond = noice.api.status.mode.has,
							color = { fg = "#ff9e64" },
						},
						'encoding', 'fileformat', 'filetype'
					},
				},
			})
		end
	},
}
