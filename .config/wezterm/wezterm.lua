local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.color_scheme = 'Tokyo Night'
config.font_size = 13.0
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 26
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = {
  left = '0.5cell',
  right = '0.5cell',
  top = '0.25cell',
  bottom = '0.25cell',
}
config.initial_cols = 100
config.initial_rows = 28

return config
