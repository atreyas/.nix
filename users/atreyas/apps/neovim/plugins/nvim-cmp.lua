local luasnip = require('luasnip')
local cmp = require('cmp')
local map = cmp.mapping

-- VSCode style snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup {
  completion = {
    completeopt = 'menu,menuone,preview,noselect',
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert {
    ['<C-k>'] = map.select_prev_item(),
    ['<C-j>'] = map.select_next_item(),
    ['<C-b>'] = map.scroll_docs(-4),
    ['<C-f>'] = map.scroll_docs(4),
    ['<C-Space>'] = map.complete(),
    ['<C-c>'] = map.abort(),
    ['<CR>'] = map.confirm { select = false },
  },

  sources = cmp.config.sources {
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  },
}

