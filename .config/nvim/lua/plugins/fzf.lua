return {
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local fzf = require("fzf-lua")

			fzf.setup({
				winopts = {
					preview = { default = "bat" }
				},
				grep    = {
					input_prompt = 'Grep $ ',
					no_header_i = true
				},
				keymap  = {
					builtin = {
						["<F1>"]     = "toggle-help",
						["<F2>"]     = "toggle-fullscreen",
						["<F3>"]     = "toggle-preview-wrap",
						["<F4>"]     = "toggle-preview",
						["<F5>"]     = "toggle-preview-ccw",
						["<F6>"]     = "toggle-preview-cw",
						["<C-d>"]    = "preview-page-down",
						["<C-u>"]    = "preview-page-up",
						["<S-left>"] = "preview-page-reset",
					},
					fzf = {
						["ctrl-z"] = "abort",
						["ctrl-f"] = "half-page-down",
						["ctrl-b"] = "half-page-up",
						["ctrl-a"] = "beginning-of-line",
						["ctrl-e"] = "end-of-line",
						["alt-a"]  = "toggle-all",
						["f3"]     = "toggle-preview-wrap",
						["f4"]     = "toggle-preview",
						["ctrl-d"] = "preview-page-down",
						["ctrl-u"] = "preview-page-up",
					},
				},
				actions = {
					files = {
						["default"] = fzf.actions.file_edit_or_qf,
						["ctrl-x"]  = fzf.actions.file_split,
						["ctrl-v"]  = fzf.actions.file_vsplit,
						["ctrl-q"]  = { fn = fzf.actions.file_sel_to_qf, prefix = 'select-all+' },
						["ctrl-t"]  = require("trouble.sources.fzf").actions.open,
					},
					buffers = {
						["default"] = fzf.actions.buf_edit,
						["ctrl-x"]  = fzf.actions.buf_split,
						["ctrl-v"]  = fzf.actions.buf_vsplit,
					}
				},
			})

			vim.keymap.set('n', '<leader>eb', fzf.buffers);
			vim.keymap.set('n', '<leader>ef', fzf.files);
			vim.keymap.set('n', '<leader>eg', fzf.live_grep);
			vim.keymap.set('n', '<leader>eh', fzf.helptags);

			vim.keymap.set('n', '<C-e>', fzf.git_files);

			-- FIXME: pcall doesn't fail
			-- vim.keymap.set('n', '<C-e>', function()
			-- 	local success = pcall(fzf.git_files)
			-- 	if not success then
			-- 		fzf.files()
			-- 	end
			-- end);

			-- winget install BurntSushi.ripgrep.MSVC
			vim.keymap.set('n', '<leader>ee', fzf.grep_cword);
			vim.keymap.set('n', '<leader>EE', fzf.grep_cWORD);
			vim.keymap.set('n', '<C-f>', fzf.grep)
		end
	}
}
