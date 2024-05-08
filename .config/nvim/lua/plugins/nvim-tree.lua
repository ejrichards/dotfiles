return {
	"nvim-tree/nvim-tree.lua", version = "*",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	config = function()
		local function my_on_attach(bufnr)
			local api = require("nvim-tree.api")

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			api.config.mappings.default_on_attach(bufnr)

			vim.keymap.set('n', '<Tab>', '<C-w><C-w>', opts('Tab'))
			vim.keymap.set('n', 'i', api.tree.change_root_to_node, opts('CD'))
			vim.keymap.set('n', '=', api.tree.change_root_to_node, opts('CD'))
			vim.keymap.set('n', 'o', api.tree.change_root_to_parent, opts('Up'))
		end

		require("nvim-tree").setup({
			on_attach = my_on_attach,
			view = {
				float = {
					enable = true,
					open_win_config = function()
						local screen_w = vim.opt.columns:get()
						local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
						local window_w = screen_w * 0.8
						local window_h = screen_h * 0.8
						local window_w_int = math.floor(window_w)
						local window_h_int = math.floor(window_h)
						return {
							relative = "editor",
							border = "rounded",
							width = window_w_int,
							height = window_h_int,
							row = 1,
							col = 10
						}
					end
				}
			}
		})

		vim.api.nvim_create_user_command('Ex', 'NvimTreeOpen %:p:h', {})
	end
}
