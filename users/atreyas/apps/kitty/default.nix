{ config, lib, pkgs, ... }:
{
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrains Mono Nerd Font";
      size = 10;
    };

    settings = {
      # Window settings (matching Alacritty)
      window_padding_width = 2;
      hide_window_decorations = true;

      # Cursor (Alacritty: Beam)
      cursor_shape = "beam";
      cursor_blink_interval = 0;

      # Scrollback (Alacritty: 10000 history, 3x multiplier)
      scrollback_lines = 10000;
      wheel_scroll_multiplier = 3;

      # Shell
      shell = "zsh";

      # Performance (GPU-accelerated like Alacritty)
      repaint_delay = 6;
      input_delay = 1;
      sync_to_monitor = true;

      # Bell
      enable_audio_bell = false;
      visual_bell_duration = 0;

      # URLs
      url_style = "curly";
      detect_urls = true;

      # Clipboard
      copy_on_select = "clipboard";
      strip_trailing_spaces = "smart";

      # Shell integration
      shell_integration = "enabled";
      scrollback_pager_history_size = 100;

      # Terminal compatibility for zellij/neovim
      term = "xterm-kitty";
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";

      # Tab bar
      tab_bar_style = "powerline";
      tab_title_template = "{index}: {title}";

      # Colors - Gruvbox (matching Alacritty exactly)
      foreground = "#d4be98";
      background = "#282828";

      # Normal colors
      color0 = "#3c3836";  # black
      color1 = "#ea6962";  # red
      color2 = "#a9b665";  # green
      color3 = "#d8a657";  # yellow
      color4 = "#7daea3";  # blue
      color5 = "#d3869b";  # magenta
      color6 = "#89b482";  # cyan
      color7 = "#d4be98";  # white

      # Bright colors (same as normal in your Alacritty config)
      color8 = "#3c3836";   # bright black
      color9 = "#ea6962";   # bright red
      color10 = "#a9b665";  # bright green
      color11 = "#d8a657";  # bright yellow
      color12 = "#7daea3";  # bright blue
      color13 = "#d3869b";  # bright magenta
      color14 = "#89b482";  # bright cyan
      color15 = "#d4be98";  # bright white
    };

    keybindings = {
      # Matching Alacritty keybindings
      "ctrl+shift+n" = "new_os_window";
      "alt+enter" = "toggle_fullscreen";

      # Kitty doesn't have Vi mode like Alacritty, but has scrollback pager
      # ctrl+shift+space -> open scrollback in pager (similar utility)
      "ctrl+shift+space" = "show_scrollback";

      # Additional useful bindings
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_window";

      # Zoom
      "ctrl+shift+z" = "toggle_layout stack";

      # Font size
      "ctrl+equal" = "change_font_size all +1.0";
      "ctrl+minus" = "change_font_size all -1.0";
      "ctrl+0" = "change_font_size all 0";
    };

    extraConfig = ''
      # Bold text uses bright colors (matching Alacritty draw_bold_text_with_bright_colors)
      bold_is_bright yes

      # Font styles
      bold_font        JetBrains Mono Nerd Font Bold
      italic_font      JetBrains Mono Nerd Font Medium Italic
      bold_italic_font JetBrains Mono Nerd Font Bold Italic
    '';
  };
}
