# Instrucoes de Execucao do Notebook

## Recomendado para avaliacao (Windows, 1 comando)

No PowerShell, dentro da raiz do projeto:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup_and_open.ps1
```

O script faz tudo automaticamente:
- valida Python 3.11+;
- cria `.venv` (se nao existir);
- instala dependencias lockadas de `requirements.txt`;
- registra kernel `desafio-omie`;
- abre `case_omie.ipynb` no Jupyter.

## Proximas execucoes (ambiente ja pronto)

Depois da primeira vez, rode:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_notebook.ps1
```

## Fallback manual

### 1) Criar e ativar ambiente virtual

Windows (PowerShell):

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

Linux / macOS:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 2) Instalar dependencias

```bash
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

### 3) Abrir notebook

```bash
python -m jupyter notebook case_omie.ipynb
```

No Jupyter, selecione o kernel `Python (desafio-omie)` e execute `Run All`.

## Observacoes

- A etapa de cambio (PTAX Banco Central) precisa de internet.
- Se a API PTAX estiver indisponivel, tente novamente depois.
- `requirements.txt` e lock file para execucao/revisao (versoes fixas com `==`).
- `requirements.in` e arquivo fonte para manutencao (restricoes com `>=`).

## Manutencao de dependencias (somente dev)

Quando quiser atualizar versoes, use `pip-tools` para regenerar o lock:

```bash
python -m pip install pip-tools
pip-compile --upgrade requirements.in -o requirements.txt
```
