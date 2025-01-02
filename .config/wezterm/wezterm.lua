local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.color_scheme = 'tokyonight_night'
-- config.font = wezterm.font('JetBrains Mono', { weight = 'Bold' })
config.font_size = 13.0
config.use_fancy_tab_bar = false
config.tab_max_width = 26

local MINIMIZE = wezterm.nerdfonts.cod_chrome_minimize
local MAXIMIZE = wezterm.nerdfonts.cod_chrome_maximize
local CLOSE = wezterm.nerdfonts.cod_chrome_close
local HOVER_COLOR = { Color = '#aaa' }
config.tab_bar_style = {
	new_tab = wezterm.format {
		{ Text = ' + ' },
	},
	new_tab_hover = wezterm.format {
		{ Foreground = HOVER_COLOR },
		{ Text = ' + ' },
	},
	window_hide = wezterm.format {
		{ Text = ' ' .. MINIMIZE .. ' ' },
	},
	window_hide_hover = wezterm.format {
		{ Foreground = HOVER_COLOR },
		{ Text = ' ' .. MINIMIZE .. ' ' },
	},
	window_maximize = wezterm.format {
		{ Text = ' ' .. MAXIMIZE .. ' ' },
	},
	window_maximize_hover = wezterm.format {
		{ Foreground = HOVER_COLOR },
		{ Text = ' ' .. MAXIMIZE .. ' ' },
	},
	window_close = wezterm.format {
		{ Text = ' ' .. CLOSE .. ' ' },
	},
	window_close_hover = wezterm.format {
		{ Foreground = HOVER_COLOR },
		{ Text = ' ' .. CLOSE .. ' ' },
	},
}

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = {
	left = '0.5cell',
	right = '0.5cell',
	top = '0.25cell',
	bottom = '0.25cell',
}

config.initial_cols = 120
config.initial_rows = 30

config.audible_bell = 'Disabled'
config.visual_bell = {
	-- fade_in_function = 'Linear',
	-- fade_in_duration_ms = 100,
	fade_out_function = 'Constant',
	fade_out_duration_ms = 50,
}

config.colors = {
	visual_bell = '#1c1d28',
	tab_bar = {
		active_tab = {
			fg_color = '#ffffff',
			bg_color = '#1a1b26',
			intensity = 'Bold',
		},
	}
}

config.enable_kitty_keyboard = true

local keys = {
	{ key = 'Tab', mods = 'SHIFT|CTRL', action = wezterm.action.ShowLauncherArgs({ flags = 'LAUNCH_MENU_ITEMS|TABS' }) },
	-- Swap these two
	{ key = 'v',   mods = 'SHIFT|CTRL', action = wezterm.action.SendString('\x16') },
	{ key = 'v',   mods = 'CTRL',       action = wezterm.action.PasteFrom('Clipboard') },
}

if wezterm.target_triple:find('windows') then
	config.allow_win32_input_mode = false

	for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
		if gpu.backend == 'Dx12' and gpu.device_type == 'DiscreteGpu' then
			config.webgpu_preferred_adapter = gpu
			config.front_end = 'WebGpu'
			break
		end
	end
	config.default_prog = { 'elvish.exe' }

	local elvish = { label = 'Elvish', args = { 'elvish.exe' } }
	local cmd = { label = 'cmd', args = { 'cmd.exe' } }
	local ubuntu = { label = 'Ubuntu', args = { 'wsl.exe', '-d', 'Ubuntu' } }
	local nixos = { label = 'NixOS', args = { 'wsl.exe', '-d', 'NixOS' } }
	local powershell = { label = 'PowerShell', args = { 'pwsh.exe', '-NoLogo' } }

	config.launch_menu = {
		elvish,
		cmd,
		ubuntu,
		nixos,
		powershell,
	}
	table.insert(keys, { key = 'phys:1', mods = 'SHIFT|CTRL', action = wezterm.action.SpawnCommandInNewTab(elvish) })
	table.insert(keys, { key = 'phys:2', mods = 'SHIFT|CTRL', action = wezterm.action.SpawnCommandInNewTab(cmd) })
	table.insert(keys, { key = 'phys:3', mods = 'SHIFT|CTRL', action = wezterm.action.SpawnCommandInNewTab(ubuntu) })
	table.insert(keys, { key = 'phys:4', mods = 'SHIFT|CTRL', action = wezterm.action.SpawnCommandInNewTab(nixos) })
	table.insert(keys, { key = 'phys:5', mods = 'SHIFT|CTRL', action = wezterm.action.SpawnCommandInNewTab(powershell) })
else
	-- Not working in Windows WebGpu right now
	config.window_background_opacity = 0.95
end

config.keys = keys

return config
