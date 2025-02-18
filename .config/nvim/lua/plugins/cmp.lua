return {
	{
		"saghen/blink.cmp",
		lazy = false,
		dependencies = "rafamadriz/friendly-snippets",
		version = "*",

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
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
