local lspconfig = require('lspconfig')
local lsp = vim.lsp

local on_attach = function(client, bufnr)
  local bufmap = function(keys, func) vim.api.nvim_buf_set_keymap(bufnr, 'n', keys, func) end

  bufmap('<leader>r', lsp.buf.rename)
  bufmap('<leader>a', lsp.buf.code_action)

  bufmap('gd', lsp.buf.definition)
  bufmap('gD', lsp.buf.declaration)
  bufmap('gI', lsp.buf.implementation)
  bufmap('<leader>D', lsp.buf.type_definition)

  if client.resolved_capabilities.document_formatting then
    bufmap('<leader>gq', lsp.buf.formatting)
  elseif client.resolved_capabilities.document_range_formatting then
    bufmap('<leader>gq', lsp.buf.range_formatting)
  end

  -- bufmap('gr', require('telescope.builtin').lsp_references)
  -- bufmap('<leader>s', require('telescope.builtin').lsp_document_symbols)
  -- bufmap('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols)

  bufmap('<C-space>', lsp.buf.hover)

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    lsp.buf.format()
  end, {})
end

local capabilities = lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('neodev').setup {
  override = function(root_dir, library)
    if root_dir:find(".nix", 1, true) == 1 then
      library.enabled = true
      library.plugins = true
    end
  end,
}

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
  },
}

require('rust-tools').setup {
  tools = {
    autoSetHints = true,
    runnables = {
      use_telescope = true
    },
    inlay_hints = {
      show_parameter_hints = true,
      parameter_hints_prefix = "<- ",
      other_hints_prefix = "=> ",
    },
  },
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
  },
}
lspconfig.rust_analyzer.setup {
  on_attach = function(client, bufnr)
    -- Hover actions
    vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
    -- Code action groups
    vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
      workspace = {
        symbol = {
          search = {
            kind = "all_symbols"
          }
        }
      }
    },
  }
}

local servers = { 'clangd', 'pyright', 'ts_ls', 'vls', 'yamlls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
