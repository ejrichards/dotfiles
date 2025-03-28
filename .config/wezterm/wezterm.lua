local wezterm = require("wezterm")
local ui = require("ui")

local config = wezterm.config_builder()

config.animation_fps = 60
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 1500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "EaseOut"

ui.apply_to_config(config)

config.initial_cols = 120
config.initial_rows = 30

config.audible_bell = "Disabled"
config.visual_bell = {
	-- fade_in_function = 'Linear',
	-- fade_in_duration_ms = 100,
	fade_out_function = "Constant",
	fade_out_duration_ms = 50,
}

config.colors = {
	visual_bell = "#1c1d28",
	-- For fancy
	-- tab_bar = {
	-- 	active_tab = {
	-- 		fg_color = '#ffffff',
	-- 		bg_color = '#1a1b26',
	-- 		intensity = 'Bold',
	-- 	},
	-- }
}

config.enable_kitty_keyboard = true

local keys = {
	{ key = "h", mods = "CTRL|SHIFT|ALT", action = wezterm.action.SplitPane({ direction = "Left" }) },
	{ key = "j", mods = "CTRL|SHIFT|ALT", action = wezterm.action.SplitPane({ direction = "Down" }) },
	{ key = "k", mods = "CTRL|SHIFT|ALT", action = wezterm.action.SplitPane({ direction = "Up" }) },
	{ key = "l", mods = "CTRL|SHIFT|ALT", action = wezterm.action.SplitPane({ direction = "Right" }) },
	{ key = "LeftArrow", mods = "CTRL|SHIFT|ALT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "RightArrow", mods = "CTRL|SHIFT|ALT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "UpArrow", mods = "CTRL|SHIFT|ALT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "DownArrow", mods = "CTRL|SHIFT|ALT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
	{ key = "Tab", mods = "CTRL", action = wezterm.action.ActivatePaneDirection("Next") },

	{
		key = "Tab",
		mods = "SHIFT|CTRL",
		action = wezterm.action.ShowLauncherArgs({ flags = "LAUNCH_MENU_ITEMS|TABS" }),
	},
	-- Swap these two
	{ key = "v", mods = "SHIFT|CTRL", action = wezterm.action.SendString("\x16") },
	{ key = "v", mods = "CTRL", action = wezterm.action.PasteFrom("Clipboard") },

	{ key = '"', mods = "SHIFT|CTRL", action = wezterm.action.ShowDebugOverlay },
	-- Harpoon-y
	{ key = "j", mods = "SHIFT|CTRL", action = wezterm.action.ActivateTab(0) },
	{ key = "k", mods = "SHIFT|CTRL", action = wezterm.action.ActivateTab(1) },
	{ key = "l", mods = "SHIFT|CTRL", action = wezterm.action.ActivateTab(2) },
	{ key = ":", mods = "SHIFT|CTRL", action = wezterm.action.ActivateTab(3) },

	{ key = "RightArrow", mods = "SHIFT|CTRL", action = wezterm.action.MoveTabRelative(1) },
	{ key = "LeftArrow", mods = "SHIFT|CTRL", action = wezterm.action.MoveTabRelative(-1) },
}

if wezterm.target_triple:find("windows") then
	config.allow_win32_input_mode = false

	for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
		if gpu.backend == "Dx12" and gpu.device_type == "DiscreteGpu" then
			config.webgpu_preferred_adapter = gpu
			config.front_end = "WebGpu"
			break
		end
	end
	config.default_prog = { "elvish.exe" }

	local local_domain = { label = "local", domain = { DomainName = "local" } }
	local cmd = { label = "cmd", args = { "cmd.exe" } }
	local ubuntu = { label = "Ubuntu", domain = { DomainName = "WSL:Ubuntu" } }
	local nixos = { label = "NixOS", domain = { DomainName = "WSL:NixOS" } }
	local powershell = { label = "PowerShell", args = { "pwsh.exe", "-NoLogo" } }

	config.launch_menu = {
		local_domain,
		cmd,
		ubuntu,
		nixos,
		powershell,
	}
	table.insert(keys, { key = "phys:1", mods = "SHIFT|CTRL", action = wezterm.action.SpawnCommandInNewTab(local_domain) })
	table.insert(keys, { key = "phys:2", mods = "SHIFT|CTRL", action = wezterm.action.SpawnCommandInNewTab(cmd) })
	table.insert(keys, { key = "phys:3", mods = "SHIFT|CTRL", action = wezterm.action.SpawnCommandInNewTab(ubuntu) })
	table.insert(keys, { key = "phys:4", mods = "SHIFT|CTRL", action = wezterm.action.SpawnCommandInNewTab(nixos) })
	table.insert( keys, { key = "phys:5", mods = "SHIFT|CTRL", action = wezterm.action.SpawnCommandInNewTab(powershell) })
else
	-- Not working in Windows WebGpu right now
	config.window_background_opacity = 0.95
end

config.keys = keys

return config
