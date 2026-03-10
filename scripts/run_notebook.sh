#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
project_root="$(cd -- "${script_dir}/.." >/dev/null 2>&1 && pwd)"

venv_dir="${project_root}/.venv"
notebook_file="${project_root}/case_omie.ipynb"

get_venv_python() {
  local candidates=(
    "${venv_dir}/bin/python"
    "${venv_dir}/Scripts/python.exe"
  )
  local candidate
  for candidate in "${candidates[@]}"; do
    if [[ -f "${candidate}" ]]; then
      printf '%s\n' "${candidate}"
      return 0
    fi
  done
  return 1
}

venv_python="$(get_venv_python || true)"
if [[ -z "${venv_python}" ]]; then
  echo "Ambiente virtual nao encontrado. Rode primeiro: bash ./scripts/setup_and_open.sh" >&2
  exit 1
fi

if [[ ! -f "${notebook_file}" ]]; then
  echo "Notebook principal nao encontrado: ${notebook_file}" >&2
  exit 1
fi

echo "Abrindo notebook com o ambiente existente..."
echo "Kernel sugerido: Python (desafio-omie)"

cd "${project_root}"
"${venv_python}" -m jupyter notebook "${notebook_file}"
