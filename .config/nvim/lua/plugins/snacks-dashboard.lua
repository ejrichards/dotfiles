return {
	"folke/snacks.nvim",

	---@module 'snacks'
	---@type snacks.Config
	opts = {
		dashboard = {
			preset = {
				header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣴⣶⣾⣿⣿⣿⣿⣷⡶⠦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⡄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣰⣿⣿⣿⠋⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⡟⠛⠛⠃⠀⠀⠀⠀⠀
⠀⠀⠀⣼⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀
⠀⠀⢰⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⣠⣿⣿⣿⣿⣿⣿⠿⠟⠛⠁⠀⠀⠀⠀⠀
⠀⠀⣾⣿⣿⣿⣿⣿⣿⣶⣤⣤⣴⣾⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣶⣶⣶⠀⠀
⠀⠀⣉⠉⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠉⣉⠀⠀
⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⠿⠿⠀⠀
⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠛⠛⠋⠉⠀⠀⠀⠀
⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣤⣤⣤⣤⡄⠀⠀⠀⠀
⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⢿⣿⣿⣿⣿⠟⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀]],
					-- stylua: ignore
					keys = {
						{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
						{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
						{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
						-- { icon = " ", key = "w", desc = "Workspaces", action = ':exe "WorkspacesOpen" | bw' },
						{ icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.dashboard.pick('projects')" },
						{ icon = " ", key = "n", desc = "Nvim Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
						{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
					},
			},
			sections = {
				{ section = "header" },
				-- function()
				-- 	local current_name = require("workspaces").name()
				-- 	local items = {
				-- 		{
				-- 			icon = " ",
				-- 			title = "Workspaces" .. (current_name ~= nil and " - " .. current_name or ""),
				-- 		},
				-- 	}
				-- 	local workspaces = require("workspaces").get()
				-- 	for i = 1, math.min(#workspaces, 5) do
				-- 		local workspace = workspaces[i]
				-- 		table.insert(items, {
				-- 			title = workspace.name,
				-- 			autokey = true,
				-- 			action = ':exe "WorkspacesOpen '
				-- 				.. workspace.name
				-- 				.. '" | lua Snacks.dashboard.update()',
				-- 			indent = 2,
				-- 		})
				-- 	end
				-- 	items[#items].padding = 1
				--
				-- 	return items
				-- end,
				function()
					return { icon = " ", title = "Recent Files ", file = vim.fn.fnamemodify(".", ":~") }
				end,
				{ section = "recent_files", cwd = true, indent = 2, padding = 1 },
				{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
				{ section = "startup" },
			},
		},
	},
}
