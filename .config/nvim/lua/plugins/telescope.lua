return {
	'nvim-telescope/telescope.nvim',
	enabled = false,
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
	 	vim.loop.os_uname().sysname == "Linux" and {
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
		} or {}
	},
	config = function()
		local telescope = require('telescope')
		local trouble = require("trouble.sources.telescope")
		telescope.setup({
			defaults = {
				mappings = {
					i = {
						['<C-h>'] = 'which_key',
						['<C-Space>'] = 'toggle_selection',
						['<Tab>'] = 'close',
						["<C-t>"] = trouble.open,
					},
					n = {
						["<C-t>"] = trouble.open,
					},
				},
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
					"--glob=!.git/*",
					"--glob=!node_modules/*"
				}
			},
			pickers = {
				help_tags = {
					previewer = false,
				}
			}
		})

		if vim.loop.os_uname().sysname == "Linux" then
			telescope.load_extension('fzf')
		end

		local builtin = require('telescope.builtin')

		vim.keymap.set('n', '<leader>eb', builtin.buffers);
		vim.keymap.set('n', '<leader>ef', builtin.find_files);
		vim.keymap.set('n', '<leader>eg', builtin.live_grep);
		vim.keymap.set('n', '<leader>eh', builtin.help_tags);

		vim.keymap.set('n', '<C-e>', function ()
			local success = pcall(builtin.git_files)
			if not success then
				builtin.find_files()
			end
		end);

		-- winget install BurntSushi.ripgrep.MSVC
		vim.keymap.set('n', '<leader>ee', builtin.grep_string);
		vim.keymap.set('n', '<leader>EE', function()
			builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
		end)
		vim.keymap.set('n', '<C-f>', function()
			builtin.grep_string({ search = vim.fn.input("Grep $ ") })
		end)
	end
}
