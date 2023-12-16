local on_attach = function(_client, bufnr)
  local bufmap = function(keys, func)
	vim.keymap.set('n', keys, func, { buffer, bufnr })
  end

end


