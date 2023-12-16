{ inputs, config, pkgs, lib, user, system, ... }:

{
  fonts.fontconfig.enable = true;
  home = {
    username = "${user.name}";
    homeDirectory = "/home/${user.name}";
    enableDebugInfo = true;

    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      firefox

      # git
      git-credential-manager

      # tippy tops
      iotop htop btop ncdu duf
      # other sysutils
      nq busybox

      #pinentry-qt
      #atuin

      # command line
      fzf
      eza

      # Rusty
      fd
      ripgrep 
      zoxide # also add `fzf`

      xclip

      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    file = {
      # Make a symlink from dotfiles/screenrc to $HOME/.screenrc
      # ".screenrc".source = dotfiles/screenrc;
      ".zshrc".source = ./dotfiles/zshrc;

      # Inline specify .gradle/gradle.properties
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    # Allows having different package versions than the OS.
    # Only enable if you know what you are doing, and especially only if you know
    # how to get out of a soup when this breaks.
    #home.enableNixpkgsReleaseCheck = false;

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
