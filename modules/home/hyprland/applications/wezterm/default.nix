{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      -- Leader Key:
      -- The leader key is set to ALT + q, with a timeout of 2000 milliseconds (2 seconds).
      -- To execute any keybinding, press the leader key (ALT + q) first, then the corresponding key.

      -- Keybindings:
      -- 1. Tab Management:
      --    - LEADER + t: Create a new tab in the current pane's domain.
      --    - LEADER + w: Close the current pane (with confirmation).
      --    - LEADER + b: Switch to the previous tab.
      --    - LEADER + n: Switch to the next tab.
      --    - LEADER + <number>: Switch to a specific tab (0–9).

      -- 2. Pane Splitting:
      --    - LEADER + .: Split the current pane horizontally into two panes.
      --    - LEADER + -: Split the current pane vertically into two panes.
      -- 3. Pane Navigation:
      --    - LEADER + h: Move to the pane on the left.
      --    - LEADER + j: Move to the pane below.
      --    - LEADER + k: Move to the pane above.
      --    - LEADER + l: Move to the pane on the right.

      -- 4. Pane Resizing:
      --    - LEADER + Ctrl + h: Increase the pane size to the left by 5 units.
      --    - LEADER + Ctrl + j: Increase the pane size to the right by 5 units.
      --    - LEADER + Ctrl + k: Increase the pane size downward by 5 units.
      --    - LEADER + Ctrl + l: Increase the pane size upward by 5 units.


      local wezterm = require 'wezterm'
      local config = {}

      config.max_fps = 240
      config.animation_fps = 240

      config.color_scheme = "Catppuccin Macchiato"
      config.font = wezterm.font("JetBrainsMono Nerd Font")

      config.tab_bar_at_bottom = true
      config.use_fancy_tab_bar = false
      config.tab_and_split_indices_are_zero_based = true
      config.hide_tab_bar_if_only_one_tab = true


      config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
      config.keys = {
          {
              mods = "LEADER",
              key = "t",
              action = wezterm.action.SpawnTab "CurrentPaneDomain",
          },
          {
              mods = "LEADER",
              key = "w",
              action = wezterm.action.CloseCurrentPane { confirm = true }
          },
          {
              mods = "LEADER",
              key = "b",
              action = wezterm.action.ActivateTabRelative(-1)
          },
          {
              mods = "LEADER",
              key = "n",
              action = wezterm.action.ActivateTabRelative(1)
          },
          {
              mods = "LEADER",
              key = ".",
              action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
          },
          {
              mods = "LEADER",
              key = "-",
              action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
          },
          {
              mods = "LEADER",
              key = "h",
              action = wezterm.action.ActivatePaneDirection "Left"
          },
          {
              mods = "LEADER",
              key = "j",
              action = wezterm.action.ActivatePaneDirection "Down"
          },
          {
              mods = "LEADER",
              key = "k",
              action = wezterm.action.ActivatePaneDirection "Up"
          },
          {
              mods = "LEADER",
              key = "l",
              action = wezterm.action.ActivatePaneDirection "Right"
          },
          {
              mods = "LEADER|CTRL",
              key = "h",
              action = wezterm.action.AdjustPaneSize { "Left", 5 }
          },
          {
              mods = "LEADER|CTRL",
              key = "l",
              action = wezterm.action.AdjustPaneSize { "Right", 5 }
          },
          {
              mods = "LEADER|CTRL",
              key = "j",
              action = wezterm.action.AdjustPaneSize { "Down", 5 }
          },
          {
              mods = "LEADER|CTRL",
              key = "k",
              action = wezterm.action.AdjustPaneSize { "Up", 5 }
          },
      }

      for i = 0, 9 do
          -- leader + number to activate that tab
          table.insert(config.keys, {
              key = tostring(i),
              mods = "LEADER",
              action = wezterm.action.ActivateTab(i),
          })
      end

      return config
    '';
  };
}
