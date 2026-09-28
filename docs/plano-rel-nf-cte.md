# Relatório: NF → CT-e → NFs vinculadas (Systêxtil)

## Objetivo
Tela nova (o inverso da `OBRF_F275`):
- **Entrada:** Empresa + Número NF + Série
- **Saída:** o CT-e ao qual a NF está vinculada (nº, série, transportadora, data, valor)
  + lista de **todas** as NFs vinculadas àquele mesmo CT-e, marcando a NF pesquisada.

## Tela de referência (o inverso)
`OBRF_F275` — digita CT-e, mostra NFs vinculadas.

SQLs que a `OBRF_F275` executa (do print):
```sql
SELECT ... FROM I_OBRF_010;   -- cabeçalho (NF e CT-e)
SELECT ... FROM I_OBRF_015;   -- itens
SELECT ... FROM OPER_276;     -- mensagens/log
SELECT ... FROM I_OBRF_016;   -- relacionamento CT-e x NF
SELECT ... FROM I_CPAG_010;   -- títulos
```

## Descobertas (fonte: javadoc oficial https://cvs.systextil.com.br/javadoc)

| Fato | Detalhe |
|---|---|
| `I_OBRF_016` = classe `RelacionamentoCte` | Colunas: `COD_EMPRESA`, `NUMERO_NOTA`, `SERIE_NOTA`, `FORNECEDOR9/4/2`, `COD_TRANSACAO`, `COD_DEPOSITO`, `TRANSPORTADORA` |
| CT-e é registro da própria `OBRF_010` | `ESPECIE_DOCTO = 'CTE'` (ex.: registro 54851 = CT-e 195483) |
| `NUM_CONHECIMENTO` da `I_OBRF_010` NÃO serve | Nos CT-e vem `0` (hipótese descartada com dados reais) |
| `I_OBRF_010` tem 75 colunas | `DOCUMENTO`, `SERIE`, `ESPECIE_DOCTO`, `NUMERO_DANF_NFE`, `CODIGO_TRANSACAO`, `COD_CIDADE_CTE`, `COD_CIDADE_CTE_DEST`, `TIPO_CONHECIMENTO`, `TRANSPA_FORNE9/4/2` |
| `OBRF_016` persistente existe | `GenericDao` tem `deleteObrf016` e `deleteIObrf016`. `I_` = integração (SPED) |

## Descoberta da `OBRF_016` — ✅ VALIDADA (17 colunas, 4.417 linhas, `TEMPORARY='N'`)

```
COL  COLNAME                TIPO            PAPEL
 1   NUM_CONHECIMENTO       NUMBER(9)       ► número do CT-e
 2   SER_CONHECIMENTO       VARCHAR2(3)     ► série do CT-e
 3   TRANSPORTADORA9        NUMBER(9)       CNPJ transportadora
 4   TRANSPORTADORA4        NUMBER(4)
 5   TRANSPORTADORA2        NUMBER(2)
 6   NUMERO_NOTA            NUMBER(9)       ► número da NF
 7   SERIE_NOTA             VARCHAR2(3)     ► série da NF
 8   FORNECEDOR9            NUMBER(9)       CNPJ fornecedor da NF
 9   FORNECEDOR4            NUMBER(4)
10   FORNECEDOR2            NUMBER(2)
11   COD_TRANSACAO          NUMBER(3)       código de tipo de transação
12   COD_DEPOSITO           NUMBER(3)       depósito da nota
13   CENTRO_CUSTO           NUMBER(9)
14   TRANSPORTADORA_R       VARCHAR2(9)     CNPJ formatado
15   TRANSPORTADORA_O       VARCHAR2(4)
16   FORNECEDOR_R           VARCHAR2(9)     CNPJ formatado
17   FORNECEDOR_O           VARCHAR2(4)
```

Ambas (`OBRF_016` e `I_OBRF_016`) são persistentes. Usar `OBRF_016` (dado real).
❌ `COD_TRANSACAO` NÃO é chave de documento (só 3 dígitos) — hipótese descartada.

## Modelo de dados

```
OBRF_016.NUM_CONHECIMENTO + SER_CONHECIMENTO  =  CT-e
OBRF_016.NUMERO_NOTA        + SERIE_NOTA       =  NF
```

Consulta em 3 tempos:
1. `OBRF_016 WHERE NUMERO_NOTA = :nf AND SERIE_NOTA = :serie` → achei o(s) CT-e(s)
2. `OBRF_016 WHERE NUM_CONHECIMENTO = :cte AND SER_CONHECIMENTO = :cte_serie` → todas as NFs do CT-e
3. `OBRF_010 WHERE DOCUMENTO = :cte AND SERIE = :cte_serie AND ESPECIE_DOCTO = 'CTE'` → cabeçalho do CT-e

> ⚠️ Uma NF pode estar vinculada a **mais de um** CT-e. O relatório deve listar todos.

## Etapas

### S1 — Estrutura da `OBRF_016` persistente  ✅
- [x] 1.1 Colunas de `OBRF_016` → 17 colunas, chave = `NUM_CONHECIMENTO`/`SER_CONHECIMENTO`
- [x] 1.2 Temporária? → **NÃO**. Usar `OBRF_016`.

### S2 — Validar cardinalidade CT-e → NF  ✅
- [x] 2.1 `ACHOU_CTE = QTD_NOTAS` em **15/15** grupos → modelo confirmado
- [x] 2.2 Amostra real: CT-e `9949/1` → NFs `18813`, `18814`, `18815` (transportadora `09.334.144/0001`)
- Maior CT-e com 3 NFs; nenhum grupo > 3

### S3 — Montar o relatório  ✅
- [x] 3.3 **Query testada com NF 18814/1** → CT-e 9949/1 com NFs 18813, 18814, 18815, marca `SIM` na pesquisada
- [x] 3.4 **21 NFs estão em mais de 1 CT-e** → relatório deve listar todos os CT-es
- [ ] 3.5 Descobrir coluna de EMPRESA em `OBRF_010` (não existe coluna com esse nome)
- [ ] 3.6 Descobrir colunas de CNPJ em `SUPR_010` (só tem `CNPJTRANS9/4/2`)

## Colunas confirmadas

**`OBRF_010`:** `DOCUMENTO`, `SERIE`, `CGC_CLI_FOR_9/4/2`, `ESPECIE_DOCTO`, `DATA_EMISSAO`,
`VALOR_ITENS`, `VALOR_ICMS`, `VALOR_TOTAL_IPI`, `VALOR_DESPESAS`, `VALOR_FRETE`, `VALOR_SEGURO`,
`VALOR_DESCONTO`, `VALOR_FUNRURAL`, `VALOR_IVA_1`, `VALOR_DESP_POST`, `VALOR_ICMS_SUB`,
`TOTAL_DOCTO`, `SITUACAO_ENTRADA`, `ESPECIE_VOLUMES`, `TRANSPA_FORNE9/4/2`, `VIA_TRANSPORTE`

**`SUPR_010`:** `NOME_FORNECEDOR`, `NOME_FANTASIA`, `NOME_DE_CONTATO`, `CNPJTRANS9/4/2`, `CNPJTRANS_R`, `CNPJTRANS_O`

## Query v1 (funcional, só com colunas confirmadas)
```sql
SELECT
    cte.DOCUMENTO                              AS CTE_NUMERO,
    cte.SERIE                                  AS CTE_SERIE,
    TO_CHAR(cte.DATA_EMISSAO,'DD/MM/YYYY')      AS CTE_DATA,
    cte.TOTAL_DOCTO                            AS CTE_VALOR_TOTAL,
    cte.VALOR_FRETE                            AS CTE_VALOR_FRETE,
    cte.SITUACAO_ENTRADA                       AS CTE_SITUACAO,
    TO_CHAR(nfe.DATA_EMISSAO,'DD/MM/YYYY')     AS NF_DATA,
    nfe.SITUACAO_ENTRADA                       AS NF_SITUACAO,
    nfe.TOTAL_DOCTO                            AS NF_VALOR_TOTAL,
    nfe.VALOR_FRETE                            AS NF_FRETE_RATEADO,
    nf.NUMERO_NOTA                             AS NF_NUMERO,
    nf.SERIE_NOTA                              AS NF_SERIE,
    CASE WHEN nf.NUMERO_NOTA = :NF AND nf.SERIE_NOTA = :SERIE
         THEN 'SIM' ELSE '' END               AS NF_PESQUISADA
FROM OBRF_016 rel
JOIN OBRF_010 cte
  ON cte.DOCUMENTO = rel.NUM_CONHECIMENTO
 AND cte.SERIE     = rel.SER_CONHECIMENTO
 AND cte.ESPECIE_DOCTO = 'CTE'
JOIN OBRF_016 nf
  ON nf.NUM_CONHECIMENTO = rel.NUM_CONHECIMENTO
 AND nf.SER_CONHECIMENTO = rel.SER_CONHECIMENTO
LEFT JOIN OBRF_010 nfe
  ON nfe.DOCUMENTO     = nf.NUMERO_NOTA
 AND nfe.SERIE         = nf.SERIE_NOTA
 AND nfe.CGC_CLI_FOR_9 = nf.FORNECEDOR9
 AND nfe.CGC_CLI_FOR_4 = nf.FORNECEDOR4
 AND nfe.CGC_CLI_FOR_2 = nf.FORNECEDOR2
WHERE rel.NUMERO_NOTA = :NF
  AND rel.SERIE_NOTA  = :SERIE
ORDER BY cte.DOCUMENTO, cte.SERIE, nf.NUMERO_NOTA, nf.SERIE_NOTA;
```

### S4 — Enriquecer com nomes  ✅ (falta só a empresa)
- [x] 4.1 `SUPR_010.FORNECEDOR9/4/2` = `OBRF_016.FORNECEDOR9/4/2` → join direto
- [x] 4.2 `SUPR_010.NOME_FORNECEDOR` / `NOME_FANTASIA` ✅
- [x] 4.3 `FATU_500.CODIGO_EMPRESA` / `NOME_EMPRESA` / `NOME_FANTASIA` / `CGC_9/4/2` ✅
- [ ] 4.4 Descobrir coluna de EMPRESA na `OBRF_010` — **adiada por decisão**, consultas prontas em `rel-nf-cte.sql` (S4.3/S4.4)

## Convenções de nomes confirmadas no banco

| Conceito | Tabela | Colunas |
|---|---|---|
| NF do CT-e | `OBRF_016` | `FORNECEDOR9/4/2` |
| CT-e | `OBRF_016` | `NUM_CONHECIMENTO` + `SER_CONHECIMENTO` |
| Transportadora | `OBRF_010` | `TRANSPA_FORNE9/4/2` |
| Tomador | `OBRF_010` | `CGC_CLI_FOR_9/4/2` |
| Cadastro de terceiros | `SUPR_010` | `FORNECEDOR9/4/2` (mesmo nome!) |
| Razão social | `SUPR_010` | `NOME_FORNECEDOR` / `NOME_FANTASIA` |
| Empresa | `FATU_500` | `CODIGO_EMPRESA`, `CGC_9/4/2`, `NOME_EMPRESA` |

## Resultado validado (NF 18814/1)

```
CT-e 9949/1 | 23/03/2024 | 5.028,12 | frete 6,00% de 83.751,08
   TRANSPORTES ANESI LTDA (ANESI TRANSPORTES)
   ├── NF 18813/1  22/03/2024  20.737,52  24,76%  SEMEAR ECOTEXTIL LTDA
   ├── NF 18814/1  22/03/2024  21.299,74  25,43%  SEMEAR ECOTEXTIL LTDA  << PESQUISADA
   └── NF 18815/1  22/03/2024  41.713,82  49,81%  SEMEAR ECOTEXTIL LTDA
```

Arquivo final: `docs/rel-nf-cte.sql` (Select 1 sem nomes, Select 2 com razão social)


