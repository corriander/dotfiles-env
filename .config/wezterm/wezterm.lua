-- Pull in the wezterm API
local wezterm = require 'wezterm'

local act = wezterm.action
local mux = wezterm.mux

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
-- config.color_scheme = 'Embers (dark) (terminal.sexy)'
-- config.color_scheme = 'Hybrid'
-- config.color_scheme = 'rose-pine'
-- config.color_scheme = 'Azu (Gogh)'
-- config.color_scheme = 'Smyck'
-- config.color_scheme = 'Lost Woods (terminal.sexy)'
config.color_scheme = 'Monokai Dark (Gogh)'
-- config.color_scheme = 'Operator Mono Dark'
-- config.color_scheme = 'Red Planet'
-- config.color_scheme = 'MaterialDark (Gogh)'
-- config.color_scheme = 'Numix Darkest (terminal.sexy)'
-- config.color_scheme = 'zenburn (terminal.sexy)'



config.window_background_opacity = 0.90

config.font = wezterm.font 'FiraCode NF'

-------------------------------------------------------------------------------
-- Workspaces
-------------------------------------------------------------------------------
-- Defaults
wezterm.on('gui-startup', function(cmd)
  -- allow `wezterm start -- something` to affect what we spawn
  -- in our initial window
  local args = {}
  if cmd then
    args = cmd.args
  end

  -- Set a workspace for coding on a current project
  -- Top pane is for the editor, bottom pane is for the build tool
  local tab, asm_pane, window = mux.spawn_window {
    workspace = 'attack-surface-management',
    cwd = '~',
    args = args,
  }
  -- launch tmuxinator project
  asm_pane:send_text 'txs asm\n'

  -- A workspace for interacting with a local machine that
  -- runs some docker containners for home automation
  local tab, config_pane, window = mux.spawn_window {
    workspace = 'general-configuration',
    args = args,
  }
  config_pane:send_text 'txs config\n'

  -- We want to startup in the asm workspace
  mux.set_active_workspace 'attack-surface-management'
end)

-- Navigation Keys
wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace())
end)

config.keys = {
  {
    key = '9',
    mods = 'ALT',
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  },
  { key = 'RightArrow', mods = 'SUPER', action = act.SwitchWorkspaceRelative(1) },
  { key = 'LeftArrow', mods = 'SUPER', action = act.SwitchWorkspaceRelative(-1) },
}

-- and finally, return the configuration to wezterm
return config
