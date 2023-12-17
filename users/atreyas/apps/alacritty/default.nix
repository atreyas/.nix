{ config, lib, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding.x = 5;
        padding.y = 5;
        decorations = "Full";
        # opacity = 1;
      };
      cursor.style = "Beam";
      shell = {
        program = "zsh";
      };
      scrolling = {
        history = 10000;
        multiplier = 1;
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
          family = "JeetBrains Mono Nerd Font";
          style = "BoldItalic";
        };
      };
	  draw_bold_text_with_bright_colors = true;
	  colors = {
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
