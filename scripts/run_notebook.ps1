[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$venvDir = Join-Path $projectRoot ".venv"
$venvPython = Join-Path $venvDir "Scripts\python.exe"
$activateScript = Join-Path $venvDir "Scripts\Activate.ps1"
$notebookFile = Join-Path $projectRoot "case_omie.ipynb"

if (-not (Test-Path -LiteralPath $venvPython)) {
    throw "Ambiente virtual nao encontrado. Rode primeiro: powershell -ExecutionPolicy Bypass -File .\\scripts\\setup_and_open.ps1"
}

if (-not (Test-Path -LiteralPath $notebookFile)) {
    throw "Notebook principal nao encontrado: $notebookFile"
}

if (Test-Path -LiteralPath $activateScript) {
    . $activateScript
}

Write-Host "Abrindo notebook com o ambiente existente..." -ForegroundColor Green
Write-Host "Kernel sugerido: Python (desafio-omie)" -ForegroundColor Yellow

Push-Location $projectRoot
try {
    & $venvPython -m jupyter notebook $notebookFile
}
finally {
    Pop-Location
}
