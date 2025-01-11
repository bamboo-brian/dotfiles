local wezterm = require 'wezterm'
local act = wezterm.action
return {
	font = wezterm.font 'RobotoMono Nerd Font',
	font_size = 16,
	color_scheme = 'rose-pine-moon',
	term = 'wezterm',
	window_decorations = "RESIZE",
	use_fancy_tab_bar = false,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,
	leader = { key = 'w', mods = 'ALT' },
	keys = {
		{
			key = 's',
			mods = 'LEADER',
			action = act.SplitVertical { domain = 'CurrentPaneDomain' },
		},
		{
			key = 'v',
			mods = 'LEADER',
			action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
		},
		{
			key = 'z',
			mods = 'LEADER',
			action = act.TogglePaneZoomState,
		},
		{
			key = 'h',
			mods = 'LEADER',
			action = act.ActivatePaneDirection 'Left',
		},
		{
			key = 'j',
			mods = 'LEADER',
			action = act.ActivatePaneDirection 'Down',
		},
		{
			key = 'k',
			mods = 'LEADER',
			action = act.ActivatePaneDirection 'Up',
		},
		{
			key = 'l',
			mods = 'LEADER',
			action = act.ActivatePaneDirection 'Right',
		},
		{
			key = 'r',
			mods = 'LEADER',
			action = act.ActivateKeyTable {
				name = 'resize_pane',
				one_shot = false,
			},
		},
		{
			key = 't',
			mods = 'LEADER',
			action = act.ActivateKeyTable {
				name = 'tabs',
				one_shot = true,
			},
		},
		{
			key = 'F13',
			action = act.SendKey {
				key = 'F12',
			}
		}
	},
	key_tables = {
		resize_pane = {
			{
				key = 'h',
				action = act.AdjustPaneSize { 'Left', 1 },
			},
			{
				key = 'j',
				action = act.AdjustPaneSize { 'Down', 1 },
			},
			{
				key = 'k',
				action = act.AdjustPaneSize { 'Up', 1 },
			},
			{
				key = 'l',
				action = act.AdjustPaneSize { 'Right', 1 },
			},
			{
				key = 'Escape',
				action = 'PopKeyTable',
			},
		},
		tabs = {
			{
				key = 'a',
				action = act.SpawnTab('CurrentPaneDomain'),
			},
			{
				key = 'q',
				action = act.CloseCurrentTab({ confirm = true }),
			},
			{
				key = 'n',
				action = act.ActivateTabRelative(1),
			},
			{
				key = 'p',
				action = act.ActivateTabRelative(-1),
			},
			{
				key = 'N',
				action = act.MoveTabRelative(1),
			},
			{
				key = 'P',
				action = act.MoveTabRelative(-1),
			},
		},
	},
}
