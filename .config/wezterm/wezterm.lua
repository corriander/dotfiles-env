-- Pull in the wezterm API
local wezterm = require 'wezterm'

local act = wezterm.action

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
local module_exists, workspaces = pcall(require, "acds-workspaces")
if not(module_exists) then
    local mux = wezterm.mux
    print("no workspaces configured")
    -- wezterm.on('gui-startup', function(cmd)
    --     local args = {}
    --     if cmd then
    --         args = cmd.args
    --     end

    --     -- spawn_window can just spawn the default program without args, but try
    --     -- to hint that the workspace configuration isn't present.
    --     local tab, pane, window = mux.spawn_window {
    --         workspace = 'default-workspace',
    --         args = args,
    --     }
    --     --pane:send_text '# acds-workspaces.lua not present\n'
    -- end)
    wezterm.on('update-right-status', function(window, pane)
        window:set_right_status('missing-workspace-configuration')
    end)
end


-------------------------------------------------------------------------------
-- Key Mapping
-------------------------------------------------------------------------------
config.keys = {
  -- workspace navigation
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
