{ config, pkgs, ...  }:

let
  inlineLua = file: "${builtins.readFile file}";  
in {
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
    extraPackages = with pkgs; [
      lua-language-server ## Remove with direnv
      rnix-lsp

      xclip
      wl-clipboard
    ];

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
      neodev-nvim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = inlineLua ./plugins/lsp.lua;
      }

      {
        plugin = comment-nvim;
        type = "lua";
        config = inlineLua ./plugins/comment.lua;
      }

      {
        plugin = lualine-nvim;
        type = "lua";
        config = inlineLua ./plugins/lualine.lua;
      }
      nvim-web-devicons

      {
        plugin = copilot-cmp;
        type = "lua";
        config = inlineLua ./plugins/copilot.lua;
      }

      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = "require('ibl').setup()";
      }

      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-cmdline

      vim-hexokinase
      vim-dirvish
      vim-surround
      mini-nvim

      clangd_extensions-nvim
      nvim-lint
    ];
  };
}
