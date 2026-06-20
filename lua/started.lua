vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Override deprecated vim.lsp.buf_get_clients() to suppress the deprecation
-- warning on nvim 0.11+. Some plugins still call it internally.
vim.lsp.buf_get_clients = function(bufnr)
  return vim.lsp.get_clients({ bufnr = vim._resolve_bufnr(bufnr) })
end


vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.py" },
  command = "setlocal tabstop=2 shiftwidth=2"
})
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.rs" },
--   command = "setlocal tabstop=2 shiftwidth=2"
-- })

vim.cmd[[ 
  let g:python_recommended_style = 0
  autocmd FileType java setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd FileType rust setlocal tabstop=2 shiftwidth=2 expandtab
]]

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

