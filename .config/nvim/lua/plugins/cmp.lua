return {
	{
		"saghen/blink.cmp",
		lazy = false,
		enabled = true,
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

			highlight = {
				use_nvim_cmp_as_default = true,
			},
			-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			nerd_font_variant = "normal",

			windows = {
				documentation = {
					auto_show = false,
				},
			},

			-- Some issues with Windows download
			-- $HOME\AppData\Local\nvim-data\lazy\blink.cmp\target\release
			fuzzy = {
				prebuiltBinaries = {
					download = vim.loop.os_uname().sysname == "Linux",
				},
			},

			-- experimental auto-brackets support
			-- accept = { auto_brackets = { enabled = true } }

			-- experimental signature help support
			-- trigger = { signature_help = { enabled = true } }
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
