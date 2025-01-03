local wezterm = require("wezterm")

local m = {}

local MINIMIZE = wezterm.nerdfonts.cod_chrome_minimize
local MAXIMIZE = wezterm.nerdfonts.cod_chrome_maximize
local CLOSE = wezterm.nerdfonts.cod_chrome_close
local HOVER_COLOR = { Color = "#aaa" }
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

function m.apply_to_config(config)
	config.color_scheme = "tokyonight_night"
	-- config.font = wezterm.font('JetBrains Mono', { weight = 'Bold' })
	config.font_size = 13.0
	config.use_fancy_tab_bar = false
	config.show_tab_index_in_tab_bar = false
	config.tab_max_width = 26
	config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
	config.window_padding = {
		left = "0.5cell",
		right = "0.5cell",
		top = "0.25cell",
		bottom = "0.25cell",
	}

	-- Tab Titles
	local colors = wezterm.color.get_builtin_schemes()[config.color_scheme]
	wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
		local title = tab.active_pane.title

		if #tabs > 1 and tab.is_active then
			if tab.tab_index == 0 then
				return {
					{ Text = " " .. title .. " " },
					{ Foreground = { Color = colors["tab_bar"]["active_tab"]["bg_color"] } },
					{ Background = { Color = colors["tab_bar"]["inactive_tab"]["bg_color"] } },
					{ Text = SOLID_RIGHT_ARROW },
				}
			end
			if tab.tab_index == #tabs - 1 then
				return {
					{ Foreground = { Color = colors["tab_bar"]["active_tab"]["bg_color"] } },
					{ Background = { Color = colors["tab_bar"]["inactive_tab"]["bg_color"] } },
					{ Text = SOLID_LEFT_ARROW },
					"ResetAttributes",
					{ Text = " " .. title .. " " },
				}
			end
			return {
				{ Foreground = { Color = colors["tab_bar"]["active_tab"]["bg_color"] } },
				{ Background = { Color = colors["tab_bar"]["inactive_tab"]["bg_color"] } },
				{ Text = SOLID_LEFT_ARROW },
				"ResetAttributes",
				{ Text = " " .. title .. " " },
				{ Foreground = { Color = colors["tab_bar"]["active_tab"]["bg_color"] } },
				{ Background = { Color = colors["tab_bar"]["inactive_tab"]["bg_color"] } },
				{ Text = SOLID_RIGHT_ARROW },
			}
		end

		return {
			{ Text = " " .. title .. " " },
		}
	end)

	-- Integrated Button Style
	config.tab_bar_style = {
		new_tab = wezterm.format({
			{ Text = " + " },
		}),
		new_tab_hover = wezterm.format({
			{ Foreground = HOVER_COLOR },
			{ Text = " + " },
		}),
		window_hide = wezterm.format({
			{ Text = " " .. MINIMIZE .. " " },
		}),
		window_hide_hover = wezterm.format({
			{ Foreground = HOVER_COLOR },
			{ Text = " " .. MINIMIZE .. " " },
		}),
		window_maximize = wezterm.format({
			{ Text = " " .. MAXIMIZE .. " " },
		}),
		window_maximize_hover = wezterm.format({
			{ Foreground = HOVER_COLOR },
			{ Text = " " .. MAXIMIZE .. " " },
		}),
		window_close = wezterm.format({
			{ Text = " " .. CLOSE .. " " },
		}),
		window_close_hover = wezterm.format({
			{ Foreground = HOVER_COLOR },
			{ Text = " " .. CLOSE .. " " },
		}),
	}
end

return m
