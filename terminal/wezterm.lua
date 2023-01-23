local wezterm = require 'wezterm'

return {
  font = wezterm.font('Roboto Mono', { weight='Bold'}),
  -- font_size = 10,
  colors = {
    foreground='#eeeeeeeeecec',
    background='#1d1d20202121',
  },
  window_frame = {
    font = wezterm.font { family = 'Roboto Mono', weight = 'Bold' },
  },
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  hide_tab_bar_if_only_one_tab = true,
  tab_bar_at_bottom = true,
}
