local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.color_scheme = 'tokyonight_night'
-- config.font = wezterm.font('JetBrains Mono', { weight = 'Bold' })
config.font_size = 13.0
config.use_fancy_tab_bar = true
config.tab_max_width = 26

config.window_background_opacity = 0.95
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = {
	left = '0.5cell',
	right = '0.5cell',
	top = '0.25cell',
	bottom = '0.25cell',
}

config.initial_cols = 120
config.initial_rows = 30

config.colors = {
	tab_bar = {
		active_tab = {
			fg_color = '#ffffff',
			bg_color = '#1a1b26',
			intensity = 'Bold',
		},
	}
}

local keys = {
	{ key = 'Tab', mods = 'SHIFT|CTRL', action = wezterm.action.ShowLauncherArgs({ flags = 'LAUNCH_MENU_ITEMS|TABS' }) },
}

if wezterm.target_triple:find('windows') then
	config.default_prog = { 'pwsh.exe', '-NoLogo' }

	local powershell = { label = 'PowerShell', args = { 'pwsh.exe', '-NoLogo' } }
	local cmd = { label = 'cmd', args = { 'cmd.exe' } }
	local ubuntu = { label = 'Ubuntu', args = { 'ubuntu.exe' } }

	config.launch_menu = {
		powershell,
		cmd,
		ubuntu
	}
	table.insert(keys, { key = 'phys:1', mods = 'SHIFT|CTRL', action = wezterm.action.SpawnCommandInNewTab(powershell) })
	table.insert(keys, { key = 'phys:2', mods = 'SHIFT|CTRL', action = wezterm.action.SpawnCommandInNewTab(cmd) })
	table.insert(keys, { key = 'phys:3', mods = 'SHIFT|CTRL', action = wezterm.action.SpawnCommandInNewTab(ubuntu) })
end

config.keys = keys

return config
