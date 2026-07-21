-- Plugin Manim 3b1b Workflow (aislado del resto de la configuración).
-- Documentación: /home/alex/Projects/manim_transform_formulas/isolateds/nvim-manim-3b1b/README_ES.md
-- Para quitarlo: borra este archivo y su línea `require("manim-3b1b-plugin"),`
-- en lazy-plugins.lua.
--
-- El comando manimgl se AUTO-DETECTA del entorno virtual activado al abrir
-- Neovim ($VIRTUAL_ENV/bin/manimgl); no hace falta configurarlo por venv.
-- Si quisieras forzar uno: setup({ command = "/ruta/al/manimgl" }).
return {
  dir = "/home/alex/Projects/manim_transform_formulas/isolateds/nvim-manim-3b1b",
  name = "manim3b1b",
  config = function()
    require("manim3b1b").setup({
      -- :ManimFixCpu usa la copia del script guardada en la config
      fix_cpu_script = vim.fn.stdpath("config") .. "/scripts/fix_manimgl_cpu.py",
    })
  end,
}
