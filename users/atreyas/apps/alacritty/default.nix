{ config, lib, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding.x = 2;
        padding.y = 2;
        decorations = "None";
        startup_mode = "Maximized";
        #opacity = 1.0;
      };
      cursor.style = "Beam";
      keyboard.bindings = [
        { key = "N"; mods = "Control|Shift"; action = "SpawnNewInstance"; }
        { key = "Space"; mods = "Control|Shift"; action = "ToggleViMode"; }
        { key = "Return"; mods = "Alt"; action = "ToggleFullScreen"; }
      ];
      shell = {
        program = "zsh";
      };
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      font = {
        size = 10;
        normal = {
          family = "JetBrains Mono Nerd Font";
          style = "Medium";
        };
        bold = {
          family = "JetBrains Mono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrains Mono Nerd Font";
          style = "MediumItalic";
        };
        bold_italic = {
          family = "JetBrains Mono Nerd Font";
          style = "BoldItalic";
        };
      };
	  colors = {
        draw_bold_text_with_bright_colors = true;
        primary = {
		  background = "#282828";
		  foreground = "#d4be98";
	    };
        normal = {
          black   = "#3c3836";
          red     = "#ea6962";
          green   = "#a9b665";
          yellow  = "#d8a657";
          blue    = "#7daea3";
          magenta = "#d3869b";
          cyan    = "#89b482";
          white   = "#d4be98";
	    };
        bright = {
          black   = "#3c3836";
          red     = "#ea6962";
          green   = "#a9b665";
          yellow  = "#d8a657";
          blue    = "#7daea3";
          magenta = "#d3869b";
          cyan    = "#89b482";
          white   = "#d4be98";
	    };
	  };
    };
  };
}
