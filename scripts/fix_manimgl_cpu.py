#!/usr/bin/env python
"""Arregla el consumo de CPU al 100% (un núcleo) de manimgl en modo embed.

Causa: en manimlib/scene/scene_embed.py, el inputhook de IPython hace
busy-wait sin sleep mientras el prompt está ocioso con la ventana abierta
(igual en manimgl master a fecha 2026-07). Este script inserta un
``time.sleep(1/60)`` en ese bucle: CPU casi nula en reposo y la ventana
sigue respondiendo a 60 Hz.

Uso (una vez por venv):
    source /ruta/al/venv/bin/activate
    python fix_manimgl_cpu.py            # parchea el manimlib ACTIVO
    python fix_manimgl_cpu.py --undo     # restaura desde el backup

Es idempotente y deja backup en scene_embed.py.cpufix.bak.
"""

import argparse
import re
import shutil
import sys
from pathlib import Path

MARKER = "# cpu-fix: evitar busy-wait en el prompt embebido"
# la detección usa solo el prefijo, para ser idempotente también con la
# versión en inglés del script (plugin de Neovim)
DETECT = "# cpu-fix"


def find_scene_embed():
    # manimlib parsea sys.argv al importarse: dejarlo limpio primero
    sys.argv = [sys.argv[0]]
    try:
        import manimlib.scene.scene_embed as se
    except ImportError:
        sys.exit("error: no hay manimlib en este entorno. Activa el venv "
                 "de ManimGL antes de ejecutar este script.")
    return Path(se.__file__)


def patch(path: Path) -> bool:
    src = path.read_text()
    if DETECT in src:
        print(f"ya estaba parcheado: {path}")
        return False

    # bucle objetivo:
    #     while not context.input_is_ready():
    #         if not self.scene.is_window_closing():
    #             self.scene.update_frame(dt=0)
    pattern = re.compile(
        r"(?P<loop>^(?P<i1>[ \t]+)while not context\.input_is_ready\(\):\n"
        r"(?P<i2>[ \t]+)if not self\.scene\.is_window_closing\(\):\n"
        r"(?P<i3>[ \t]+)self\.scene\.update_frame\(dt=0\)\n)",
        re.MULTILINE,
    )
    m = pattern.search(src)
    if not m:
        sys.exit(f"error: no encontré el bucle del inputhook en {path}.\n"
                 f"¿Versión de manimlib distinta? Parchea a mano añadiendo un "
                 f"time.sleep(1/60) dentro del while del inputhook de "
                 f"enable_gui().")

    i2 = m.group("i2")  # indentación del cuerpo del while
    insert = (f"{i2}import time as _t  {MARKER}\n"
              f"{i2}_t.sleep(1 / 60)\n")
    patched = src[:m.end("loop")] + insert + src[m.end("loop"):]

    backup = path.with_suffix(path.suffix + ".cpufix.bak")
    if not backup.exists():
        shutil.copy2(path, backup)
    path.write_text(patched)
    print(f"parcheado: {path}\nbackup   : {backup}")
    return True


def undo(path: Path):
    backup = path.with_suffix(path.suffix + ".cpufix.bak")
    if not backup.exists():
        sys.exit(f"error: no existe el backup {backup}")
    shutil.copy2(backup, path)
    print(f"restaurado {path} desde el backup")


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--undo", action="store_true",
                        help="restaurar el archivo original desde el backup")
    args = parser.parse_args()

    path = find_scene_embed()
    print(f"manimlib activo: {path}")
    if args.undo:
        undo(path)
    else:
        patch(path)


if __name__ == "__main__":
    main()
