-- Optional loading, ignore error
pcall(require, "local")

-- Byebye netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.undofile = true

if vim.g.neovide then
	vim.opt.title = true
	if vim.loop.os_uname().sysname == "Linux" then
		-- Linux paths don't work for wt.exe for some reason...
		vim.keymap.set("n", "<leader>tt", '<Cmd>silent !wt.exe -p Ubuntu wsl.exe --cd "%:p:h"<CR>')
		-- vim.keymap.set("n", "<leader>tt", '<Cmd>silent !wezterm.exe start -- wsl.exe --cd "%:p:h"<CR>')

		-- Trying out with plugin now
		-- vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
	else
		vim.keymap.set("n", "<leader>tt", '<Cmd>silent !wt -d "%:p:h"<CR>')
		-- vim.keymap.set("n", "<leader>tt", '<Cmd>silent !wezterm.exe start --cwd "%:p:h"<CR>')
	end

	vim.g.neovide_transparency = 0.95
	vim.g.neovide_scroll_animation_length = 0.1
	vim.g.neovide_scroll_animation_far_lines = 0
	-- Was kinda fun, but annoying with some plugins
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_animate_command_line = false
	vim.g.neovide_cursor_animate_in_insert_mode = false

	vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
else
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })

	if vim.loop.os_uname().sysname == "Linux" and vim.loop.os_uname().release:find("microsoft") then
		vim.g.clipboard = {
			name = 'WslClipboard',
			copy = {
				['+'] = require('vim.ui.clipboard.osc52').copy('+'),
				['*'] = require('vim.ui.clipboard.osc52').copy('*'),
			},
			paste = {
				['+'] = function() return 0 end,
				['*'] = function() return 0 end,
			},
		}
	end
end

-- Fix ugly float popups
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Lazy package config
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
