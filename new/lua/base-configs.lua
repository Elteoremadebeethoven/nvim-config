vim.wo.number = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.o.termguicolors = true

vim.opt.laststatus = 3
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.scrolloff = 2
vim.opt.shell = "zsh"
vim.opt.path:append { "**" }
vim.opt.wildignore:append { "*/node_modules/*" }

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.autoindent = true

vim.opt.cursorline = true
vim.opt.numberwidth = 2
vim.opt.undofile = true
vim.o.undodir = "/tmp/.vim/.undodir"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.py" },
  command = "setlocal tabstop=2 shiftwidth=2",
})
