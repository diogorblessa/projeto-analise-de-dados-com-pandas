# Contexto do projeto:

Análise de performance de canais de marketing e campanhas pagas de um sistema de gestão empresarial (ERP) 100% em nuvem, com foco em funil de conversão, eficiência de investimento e sazonalidade ao longo de 2022. Os dados deste projeto são fictícios.

## O que o notebook cobre

- Auditoria e limpeza dos dados (encoding, datas, campanhas órfãs)
- Conversão EUR → BRL via API PTAX do Banco Central (taxa diária)
- Performance por canal e tipo de campanha (CTR, CVR, CPL, CPA)
- Funil de conversão: impressões até apps pagos, por canal
- Sazonalidade de leads por mês
- Correlação investimento x conversões (Pearson + Spearman)
- Robustez de correlações com outliers
- Análise Pareto e evolução mensal de eficiência
- Síntese analítica e recomendações com dados concretos

## Análises futuras (não executadas)

Estas frentes não foram executadas neste case. Elas representam um roadmap analítico para evolução da decisão de negócio.

**Viável com dados atuais**
- `ROAS` (`faturamento / investimento`): há dados de `faturamento` e `investimento` para leitura de retorno por canal.
- `CAC`: pode ser derivado da estrutura atual de aquisição, com definição formal do evento padrão de aquisição.
- `Modelagem preditiva` (exploratória): possível com a base atual, com ressalva de janela curta de `12` meses.

**Depende de dados adicionais ou desenho experimental**
- `Cohort`: requer identificador individual (`lead_id` ou `cliente_id`) e linha do tempo por lead.
- `Teste A/B`: requer randomização, grupo de controle e protocolo experimental.
- `Atribuição multi touch`: requer trilha de interações por usuário ao longo da jornada.
- `LTV` e `LTV vs CAC`: requer histórico por cliente com retenção, receita recorrente e churn.

## Dados e premissas

- Período analisado: Janeiro a Dezembro de 2022
- Fontes de dados: `docs/data.csv` e `docs/campaigns.csv`
- A análise de correlação é usada para identificar relação entre variáveis, não para provar causalidade
- Conversão cambial EUR → BRL realizada via API PTAX por data de referência

## Requisitos do desafio e onde estão no notebook

| Requisito do enunciado | Onde está no notebook |
| --- | --- |
| PASSO 1: cenário geral por canal e tipo de campanha | `7.1`, `7.2`, `7.3` |
| PASSO 1: desempenho do funil por canal | `8` |
| PASSO 1: leads por mês e sazonalidade | `9` |
| PASSO 1: melhor tipo dentro de canais pagos | `10` |
| PASSO 2: correlação entre investimento e apps pagos | `11.1` |
| PASSO 2: correlação entre investimento e CPL | `11.2` |
| PASSO 2: correlação entre Search e Direto (efeito halo) | `11.3` |
| PASSO 2: robustez das correlações com outliers | `11.4` |
| Síntese para apresentação | `13`, `14`, `15` |

Nota: `PASSO 1` e `PASSO 2` são rótulos do enunciado original do desafio. As respostas já estão executadas nas etapas indicadas do notebook, e o `PASSO 2` está coberto nas subetapas `11.1` a `11.4`.

## Como executar

**Pré-requisitos:** Python `3.11+` e internet (para a etapa de câmbio via PTAX).

1. Criar e ativar ambiente virtual.

Linux e macOS:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Windows (Git Bash):

```bash
python -m venv .venv
source .venv/Scripts/activate
```

2. Instalar dependências.

```bash
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
```

3. Abrir o notebook.

```bash
python -m jupyter notebook case_projeto_analise_dados.ipynb
```

No Jupyter, selecione o kernel da venv ativa e execute `Run All`.

## Estrutura do projeto

```
projeto-analise-de-dados-com-pandas/
├── case_projeto_analise_dados.ipynb        # Notebook principal da análise
├── requirements.txt       # Dependências Python
└── docs/
    ├── data.csv           # Dados de métricas por campanha
    └── campaigns.csv      # Dicionário de campanhas
```

## Licença

Uso educacional e de avaliação técnica.
