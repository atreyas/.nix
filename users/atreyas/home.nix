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

    # These don't work with Wayland
    keyboard.options = [
      #"caps:escape"
      "caps:ctrl_modifier"
      "ctrl:nocaps"
    ];
    
    packages = with pkgs; [
      # tippy tops
      iotop htop btop ncdu duf
      # other sysutils
      nq
      dtach
      (uutils-coreutils.override { prefix = ""; })
      qjackctl
      perf-tools

      #pinentry-qt
      #atuin

      # command line
      fzf
      eza
      ## Rusty
      bat
      fd
      ripgrep
      zoxide # also add `fzf`

      # AI tools
      claude-code

      xclip
      drawio
      discord
      inputs.rippkgs

      nerd-fonts.dejavu-sans-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.noto
      nerd-fonts.profont
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono

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
      ".gitconfig".source = ./dotfiles/gitconfig;
      ".gitignore_global".source = ./dotfiles/gitignore_global;

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
