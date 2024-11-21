local wezterm = require('wezterm')
local action = wezterm.action
local window_frame = require('lua/rose-pine').window_frame()

return {
    front_end = "WebGpu", -- https://github.com/wez/wezterm/issues/5990
    webgpu_power_preference = 'HighPerformance', -- https://github.com/wez/wezterm/issues/5990
    color_scheme = 'Catppuccin Frappe',
    font_size = 13.0,
    line_height = 1.1,
    font = wezterm.font('MesloLGSDZ Nerd Font'),
    freetype_load_flags = 'NO_HINTING',
    window_frame = window_frame,
    window_close_confirmation = 'NeverPrompt',
    audible_bell = 'Disabled',
    max_fps = 100,
    use_fancy_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    enable_scroll_bar = false,
    quit_when_all_windows_are_closed = false,
    keys = {
        { mods = "OPT", key = "LeftArrow",  action = action.SendKey({ mods = "ALT", key = "b" }) },
        { mods = "OPT", key = "RightArrow", action = action.SendKey({ mods = "ALT", key = "f" }) },
        { mods = "CMD", key = "LeftArrow",  action = action.SendKey({ mods = "CTRL", key = "a" }) },
        { mods = "CMD", key = "RightArrow", action = action.SendKey({ mods = "CTRL", key = "e" }) },
        { mods = "CMD", key = "Backspace",  action = action.SendKey({ mods = "CTRL", key = "u" }) },
    },
}
