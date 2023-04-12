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
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
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
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
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

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '│',
      show_current_context = true,
      show_trailing_blankline_indent = false,
    },
  },
  { 'numToStr/Comment.nvim',         opts = {} },
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
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
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
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
      symbols = {
      },
      kinds = {
      },
    }
  },
  { "ellisonleao/gruvbox.nvim" },
  { 'tiagovla/tokyodark.nvim' },
  { "windwp/nvim-autopairs" },
  { "simrat39/symbols-outline.nvim" },
  { "rmagatti/goto-preview" },
  {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
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
  { 'mrjones2014/nvim-ts-rainbow' },
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
  { "RRethy/vim-illuminate" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  { "kdheepak/lazygit.nvim" },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  "xiyaowong/transparent.nvim",
  "jose-elias-alvarez/null-ls.nvim",
  "aca/emmet-ls",


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
