local keymap = vim.keymap

-- Mover líneas
keymap.set("n", "<A-j>", ":m .+1<CR>==")
keymap.set("n", "<A-k>", ":m .-2<CR>==")
keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>==gi")
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- Flash (motions)
-- (los keymaps se registran en lazy-plugins.lua via flash.config)
-- S = hop word (instant motion)
keymap.set("n", "S", ":HopWord<CR>", { desc = "Hop word" })

-- Salir de terminal
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>")
keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h<CR>")
keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k<CR>")
keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j<CR>")
keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l<CR>")
keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h<CR>")

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Buffers
keymap.set("n", "<M-m>", ":BufferLineMoveNext<CR>")
keymap.set("n", "<M-b>", ":BufferLineMovePrev<CR>")
keymap.set("n", "<C-s>", ":w<CR>")
keymap.set("i", "<C-s>", "<ESC>:w<CR>a")

-- Comentarios
keymap.set("n", "<Leader>/", '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>')
keymap.set("v", "<Leader>/", '<cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- Tabs / splits
keymap.set("n", "te", ":tabedit<Return>", { silent = true })
keymap.set("n", "ss", ":split<Return><C-w>w", { silent = true })
keymap.set("n", "sv", ":vsplit<Return><C-w>w", { silent = true })
keymap.set("n", "<leader>T", ":ToggleTerm direction=vertical size=65<CR>", { silent = true })

-- Borrar palabra
keymap.set("n", "dw", "diw")

-- No yank con x/c
keymap.set("n", "x", '"_x')
keymap.set("n", "c", '"_c')

-- Inc/dec
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- Borrar buffer
keymap.set("n", "<M-x>", ":<C-U>bprevious <bar> bdelete #<CR>")
keymap.set("n", "<leader>x", ":<C-U>bprevious <bar> bdelete #<CR>")

-- Ciclar buffers
vim.api.nvim_set_keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", {})
vim.api.nvim_set_keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", {})

-- Goto preview
keymap.set("n", "gpd", function() require("goto-preview").goto_preview_definition() end)
keymap.set("n", "gpi", function() require("goto-preview").goto_preview_implementation() end)
keymap.set("n", "gP", function() require("goto-preview").close_all_win() end)
keymap.set("n", "gpr", function() require("goto-preview").goto_preview_references() end)

-- Windows
keymap.set("", "<C-h>", "<C-w>h")
keymap.set("", "<C-k>", "<C-w>k")
keymap.set("", "<C-j>", "<C-w>j")
keymap.set("", "<C-l>", "<C-w>l")

-- Redimensionar
keymap.set("n", "<M-H>", "<C-w><")
keymap.set("n", "<M-L>", "<C-w>>")
keymap.set("n", "<M-K>", "<C-w>+")
keymap.set("n", "<M-J>", "<C-w>-")

-- Quitar highlights
keymap.set("n", "sh", ":noh<CR>")
keymap.set("n", "<leader>h", ":noh<CR>")

-- Salir
keymap.set("n", "<M-q>", ":qa!<CR>")
keymap.set("n", "<leader>X", ":qa!<CR>")

-- Maximizar / igualar
keymap.set("n", "<leader>|", "<c-w>|")
keymap.set("n", "<leader>_", "<c-w>_")
keymap.set("n", "<leader>=", "<c-w>=")
keymap.set("n", "<leader>0", "^")
keymap.set("n", "<leader>m", "^")

-- Word wrap con j/k
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Telescope
keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
keymap.set("n", "<leader>sW", require("telescope.builtin").grep_string, { desc = "[S]earch [W]ord" })
keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "Search by [G]rep" })
keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "Search [D]iagnostics" })
keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "Recent files" })
keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "Buffers" })
keymap.set("n", "<leader>g", function()
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
    winblend = 10, previewer = false,
  })
end, { desc = "Fuzzy search buffer" })

-- LSP
local function has_lsp_method(method)
  return #vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf(), method = method }) > 0
end

keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "[G]oto [R]eferences" })
keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "[G]oto [I]mplementation" })
keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type [D]efinition" })
keymap.set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })
keymap.set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "[W]orkspace [S]ymbols" })
keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "[G]oto [D]eclaration" })

local function lsp_signature_help()
  if has_lsp_method("textDocument/signatureHelp") then
    vim.lsp.buf.signature_help()
  end
end

keymap.set("n", "K", function()
  if has_lsp_method("textDocument/hover") then vim.lsp.buf.hover()
  elseif has_lsp_method("textDocument/signatureHelp") then vim.lsp.buf.signature_help() end
end, { desc = "Hover / Signature" })

keymap.set("n", "<leader>l", lsp_signature_help, { desc = "Signature help" })
keymap.set({ "i", "s" }, "<C-l>", lsp_signature_help, { desc = "Signature help" })

-- Diagnostics
keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Diagnostic float" })
keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics loclist" })
keymap.set("n", "<leader>L", function() vim.diagnostic.open_float({ scope = "line" }) end, { desc = "Line diagnostic" })

-- Refresh
keymap.set("n", "<leader>R", "<cmd>w<cr><cmd>e!<cr>", { desc = "Refresh" })

-- Clipboard
keymap.set("n", "<s-c-c>", '"+y')
keymap.set("v", "<s-c-c>", '"+y')
keymap.set("n", "<s-c-v>", '"+p')
keymap.set("i", "<c-v>", "<c-r>+")
keymap.set("c", "<c-v>", "<c-r>+")
keymap.set("i", "<c-r>", "<c-v>")
keymap.set("v", ">", ">gv")
keymap.set("v", "<", "<gv")

-- Nvim-tree
keymap.set("n", "<leader>e", "<cmd>:NvimTreeToggle<CR>")
keymap.set("n", "<leader>Q", "<cmd>:q<CR>")

-- File tree navigation (dentro de nvim-tree)
local function nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
  vim.keymap.set("n", "<C-v>", api.node.open.vertical, opts("Vertical Split"))
  vim.keymap.set("n", "<C-x>", api.node.open.horizontal, opts("Horizontal Split"))
  vim.keymap.set("n", "<C-t>", api.node.open.tab, opts("New Tab"))
  vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "a", api.fs.create, opts("Create"))
  vim.keymap.set("n", "d", api.fs.remove, opts("Delete"))
  vim.keymap.set("n", "r", api.fs.rename, opts("Rename"))
  vim.keymap.set("n", "y", api.fs.copy.filename, opts("Copy Name"))
  vim.keymap.set("n", "x", api.fs.cut, opts("Cut"))
  vim.keymap.set("n", "p", api.fs.paste, opts("Paste"))
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function(args) nvim_tree_on_attach(args.buf) end,
})

-- Spectre
keymap.set("n", "<leader>E", "<cmd>lua require('spectre').open()<CR>", { desc = "Spectre" })
keymap.set("n", "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", { desc = "Search word" })
keymap.set("v", "<leader>sw", "<esc><cmd>lua require('spectre').open_visual()<CR>", { desc = "Search word" })
keymap.set("n", "<leader>sp", "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>", { desc = "Search file" })

-- Paste sin yank
keymap.set("x", "<leader>p", '"_dP')

-- Indentación
keymap.set("i", "<c-F>", "<cr><esc><<<<ko<bs>")
keymap.set("i", "<c-K>", "<cr><esc><<ko<bs><tab>")
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "rust" },
  callback = function() vim.opt_local.expandtab = true; vim.opt_local.tabstop = 2; vim.opt_local.shiftwidth = 2 end,
})
