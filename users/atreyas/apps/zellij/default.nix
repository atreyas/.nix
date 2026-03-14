{ pkgs, ... }:
{
  xdg.configFile."zellij/layouts/default.kdl".source = ./layouts/default.kdl;
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "gruvbox";
      scroll_buffer_size = 10000;
      layout = "default";
      simplified_ui = false;

      # Session persistence
      session_serialization = true;
      serialize_pane_viewport = true;

      # Kitty compatibility
      copy_on_select = true;
      scrollback_editor = "nvim";

      keybinds =
      let
        alt_n_tab_n = n: {
          "bind \"Alt ${builtins.toString n}\"" = { GoToTab = n; };
        };
      in
      {
        normal =
          {
            "unbind \"Ctrl b\"" = {};
          } //
          alt_n_tab_n 1 //
          alt_n_tab_n 2 //
          alt_n_tab_n 3 //
          alt_n_tab_n 4 //
          alt_n_tab_n 5 //
          alt_n_tab_n 6 //
          alt_n_tab_n 7 //
          alt_n_tab_n 8 //
          alt_n_tab_n 9
        ;
        pane = {
          "bind \"v\"" = { NewPane = "Right"; SwitchToMode = "Normal"; };
          "bind \"d\"" = { NewPane = "Down"; SwitchToMode = "Normal"; };
        };
      };

      # Gruvbox theme matching Kitty/Alacritty colors
      themes = {
        gruvbox = {
          fg = "#d4be98";
          bg = "#282828";
          black = "#3c3836";
          red = "#ea6962";
          green = "#a9b665";
          yellow = "#d8a657";
          blue = "#7daea3";
          magenta = "#d3869b";
          cyan = "#89b482";
          white = "#d4be98";
          orange = "#e78a4e";
        };
      };
    };
  };
}
