vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.py" },
  command = "setlocal tabstop=2 shiftwidth=2"
})

vim.cmd[[ 
  let g:python_recommended_style = 0
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

