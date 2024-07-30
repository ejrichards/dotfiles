return {
	{
		"echasnovski/mini.starter",
		version = "*",
		config = function()
			local starter = require("mini.starter")
			starter.setup({
				items = {
					function()
						local workspaces = require("workspaces").get()
						local workspace_items = {}
						for i, workspace in ipairs(workspaces) do
							if i > 8 then
								break
							end
							table.insert(workspace_items, {
								section = 'Workspaces',
								name = workspace.name,
								action = 'exe "WorkspacesOpen ' .. workspace.name .. '" | bw',
							})
						end
						return workspace_items
					end,
					starter.sections.recent_files(8, true),
				},
				footer = function()
					local stats = require("lazy").stats()
					return stats.count .. ' plugins 󰒲  ' .. stats.times.LazyDone .. 'ms'
				end,
			})
		end
	},
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
			"natecraddock/workspaces.nvim",
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
			local workspaces = require("workspaces")

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
				sections = {
					lualine_b = {
						function()
							if vim.env.GIT_DIR ~= nil and vim.env.GIT_WORK_TREE ~= nil then
								return 'Baredot'
							end
							return ''
						end,
						function()
							local workspace_path = workspaces.path()
							if workspace_path == nil then
								return ''
							end

							-- Always has trailing / or \
							workspace_path = workspace_path:sub(0, workspace_path:len() - 1)

							if workspace_path ~= vim.fn.getcwd() then
								return ''
							end

							return workspaces.name()
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
