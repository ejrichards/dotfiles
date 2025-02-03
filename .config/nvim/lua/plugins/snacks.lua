return {
	{
		"folke/snacks.nvim",
		version = "*",
		priority = 1000,
		lazy = false,

	-- stylua: ignore
	keys = {
		{ "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
		{ "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
		{ "<leader>bw", function() Snacks.bufdelete.delete({wipe = true}) end, desc = "bw" },
		-- Pickers
		{ "<C-e>", function() Snacks.picker.git_files({cwd = vim.env.GIT_WORK_TREE or Snacks.git.get_root()}) end, desc = "Git Files" },
		{ "<C-f>", function() Snacks.picker.grep() end, desc = "Live Grep" },
		{ "<leader>eg", function() Snacks.picker.grep({live = false}) end, desc = "Grep" },
		{ "<leader>eb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>ef", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>eh", function() Snacks.picker.help() end, desc = "Help Pages" },
		{ "<leader>er", function() Snacks.picker.registers() end, desc = "Registers" },
		{ "<leader>ee", function() Snacks.picker.grep_word() end, desc = "Word", mode = { "n", "x" } },
		{ "<leader>ed", function() Snacks.explorer.open({
			follow_file = true,
		}) end, desc = "Explorer Buffer" },
		{ "<leader>ec", function() Snacks.explorer.open({
			follow_file = false,
		}) end, desc = "Explorer PWD" },
	},

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
			indent = { enabled = true },

			explorer = {
				enabled = true,
				replace_netrw = true,
			},
			picker = {
				enabled = true,
				win = {
					input = {
						keys = {
							["<c-s>"] = { "toggle_preview", mode = { "i", "n" } },
						},
					},
					list = {
						keys = {
							["<c-s>"] = "toggle_preview",
						},
					},
				},
				sources = {
					explorer = {
						layout = { preset = "dropdown" },
						auto_close = true,
						git_status = false,
						win = {
							list = {
								keys = {
									["i"] = "explorer_focus",
									["o"] = "explorer_up",
									["."] = "explorer_cd",
								},
							},
						},
					},
				},
			},

			dashboard = {
				preset = {
					header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣴⣶⣾⣿⣿⣿⣿⣷⡶⠦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⡄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣰⣿⣿⣿⠋⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⡟⠛⠛⠃⠀⠀⠀⠀⠀
⠀⠀⠀⣼⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀
⠀⠀⢰⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⠿⠟⠛⠁⠀⠀⠀⠀⠀
⠀⠀⣾⣿⣿⣿⣿⣿⣿⣶⣤⣤⣴⣾⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣶⣶⣶⠀⠀
⠀⠀⣉⠉⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠉⣉⠀⠀
⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⠿⠿⠀⠀
⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠛⠛⠋⠉⠀⠀⠀⠀
⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣤⣤⣤⡄⠀⠀⠀⠀
⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⢿⣿⣿⣿⣿⠟⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀]],
					-- stylua: ignore
					keys = {
						{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
						{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
						{ icon = " ", key = "w", desc = "Workspaces", action = ':exe "WorkspacesOpen" | bw' },
						{ icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
						{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
					},
				},
				sections = {
					{ section = "header" },
					function()
						local current_name = require("workspaces").name()
						local items = {
							{
								icon = " ",
								title = "Workspaces" .. (current_name ~= nil and " - " .. current_name or ""),
							},
						}
						local workspaces = require("workspaces").get()
						for i = 1, math.min(#workspaces, 5) do
							local workspace = workspaces[i]
							table.insert(items, {
								title = workspace.name,
								autokey = true,
								action = ':exe "WorkspacesOpen '
									.. workspace.name
									.. '" | lua Snacks.dashboard.update()',
								indent = 2,
							})
						end
						items[#items].padding = 1

						return items
					end,
					function()
						return { icon = " ", title = "Recent Files ", file = vim.fn.fnamemodify(".", ":~") }
					end,
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
		"folke/trouble.nvim",
		optional = true,
		specs = {
			"folke/snacks.nvim",
			opts = function(_, opts)
				return vim.tbl_deep_extend("force", opts or {}, {
					picker = {
						actions = require("trouble.sources.snacks").actions,
						win = {
							input = {
								keys = {
									["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
								},
							},
						},
					},
				})
			end,
		},
	},
	{
		"folke/todo-comments.nvim",
		optional = true,
		keys = {
			{
				"<leader>et",
				function()
					Snacks.picker.todo_comments()
				end,
				desc = "Todo",
			},
			{
				"<leader>eT",
				function()
					Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
				end,
				desc = "Todo/Fix/Fixme",
			},
		},
	},
}
