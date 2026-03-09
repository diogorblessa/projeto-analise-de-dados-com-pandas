[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$venvDir = Join-Path $projectRoot ".venv"
$venvPython = Join-Path $venvDir "Scripts\python.exe"
$activateScript = Join-Path $venvDir "Scripts\Activate.ps1"
$requirementsFile = Join-Path $projectRoot "requirements.txt"
$notebookFile = Join-Path $projectRoot "case_omie.ipynb"

function Assert-PathExists {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Label
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "$Label nao encontrado: $Path"
    }
}

function Get-SystemPython {
    $candidates = @()

    if (Get-Command py -ErrorAction SilentlyContinue) {
        $candidates += ,@("py", "-3")
    }
    if (Get-Command python -ErrorAction SilentlyContinue) {
        $candidates += ,@("python")
    }

    foreach ($candidate in $candidates) {
        $exe = $candidate[0]
        $prefix = @()
        if ($candidate.Count -gt 1) {
            $prefix = $candidate[1..($candidate.Count - 1)]
        }

        try {
            $args = @()
            $args += $prefix
            $args += "-c"
            $args += "import sys; print(sys.executable)"
            $pythonPath = (& $exe @args 2>$null).Trim()
            if ($LASTEXITCODE -eq 0 -and $pythonPath) {
                return $pythonPath
            }
        } catch {
            # try next candidate
        }
    }

    throw "Python nao encontrado. Instale Python 3.11+ e tente novamente."
}

Assert-PathExists -Path $requirementsFile -Label "Arquivo requirements.txt"
Assert-PathExists -Path $notebookFile -Label "Notebook principal"

$systemPython = Get-SystemPython
$pythonVersion = (& $systemPython -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')").Trim()

if ([version]$pythonVersion -lt [version]"3.11") {
    throw "Versao do Python insuficiente ($pythonVersion). Use Python 3.11+."
}

Write-Host "Python detectado: $systemPython (versao $pythonVersion)" -ForegroundColor Cyan

if (-not (Test-Path -LiteralPath $venvPython)) {
    Write-Host "Criando ambiente virtual em $venvDir ..." -ForegroundColor Cyan
    & $systemPython -m venv $venvDir
}
else {
    Write-Host "Ambiente virtual ja existe em $venvDir" -ForegroundColor DarkCyan
}

Assert-PathExists -Path $venvPython -Label "Python da venv"
Assert-PathExists -Path $activateScript -Label "Script de ativacao da venv"

. $activateScript

Write-Host "Atualizando pip..." -ForegroundColor Cyan
& $venvPython -m pip install --upgrade pip

Write-Host "Instalando dependencias..." -ForegroundColor Cyan
& $venvPython -m pip install -r $requirementsFile

Write-Host "Registrando kernel Jupyter 'desafio-omie'..." -ForegroundColor Cyan
& $venvPython -m ipykernel install --user --name "desafio-omie" --display-name "Python (desafio-omie)"

Write-Host "Abrindo notebook case_omie.ipynb..." -ForegroundColor Green
Write-Host "Nota: a etapa PTAX requer internet." -ForegroundColor Yellow

Push-Location $projectRoot
try {
    & $venvPython -m jupyter notebook $notebookFile
}
finally {
    Pop-Location
}
