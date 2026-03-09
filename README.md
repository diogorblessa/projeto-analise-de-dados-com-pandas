# Case Omie

Análise de performance de canais de marketing e campanhas pagas da Omie ao longo de 2022, com foco em funil de conversão, eficiência de investimento e sazonalidade.

## O que o notebook cobre

- Auditoria e limpeza dos dados (encoding, datas, campanhas órfãs)
- Conversão EUR → BRL via API PTAX do Banco Central (taxa diária)
- Performance por canal e tipo de campanha (CTR, CVR, CPL, CPA)
- Funil de conversão: impressões até apps pagos, por canal
- Sazonalidade de leads por mês
- Correlação investimento x conversões (Pearson + Spearman)
- Análise Pareto e evolução mensal de eficiência
- Insights e recomendações com dados concretos

## Como executar

### Opção rápida (Windows, 1 comando)

No PowerShell, dentro da raiz do projeto:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup_and_open.ps1
```

O script faz tudo automaticamente:
- valida Python 3.11+;
- cria `.venv` (se não existir);
- instala dependências lockadas de `requirements.txt`;
- registra kernel `desafio-omie`;
- abre `case_omie.ipynb` no Jupyter.

Depois da primeira vez, rode:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\run_notebook.ps1
```

### Opção manual (Windows / Linux / macOS)

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

#### 2) Instalar dependências

```bash
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

#### 3) Abrir notebook

```bash
python -m jupyter notebook case_omie.ipynb
```

No Jupyter, selecione o kernel `Python 3 (ipykernel)` e execute `Run All`.

## Estrutura do projeto

```
desafio_omie/
├── case_omie.ipynb        # Notebook principal da análise
├── requirements.txt       # Dependências lockadas (pip-compile)
├── requirements.in        # Dependências fonte (restrições >=)
├── docs/
│   ├── data.csv           # Dados de métricas por campanha
│   └── campaigns.csv      # Dicionário de campanhas
└── scripts/
    ├── setup_and_open.ps1 # Setup completo + abre Jupyter (Windows)
    └── run_notebook.ps1   # Abre Jupyter com ambiente existente
```

## Observações

- A etapa de câmbio (PTAX Banco Central) precisa de internet.
- Se a API PTAX estiver indisponível, tente novamente depois.
- `requirements.txt` é lock file para execução/revisão (versões fixas com `==`).
- `requirements.in` é arquivo fonte para manutenção (restrições com `>=`).
