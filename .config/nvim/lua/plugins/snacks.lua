return {
	{
		"folke/snacks.nvim",
		-- version = "*",
		priority = 1000,
		lazy = false,

	-- stylua: ignore
	keys = {
		{ "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
		{ "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
		{ "<leader>bw", function() Snacks.bufdelete.delete({wipe = true}) end, desc = "bw" },
		-- Pickers
		{ "<C-e>", function() Snacks.picker.smart() end, desc = "Smart" },
		{ "<C-f>", function() Snacks.picker.grep() end, desc = "Live Grep" },
		{ "<leader>cs", function() Snacks.picker.spelling() end, desc = "Spelling" },
		{ "<leader>ep", function() Snacks.picker.projects() end, desc = "Projects" },
		{ "<leader>el", function() Snacks.picker.grep() end, desc = "Live Grep" },
		{ "<leader>es", function() Snacks.picker() end, desc = "[S]nacks Picker" },
		-- { "<leader>eg", function() Snacks.picker.grep({live = false}) end, desc = "Grep" },
		{ "<leader>eg", function() Snacks.picker.git_files({cwd = vim.env.GIT_WORK_TREE or Snacks.git.get_root()}) end, desc = "Git Files" },
		{ "<leader>eb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>ef", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>eh", function() Snacks.picker.help() end, desc = "Help Pages" },
		{ "<leader>er", function() Snacks.picker.registers() end, desc = "Registers" },
		{ "<leader>ee", function() Snacks.picker.grep_word() end, desc = "Word", mode = { "n", "x" } },
		{ "<leader>ed", function() Snacks.explorer.reveal() end, desc = "Explorer Buffer" },
		{ "<leader>ec", function() Snacks.explorer.open({
			follow_file = false,
		}) end, desc = "Explorer PWD" },
		{ "<leader>en", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Nvim config" },
		{ "<leader>e:", function() Snacks.picker.command_history() end, desc = "Command History" },

		{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "LSP Definitions" },
		{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "LSP Declarations" },
		{ "gT", function() Snacks.picker.lsp_type_definitions() end, desc = "LSP Type Definitions" },
		{ "gi", function() Snacks.picker.lsp_implementations() end, desc = "LSP Implementations" },
		{ "gr", function() Snacks.picker.lsp_references() end, desc = "LSP References" },
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
							["<C-s>"] = { "toggle_preview", mode = { "n", "i" } },
							["<C-y>"] = { "confirm", mode = { "n", "i" } },
						},
					},
					list = {
						keys = {
							["<C-s>"] = "toggle_preview",
							["<C-y>"] = "confirm",
						},
					},
				},
				sources = {
					explorer = {
						layout = { preset = "dropdown" },
						auto_close = true,
						git_status = false,
						hidden = true,
						-- TODO: Not working with Baredot
						watch = false,
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
					projects = {
						dev = { "~/Workspace" },
						patterns = { ".git", ".jj" },
						win = {
							input = {
								keys = {
									["<CR>"] = { { "cd", "picker_files" }, mode = { "n", "i" } },
								},
							},
						},
					},
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
