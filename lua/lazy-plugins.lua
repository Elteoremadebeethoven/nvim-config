require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',
  'yorik1984/newpaper.nvim',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'saadparwaiz1/cmp_luasnip' },
  },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },

  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
    },
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme 'onedark'
    -- end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'tokyonight',
        -- component_separators = '|',
        -- section_separators = '',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
    },
  },

  -- {
  --   -- Add indentation guides even on blank lines
  --   'lukas-reineke/indent-blankline.nvim',
  --   -- Enable `lukas-reineke/indent-blankline.nvim`
  --   -- See `:help indent_blankline.txt`
  --   opts = {
  --     char = '│',
  --     show_current_context = true,
  --     show_trailing_blankline_indent = false,
  --   },
  --   -- main=""
  -- },
  { "lukas-reineke/indent-blankline.nvim", main = "ibl",  opts = {} },
  { 'numToStr/Comment.nvim',               opts = {} },
  { 'nvim-telescope/telescope.nvim',       version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    -- Patch query_predicates directives to handle nvim 0.12 API change
    -- (vim.treesitter.get_node_text now requires a node with a :range() method).
    -- Without these patches, the treesitter highlighter errors with
    -- "attempt to call method 'range' (a nil value)" and can leave the last
    -- line uncolored.
    config = function()
      local aliases = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
      local html_script = { importmap = "json", module = "javascript", ["application/ecmascript"] = "javascript", ["text/ecmascript"] = "javascript" }
      local function get_parser_from_info_string(alias)
        local match = vim.filetype.match { filename = 'a.' .. alias }
        return match or aliases[alias] or alias
      end
      local function safe_node_text(node, bufnr, metadata)
        local ok, text = pcall(vim.treesitter.get_node_text, node, bufnr, metadata)
        if not ok or type(text) ~= 'string' then return nil end
        return text
      end
      vim.treesitter.query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
        local node = match[pred[2]]
        if not node then return end
        local text = safe_node_text(node, bufnr)
        if not text then return end
        metadata['injection.language'] = get_parser_from_info_string(text:lower())
      end, { all = true, force = true })
      vim.treesitter.query.add_directive('set-lang-from-mimetype!', function(match, _, bufnr, pred, metadata)
        local node = match[pred[2]]
        if not node then return end
        local text = safe_node_text(node, bufnr)
        if not text then return end
        local configured = html_script[text]
        if configured then
          metadata['injection.language'] = configured
        else
          local parts = vim.split(text, '/', {})
          metadata['injection.language'] = parts[#parts]
        end
      end, { all = true, force = true })
      vim.treesitter.query.add_directive('downcase!', function(match, _, bufnr, pred, metadata)
        local id = pred[2]
        local node = match[id]
        if not node then return end
        local text = safe_node_text(node, bufnr, { metadata = metadata[id] }) or ''
        if not metadata[id] then metadata[id] = {} end
        metadata[id].text = text:lower()
      end, { all = true, force = true })
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    "SmiteshP/nvim-navic",
    requires = "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      require("nvim-navic").setup()
    end
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    lazy = false,
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      attach_navic = false,
      symbols = {
      },
      kinds = {
      },
    }
  },
  { "ellisonleao/gruvbox.nvim" },
  { 'tiagovla/tokyodark.nvim' },
  { "windwp/nvim-autopairs" },
  {
    "simrat39/symbols-outline.nvim",
    -- Patch deprecated vim.lsp.buf_get_clients() -> vim.lsp.get_clients({ bufnr = ... })
    config = function()
      local ok, lsp_utils = pcall(require, "symbols-outline.utils.lsp_utils")
      if ok then
        lsp_utils.is_buf_attached_to_lsp = function(bufnr)
          return #vim.lsp.get_clients({ bufnr = bufnr or 0 }) > 0
        end
      end
      local ok2, nvim_lsp = pcall(require, "symbols-outline.providers.nvim-lsp")
      if ok2 then
        nvim_lsp.hover_info = function(bufnr, params, on_info)
          local config = require("symbols-outline.config")
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if not config.is_client_blacklisted(client.id) and client.server_capabilities.hoverProvider then
              client.request("textDocument/hover", params, on_info, bufnr)
              return
            end
          end
          on_info(nil, { contents = { kind = "markdown", content = { "No extra information available!" } } })
        end
        nvim_lsp.should_use_provider = function(bufnr)
          local config = require("symbols-outline.config")
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if not config.is_client_blacklisted(client.id) and client.server_capabilities.documentSymbolProvider then
              return true
            end
          end
          return false
        end
      end
    end,
  },
  { "rmagatti/goto-preview" },
  {
    'smoka7/hop.nvim',
    version = '*',
  },
  { 'folke/tokyonight.nvim', branch = 'main' },
  { 'numToStr/Comment.nvim' },
  {
    'akinsho/bufferline.nvim',
    requires = 'nvim-tree/nvim-web-devicons',
    opts = {
      options = {
        buffer_close_icon = "窱"
      }
    }
  },
  { 'NvChad/nvim-colorizer.lua' },
  -- { 'mrjones2014/nvim-ts-rainbow' },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  {
    "mg979/vim-visual-multi",
    config = function()
      vim.cmd [[
      nmap   <M-C-j>         <Plug>(VM-Add-Cursor-Down)
      nmap   <M-C-k>         <Plug>(VM-Add-Cursor-Up)
      nmap   <C-LeftMouse>         <Plug>(VM-Mouse-Cursor)
      nmap   <C-RightMouse>        <Plug>(VM-Mouse-Word)
      nmap   <M-C-RightMouse>      <Plug>(VM-Mouse-Column)
      ]]
    end
  },
  {
    "jayp0521/mason-nvim-dap.nvim",
    -- event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    -- enabled = vim.fn.has "win32" == 0,
  },
  { "MunifTanjim/nui.nvim" },
  {
    "SmiteshP/nvim-navbuddy",
    requires = {
      "neovim/nvim-lspconfig",
      "SmiteshP/nvim-navic",
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      -- "Gdiffsplit",
      "Gvdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit"
    },
    ft = { "fugitive" }
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = { --[[ things you want to change go here]] }
  },
  {
    "RRethy/vim-illuminate",
    -- Patch client.supports_method (dot syntax) -> client:supports_method (colon)
    -- to avoid the "client.supports_method is deprecated" warning on nvim 0.11+.
    -- Re-applied on every nvim start, so it survives :Lazy update.
    config = function()
      local ok, lsp_provider = pcall(require, "illuminate.providers.lsp")
      if ok then
        lsp_provider.is_ready = function(bufnr)
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if client and client:supports_method("textDocument/documentHighlight") then
              return true
            end
          end
          return false
        end
      end
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
  },
  { "kdheepak/lazygit.nvim" },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  "xiyaowong/transparent.nvim",
  "nvimtools/none-ls.nvim",
  "aca/emmet-ls",
  "nvim-pack/nvim-spectre",
  "derektata/lorem.nvim",
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = 'rainbow-delimiters.strategy.global',
          vim = 'rainbow-delimiters.strategy.local',
        },
        query = {
          [''] = 'rainbow-delimiters',
          javascript = 'rainbow-delimiters-react',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },
  "tikhomirov/vim-glsl",
  -- "eclipse-jdtls/eclipse.jdt.ls",
  {
    'nvim-java/nvim-java',
    dependencies = {
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      {
        'williamboman/mason.nvim',
        opts = {
          registries = {
            'github:nvim-java/mason-registry',
            'github:mason-org/mason-registry',
          },
        },
      }
    },
  }


  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  --
  --    An additional note is that if you only copied in the `init.lua`, you can just comment this line
  --    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
  -- { import = 'custom.plugins' },
}, {})
