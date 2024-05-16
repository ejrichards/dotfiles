return {
	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			'L3MON4D3/LuaSnip',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require('luasnip')

			luasnip.config.setup({})
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = {
					completeopt = 'menu,menuone,preview',
				},
				mapping = cmp.mapping.preset.insert({
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<C-y>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),

					['<C-l>'] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { 'i', 's' }),
					['<C-h>'] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { 'i', 's' }),
				}),
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'path' },
				}
			})
		end
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		-- Seems to be some issue on initial load, force this first
		priority = 99,
		dependencies = {
			'folke/trouble.nvim',
			'hrsh7th/cmp-nvim-lsp',
			{ 'j-hui/fidget.nvim', config = true },
			{
				'folke/neodev.nvim',
				opts = {},
			},
		},
		config = function()
			local lspconfig = require('lspconfig')
			local trouble = require('trouble')

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
			-- For UFO folding
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true
			}

			vim.diagnostic.config({
				float = {
					border = "rounded",
					source = true,
				}
			})
			vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Diag Float' })

			vim.api.nvim_create_autocmd('LspAttach', {
				desc = 'LSP actions',
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
					end

					-- Moved to UFO
					-- map('K', vim.lsp.buf.hover, 'Hover')
					map('gd', vim.lsp.buf.definition, 'Definition')
					map('gD', vim.lsp.buf.declaration, 'Declaration')
					map('gi', vim.lsp.buf.implementation, 'Implementation')
					map('<F2>', vim.lsp.buf.rename, 'Rename')
					map('<leader>cr', vim.lsp.buf.rename, 'Rename')
					vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, { buffer = event.buf, desc = 'LSP: format' })
					map('<F4>', vim.lsp.buf.code_action, 'Code Action')
					map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')

					vim.keymap.set({ 'n', 'i' }, '<C-h>', vim.lsp.buf.signature_help, { buffer = event.buf, desc = 'LSP: Signature Help' })
					map('gT', vim.lsp.buf.type_definition, 'Type Definition')
					map('gr', function() trouble.toggle('lsp_references') end, 'References')

					map('<leader>rn', vim.lsp.buf.rename, 'Rename')
				end
			})

			local signs = {
				Error = '✘',
				Warn = '▲',
				Hint = '⚑',
				Info = '»'
			}
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end


			-- :help lspconfig-all
			--local lsp_util = require'lspconfig.util'

			-- rustup component add rust-analyzer
			lspconfig.rust_analyzer.setup({
				capabilities = capabilities,
				settings = {
					['rust-analyzer'] = {
						diagnostics = {
							enable = false,
						}
					}
				}
			})

			-- npm install -g typescript typescript-language-server
			--lspconfig.tsserver.setup({
			--	root_dir = lsp_util.root_pattern("tsconfig.app.json", "package.json", "tsconfig.json", "jsconfig.json", ".git")
			--})

			-- OLD: npm -g install @angular/language-server@<VERSION>
			-- NEW: Install project local, reference local "node_modules" folder
			local angularls_cmd = { "npx", "ngserver", "--stdio", "--tsProbeLocations", "node_modules",
				"--ngProbeLocations", "node_modules" }
			lspconfig.angularls.setup({
				capabilities = capabilities,
				cmd = angularls_cmd,
				on_new_config = function(new_config, new_root_dir)
					new_config.cmd = angularls_cmd
				end,
				on_init = function(client)
					-- Angular messing up folding
					client.server_capabilities.foldingRangeProvider = nil
				end
			})

			-- npm install -g svelte-language-server
			lspconfig.svelte.setup({
				capabilities = capabilities,
			})

			-- https://github.com/zigtools/zls/releases/latest
			vim.g.zig_fmt_autosave = 0
			lspconfig.zls.setup({
				capabilities = capabilities,
			})

			-- go install golang.org/x/tools/gopls@latest
			lspconfig.gopls.setup({
				capabilities = capabilities,
			})

			-- npm install -g pyright
			lspconfig.pyright.setup({
				capabilities = capabilities,
			})

			-- winget install LuaLS.lua-language-server
			-- need to add actual dir to path, symlink doesn't work
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace"
						},
						workspace = {
							checkThirdParty = false,
						}
					}
				}
			})
		end
	},
	{
		"pmizio/typescript-tools.nvim",
		lazy = false,
		priority = 99,
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {
			settings = {
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "literals"
				}
			}
		},
	}
}
