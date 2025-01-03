-- Optional loading, ignore error
pcall(require, "local")

if vim.uv.os_uname().sysname == "Linux" then
	vim.opt.shell = "/bin/sh"
end

-- Byebye netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.undofile = true
vim.opt.cursorlineopt = "number"
vim.opt.cursorline = true

if vim.g.neovide then
	vim.opt.title = true
	if vim.uv.os_uname().sysname == "Linux" then
		-- Linux paths don't work for wt.exe for some reason...
		vim.keymap.set("n", "<leader>tt", '<Cmd>silent !wt.exe -p Ubuntu wsl.exe --cd "%:p:h"<CR>')
		-- vim.keymap.set("n", "<leader>tt", '<Cmd>silent !wezterm.exe start -- wsl.exe --cd "%:p:h"<CR>')

		-- Trying out with plugin now
		-- vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
	else
		vim.g.neovide_title_background_color = "#051e05"
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

	if vim.uv.os_uname().sysname == "Linux" and vim.uv.os_uname().release:find("microsoft") then
		vim.g.clipboard = {
			name = "WslClipboard",
			copy = {
				["+"] = require("vim.ui.clipboard.osc52").copy("+"),
				["*"] = require("vim.ui.clipboard.osc52").copy("*"),
			},
			paste = {
				["+"] = function()
					return 0
				end,
				["*"] = function()
					return 0
				end,
			},
		}
	end
end

-- Fix ugly float popups
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

--[[ fzf does this, but was interesting to figure out
vim.keymap.set("n", "<leader>ps", function()
	local regs = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ%/:"
	local register_list = {}
	local register_contents = {}
	for i = 1, #regs do
		local register = regs:sub(i, i)
		local contents = vim.fn.getreg(register)
		if #contents > 0 then
			table.insert(register_list, register)
			register_contents[register] = contents
		end
	end

	vim.ui.select(register_list, {
		prompt = "Registers",
		format_item = function(item)
			return register_contents[item]:gsub("\n", "↲"):gsub("\t", "» ")
		end,
	}, function(choice)
		if choice ~= nil then
			vim.api.nvim_put(vim.split(register_contents[choice], "\n"), "", true, false)
		end
	end)
end)
--]]

vim.filetype.add({
	extension = {
		["http"] = "http",
	},
})

local additional_rtp = {}
if vim.uv.fs_stat("/etc/nvim/nvim-treesitter-parsers.lua") then
	table.insert(additional_rtp, dofile("/etc/nvim/nvim-treesitter-parsers.lua"))
end

-- Lazy package config
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	performance = {
		rtp = {
			paths = additional_rtp,
		},
	},
})
