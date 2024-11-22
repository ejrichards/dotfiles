return {
	{
		"stevearc/dressing.nvim",
		opts = {
			input = {
				get_config = function()
					-- Don't seem to play well
					if vim.api.nvim_get_option_value("filetype", { buf = 0 }) == "NvimTree" then
						return { enabled = false }
					end
				end,
			},
		},
	},
	{
		"folke/which-key.nvim",
		version = "*",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			delay = function(ctx)
				return ctx.plugin and 0 or 500
			end,
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			sections = {
				lualine_b = {
					function()
						if vim.env.GIT_DIR ~= nil and vim.env.GIT_WORK_TREE ~= nil then
							return "Baredot"
						end
						return ""
					end,
					function()
						local workspace_name = require("workspaces").name()
						if workspace_name == nil then
							return ""
						end

						return workspace_name
					end,
					"branch",
					"diff",
					"diagnostics",
				},
				lualine_c = {
					"filename",
					{
						require("noice").api.status.search.get,
						cond = require("noice").api.status.search.has,
						color = { fg = "#ff9e64" },
					},
				},
				lualine_x = {
					-- '%S',
					{
						require("noice").api.status.mode.get,
						cond = require("noice").api.status.mode.has,
						color = { fg = "#ff9e64" },
					},
					"encoding",
					"fileformat",
					"filetype",
				},
			},
		},
	},
	{
		"folke/snacks.nvim",
		version = "*",
		priority = 1000,
		lazy = false,

		---@module 'snacks'
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			notifier = {
				enabled = true,
				timeout = 3000,
			},
			words = { enabled = true },
			styles = {
				notification = {
					wo = { wrap = true },
				},
			},

			dashboard = {
				preset = {
					-- stylua: ignore
					keys = {
						{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
						{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
						{ icon = " ", key = "w", desc = "Workspaces", action = ":WorkspacesOpen" },
						{ icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
						{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
					},
				},
				sections = {
					{ section = "header" },
					function()
						local items = {
							{ icon = " ", title = "Workspaces ", file = require("workspaces").name() },
						}
						local workspaces = require("workspaces").get()
						for i = 1, math.min(#workspaces, 5) do
							local workspace = workspaces[i]
							table.insert(items, {
								title = workspace.name,
								autokey = true,
								action = ':exe "WorkspacesOpen ' .. workspace.name .. '" | lua Snacks.dashboard.update()',
								indent = 2,
							})
						end
						items[#items].padding = 1

						return items
					end,
					{ icon = " ", title = "Recent Files ", file = vim.fn.fnamemodify(".", ":~") },
					{ section = "recent_files", cwd = true, indent = 2, padding = 1 },
					{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
					{ section = "startup" },
				},
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command
				end,
			})
		end,
	},
	{
		"folke/noice.nvim",
		version = "*",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		config = function()
			local noice = require("noice")

			noice.setup({
				messages = {
					view_search = false,
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

			vim.keymap.set("n", "<leader>cd", function()
				vim.cmd.CD()
				noice.redirect("pwd")
			end, { desc = ":cd to current buffer" })

			vim.opt.showmode = false
			-- Trying no showcmd for now
			-- vim.opt.showcmdloc = 'statusline'
			vim.opt.showcmd = false
		end,
	},
}
