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
				completion = {
					enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
				},
				providers = {
					lsp = { fallback_for = { "lazydev" } },
					lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
				},
			},

			completion = {
				documentation = {
					auto_show = true,
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
