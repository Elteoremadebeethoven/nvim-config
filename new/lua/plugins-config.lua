require("nvim-web-devicons").setup()

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
  group = highlight_group,
  pattern = "*",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "javascript", "typescript", "tsx", "jsx", "lua", "rust", "html", "css", "scss", "vue" },
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- ============ Telescope ============
local ok, t_actions = pcall(require, "telescope.actions")
if ok then
  require("telescope").setup({
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = t_actions.move_selection_next,
          ["<C-k>"] = t_actions.move_selection_previous,
        },
      },
    },
  })
  pcall(require("telescope").load_extension, "fzf")
end

-- ============ LSP ============
local servers = {
  clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_markers = { ".clangd", "compile_commands.json", ".git" },
  },
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyrightconfig.json", "pyproject.toml", "setup.py", ".git" },
  },
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  },
  cssls = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_markers = { "package.json", ".git" },
  },
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", "lua", ".git" },
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
  vue_ls = {
    cmd = { "vue-language-server", "--stdio" },
    filetypes = { "vue" },
    root_markers = { "package.json", ".git" },
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
})

vim.lsp.config("*", { capabilities = capabilities })
for name, cfg in pairs(servers) do
  vim.lsp.config(name, cfg)
end
vim.lsp.enable(vim.tbl_keys(servers))

-- ============ nvim-cmp ============
local cmp = require("cmp")
local luasnip = require("luasnip")
luasnip.config.setup {}

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-j>"] = cmp.mapping.scroll_docs(-4),
    ["<C-k>"] = cmp.mapping.scroll_docs(4),
    ["<C-b>"] = cmp.mapping.complete {},
    ["<CR>"] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})

-- ============ Autopairs ============
local ok_ap, autopairs = pcall(require, "nvim-autopairs")
if ok_ap then autopairs.setup() end

-- ============ Goto preview ============
local ok_gp, gotop = pcall(require, "goto-preview")
if ok_gp then
  gotop.setup { width = 90, height = 13, default_mappings = false }
end

-- ============ Colorizer ============
local ok_cz, colorizer = pcall(require, "colorizer")
if ok_cz then
  colorizer.setup {
    filetypes = { "*" },
    user_default_options = {
      RGB = true, RRGGBB = true, names = true, RRGGBBAA = true, AARRGGBB = true,
      rgb_fn = true, hsl_fn = true, css = true, css_fn = true,
      mode = "background", tailwind = false,
      sass = { enable = false },
    },
  }
end

-- ============ Illuminate ============
local ok_il, illuminate = pcall(require, "illuminate")
if ok_il then illuminate.configure({}) end

-- ============ Indent blankline ============
require("ibl").setup {
  scope = { enabled = true, show_start = false, show_end = false },
}

-- ============ Rainbow delimiters ============
vim.g.rainbow_delimiters = {
  strategy = { [''] = 'rainbow-delimiters.strategy.global' },
  query = { [''] = 'rainbow-delimiters' },
  highlight = {
    'RainbowDelimiterRed', 'RainbowDelimiterYellow', 'RainbowDelimiterBlue',
    'RainbowDelimiterOrange', 'RainbowDelimiterGreen', 'RainbowDelimiterViolet', 'RainbowDelimiterCyan',
  },
}

-- ============ Nvim-tree ============
require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  view = { side = "left", width = 30 },
  git = { enable = true, ignore = false },
  renderer = { indent_markers = { enable = true } },
})

-- ============ Trouble ============
vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>tq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix" })
vim.keymap.set("n", "<leader>tl", "<cmd>Trouble loclist toggle<cr>", { desc = "Loclist" })
vim.keymap.set("n", "<leader>tr", "<cmd>Trouble lsp_references toggle<cr>", { desc = "LSP references" })

-- ============ Toggleterm ============
require("toggleterm").setup {
  open_mapping = [[<M-F>]],
  direction = "float",
  start_in_insert = true,
  float_opts = { border = "curved", winblend = 3 },
}

-- ============ None-ls ============
local ok_nl, null_ls = pcall(require, "null-ls")
if ok_nl then
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.prettier.with({
        extra_args = { "--print-width", "80" },
        filetypes = { "typescript", "typescriptreact", "javascript", "vue" },
      }),
    },
  })
end

-- ============ Spectre (search & replace) ============
local ok_sp, spectre = pcall(require, "spectre")
if ok_sp then spectre.setup() end

-- ============ Visual multi ============
vim.cmd [[
  nmap <M-C-j> <Plug>(VM-Add-Cursor-Down)
  nmap <M-C-k> <Plug>(VM-Add-Cursor-Up)
  nmap <C-LeftMouse> <Plug>(VM-Mouse-Cursor)
  nmap <C-RightMouse> <Plug>(VM-Mouse-Word)
  nmap <M-C-RightMouse> <Plug>(VM-Mouse-Column)
]]

-- ============ TokyoNight (theme) ============
local ok_tn, tn = pcall(require, "tokyonight")
if ok_tn then
  tn.setup({ style = "night" })
  vim.cmd.colorscheme("tokyonight-night")
end

-- ============ Navbuddy (quitado del spec, queda disponible pero no auto-attach) ============

-- ============ Statusline ============
require("lualine").setup({
  options = { theme = "tokyonight" },
})
