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
								section = "Workspaces",
								name = workspace.name,
								action = 'exe "WorkspacesOpen ' .. workspace.name .. '" | bw',
							})
						end
						return workspace_items
					end,
					starter.sections.recent_files(8, true),
					{
						section = "Lazy",
						name = "Lazy - Open",
						action = "Lazy",
					},
				},
				footer = function()
					local stats = require("lazy").stats()
					return stats.count .. " plugins 󰒲  " .. stats.times.LazyDone .. "ms"
				end,
			})
		end,
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
		-- version = "*",
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

			statuscolumn = { enabled = false },
			quickfile = { enabled = false },
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
