# New Neovim Setup

Setup limpio basado en la auditoría de `STATUS.md`. Para testear en Docker.

## Diferencias con el setup original

**Quitados (15 plugins):**
- 4 colorschemes redundantes (gruvbox, onedark, tokyodark, newpaper)
- Stack nvim-java completo (5 plugins)
- `hop.nvim` → reemplazado por `flash.nvim`
- `navbuddy` (redundante con barbecue)
- `NvChad/nvim-colorizer.lua` → reemplazado por `catgoose/nvim-colorizer.lua`
- `nvim-spectre`, `transparent.nvim`, `lorem.nvim`, `vim-glsl`
- `lualine-config.lua` redundante (lualine se configura en spec)

**Añadidos / cambiados:**
- `folke/flash.nvim` (reemplaza hop)
- `catgoose/nvim-colorizer.lua` (fork mantenido)
- `nvim-treesitter` en `branch = "main"` (nueva API, el master está archivado)

**Total: 67 → 50 plugins.**

## Estructura

```
new/
├── init.lua
└── lua/
    ├── started.lua
    ├── base-configs.lua
    ├── lazy-plugins.lua
    ├── plugins-config.lua
    ├── keymaps.lua
    └── lualine-config.lua
```

## Test en Docker

Montar el directorio como config de nvim:

```bash
docker run --rm -it \
  -v $(pwd)/new:/root/.config/nvim \
  -v $(pwd)/new/lazy-lock.json:/root/.config/nvim/lazy-lock.json \
  alpine:latest sh -c '
    apk add neovim git curl make gcc musl-dev nodejs npm lazygit ripgrep fd bash
    nvim --headless "+Lazy! sync" +qa
  '
```

O interactivamente:

```bash
docker run --rm -it \
  -v $(pwd)/new:/root/.config/nvim \
  alpine:latest sh

# Dentro del container:
apk add neovim git curl make gcc musl-dev nodejs npm lazygit ripgrep fd bash
nvim
```

## Post-instalación manual requerida

1. **Mason**: instalar LSPs — `:Mason` y buscar/instalar: `pyright`, `lua-language-server`, `typescript-language-server`, `rust-analyzer`, `clangd`, `vue-language-server`, `vscode-css-language-server`, `prettier`, `typescript-language-server`
2. **Treesitter parsers**: `:TSInstall python lua javascript typescript rust html css vue`
3. **DAP** (si se usa): `:DapInstall` para los debuggers

## Tabsets

Esta config incluye una capa de "tabs de tabs" en `lua/tabsets.lua`. Cada tabset guarda su propio layout de tabs/ventanas y su lista de buffers en `stdpath("data")/tabsets`.

`NvimTree` se trata como estado externo al layout: al cambiar de tabset se cierra antes de restaurar la sesión y se vuelve a abrir solo si ese tabset lo tenía abierto.

Comandos principales:

- `:TabsetNew nombre` crea un nuevo conjunto.
- `:TabsetSwitch nombre` cambia a otro conjunto.
- `:TabsetPick` muestra el selector.
- `:TabsetSave` guarda el conjunto actual.
- `:TabsetNext` / `:TabsetPrev` ciclan entre conjuntos.
- `:TabsetRename nombre` renombra el actual.
- `:TabsetDelete nombre` borra un conjunto.
- `:TabsetList` lista los conjuntos.

Atajos:

- `<leader>ta` nuevo tabset.
- `<leader>ts` selector de tabsets.
- `<leader>tS` guardar tabset.
- `<leader>K` siguiente tabset.
- `<leader>J` tabset anterior.
- `<leader>t]` siguiente tabset alternativo.
- `<leader>t[` tabset anterior alternativo.

## Notas sobre decisiones

- **nvim-treesitter nueva API**: `branch = "main"` porque la `master` está archivada. La nueva API es mucho más simple: `require('nvim-treesitter').setup({})` + queries nativas de nvim 0.12
- **flash.nvim vs leap.nvim**: elegí flash por mantenimiento activo (folke) y mejor integración con LSP/treesitter
- **colorizer catgoose**: fork mantenido del original abandonado, soporta nvim 0.12 `document_color` built-in
- **none-ls**: mantenido por ahora. Para migrar a `conform.nvim` + `nvim-lint` es straightforward pero no urgente
- **nui.nvim**: solo era dependencia de navbuddy y nvim-java. Ambos quitados, así que se omite
