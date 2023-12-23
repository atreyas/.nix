{ config, pkgs, ...  }:

let
  inlineLua = file: "${builtins.readFile file}";  
  withCfg = plugin: {
    inherit plugin;
    type = "lua";
    config = inlineLua ./plugins/${plugin.pname}.lua;
  };
  withDefaultCfg = plugin: name: {
    inherit plugin;
    type = "lua";
    config = "require('${name}').setup()";
  };
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
    extraConfig = ''
      imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
    '';
    extraLuaConfig = ''
      ${builtins.readFile ./settings.lua}
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

      plenary-nvim
      telescope-fzf-native-nvim
      (withCfg telescope-nvim)
      ## lsp
      neodev-nvim
      nvim-compe # Autocompletion
      dressing-nvim 
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = inlineLua ./plugins/lsp.lua;
      }

      (withCfg comment-nvim)

      (withCfg lualine-nvim)

      nvim-web-devicons
      (withDefaultCfg nvim-tree-lua "nvim-tree")

      #copilot-cmp
      copilot-vim

      (withDefaultCfg indent-blankline-nvim "ibl")

      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp-cmdline
      cmp_luasnip
      (withCfg nvim-cmp)

      vim-hexokinase
      vim-dirvish
      vim-surround
      mini-nvim

      clangd_extensions-nvim
      nvim-lint

      neorg
    ];
  };
}
