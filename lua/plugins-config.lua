require'nvim-web-devicons'.setup {
 enabled = vim.g.icons_enabled,
 override = {
  info = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Information"
  },

 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
 -- globally enable "strict" selection of icons - icon will be looked up in
 -- different tables, first by filename, and if not found by extension; this
 -- prevents cases when file doesn't have any extension but still gets some icon
 -- because its name happened to match some extension (default to false)
 strict = true;
 -- same as `override` but specifically for overrides by filename
 -- takes effect when `strict` is true
 override_by_filename = {
  [".gitignore"] = {
    icon = "",
    color = "#f1502f",
    name = "Gitignore"
  },
  ["dockerfile"] = {
    icon = "",
    color = "#0088B3",
    name = "Dockerfile"
  }

 };
 -- same as `override` but specifically for overrides by extension
 -- takes effect when `strict` is true
 override_by_extension = {
  ["log"] = {
    icon = "",
    color = "#81e043",
    name = "Log"
  },
  ["Dockerfile"] = {
    icon = "",
    color = "#0088B3",
    name = "Dockerfile"
  },
 };
}
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local a_status, t_actions = pcall(require, 'telescope.actions')
if (not a_status) then
  print("No actions added")
else
  require('telescope').setup {
    defaults = {
      mappings = {
        i = {
          -- ['<C-u>'] = true,
          -- ['<C-d>'] = false,
          ["<C-j>"] = t_actions.move_selection_next,
          ["<C-k>"] = t_actions.move_selection_previous,
        },
      },
    },
  }
end
-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
require("telescope").load_extension("lazygit")

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  -- ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'help', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,
  -- open_on_setup = true,
  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}



local navic = require("nvim-navic")
require("nvim-navbuddy").setup()
local navbuddy = require("nvim-navbuddy")
-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
-- NOTE: Remember that lua is a real programming language, and as such it is possible
-- to define small helper and utility functions so you don't have to repeat yourself
-- many times.
--
-- In this case, we create a function that lets us more easily define mappings specific
-- for LSP related items. It sets the mode, buffer and description for us each time.
if (client.name == "tsserver") or (client.name =="volar" ) or (client.name == "tailwindcss") then
  -- client.resolved_capabilities.document_formatting = false -- 0.7 and earlier
  client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
  -- client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = false
else
  client.server_capabilities.documentFormattingProvider = true -- 0.8 and later
  client.server_capabilities.documentRangeFormattingProvider = true
end


if client.server_capabilities.documentSymbolProvider then
  navic.attach(client, bufnr)
  navbuddy.attach(client, bufnr)
end
  -- if client.name ~= 'tailwindcss' then
  --   formatting_callback(client, bufnr)
  --   print(client.name)
  -- end

-- Create a command `:Format` local to the LSP buffer
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
clangd = {},
pyright = {
    python = {
      analysis = {
        typeCheckingMode = "off",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true
      }
    }
},
volar = {
  filetypes = {'vue', 'typescript', 'javascript', 'json'},
},
rust_analyzer = {},
tsserver = {
  filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact", "javascript.jsx" },
  cmd = { "typescript-language-server", "--stdio" }
},
tailwindcss = {
  filetypes = {"html", "css", "scss"}
},
cssls = {
  filetypes = {"vue", "css", "scss"}
},

lua_ls = {
  Lua = {
    workspace = { checkThirdParty = false },
    telemetry = { enable = false },
  },
},
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
function(server_name)

  require('lspconfig')[server_name].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = servers[server_name],
  }
end,
}

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

cmp.setup {
snippet = {
  expand = function(args)
    luasnip.lsp_expand(args.body)
  end,
},
mapping = cmp.mapping.preset.insert {
  ['<C-j>'] = cmp.mapping.scroll_docs(-4),
    ['<C-k>'] = cmp.mapping.scroll_docs(4),
    ['<C-b>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },

  sources = {
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "nvim_lua" },
    { name = "path" },
  },
}
--
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})






require'lspconfig'.volar.setup{
  filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
  on_attach = on_attach,
  capabilities = capabilities
}



local status_autopairs, autopairs = pcall(require, 'nvim-autopairs')
if (not status_autopairs) then
  print('No autopairs added')
else
  autopairs.setup()
end

local status_hop, hop = pcall(require, 'hop')
if (not status_hop) then
  print("Hop not added")
else
  hop.setup()
end



local status_goto, gotop = pcall(require, 'goto-preview')
if (not status_goto) then
  print("Goto preview not added")
else
  gotop.setup {
    width = 90,
    height = 13,
    default_mappings = false,
    debug = false,
    opacity = nil,
    post_open_hook = nil
  }
end

vim.opt.termguicolors = true
-- require("bufferline").setup{}


local status_indent, indent_line = pcall(require, 'indent_blankline')
if (not status_indent) then
  print("Indent blankline not added")
else
  vim.opt.termguicolors = false
  -- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#333333 gui=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineContextChar guifg=#C3251C gui=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineChar guifg=#FF0000 gui=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineSpaceChar guifg=#FF0000 gui=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineSpaceCharBlankline guifg=#FF0000 gui=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineContextSpaceChar guifg=#FF0000 gui=nocombine]]
  -- vim.cmd [[highlight IndentBlanklineContextStart guifg=#FF0000 gui=nocombine]]
  vim.opt.termguicolors = false
  indent_line.setup {
    space_char_blankline = " ",
    -- char_highlight_list = {
    --   "IndentBlanklineIndent1",
    --   "IndentBlanklineIndent1",
    --   "IndentBlanklineIndent1",
    --   "IndentBlanklineIndent1",
    --   "IndentBlanklineIndent1",
    --   "IndentBlanklineIndent1",
    -- },
  }
end

require("symbols-outline").setup()


local status_comment, comment = pcall(require, 'Comment')
if (not status_comment) then
  comment.setup()
end


require('nvim-treesitter.configs').setup({
  rainbow = {
    enable = true,
    disable = { "vue", "html", "css", "scss", "javascriptreact", "typescriptreact", "tsx", "jsx", "javascript.jsx"},
    extended_mode = true,
    max_file_lines = nil,
  },
})


require("colorizer").setup {
  filetypes = { "*" },
  user_default_options = {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = true, -- "Name" codes like Blue or blue
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    AARRGGBB = true, -- 0xAARRGGBB hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    -- Available modes for `mode`: foreground, background,  virtualtext
    mode = "background", -- Set the display mode.
    -- Available methods are false / true / "normal" / "lsp" / "both"
    -- True is same as normal
    tailwind = false, -- Enable tailwind colors
    -- parsers can contain values used in |user_default_options|
    sass = { enable = true }, -- Enable sass colors
    virtualtext = "■",
    -- update color values even if buffer is not focused
    -- example use: cmp_menu, cmp_docs
    always_update = false
  },
  buftypes = {},
}

vim.g.navic_silence = true

-- Lua
require("lualine-config")


local status, bufferline = pcall(require, "bufferline")
if (not status) then return end

bufferline.setup({
  options = {
    -- mode = "tabs",
    always_show_bufferline = true,
    show_buffer_close_icons = true,
    color_icons = true,
    indicator = {
      icon = " 喇",
      style = "icon"
    },
    close_icon = '',
    diagnostics = "nvim_lsp",
    -- separator_style =  "slant" ,
    show_tab_indicators = true,
    buffer_close_icon = "窱",
    diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or ""
        return " " .. icon .. count
    end
  },
})



vim.g.icons_enabled = true


require("toggleterm").setup{
  open_mapping = [[<M-F>]],
  shade_filetypes = {},
  autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
  highlights = {
    -- highlights which map to a highlight group name and a table of it's values
    -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
    NormalFloat = {
      link = 'Normal'
    },
  },
  shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
  direction = 'float',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  auto_scroll = true, -- automatically scroll to the bottom on terminal output
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'curved' ,
    -- like `size`, width and height can be a number or function which is passed the current terminal
    winblend = 3,
  },
}

require('illuminate').configure({
    -- providers: provider used to get references in the buffer, ordered by priority
    providers = {
        'lsp',
        'treesitter',
        'regex',
    },
    -- delay: delay in milliseconds
    delay = 100,
    -- filetype_overrides: filetype specific overrides.
    -- The keys are strings to represent the filetype while the values are tables that
    -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
    filetype_overrides = {},
    -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
    filetypes_denylist = {
        'dirvish',
        'fugitive',
    },
    -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
    filetypes_allowlist = {},
    -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
    -- See `:help mode()` for possible values
    modes_denylist = {},
    -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
    -- See `:help mode()` for possible values
    modes_allowlist = {},
    -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
    -- Only applies to the 'regex' provider
    -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    providers_regex_syntax_denylist = {},
    -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
    -- Only applies to the 'regex' provider
    -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    providers_regex_syntax_allowlist = {},
    -- under_cursor: whether or not to illuminate under the cursor
    under_cursor = true,
    -- large_file_cutoff: number of lines at which to use large_file_config
    -- The `under_cursor` option is disabled when this cutoff is hit
    large_file_cutoff = nil,
    -- large_file_config: config to use for large files (based on large_file_cutoff).
    -- Supports the same keys passed to .configure
    -- If nil, vim-illuminate will be disabled for large files.
    large_file_overrides = nil,
    -- min_count_to_highlight: minimum number of matches required to perform highlighting
    min_count_to_highlight = 1,
})

vim.cmd("hi def IlluminatedWordText gui=underline")

require("transparent").setup({
  groups = { -- table: default groups
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLineNr', 'EndOfBuffer', 'CursorLine', 'Telescope',
  },
  extra_groups = {}, -- table: additional groups that should be cleared
  exclude_groups = {}, -- table: groups you don't want to clear
})

--
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier.with({
      extra_args = {
        "--print-with", "80"
      },
      filetypes = {
        "typescript", "typescriptreact", "javascript", "vue"
      },
    }),
  },
})

local lspconfig = require("lspconfig")

capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}
lspconfig.emmet_ls.setup({
  capabilities = capabilities,
  filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', "vue" }
})

