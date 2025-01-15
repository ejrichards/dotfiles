return {
	{
		"ibhagwan/fzf-lua",
		enabled = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")

			fzf.setup({
				fzf_args = "--bind=change:first",
				winopts = {
					preview = { default = "bat" },
				},
				grep = {
					input_prompt = "Grep",
					no_header_i = true,
				},
				files = {
					formatter = "path.filename_first",
				},
				git = {
					files = {
						formatter = "path.filename_first",
					},
				},
				keymap = {
					builtin = {
						["<C-/>"] = "toggle-help",
						["<C-s>"] = "toggle-preview",
						["<F2>"] = "toggle-fullscreen",
						["<F3>"] = "toggle-preview-wrap",
						["<F5>"] = "toggle-preview-ccw",
						["<F6>"] = "toggle-preview-cw",
						["<C-d>"] = "preview-page-down",
						["<C-u>"] = "preview-page-up",
						["<S-left>"] = "preview-page-reset",
					},
					fzf = {
						["ctrl-z"] = "abort",
						["ctrl-f"] = "half-page-down",
						["ctrl-b"] = "half-page-up",
						["ctrl-a"] = "beginning-of-line",
						["ctrl-e"] = "end-of-line",
						["alt-a"] = "toggle-all",
						["f3"] = "toggle-preview-wrap",
						["ctrl-s"] = "toggle-preview",
						["ctrl-d"] = "preview-page-down",
						["ctrl-u"] = "preview-page-up",
					},
				},
				actions = {
					files = {
						["default"] = fzf.actions.file_edit_or_qf,
						["ctrl-x"] = fzf.actions.file_split,
						["ctrl-v"] = fzf.actions.file_vsplit,
						["ctrl-q"] = { fn = fzf.actions.file_sel_to_qf, prefix = "select-all+" },
						["ctrl-t"] = require("trouble.sources.fzf").actions.open,
					},
					buffers = {
						["default"] = fzf.actions.buf_edit,
						["ctrl-x"] = fzf.actions.buf_split,
						["ctrl-v"] = fzf.actions.buf_vsplit,
					},
				},
			})

			vim.keymap.set("n", "<leader>eb", fzf.buffers, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>ef", fzf.files, { desc = "Files" })
			vim.keymap.set("n", "<leader>eg", fzf.live_grep, { desc = "Live Grep" })
			vim.keymap.set("n", "<leader>eh", fzf.helptags, { desc = "Help" })
			vim.keymap.set("n", "<leader>er", fzf.registers, { desc = "Registers" })
			vim.keymap.set("n", "<leader>ps", fzf.registers, { desc = "Fzf Registers" })

			vim.keymap.set("n", "<C-e>", fzf.git_files, { desc = "Git Files" })

			-- FIXME: pcall doesn't fail
			-- vim.keymap.set('n', '<C-e>', function()
			-- 	local success = pcall(fzf.git_files)
			-- 	if not success then
			-- 		fzf.files()
			-- 	end
			-- end);

			-- winget install BurntSushi.ripgrep.MSVC
			vim.keymap.set("n", "<leader>ee", fzf.grep_cword, { desc = "<cword>" })
			vim.keymap.set("n", "<leader>EE", fzf.grep_cWORD, { desc = "<cWORD>" })
			vim.keymap.set("n", "<C-f>", fzf.grep, { desc = "Grep" })
		end,
	},
}
