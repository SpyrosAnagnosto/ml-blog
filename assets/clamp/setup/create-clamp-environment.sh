#!/usr/bin/env bash
# Run from a terminal. Requires uv and Git.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
export UV_CACHE_DIR="${UV_CACHE_DIR:-$PWD/.cache/uv}"
export UV_PYTHON_INSTALL_DIR="$PWD/.python"
uv venv --python 3.10 .venv-clamp
uv pip install --python .venv-clamp/bin/python torch torchvision \
  --index-url https://download.pytorch.org/whl/cpu
uv pip install --python .venv-clamp/bin/python \
  --build-constraint setup/clamp-build-constraints.txt \
  'git+https://github.com/ml-jku/clamp.git@61575cb76f4079ccdee13ac8513906af23baf047' \
  ipykernel 'setuptools<81' 'numpy<2' 'transformers<5'
.venv-clamp/bin/python -m ipykernel install --sys-prefix \
  --name clamp --display-name 'CLAMP (Python 3.10)'
