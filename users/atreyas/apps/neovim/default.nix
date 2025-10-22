{ config, pkgs, ...  }:

let
  inlineLua = file: "${builtins.readFile file}";  
  withLua = plugin: {
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
    #extraConfig = ''
    #  imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
    #'';
    extraLuaConfig = ''
      ${builtins.readFile ./settings.lua}
      vim.keymap.set('n', '<leader>tr', vim.cmd.NvimTreeToggle)
      vim.keymap.set('n', '<leader>tt', vim.cmd.NvimTreeFocus)
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
      vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
    '';
    extraPackages = with pkgs; [
      lua-language-server ## Remove with direnv
      #rnix-lsp -- unmaintained and removed
      rust-analyzer

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
      undotree

      plenary-nvim
      telescope-fzf-native-nvim
      (withLua telescope-nvim)

      vim-fugitive

      ## lsp
      neodev-nvim
      nvim-cmp # Autocompletion
      rust-tools-nvim
      {
        plugin = nvim-bacon; # Rust Bacon
        type = "lua";
        config = inlineLua ./plugins/bacon.lua;
      }
      dressing-nvim 
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = inlineLua ./plugins/lsp.lua;
      }

      (withLua comment-nvim)

      (withLua lualine-nvim)

      nvim-web-devicons
      (withDefaultCfg nvim-tree-lua "nvim-tree")

      #copilot-cmp
      #copilot-vim

      (withDefaultCfg indent-blankline-nvim "ibl")

      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-nvim-lua
      cmp-buffer
      cmp-path
      vim-vsnip
      cmp-vsnip
      luasnip
      cmp_luasnip
      cmp-cmdline
      (withLua nvim-cmp)

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
