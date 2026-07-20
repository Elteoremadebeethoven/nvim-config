local M = {}

local api = vim.api
local fn = vim.fn

local data_dir = fn.stdpath("data") .. "/tabsets"
local sessions_dir = data_dir .. "/sessions"
local index_file = data_dir .. "/index.json"

local state = {
  version = 1,
  current = nil,
  order = {},
  sets = {},
}

local did_setup = false
local loading = false
local pending_state_save = false

local function notify(message, level)
  vim.notify("[tabsets] " .. message, level or vim.log.levels.INFO)
end

local function trim(value)
  return vim.trim(value or "")
end

local function normalize_path(path)
  if not path or path == "" then
    return ""
  end

  if vim.fs and vim.fs.normalize then
    return vim.fs.normalize(path)
  end

  return fn.fnamemodify(path, ":p")
end

local function ensure_dirs()
  fn.mkdir(sessions_dir, "p")
end

local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end

  local content = file:read("*a")
  file:close()
  return content
end

local function write_file(path, content)
  ensure_dirs()

  local file, err = io.open(path, "w")
  if not file then
    return false, err
  end

  file:write(content)
  file:close()
  return true
end

local function json_encode(value)
  if vim.json and vim.json.encode then
    return vim.json.encode(value)
  end

  return fn.json_encode(value)
end

local function json_decode(value)
  if vim.json and vim.json.decode then
    return vim.json.decode(value)
  end

  return fn.json_decode(value)
end

local function save_state()
  local ok, encoded = pcall(json_encode, state)
  if not ok then
    notify("No pude serializar el indice: " .. encoded, vim.log.levels.ERROR)
    return false
  end

  local written, err = write_file(index_file, encoded)
  if not written then
    notify("No pude guardar el indice: " .. (err or "error desconocido"), vim.log.levels.ERROR)
    return false
  end

  return true
end

local function schedule_state_save()
  if pending_state_save then
    return
  end

  pending_state_save = true
  vim.defer_fn(function()
    pending_state_save = false
    save_state()
  end, 250)
end

local function load_state()
  ensure_dirs()

  local content = read_file(index_file)
  if not content or content == "" then
    return
  end

  local ok, decoded = pcall(json_decode, content)
  if not ok or type(decoded) ~= "table" then
    notify("No pude leer el indice de tabsets; usare uno nuevo", vim.log.levels.WARN)
    return
  end

  state.version = decoded.version or 1
  state.current = decoded.current
  state.order = type(decoded.order) == "table" and decoded.order or {}
  state.sets = type(decoded.sets) == "table" and decoded.sets or {}

  for name, entry in pairs(state.sets) do
    if type(entry) == "table" then
      entry.name = entry.name or name
      entry.buffers = type(entry.buffers) == "table" and entry.buffers or {}
      entry.tree_open = entry.tree_open == true
    end
  end
end

local function contains(list, value)
  for _, item in ipairs(list) do
    if item == value then
      return true
    end
  end

  return false
end

local function replace_in_order(old_name, new_name)
  for index, item in ipairs(state.order) do
    if item == old_name then
      state.order[index] = new_name
      return
    end
  end

  table.insert(state.order, new_name)
end

local function remove_from_order(name)
  for index = #state.order, 1, -1 do
    if state.order[index] == name then
      table.remove(state.order, index)
    end
  end
end

local function sanitize_filename(name)
  local safe = name:gsub("[^%w%._%-]+", "-")
  safe = safe:gsub("^%-+", ""):gsub("%-+$", "")

  if safe == "" then
    safe = "tabset"
  end

  return safe
end

local function session_file_in_use(path)
  for _, entry in pairs(state.sets) do
    if type(entry) == "table" and entry.file == path then
      return true
    end
  end

  return false
end

local function allocate_session_file(name)
  local safe = sanitize_filename(name)
  local candidate = sessions_dir .. "/" .. safe .. ".vim"
  local counter = 2

  while session_file_in_use(candidate) or fn.filereadable(candidate) == 1 do
    candidate = sessions_dir .. "/" .. safe .. "-" .. counter .. ".vim"
    counter = counter + 1
  end

  return candidate
end

local function default_name()
  local cwd_name = fn.fnamemodify(fn.getcwd(), ":t")
  if cwd_name == "" then
    return "default"
  end

  return cwd_name
end

local function unique_name(base)
  local name = trim(base)
  if name == "" then
    name = default_name()
  end

  if not state.sets[name] then
    return name
  end

  local counter = 2
  while state.sets[name .. " " .. counter] do
    counter = counter + 1
  end

  return name .. " " .. counter
end

local function create_set(name, cwd)
  local entry = {
    name = name,
    cwd = normalize_path(cwd or fn.getcwd()),
    file = allocate_session_file(name),
    buffers = {},
    tree_open = false,
    created = os.time(),
    updated = os.time(),
  }

  state.sets[name] = entry

  if not contains(state.order, name) then
    table.insert(state.order, name)
  end

  return entry
end

local function find_set_for_cwd(cwd)
  local normalized = normalize_path(cwd)

  for _, name in ipairs(state.order) do
    local entry = state.sets[name]
    if entry and normalize_path(entry.cwd) == normalized then
      return name
    end
  end

  return nil
end

local function current_entry()
  if not state.current then
    return nil
  end

  return state.sets[state.current]
end

local function ensure_current_set()
  local entry = current_entry()
  if entry then
    return entry
  end

  local cwd = fn.getcwd()
  local existing = find_set_for_cwd(cwd)
  if existing then
    state.current = existing
    save_state()
    return state.sets[existing]
  end

  local name = unique_name(default_name())
  entry = create_set(name, cwd)
  state.current = name
  save_state()
  return entry
end

local function buffer_path(bufnr)
  if not api.nvim_buf_is_valid(bufnr) then
    return nil
  end

  local ok, buftype = pcall(function()
    return vim.bo[bufnr].buftype
  end)
  if not ok or buftype ~= "" then
    return nil
  end

  local name = api.nvim_buf_get_name(bufnr)
  if name == "" then
    return nil
  end

  return normalize_path(name)
end

local function add_buffer(entry, path)
  if not path or path == "" then
    return false
  end

  entry.buffers = entry.buffers or {}
  for _, existing in ipairs(entry.buffers) do
    if existing == path then
      return false
    end
  end

  table.insert(entry.buffers, path)
  return true
end

local function remove_buffer(entry, path)
  if not entry or not path or path == "" then
    return false
  end

  local removed = false
  entry.buffers = entry.buffers or {}
  for index = #entry.buffers, 1, -1 do
    if entry.buffers[index] == path then
      table.remove(entry.buffers, index)
      removed = true
    end
  end

  return removed
end

local function buffer_visible_in_tabset(bufnr)
  for _, tabpage in ipairs(api.nvim_list_tabpages()) do
    for _, win in ipairs(api.nvim_tabpage_list_wins(tabpage)) do
      if api.nvim_win_is_valid(win) and api.nvim_win_get_buf(win) == bufnr then
        return true
      end
    end
  end

  return false
end

local function refresh_visible_buffers(entry)
  entry.buffers = entry.buffers or {}

  for _, tabpage in ipairs(api.nvim_list_tabpages()) do
    for _, win in ipairs(api.nvim_tabpage_list_wins(tabpage)) do
      if api.nvim_win_is_valid(win) then
        add_buffer(entry, buffer_path(api.nvim_win_get_buf(win)))
      end
    end
  end
end

local function nvim_tree_api()
  local ok, tree_api = pcall(require, "nvim-tree.api")
  if ok then
    return tree_api
  end

  return nil
end

local function nvim_tree_windows()
  local windows = {}

  for _, tabpage in ipairs(api.nvim_list_tabpages()) do
    for _, win in ipairs(api.nvim_tabpage_list_wins(tabpage)) do
      if api.nvim_win_is_valid(win) then
        local bufnr = api.nvim_win_get_buf(win)
        local ok, filetype = pcall(function()
          return vim.bo[bufnr].filetype
        end)

        if ok and filetype == "NvimTree" then
          table.insert(windows, { tabpage = tabpage, win = win })
        end
      end
    end
  end

  return windows
end

local function close_nvim_tree()
  local windows = nvim_tree_windows()
  if #windows == 0 then
    return false
  end

  local current_tabpage = api.nvim_get_current_tabpage()
  local current_win = api.nvim_get_current_win()

  for _, item in ipairs(windows) do
    if api.nvim_tabpage_is_valid(item.tabpage) and api.nvim_win_is_valid(item.win) then
      pcall(api.nvim_set_current_tabpage, item.tabpage)
      pcall(api.nvim_set_current_win, item.win)

      local tree_api = nvim_tree_api()
      local closed = false
      if tree_api and tree_api.tree and tree_api.tree.close then
        closed = pcall(tree_api.tree.close)
      end

      if not closed then
        pcall(vim.cmd, "silent! NvimTreeClose")
      end

      if api.nvim_win_is_valid(item.win) then
        pcall(api.nvim_win_close, item.win, true)
      end
    end
  end

  if api.nvim_tabpage_is_valid(current_tabpage) then
    pcall(api.nvim_set_current_tabpage, current_tabpage)
    if api.nvim_win_is_valid(current_win) then
      pcall(api.nvim_set_current_win, current_win)
    end
  end

  return true
end

local function open_nvim_tree()
  local tree_api = nvim_tree_api()
  if tree_api and tree_api.tree and tree_api.tree.open then
    local ok = pcall(tree_api.tree.open)
    if ok then
      return
    end
  end

  pcall(vim.cmd, "silent! NvimTreeOpen")
end

local function set_sessionoptions(value)
  local ok, err = pcall(function()
    vim.o.sessionoptions = value
  end)

  return ok, err
end

local function sanitize_session_file(path)
  local ok, lines = pcall(fn.readfile, path)
  if not ok then
    return
  end

  for index, line in ipairs(lines) do
    if line == "silent tabonly" then
      lines[index] = "silent! tabonly!"
    elseif line:match("^balt%s+") then
      lines[index] = "silent! " .. line
    end
  end

  pcall(fn.writefile, lines, path)
end

local function save_session(entry, opts)
  opts = opts or {}
  local tree_was_open = close_nvim_tree()

  refresh_visible_buffers(entry)

  entry.cwd = normalize_path(fn.getcwd())
  entry.tree_open = tree_was_open
  entry.updated = os.time()

  local previous_sessionoptions = vim.o.sessionoptions
  local sessionoptions = "blank,curdir,folds,help,tabpages,terminal,winsize"
  local ok_options = set_sessionoptions(sessionoptions)
  if not ok_options then
    set_sessionoptions("blank,curdir,folds,help,tabpages,winsize")
  end

  local ok, err = pcall(vim.cmd, "silent mksession! " .. fn.fnameescape(entry.file))
  set_sessionoptions(previous_sessionoptions)

  if tree_was_open and opts.restore_tree ~= false then
    open_nvim_tree()
  end

  if not ok then
    notify("No pude guardar '" .. entry.name .. "': " .. err, vim.log.levels.ERROR)
    return false
  end

  sanitize_session_file(entry.file)
  save_state()
  return true
end

local function reset_to_empty_tab()
  close_nvim_tree()

  local previous_hidden = vim.o.hidden
  vim.o.hidden = true

  local ok, err = pcall(vim.cmd, "tabnew")
  if not ok then
    vim.o.hidden = previous_hidden
    return false, err
  end

  ok, err = pcall(vim.cmd, "silent! tabonly!")
  vim.o.hidden = previous_hidden
  if not ok then
    return false, err
  end

  return true
end

local function restore_buffer_list(entry)
  for _, path in ipairs(entry.buffers or {}) do
    if fn.filereadable(path) == 1 then
      pcall(vim.cmd, "silent badd " .. fn.fnameescape(path))
    end
  end
end

local function load_session(entry)
  loading = true
  local previous_hidden = vim.o.hidden
  vim.o.hidden = true

  local function finish(ok, err)
    vim.o.hidden = previous_hidden
    loading = false
    return ok, err
  end

  local ok, err = reset_to_empty_tab()
  if not ok then
    return finish(ok, err)
  end

  if entry.file and fn.filereadable(entry.file) == 1 then
    ok, err = pcall(vim.cmd, "silent! source " .. fn.fnameescape(entry.file))
  end

  close_nvim_tree()

  if ok and entry.cwd and fn.isdirectory(entry.cwd) == 1 then
    pcall(vim.cmd, "cd " .. fn.fnameescape(entry.cwd))
  end

  if ok then
    restore_buffer_list(entry)
    if entry.tree_open then
      open_nvim_tree()
    end
  end

  return finish(ok, err)
end

local function complete_tabsets()
  return vim.tbl_filter(function(name)
    return state.sets[name] ~= nil
  end, state.order)
end

local function with_name(name, prompt, callback)
  name = trim(name)
  if name ~= "" then
    callback(name)
    return
  end

  vim.ui.input({ prompt = prompt, default = unique_name(default_name()) }, function(input)
    input = trim(input)
    if input ~= "" then
      callback(input)
    end
  end)
end

function M.current_name()
  local entry = ensure_current_set()
  return entry and entry.name or "default"
end

function M.statusline()
  ensure_current_set()

  local parts = {}
  for _, name in ipairs(state.order) do
    if state.sets[name] then
      if name == state.current then
        table.insert(parts, "[" .. name .. "]")
      else
        table.insert(parts, " " .. name .. " ")
      end
    end
  end

  if #parts == 0 then
    return ""
  end

  return "Tabsets " .. table.concat(parts, "|")
end

function M.track_buffer(bufnr)
  if loading then
    return
  end

  local entry = ensure_current_set()
  local path = buffer_path(bufnr or api.nvim_get_current_buf())
  if add_buffer(entry, path) then
    entry.updated = os.time()
    schedule_state_save()
  end
end

function M.untrack_buffer(bufnr)
  if loading then
    return
  end

  local entry = current_entry()
  if not entry then
    return
  end

  local path = buffer_path(bufnr)
  if remove_buffer(entry, path) then
    entry.updated = os.time()
    schedule_state_save()
  end
end

function M.buffer_filter(bufnr)
  local entry = current_entry()
  if not entry then
    return true
  end

  local path = buffer_path(bufnr)
  if not path then
    return buffer_visible_in_tabset(bufnr)
  end

  for _, tracked_path in ipairs(entry.buffers or {}) do
    if tracked_path == path then
      return true
    end
  end

  return buffer_visible_in_tabset(bufnr)
end

function M.save(opts)
  opts = opts or {}

  local entry = ensure_current_set()
  if not entry then
    return false
  end

  local ok = save_session(entry, opts)
  if ok and not opts.quiet then
    notify("Guardado: " .. entry.name)
  end

  return ok
end

function M.new(name)
  with_name(name, "Nuevo tabset: ", function(resolved_name)
    if state.sets[resolved_name] then
      M.switch(resolved_name)
      return
    end

    local previous = state.current
    if not M.save({ quiet = true, restore_tree = false }) then
      return
    end

    local entry = create_set(resolved_name, fn.getcwd())
    local ok, err = reset_to_empty_tab()
    if not ok then
      state.sets[entry.name] = nil
      remove_from_order(entry.name)
      state.current = previous
      save_state()
      notify("No pude crear '" .. resolved_name .. "': " .. err, vim.log.levels.ERROR)
      return
    end

    state.current = entry.name
    save_state()
    notify("Nuevo tabset: " .. entry.name)
  end)
end

function M.switch(name)
  name = trim(name)
  if name == "" then
    M.pick()
    return
  end

  local entry = state.sets[name]
  if not entry then
    notify("No existe el tabset '" .. name .. "'", vim.log.levels.WARN)
    return
  end

  if state.current == name then
    notify("Ya estas en: " .. name)
    return
  end

  local previous = state.current
  if not M.save({ quiet = true, restore_tree = false }) then
    return
  end

  state.current = name
  save_state()

  local ok, err = load_session(entry)
  if not ok then
    state.current = previous
    save_state()
    notify("No pude cargar '" .. name .. "': " .. err, vim.log.levels.ERROR)
    return
  end

  notify("Tabset: " .. name)
end

function M.pick()
  local items = {}
  for _, name in ipairs(state.order) do
    local entry = state.sets[name]
    if entry then
      table.insert(items, {
        name = name,
        cwd = entry.cwd or "",
        current = name == state.current,
      })
    end
  end

  if #items == 0 then
    notify("No hay tabsets registrados", vim.log.levels.WARN)
    return
  end

  vim.ui.select(items, {
    prompt = "Tabsets",
    format_item = function(item)
      local marker = item.current and "* " or "  "
      local cwd = item.cwd ~= "" and (" - " .. fn.fnamemodify(item.cwd, ":~")) or ""
      return marker .. item.name .. cwd
    end,
  }, function(item)
    if item then
      M.switch(item.name)
    end
  end)
end

local function current_order_index()
  for index, name in ipairs(state.order) do
    if name == state.current then
      return index
    end
  end

  return nil
end

function M.next()
  if #state.order < 2 then
    notify("Solo hay un tabset")
    return
  end

  local index = current_order_index() or 1
  local next_index = index == #state.order and 1 or index + 1
  M.switch(state.order[next_index])
end

function M.previous()
  if #state.order < 2 then
    notify("Solo hay un tabset")
    return
  end

  local index = current_order_index() or 1
  local previous_index = index == 1 and #state.order or index - 1
  M.switch(state.order[previous_index])
end

function M.rename(new_name)
  with_name(new_name, "Renombrar tabset: ", function(resolved_name)
    local entry = current_entry()
    if not entry then
      return
    end

    if state.sets[resolved_name] then
      notify("Ya existe el tabset '" .. resolved_name .. "'", vim.log.levels.WARN)
      return
    end

    local old_name = entry.name
    local old_file = entry.file
    state.sets[old_name] = nil

    entry.name = resolved_name
    entry.file = allocate_session_file(resolved_name)

    if old_file and fn.filereadable(old_file) == 1 then
      if fn.rename(old_file, entry.file) ~= 0 then
        entry.file = old_file
      end
    end

    state.sets[resolved_name] = entry
    state.current = resolved_name
    replace_in_order(old_name, resolved_name)
    save_state()
    notify("Renombrado: " .. old_name .. " -> " .. resolved_name)
  end)
end

function M.delete(name)
  name = trim(name)
  if name == "" then
    name = state.current
  end

  local entry = state.sets[name]
  if not entry then
    notify("No existe el tabset '" .. name .. "'", vim.log.levels.WARN)
    return
  end

  if name == state.current then
    if #state.order < 2 then
      notify("No puedo borrar el unico tabset activo", vim.log.levels.WARN)
      return
    end

    local index = current_order_index() or 1
    local next_name = state.order[index + 1] or state.order[index - 1]
    M.switch(next_name)

    if state.current == name then
      return
    end
  end

  state.sets[name] = nil
  remove_from_order(name)
  if entry.file then
    fn.delete(entry.file)
  end
  save_state()
  notify("Borrado: " .. name)
end

function M.list()
  local lines = {}
  for _, name in ipairs(state.order) do
    local entry = state.sets[name]
    if entry then
      local marker = name == state.current and "* " or "  "
      local cwd = entry.cwd and (" - " .. fn.fnamemodify(entry.cwd, ":~")) or ""
      table.insert(lines, marker .. name .. cwd)
    end
  end

  if #lines == 0 then
    notify("No hay tabsets registrados")
    return
  end

  notify(table.concat(lines, "\n"))
end

local function create_commands()
  api.nvim_create_user_command("TabsetNew", function(opts)
    M.new(table.concat(opts.fargs, " "))
  end, { nargs = "*", desc = "Crear un nuevo conjunto de tabs" })

  api.nvim_create_user_command("TabsetSave", function()
    M.save()
  end, { desc = "Guardar el conjunto de tabs actual" })

  api.nvim_create_user_command("TabsetSwitch", function(opts)
    M.switch(table.concat(opts.fargs, " "))
  end, { nargs = "*", complete = complete_tabsets, desc = "Cambiar de conjunto de tabs" })

  api.nvim_create_user_command("TabsetPick", function()
    M.pick()
  end, { desc = "Elegir conjunto de tabs" })

  api.nvim_create_user_command("TabsetNext", function()
    M.next()
  end, { desc = "Siguiente conjunto de tabs" })

  api.nvim_create_user_command("TabsetPrev", function()
    M.previous()
  end, { desc = "Conjunto de tabs anterior" })

  api.nvim_create_user_command("TabsetRename", function(opts)
    M.rename(table.concat(opts.fargs, " "))
  end, { nargs = "*", desc = "Renombrar el conjunto de tabs actual" })

  api.nvim_create_user_command("TabsetDelete", function(opts)
    M.delete(table.concat(opts.fargs, " "))
  end, { nargs = "*", complete = complete_tabsets, desc = "Borrar un conjunto de tabs" })

  api.nvim_create_user_command("TabsetList", function()
    M.list()
  end, { desc = "Listar conjuntos de tabs" })
end

local function create_autocmds()
  local group = api.nvim_create_augroup("Tabsets", { clear = true })

  api.nvim_create_autocmd({ "BufEnter", "BufFilePost" }, {
    group = group,
    callback = function(args)
      M.track_buffer(args.buf)
    end,
  })

  api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
    group = group,
    callback = function(args)
      M.untrack_buffer(args.buf)
    end,
  })

  api.nvim_create_autocmd("DirChanged", {
    group = group,
    callback = function()
      local entry = current_entry()
      if entry then
        entry.cwd = normalize_path(fn.getcwd())
        entry.updated = os.time()
        schedule_state_save()
      end
    end,
  })

  api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      M.save({ quiet = true, restore_tree = false })
    end,
  })
end

function M.setup()
  if did_setup then
    return
  end

  did_setup = true
  load_state()
  ensure_current_set()
  create_commands()
  create_autocmds()
  M.track_buffer(api.nvim_get_current_buf())
end

return M
