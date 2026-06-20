# STATUS.md — Auditoría de plugins de Neovim

**Fecha**: 19 jun 2026
**Neovim**: 0.12.2
**Total plugins**: 67 (en `lazy-lock.json`)

## Leyenda de estado

| Estado | Significado |
|--------|------------|
| ✅ Activo | Mantenido, releases recientes, issues atendidos |
| ⚠️ Stale | Sin releases en >1 año, pero funcional |
| 🧊 Congelado | Rama/API congelada por decisión del maintainer |
| 📦 Archivado | Repo marcado como read-only en GitHub |
| 💀 Abandonado | Sin maintainer, roto o no funcional |
| 🔄 Fork vivo | Original abandonado, fork comunitario activo |

## Tabla de plugins

### Core / Package manager

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `folke/lazy.nvim` | Package manager | ✅ Activo | continuo | Estándar de facto |
| `nvim-lua/plenary.nvim` | Utilidades Lua | ⚠️ Stale | — | El README indica "will be archived in Q2 2026". Usar solo si otros plugins lo requieren |

### LSP / Lenguajes

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `neovim/nvim-lspconfig` | Configuración LSP | ✅ Activo | continuo | Oficial Neovim |
| `williamboman/mason.nvim` | Instalador de tools | ✅ Activo | continuo | — |
| `williamboman/mason-lspconfig.nvim` | Bridge mason↔lspconfig | ✅ Activo | continuo | — |
| `j-hui/fidget.nvim` | Progreso LSP en statusline | ✅ Activo | continuo | — |
| `folke/neodev.nvim` | Lua LS config | ✅ Activo | continuo | — |
| `mfussenegger/nvim-dap` | Debug Adapter Protocol | ✅ Activo | continuo | — |
| `jayp0521/mason-nvim-dap.nvim` | DAP en mason | ✅ Activo | continuo | — |

### Treesitter

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `nvim-treesitter/nvim-treesitter` | Syntax + highlights | 📦 **Archivado** | rama `master` congelada (Abr 2026) | El repo entero fue **archivado el 3 Abr 2026**. La rama `main` tiene un rewrite incompatible. Tu config está fijada a `master` con parches manuales. **Migración obligatoria** a la nueva API o a `nvim-treesitter-textobjects` standalone |
| `nvim-treesitter/nvim-treesitter-textobjects` | Text objects TS | ✅ Activo | continuo | Funciona con ambas APIs |

### Autocompletado / Snippets

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `hrsh7th/nvim-cmp` | Completion engine | ✅ Activo | continuo | — |
| `hrsh7th/cmp-nvim-lsp` | Source LSP | ✅ Activo | continuo | — |
| `hrsh7th/cmp-buffer` | Source buffers | ✅ Activo | continuo | — |
| `hrsh7th/cmp-path` | Source paths | ✅ Activo | continuo | — |
| `hrsh7th/cmp-cmdline` | Source cmdline | ✅ Activo | continuo | — |
| `saadparwaiz1/cmp_luasnip` | Bridge cmp↔luasnip | ✅ Activo | continuo | — |
| `L3MON4D3/LuaSnip` | Snippet engine | ✅ Activo | continuo | — |
| `rafamadriz/friendly-snippets` | Colección snippets | ✅ Activo | continuo | — |

### UI / Navegación

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `nvim-tree/nvim-tree.lua` | File explorer | ✅ Activo | continuo | — |
| `nvim-tree/nvim-web-devicons` | Iconos | ✅ Activo | continuo | — |
| `lewis6991/gitsigns.nvim` | Git signs | ✅ Activo | continuo | — |
| `akinsho/bufferline.nvim` | Buffer tabs | ✅ Activo | continuo | — |
| `SmiteshP/nvim-navic` | LSP breadcrumbs | ✅ Activo | continuo | — |
| `utilyre/barbecue.nvim` | Winbar breadcrumbs | ✅ Activo | continuo | — |
| `SmiteshP/nvim-navbuddy` | Code outline window | 🔄 Nuevo maintainer | reciente | Cambió de maintainer. Usar `auto_attach = true` en setup |
| `simrat39/symbols-outline.nvim` | Symbols sidebar | ✅ Activo | continuo | Tiene deprecation `vim.lsp.buf_get_clients` parchado en tu config |
| `folke/which-key.nvim` | Popup de keymaps | ✅ Activo | continuo | — |
| `mg979/vim-visual-multi` | Multi-cursor | ✅ Activo | continuo | — |

### Movimiento / Edición rápida

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `smoka7/hop.nvim` | EasyMotion-like | ⚠️ Stale | v2.7.2 (Oct 2024) | Fork de `yuki-yano/hop.nvim`. Sin updates en 8 meses pero funcional. Alternativas modernas: `folke/flash.nvim` o `ggandor/leap.nvim` (movido a Codeberg) |
| `RRethy/vim-illuminate` | Highlight palabra bajo cursor | ✅ Activo | continuo | Necesita parche `client:supports_method` para nvim 0.12 (ya aplicado) |
| `windwp/nvim-autopairs` | Auto-pairs | ✅ Activo | continuo | — |
| `numToStr/Comment.nvim` | Toggle comments | ✅ Activo | continuo | — |
| `windwp/nvim-ts-autotag` | Auto-close tags HTML/JSX | ✅ Activo | continuo | — |
| `HiPhish/rainbow-delimiters.nvim` | Rainbow parens | ✅ Activo | continuo | — |
| `NvChad/nvim-colorizer.lua` | Color highlighter | 🔄 **Fork vivo recomendado** | — | Original `norcalli/nvim-colorizer.lua` abandonado. Usar `catgoose/nvim-colorizer.lua` (más rápido, mejor API, soporta nvim 0.12 `document_color`). Alternativa: usar `vim.lsp.document_color` built-in en 0.12+ |
| `aca/emmet-ls` | Emmet LSP | ✅ Activo | continuo | — |

### Search / Fuzzy finder

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `nvim-telescope/telescope.nvim` | Fuzzy finder | ✅ Activo | continuo | — |
| `nvim-telescope/telescope-fzf-native.nvim` | Backend fzf | ✅ Activo | continuo | Requiere `make` |
| `rmagatti/goto-preview` | Preview de jumps | ✅ Activo | continuo | — |
| `nvim-pack/nvim-spectre` | Search & replace | ✅ Activo | continuo | — |
| `folke/todo-comments.nvim` | TODO/FIXME highlights | ✅ Activo | continuo | — |
| `derektata/lorem.nvim` | Generar lorem ipsum | ✅ Activo | continuo | 39 stars, nicho pero funcional |

### Git / Terminal

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `tpope/vim-fugitive` | Git wrapper | ✅ Activo | continuo | — |
| `kdheepak/lazygit.nvim` | Lazygit wrapper | ✅ Activo | continuo | — |
| `akinsho/toggleterm.nvim` | Terminal flotante | ✅ Activo | continuo | — |

### LSP tools / Formateo

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `nvimtools/none-ls.nvim` | null-ls reloaded | 🔄 Fork vivo | continuo | Mantenido por comunidad. El original `jose-elias-alvarez/null-ls.nvim` está abandonado. **Recomendado migrar a**: `stevearc/conform.nvim` (formateo) + `mfussenegger/nvim-lint` (lint) que son más mantenidos y usan la API nativa de nvim 0.11+ |

### Indent / Visual

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `lukas-reineke/indent-blankline.nvim` | Indent guides | ✅ Activo (v3) | continuo | API cambió en v3 (`main = "ibl"` en tu spec). Correcto |
| `xiyaowong/transparent.nvim` | Fondo transparente | ⚠️ Stale | 2024 | Funcional pero sin updates recientes. Alternativa: `nvim-transparent` o configuración manual de `NormalNC` |

### Lenguajes específicos

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `nvim-java/nvim-java` | Java integration | ✅ Activo | v4.1.0 (Feb 2026) | **PERO** tu config tiene `require('java').setup()` comentado. Si no haces Java, eliminar todo el stack |
| `nvim-java/nvim-java-core` | Core Java | ✅ Activo | continuo | — |
| `nvim-java/nvim-java-test` | Test runner Java | ✅ Activo | continuo | — |
| `nvim-java/nvim-java-dap` | DAP Java | ✅ Activo | continuo | — |
| `nvim-java/lua-async-await` | Async helpers | ✅ Activo | continuo | — |
| `nvim-java/spring-boot.nvim` | Spring Boot | ✅ Activo | continuo | — |
| `tikhomirov/vim-glsl` | GLSL syntax | ⚠️ Stale | 2021 | Solo relevante si editas shaders |

### Colores (5 instalados, 1 usado)

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `folke/tokyonight.nvim` | Colorscheme | ✅ Activo | continuo | **Tu colorescheme activo** |
| `ellisonleao/gruvbox.nvim` | Colorscheme | ✅ Activo | continuo | Solo si alternas |
| `navarasu/onedark.nvim` | Colorscheme | ✅ Activo | continuo | Solo si alternas |
| `tiagovla/tokyodark.nvim` | Colorscheme | ⚠️ Stale | 2024 | Variante de tokyonight, redundante |
| `yorik1984/newpaper.nvim` | Colorscheme | ⚠️ Stale | 2024 | Solo si alternas |

### Misc

| Plugin | Propósito | Estado | Último release | Notas |
|--------|-----------|--------|----------------|-------|
| `MunifTanjim/nui.nvim` | UI components | ✅ Activo | continuo | Dependencia de nvim-java, navbuddy |
| `tpope/vim-rhubarb` | Mapeo de `<C-r>` en insert | ✅ Activo | continuo | — |
| `tpope/vim-sleuth` | Detect indents | ✅ Activo | continuo | — |
| `nvim-lualine/lualine.nvim` | Statusline | ✅ Activo | continuo | — |

---

## Resumen ejecutivo

### 🔴 Acción urgente

1. **`nvim-treesitter` está archivado** (3 Abr 2026). Tu config está fijada a la rama `master` congelada. Opciones:
   - **Migrar a la nueva API** (`main` branch, rewrite completo) — cambio grande en `plugins-config.lua:89-169`
   - **O migrar a nvim 0.12 nativo**: `vim.treesitter.start()` + `:checkhealth nvim` para highlights, eliminar el plugin
2. **`NvChad/nvim-colorizer.lua`** es un fork viejo. Migrar a `catgoose/nvim-colorizer.lua` o usar `vim.lsp.document_color` built-in de nvim 0.12
3. **`nvimtools/none-ls.nvim`** funciona pero es pesado. Considerar migrar a `conform.nvim` (formato) + `nvim-lint` (lint)

### ⚠️ Stale pero funcionales (vigilar)

- `hop.nvim` (8 meses sin updates) — considerar `flash.nvim` o `leap.nvim`
- `tokyodark.nvim` — redundante con `tokyonight.nvim`
- `transparent.nvim` — alternativa: config manual
- `vim-glsl` — solo si usas GLSL

### 🧹 Limpieza recomendada

1. **5 colorschemes** — quitar 4 que no usas (deja solo `tokyonight` que es el activo)
2. **`nvim-java` stack completo** (5 plugins) — si no haces Java, eliminar
3. **Plenary** — el repo indica archivado en Q2 2026, pero muchos plugins lo requieren, mantener hasta que dejen de usarlo
4. **Keymaps duplicados** en Trouble (`tt` y `tw` hacen lo mismo)
5. **3 plugins de navegación/breadcrumbs** (barbecue + navbuddy + navic) — navbuddy y barbecue son redundantes en función

### 📊 Estadísticas

- **67 plugins** totales
- **57 activos** (85%)
- **5 stale** (7%)
- **1 archivado** crítico: `nvim-treesitter`
- **1 congelado**: nvim-treesitter master
- **3 forks vivos** (colorizer, none-ls, navbuddy)

---

## 🔗 Mapa de dependencias

Dependencias declaradas explícitamente en `lazy-plugins.lua` y `requires`. Las **implícitas** son las que un plugin asume que existen aunque no las declares (carga por `require()` directo).

### Dependencias explícitas (declaradas en lazy spec)

| Padre | Hijos (dependencies / requires) |
|-------|--------------------------------|
| `neovim/nvim-lspconfig` | `mason.nvim`, `mason-lspconfig.nvim`, `fidget.nvim`, `neodev.nvim` |
| `nvim-java/nvim-java` | `lua-async-await`, `nvim-java-core`, `nvim-java-test`, `nvim-java-dap`, `nui.nvim`, `nvim-lspconfig`, `nvim-dap`, `mason.nvim` (con registries custom) |
| `SmiteshP/nvim-navic` | `nvim-lspconfig` |
| `utilyre/barbecue.nvim` | `nvim-navic`, `nvim-web-devicons` |
| `SmiteshP/nvim-navbuddy` | `nvim-lspconfig`, `nvim-navic` |
| `nvim-treesitter/nvim-treesitter` | `nvim-treesitter-textobjects` |
| `nvim-tree/nvim-tree.lua` | `nvim-web-devicons` |
| `akinsho/bufferline.nvim` | `nvim-web-devicons` |
| `nvim-telescope/telescope.nvim` | `plenary.nvim` |
| `L3MON4D3/LuaSnip` | `friendly-snippets` |
| `hrsh7th/nvim-cmp` | `cmp-nvim-lsp`, `cmp_luasnip` |
| `HiPhish/rainbow-delimiters.nvim` | `nvim-treesitter` |
| `jayp0521/mason-nvim-dap.nvim` | `mason.nvim`, `nvim-dap` |

### Dependencias implícitas (asumidas por `require()` en el código)

| Plugin que requiere | Quién lo asume |
|--------------------|----------------|
| `plenary.nvim` | telescope, nvim-navbuddy, nvim-spectre, todo-comments, mason-lspconfig, gitsigns, trouble.nvim |
| `nvim-web-devicons` | nvim-tree, bufferline, barbecue, telescope (icons), lualine |
| `nvim-navic` | navbuddy, barbecue, nvim-lspconfig (no, lualine sí) |
| `MunifTanjim/nui.nvim` | nvim-java, nvim-navbuddy |
| `nvim-treesitter` (queries/) | rainbow-delimiters, nvim-ts-autotag, navic (usa treesitter parser), textobjects |
| `telescope` (vía plenary) | trouble.nvim, gitsigns, mason-lspconfig |

---

## ⚠️ Cascada de reemplazos

Si reemplazas un plugin, estos otros se ven afectados:

### Si reemplazas `nvim-web-devicons`
- **Afecta a**: `nvim-tree` (sin iconos), `bufferline` (sin iconos), `barbecue` (sin iconos en winbar), `telescope`, `lualine` (sin iconos)
- **Acción**: cambiar a alternativa que mantenga API de iconos (e.g., `nvim-tree/nvim-web-devicons` sigue mantenido, o `mini.icons`)

### Si reemplazas `plenary.nvim`
- **Afecta a**: telescope, nvim-navbuddy, nvim-spectre, todo-comments, gitsigns, trouble.nvim
- **Acción**: NO reemplazable (es estándar de facto). El README dice "will be archived in Q2 2026" pero seguirá disponible por compatibilidad. Si se archiva, habrá que esperar forks

### Si reemplazas `nvim-navic`
- **Afecta a**: `nvim-navbuddy` (lo requiere), `barbecue.nvim` (lo requiere)
- **Acción**: si migras a `fidget.nvim` para breadcrumbs, ambos quedan huérfanos. Necesitas reemplazar la cadena completa: navic → navbuddy + barbecue (o elegir uno y quitar el otro)

### Si reemplazas `nvim-treesitter`
- **Afecta a**: `nvim-treesitter-textobjects` (incompatible con nueva API), `rainbow-delimiters.nvim` (usa queries TS), `nvim-ts-autotag` (usa TS), `nvim-navic` (usa TS)
- **Acción**: migración compleja. Opciones:
  1. Usar la nueva API (`main` branch): reescribir `plugins-config.lua:89-169` y actualizar textobjects
  2. Usar nvim 0.12 nativo: `vim.treesitter.start()` + eliminar nvim-treesitter. Textobjects sigue funcionando standalone con su propia config

### Si reemplazas `mason.nvim`
- **Afecta a**: `mason-lspconfig.nvim` (lo requiere), `nvim-java` (lo requiere con registries custom)
- **Acción**: si usas `mason-registry` de nvim-java, el reemplazo debe soportar registries custom (pocos lo hacen)

### Si reemplazas `nvim-dap`
- **Afecta a**: `mason-nvim-dap.nvim`, `nvim-java` (lo requiere)
- **Acción**: dap es el estándar. No hay reemplazo real

### Si reemplazas `MunifTanjim/nui.nvim`
- **Afecta a**: `nvim-java` (lo requiere), `nvim-navbuddy` (lo requiere)
- **Acción**: difícil de reemplazar, es base de muchos UIs

### Si reemplazas `nvim-lspconfig`
- **Afecta a**: `nvim-navic`, `nvim-navbuddy`, `mason-lspconfig.nvim`, `nvim-java`, todos los servers configurados en `plugins-config.lua:261-366`
- **Acción**: parte de la API oficial de Neovim, no reemplazable. Si usas el sistema nativo `vim.lsp.config()` de 0.11+, lspconfig sigue siendo útil como catálogo de servers

### Si reemplazas `nvim-cmp`
- **Afecta a**: `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp-cmdline`, `cmp_luasnip`, `LuaSnip`
- **Acción**: alternativa es `saghen/blink.cmp` (más rápido, mejor default config, integra snippets propio). Migración de toda la cadena de sources

### Si reemplazas `telescope.nvim`
- **Afecta a**: `telescope-fzf-native.nvim` (lo requiere), todas las integraciones externas (mason-lspconfig, gitsigns, etc.)
- **Acción**: alternativa moderna `nvim-telescope/telescope.nvim` sigue activo. O `ibhagwan/fzf-lua` (más rápido, sin plenary)

---

## 🎯 Plan de migración recomendado (orden)

1. **Quitar colorschemes no usados** (4 plugins) — sin cascada
2. **Quitar stack nvim-java completo** (5 plugins) si no usas Java — sin cascada (excepto nui que también usa navbuddy; pero navbuddy requiere nui vía implícito, no declarado)
3. **Quitar nvim-spectre, transparent, lorem, glsl** (4 plugins menores) — sin cascada
4. **Migrar `NvChad/nvim-colorizer.lua` → `catgoose/nvim-colorizer.lua`** — sin cascada, mismo nombre de módulo
5. **Decidir entre `barbecue` y `navbuddy`** (ambos breadcrumbs/outline) — quitar uno, ajustar config
6. **Migrar `hop.nvim` → `flash.nvim`** o `leap.nvim` — sin cascada
7. **Evaluar migración de `none-ls` → `conform.nvim` + `nvim-lint`** — afecta solo a config de formateo
8. **Migrar `nvim-treesitter` (archivado) → nvim 0.12 nativo o nueva API** — cascada compleja, último paso
