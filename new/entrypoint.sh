#!/bin/bash
# Entrypoint: arregla permisos de volúmenes montados y luego ejecuta el comando
# Corre como nvim (por USER nvim en el Dockerfile), usa sudo para chown
set -e

# Si los volúmenes named se crearon como root, el usuario nvim no puede escribir.
# También limpia caches de npm/pip que puedan haber quedado root-owned.
for dir in \
    /home/nvim/.local/share/nvim \
    /home/nvim/.local/state/nvim \
    /home/nvim/.cache/nvim \
    /home/nvim/.npm \
    /home/nvim/.cache/pip \
    /home/nvim/.local \
    /home/nvim/work; do
  if [ -d "$dir" ]; then
    sudo chown -R nvim:nvim "$dir" 2>/dev/null || chown -R nvim:nvim "$dir" 2>/dev/null || true
  fi
done

exec "$@"
