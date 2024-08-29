return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			vim.api.nvim_command("highlight TreesitterContextBottom gui=underline guisp=Grey cterm=underline")
			vim.api.nvim_command("highlight TreesitterContextLineNumberBottom gui=underline guisp=Grey cterm=underline")
			require("treesitter-context").setup({
				max_lines = 6,
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		-- version = "*",
		build = ":TSUpdate",
		config = function()
			-- Avoid conflicts with Baredot
			require("nvim-treesitter.install").prefer_git = false

			-- Windows: Open in native tools prompt for VS
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"css",
					"csv",
					"dockerfile",
					"gitattributes",
					"gitcommit",
					"gitignore",
					"go",
					"html",
					"http",
					"javascript",
					"jq",
					"json",
					"regex",
					"rust",
					"toml",
					"typescript",
					"xml",
					"yaml",
					"zig",
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = false,

				-- List of parsers to ignore installing (or "all")
				ignore_install = {},

				highlight = {
					enable = true,

					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = { query = "@function.outer", desc = "Around function" },
							["if"] = { query = "@function.inner", desc = "Inside function" },
							["ac"] = { query = "@class.outer", desc = "Around class" },
							["ic"] = { query = "@class.inner", desc = "Inside class" },
						},
						selection_modes = {
							["@function.outer"] = "V",
							["@function.inner"] = "V",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>sp"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
}
