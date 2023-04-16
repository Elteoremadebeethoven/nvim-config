-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim. Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'
vim.cmd("set clipboard+=unnamedplus")

-- Enable break indent
vim.o.breakindent = true


-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true


-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.

-- [[ Setting options ]]
-- See `:help vim.o`
vim.opt.laststatus = 3 -- global statusline
-- Set highlight on search
vim.o.hlsearch = false


vim.scriptencoding    = 'utf-8'
vim.opt.encoding      = 'utf-8'
vim.opt.fileencoding  = 'utf-8'


vim.opt.title         = true
vim.opt.hlsearch      = true

vim.opt.backup        = false
vim.opt.showcmd       = true
vim.opt.cmdheight     = 1
-- vim.opt.laststatus    = 2
vim.opt.scrolloff     = 2
vim.opt.shell         = 'zsh'

vim.opt.backupskip    = '/tmp/*./private/tmp/*'
vim.opt.inccommand    = 'split'
vim.opt.ignorecase    = true
vim.opt.breakindent   = true
vim.opt.ai            = true
vim.opt.si            = true
vim.opt.wrap          = false
vim.opt.backspace     = 'start,eol,indent'
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules/*' }

vim.opt.tabstop         = 2
vim.opt.showtabline     = 2
-- vim.opt.relativenumber  = true
vim.opt.numberwidth     = 2
vim.opt.shiftwidth      = 2
vim.opt.softtabstop     = 2
vim.opt.smartindent     = true
vim.opt.smarttab        = true
vim.opt.expandtab       = true
vim.opt.autoindent      = true
vim.opt.cindent         = true

vim.opt.cursorline = true
vim.opt.winblend   = 0
vim.wildoptions    = 'pum'
vim.opt.pumblend   = 5

vim.opt.undofile = true
vim.o.undodir = '/tmp/.vim/.undodir'
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
vim.opt.showmode = false

vim.cmd[[
  set guifont=Fira\ Code\:h15
  let g:neovide_input_macos_alt_is_meta = v:true
]]

vim.g.neovide_input_macos_alt_is_meta = true


vim.cmd [[
" system clipboard
  nmap <s-c-c> "+y
  vmap <s-c-c> "+y
  nmap <s-c-v> "+p
  inoremap <c-v> <c-r>+
  cnoremap <c-v> <c-r>+
  " use <c-r> to insert original character without triggering things like auto-pairs
  inoremap <c-r> <c-v>
  "keep visual mode after indent
  vnoremap > >gv
  vnoremap < <gv
]]
