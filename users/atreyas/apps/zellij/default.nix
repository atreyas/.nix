{ pkgs, ... }:
{
  xdg.configFile."zellij/layouts/default.kdl".source = ./layouts/default.kdl;
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      #default_shell = "nushell";
      #theme = "gruvbox";
      scroll_buffer_size = 10000;
      layout = "default";
      simplified_ui = false;
      keybinds = 
      let
        alt_n_tab_n = n: {
          "bind \"Alt ${builtins.toString n}\"" = { GoToTab = n; };
        };
      in
      {
        normal = 
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
      };

      themes = {
        gruvbox = {
          fg = "#D5C4A1";
          bg = "#282828";
          black = "#3C3836";
          red = "#CC241D";
          green =  "#98971A";
          yellow = "#D79921";
          blue = "#3C8588";
          magenta = "#B16286";
          cyan = "#689D6A";
          white = "#FBF1C7";
          orange = "#D65D0E";
        };
      };
    };
  };
}
