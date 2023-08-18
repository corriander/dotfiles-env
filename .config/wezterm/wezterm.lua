-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 's3r0 modified (terminal.sexy)'
-- config.color_scheme = 'Glacier'
-- config.color_scheme = 'Smyck (Gogh)'
-- config.color_scheme = 'Gruvbox Dark (Gogh)'
-- config.color_scheme = 'Jellybeans (Gogh)'
-- config.color_scheme = 'Kanagawa (Gogh)'
-- config.color_scheme = 'Kasugano (terminal.sexy)'
config.color_scheme = 'Embers (dark) (terminal.sexy)'

config.window_background_opacity = 0.90

config.font = wezterm.font 'FiraCode NF'

-- and finally, return the configuration to wezterm
return config
