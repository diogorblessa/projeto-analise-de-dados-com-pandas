#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
project_root="$(cd -- "${script_dir}/.." >/dev/null 2>&1 && pwd)"

venv_dir="${project_root}/.venv"
requirements_file="${project_root}/requirements.txt"
notebook_file="${project_root}/case_omie.ipynb"

assert_path_exists() {
  local path="$1"
  local label="$2"
  if [[ ! -e "${path}" ]]; then
    echo "${label} nao encontrado: ${path}" >&2
    exit 1
  fi
}

get_system_python() {
  local python_path=""

  if command -v python3 >/dev/null 2>&1; then
    python_path="$(python3 -c 'import sys; print(sys.executable)' 2>/dev/null || true)"
    if [[ -n "${python_path}" ]]; then
      printf '%s\n' "${python_path}"
      return 0
    fi
  fi

  if command -v python >/dev/null 2>&1; then
    python_path="$(python -c 'import sys; print(sys.executable)' 2>/dev/null || true)"
    if [[ -n "${python_path}" ]]; then
      printf '%s\n' "${python_path}"
      return 0
    fi
  fi

  if command -v py >/dev/null 2>&1; then
    python_path="$(py -3 -c 'import sys; print(sys.executable)' 2>/dev/null || true)"
    if [[ -n "${python_path}" ]]; then
      printf '%s\n' "${python_path}"
      return 0
    fi
  fi

  return 1
}

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

assert_path_exists "${requirements_file}" "Arquivo requirements.txt"
assert_path_exists "${notebook_file}" "Notebook principal"

system_python="$(get_system_python || true)"
if [[ -z "${system_python}" ]]; then
  echo "Python nao encontrado. Instale Python 3.11+ e tente novamente." >&2
  exit 1
fi

if ! "${system_python}" -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 11) else 1)' >/dev/null 2>&1; then
  python_version="$("${system_python}" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
  echo "Versao do Python insuficiente (${python_version}). Use Python 3.11+." >&2
  exit 1
fi

python_version="$("${system_python}" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"
echo "Python detectado: ${system_python} (versao ${python_version})"

venv_python="$(get_venv_python || true)"
if [[ -z "${venv_python}" ]]; then
  echo "Criando ambiente virtual em ${venv_dir} ..."
  "${system_python}" -m venv "${venv_dir}"
else
  echo "Ambiente virtual ja existe em ${venv_dir}"
fi

venv_python="$(get_venv_python || true)"
if [[ -z "${venv_python}" ]]; then
  echo "Python da venv nao encontrado: ${venv_dir}" >&2
  exit 1
fi

echo "Atualizando pip..."
"${venv_python}" -m pip install --upgrade pip

echo "Instalando dependencias..."
"${venv_python}" -m pip install -r "${requirements_file}"

echo "Registrando kernel Jupyter 'desafio-omie'..."
"${venv_python}" -m ipykernel install --user --name "desafio-omie" --display-name "Python (desafio-omie)"

echo "Abrindo notebook case_omie.ipynb..."
echo "Nota: a etapa PTAX requer internet."

cd "${project_root}"
"${venv_python}" -m jupyter notebook "${notebook_file}"
