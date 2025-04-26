{ config, pkgs, lib, ... }:
{
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override ({ withNerdIcons = true; });
#    bookmarks = {
#      d = "$HOME/Downloads";
#      ws = "$HOME/workspace";
#    };
    extraPackages = with pkgs; [
      bat
      eza
      fzf
      imv
      mediainfo
      ffmpegthumbnailer
      zoxide
    ];
    plugins = {
      mappings = {
        j = "autojump";
        v = "imgview";
	i = "mediainfo";
      };
    };
  };
  programs.zsh.initContent = lib.optionalString config.programs.zsh.enable ''
    # Export NNN_TMPFILE to quit on cd always
    export NNN_TMPFILE="${config.xdg.configHome}/nnn/.lastd"
    . ${config.programs.nnn.finalPackage}/share/quitcd/quitcd.bash_sh_zsh
  '';
}
