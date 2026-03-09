# Case Omie — Analista de Dados (Growth)

Analise de performance de canais de marketing e campanhas pagas da Omie ao longo de 2022, com foco em funil de conversao, eficiencia de investimento e sazonalidade.

## O que o notebook cobre

- Auditoria e limpeza dos dados (encoding, datas, campanhas orfas)
- Conversao EUR → BRL via API PTAX do Banco Central (taxa diaria)
- Performance por canal e tipo de campanha (CTR, CVR, CPL, CPA)
- Funil de conversao: impressoes ate apps pagos, por canal
- Sazonalidade de leads por mes
- Correlacao investimento x conversoes (Pearson + Spearman)
- Analise Pareto e evolucao mensal de eficiencia
- Insights e recomendacoes com dados concretos

## Como executar

### Opcao rapida (Windows, 1 comando)

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

Depois da primeira vez, rode:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_notebook.ps1
```

### Opcao manual (Windows / Linux / macOS)

#### 1) Criar e ativar ambiente virtual

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

#### 2) Instalar dependencias

```bash
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

#### 3) Abrir notebook

```bash
python -m jupyter notebook case_omie.ipynb
```

No Jupyter, selecione o kernel `Python (desafio-omie)` e execute `Run All`.

## Estrutura do projeto

```
desafio_omie/
├── case_omie.ipynb        # Notebook principal da analise
├── requirements.txt       # Dependencias lockadas (pip-compile)
├── requirements.in        # Dependencias fonte (restricoes >=)
├── docs/
│   ├── data.csv           # Dados de metricas por campanha
│   └── campaigns.csv      # Dicionario de campanhas
└── scripts/
    ├── setup_and_open.ps1 # Setup completo + abre Jupyter (Windows)
    └── run_notebook.ps1   # Abre Jupyter com ambiente existente
```

## Observacoes

- A etapa de cambio (PTAX Banco Central) precisa de internet.
- Se a API PTAX estiver indisponivel, tente novamente depois.
- `requirements.txt` e lock file para execucao/revisao (versoes fixas com `==`).
- `requirements.in` e arquivo fonte para manutencao (restricoes com `>=`).

## Manutencao de dependencias

Quando quiser atualizar versoes, use `pip-tools` para regenerar o lock:

```bash
python -m pip install pip-tools
pip-compile --upgrade requirements.in -o requirements.txt
```
