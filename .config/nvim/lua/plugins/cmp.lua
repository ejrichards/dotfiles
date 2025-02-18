return {
	{
		"saghen/blink.cmp",
		lazy = false,
		dependencies = "rafamadriz/friendly-snippets",
		version = vim.uv.fs_stat("/etc/nvim/blink-version.lua") and dofile("/etc/nvim/blink-version.lua") or "*",

		init = function()
			local etc_fuzzy = "/etc/nvim/libblink_cmp_fuzzy.so"
			if vim.uv.fs_stat(etc_fuzzy) then
				-- blink.cmp is hardcoded for this location:
				local blink_dir = vim.fn.stdpath("data") .. "/lazy/blink.cmp/"
				local fuzzy_path = blink_dir .. "/target/release/libblink_cmp_fuzzy.so"
				local fuzzy_stat = vim.uv.fs_lstat(fuzzy_path)

				if fuzzy_stat and fuzzy_stat.type == "link" then
					return
				end

				if not vim.uv.fs_stat(blink_dir .. "/target/release") then
					vim.uv.fs_mkdir(blink_dir .. "/target", tonumber('755', 8))
					vim.uv.fs_mkdir(blink_dir .. "/target/release", tonumber('755', 8))
				elseif fuzzy_stat and fuzzy_stat.type == "file" then
					os.remove(fuzzy_path)
				end
				vim.uv.fs_symlink(etc_fuzzy, fuzzy_path)
			end
		end,

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			fuzzy = {
				prebuilt_binaries = {
					download = not vim.uv.fs_stat("/etc/nixos"),
				},
			},

			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},

			-- cmdline = {
			-- 	sources = {},
			-- },

			completion = {
				documentation = {
					auto_show = true,
				},
				accept = {
					auto_brackets = {
						kind_resolution = {
							blocked_filetypes = { "elvish" },
						},
					},
				},
			},

			-- signature = { enabled = true },

			keymap = {
				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-y>"] = { "select_and_accept" },

				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },

				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },

				["<C-j>"] = { "snippet_forward", "fallback" },
				["<C-k>"] = { "snippet_backward", "fallback" },
			},
		},
	},
}
