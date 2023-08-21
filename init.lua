require("started")
require("base-configs")
require("lazy-plugins")
require("plugins-config")
require("keymaps")

local t_status, gb = pcall(require, "gruvbox")
if not t_status then
  vim.cmd [[highlight IndentBlanklineContextChar guifg=#C3251C gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineChar guifg=#FF0000 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineSpaceChar guifg=#FF0000 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineSpaceCharBlankline guifg=#FF0000 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineContextSpaceChar guifg=#FF0000 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineContextStart guifg=#FF0000 gui=nocombine]]
  gb.setup({
      -- palette_overrides = {
      --   dark0_hard = "#161616",
      -- },
      contrast = "hard",
      overrides = {
          Constant = {link="GruvboxPurpleBold"},
          StorageClass = {fg = "#98A254", bold=true},
          Type = {link="GruvboxYellowBold"},
          -- ["@constructor"] = {fg = "#98A254", bold=true},
          Identifier = {link="GruvboxBlue"},
          -- ["@tag.attribute"] = {fg="#98A254"},
          ["@parameter"] = {link = "GruvboxYellow"},
          ["@variable.builtin"] = {link="GruvboxYellowBold"},
          htmlArg = {link="GruvboxRed"},
          Conditional = { link = "GruvboxRedBold" },
          Statement = { link = "GruvboxRedBold" },
          Repeat = { link = "GruvboxRedBold" },
          Label = { link = "GruvboxRedBold" },
          Keyword = { link = "GruvboxRedBold" },
          Tag = { link = "GruvboxRedBold" },
          Special = { link = "GruvboxOrangeBold" },
          ["@text.uri"] = {},
          -- typescriptIdentifier = { link = "GruvboxOrange" },
          -- Conceal = {fg = "#98A254", bold=true},
      }
    })
  -- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#333333 gui=nocombine]]
  vim.cmd[[colorscheme gruvbox]]
else
  --vim.cmd [[highlight IndentBlanklineIndent1 guifg=#333333 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineContextChar guifg=#C3251C gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineChar guifg=#9D7CD8 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineSpaceChar guifg=#9D7CD8 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineSpaceCharBlankline guifg=#9D7CD8 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineContextSpaceChar guifg=#9D7CD8 gui=nocombine]]
  vim.cmd [[highlight IndentBlanklineContextStart guifg=#9D7CD8 gui=nocombine]]
  require("tokyonight").setup({
    style = "night",
    styles = {
      comments = { italic = true },
      keywords = { bold = true },
      functions = { bold = true },
      variables = {},
      operators = { bold = true },
      booleans = { bold = true },
      sidebars = "dark",
      floats = "dark",
    },
    on_highlights = function(hl, c)
      hl.CursorLine = { bg = c.bg_highlight }
      hl.Visual = { bg = "#484a37" }
      hl.Type                 = { fg = c.blue1, bold = true }
      hl.Conditional          = { fg = c.magenta, bold = true }
      hl.Repeat               = { fg = c.magenta, bold = true }
      hl.Label                = { fg = c.red }
      hl.Constant             = { fg = c.orange, bold = true }
      hl.String               = { fg = c.green }
      hl.Character            = { fg = c.green }
      hl.Number               = { fg = c.orange }
      hl.Boolean              = { fg = c.orange }
      hl.Float                = { fg = c.orange }
      hl["@constructor"]      = { fg = c.blue1 }
      hl["@variable.builtin"] = { fg = c.red }
      hl["@text.uri"] = {}
      hl.Include              = { fg = c.magenta, bold = true }
      hl.rainbowcol1          = { fg = '#F4CA0D' }
      hl.rainbowcol2          = { fg = c.purple }
      hl.rainbowcol3          = { fg = c.cyan }
      hl.rainbowcol4          = { fg = '#F4CA0D' }
      hl.rainbowcol5          = { fg = c.purple }
      hl.rainbowcol6          = { fg = c.cyan }
      hl.rainbowcol7          = { fg = '#F4CA0D' }
      -- hl.rainbowcol7 = { fg = c.purple }
      hl["@punctuation.bracket"] = { fg = c.magenta } -- For brackets and parens.
    end
  })
  vim.cmd[[colorscheme tokyonight-night]]
  vim.cmd[[
    highlight RainbowDelimiterRed  guifg=#f4ca0d ctermfg=White
    highlight RainbowDelimiterYellow guifg=#9d7cd8 ctermfg=White
    highlight RainbowDelimiterBlue guifg=#7dcfff ctermfg=White
    highlight RainbowDelimiterOrange guifg=#f4ca0d ctermfg=White
    highlight RainbowDelimiterGreen guifg=#9d7cd8 ctermfg=White
    highlight RainbowDelimiterViolet guifg=#7dcfff ctermfg=White
    highlight RainbowDelimiterCyan guifg=#f4ca0d ctermfg=White
  ]]
  -- vim.cmd("vim.g.tokyonight_transparent = vim.g.transparent_enabled")
  -- vim.cmd[[hi NvimTreeNormal guibg=NONE ctermbg=NONE]]
  -- vim.cmd("autocmd Colorscheme * highlight NvimTreeNormal guibg=none guifg=##16161E")

end


