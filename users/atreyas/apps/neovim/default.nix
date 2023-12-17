{ config, pkgs, ...  }:

let
  toLua = str: "lua << EOF\n${str}\nEOF\n";  
  inlineLua = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";  
in{
  home.packages = with pkgs; [
    vscode-extensions.ms-vscode.cpptools
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    extraLuaConfig = ''
      ${builtins.readFile ./options.lua}
    '';

    plugins = with pkgs.vimPlugins; [
      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }
      ## Treesitter
      nvim-treesitter
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects 

      ## lsp
      {
        plugin = nvim-lspconfig;
        config = inlineLua ./plugins/lsp.lua;
      }

      {
        plugin = comment-nvim;
        config = inlineLua ./plugins/comment.lua;
      }
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-cmdline

	  vim-hexokinase
	  vim-dirvish
	  mini-nvim

      clangd_extensions-nvim
      nvim-lint
    ];
  };
}
