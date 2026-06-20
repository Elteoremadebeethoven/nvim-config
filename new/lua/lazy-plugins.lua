require("lazy").setup({
  -- ============= LSP =============
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      "folke/neodev.nvim",
    },
  },

  -- ============= Treesitter (nueva API) =============
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "bash", "c", "cpp", "css", "html", "javascript", "json",
          "lua", "python", "rust", "scss", "tsx", "typescript",
          "vim", "vue",
        },
        sync_install = false,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
          goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
          goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
          goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
        },
        swap = {
          enable = true,
          swap_next = { ["<leader>a"] = "@parameter.inner" },
          swap_previous = { ["<leader>A"] = "@parameter.inner" },
        },
      })
    end,
  },

  -- ============= Completion =============
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
  },

  -- ============= UI =============
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("gitsigns").setup() end,
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = { options = { buffer_close_icon = "󰅖" } },
  },
  {
    "SmiteshP/nvim-navic",
    lazy = false,
    config = function() require("nvim-navic").setup() end,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    lazy = false,
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = { attach_navic = false },
  },
  { "folke/which-key.nvim", opts = {} },
  { "mg979/vim-visual-multi" },

  -- ============= Movimiento (hop → flash) =============
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "asdfghjkl",
      search = {
        forward = true,
        backward = true,
        wrap = true,
        multi_line = true,
      },
      jump = {
        autojump = true,
      },
    },
    config = function(_, opts)
      require("flash").setup(opts)
      local flash = require("flash")
      -- s = flash backward (era S antes, ahora en s por preferencia)
      vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump({ backward = true }) end, { desc = "Flash backward" })
      vim.keymap.set("n", "<C-s>", function() flash.treesitter() end, { desc = "Flash treesitter" })
    end,
  },
  {
    "smoka7/hop.nvim",
    version = "*",
    config = function()
      local ok, hop = pcall(require, "hop")
      if ok then hop.setup() end
    end,
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      local ok, p = pcall(require, "illuminate.providers.lsp")
      if ok then
        p.is_ready = function(bufnr)
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
  { "windwp/nvim-autopairs" },
  { "numToStr/Comment.nvim", opts = {} },
  { "windwp/nvim-ts-autotag" },
  { "HiPhish/rainbow-delimiters.nvim" },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {},
  },

  -- ============= Search =============
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = function() return vim.fn.executable("make") == 1 end,
  },
  { "rmagatti/goto-preview" },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function() require("todo-comments").setup() end,
  },

  -- ============= Git / Terminal =============
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gvdiffsplit", "Gread", "Gwrite", "Ggrep" },
    ft = { "fugitive" },
  },
  { "kdheepak/lazygit.nvim" },
  { "akinsho/toggleterm.nvim", version = "*" },

  -- ============= DAP =============
  {
    "jayp0521/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
  },

  -- ============= LSP tools =============
  { "nvimtools/none-ls.nvim" },

  -- ============= Indent / Misc =============
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-sleuth" },
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "tokyonight" } } },

  -- ============= Colorscheme (solo uno) =============
  { "folke/tokyonight.nvim", branch = "main", priority = 1000 },
}, {})
