# API — Relatório NF-e → CT-e → NFs vinculadas

> Documento de contrato para o endpoint que retorna os dados do relatório.
> A implementação fica a cargo do desenvolvedor; aqui está tudo o que ele precisa saber.

---

## 1. Objetivo

Dado o número (e série) de uma **NF-e**, retornar o **CT-e** ao qual ela está vinculada e **todas
as NFs vinculadas àquele mesmo CT-e**, marcando qual delas foi a pesquisada.

É o inverso da tela `OBRF_F275` do Systêxtil (que pede o CT-e e devolve as NFs).

---

## 2. Endpoint

```
GET /api/v1/relatorios/nf-cte
```

### Query string

| Parâmetro  | Tipo    | Obrigatório | Exemplo | Observação                          |
|------------|---------|--------------|---------|------------------------------------|
| `numeroNF` | inteiro | sim          | `18814` | Número da nota, sem zeros à esquerda |
| `serieNF`  | texto   | sim          | `1`     | Série da nota. `OBRF_016.SERIE_NOTA` é `VARCHAR2(3)` |

### Exemplo de chamada

```
GET /api/v1/relatorios/nf-cte?numeroNF=18814&serieNF=1
```

---

## 3. SQL do endpoint

Bind variables `:NUMERO_NF` e `:SERIE_NF`. É exatamente o Select 2 de
[`rel-nf-cte.sql`](./rel-nf-cte.sql), já validado em produção.

```sql
SELECT
    /* ---------------- CT-e (repetido a cada linha) ---------------- */
    cte.DOCUMENTO                            AS CTE_NUMERO,
    cte.SERIE                                AS CTE_SERIE,
    TO_CHAR(cte.DATA_EMISSAO, 'DD/MM/YYYY')  AS CTE_DATA,
    cte.TOTAL_DOCTO                          AS CTE_VALOR_TOTAL,
    SUM(nfe.TOTAL_DOCTO) OVER (PARTITION BY cte.DOCUMENTO, cte.SERIE)
                                                 AS SOMA_NF_DO_CTE,
    ROUND(cte.TOTAL_DOCTO
          / NULLIF(SUM(nfe.TOTAL_DOCTO) OVER (PARTITION BY cte.DOCUMENTO, cte.SERIE), 0)
          * 100, 2)                            AS PCT_CTE_SOBRE_TOTAL_NFS,
    cte.VALOR_FRETE                          AS CTE_VALOR_FRETE,
    cte.SITUACAO_ENTRADA                     AS CTE_SITUACAO,
    transp.NOME_FORNECEDOR                   AS CTE_TRANSPORTADORA_RAZAO,
    transp.NOME_FANTASIA                     AS CTE_TRANSPORTADORA_FANTASIA,
    tomador.NOME_FORNECEDOR                  AS CTE_TOMADOR_RAZAO,
    tomador.NOME_FANTASIA                    AS CTE_TOMADOR_FANTASIA,

    /* ---------------- NFs vinculadas ---------------- */
    nf.NUMERO_NOTA                           AS NF_NUMERO,
    nf.SERIE_NOTA                            AS NF_SERIE,
    CASE WHEN nf.NUMERO_NOTA = :NUMERO_NF
          AND nf.SERIE_NOTA  = :SERIE_NF
         THEN '>> NF PESQUISADA' END         AS MARCA,
    TO_CHAR(nfe.DATA_EMISSAO, 'DD/MM/YYYY')  AS NF_DATA,
    nfe.TOTAL_DOCTO                          AS NF_VALOR_TOTAL,
    ROUND(nfe.TOTAL_DOCTO
          / NULLIF(SUM(nfe.TOTAL_DOCTO) OVER (PARTITION BY cte.DOCUMENTO, cte.SERIE), 0)
          * 100, 2)                          AS PCT_NF_NO_TOTAL_CTE,
    nfe.VALOR_FRETE                          AS NF_FRETE_RATEADO,
    nfe.SITUACAO_ENTRADA                     AS NF_SITUACAO,
    forn.NOME_FORNECEDOR                     AS NF_FORNECEDOR_RAZAO,
    forn.NOME_FANTASIA                       AS NF_FORNECEDOR_FANTASIA

FROM        OBRF_016 rel
JOIN        OBRF_010 cte
       ON   cte.DOCUMENTO     = rel.NUM_CONHECIMENTO
       AND cte.SERIE         = rel.SER_CONHECIMENTO
       AND cte.ESPECIE_DOCTO = 'CTE'
JOIN        OBRF_016 nf
       ON   nf.NUM_CONHECIMENTO = rel.NUM_CONHECIMENTO
       AND nf.SER_CONHECIMENTO = rel.SER_CONHECIMENTO
LEFT JOIN   OBRF_010 nfe
       ON   nfe.DOCUMENTO     = nf.NUMERO_NOTA
       AND nfe.SERIE         = nf.SERIE_NOTA
       AND nfe.CGC_CLI_FOR_9 = nf.FORNECEDOR9
       AND nfe.CGC_CLI_FOR_4 = nf.FORNECEDOR4
       AND nfe.CGC_CLI_FOR_2 = nf.FORNECEDOR2
LEFT JOIN   SUPR_010 transp
       ON   transp.FORNECEDOR9 = cte.TRANSPA_FORNE9
       AND transp.FORNECEDOR4 = cte.TRANSPA_FORNE4
       AND transp.FORNECEDOR2 = cte.TRANSPA_FORNE2
LEFT JOIN   SUPR_010 tomador
       ON   tomador.FORNECEDOR9 = cte.CGC_CLI_FOR_9
       AND tomador.FORNECEDOR4 = cte.CGC_CLI_FOR_4
       AND tomador.FORNECEDOR2 = cte.CGC_CLI_FOR_2
LEFT JOIN   SUPR_010 forn
       ON   forn.FORNECEDOR9 = nf.FORNECEDOR9
       AND forn.FORNECEDOR4 = nf.FORNECEDOR4
       AND forn.FORNECEDOR2 = nf.FORNECEDOR2
WHERE       rel.NUMERO_NOTA = :NUMERO_NF
  AND       rel.SERIE_NOTA  = :SERIE_NF
ORDER BY    cte.DOCUMENTO, cte.SERIE, nf.NUMERO_NOTA, nf.SERIE_NOTA
```

---

## 3. Endpoint por período (relatório de listagem)

Versão **v2** do endpoint: em vez de buscar uma NF, devolve **todas as NFs com CT-e dentro
de um período**. Serve para o dashboard e para o usuário não precisar saber o número da nota.

```
GET /api/v1/relatorios/nf-cte/periodo
```

### Query string

| Parâmetro    | Tipo  | Obrigatório | Padrão                    | Exemplo      |
|--------------|-------|--------------|---------------------------|--------------|
| `dataInicio` | data  | não          | 2 meses antes de hoje     | `2025-07-28` |
| `dataFim`    | data  | não          | hoje                      | `2025-09-28` |

Omitir os dois devolve os últimos 2 meses. Ambos são sempre expandidos para o dia inteiro:
`dataFim` é inclusivo até `23:59:59`.

### Diferenças em relação ao endpoint por número de NF

| Aspecto | Endpoint por NF (v1) | Endpoint por período (v2) |
|---|---|---|
| Parâmetros | `numeroNF`, `serieNF` | `dataInicio`, `dataFim` |
| Filtro | `OBRF_016.NUMERO_NOTA` / `SERIE_NOTA` | `OBRF_010.DATA_EMISSAO` |
| Campo `pesquisada` / `MARCA` | presente, `true` em uma linha | **removido** — não há NF "pesquisada" em uma listagem |
| Volume | 1 CT-e, poucas linhas | muitos CT-es, pode passar de mil linhas |
| Paginação | desnecessária | **obrigatória** |

### Paginação (v2)

Com período de 2 meses o volume cresce muito. Adicionar paginação na aplicação — a query
base continua a mesma, limite o `OFFSET`/`FETCH` ou filtre no driver:

```sql
OFFSET :OFFSET ROWS FETCH NEXT :LIMITE ROWS ONLY
```

> **Atenção:** paginar **depois** da ordenação é correto, mas as funções de janela
> (`SUM() OVER (PARTITION BY cte.DOCUMENTO, cte.SERIE)`) continuam calculando a soma de
> **todas** as NFs do CT-e, mesmo nas páginas parciais. Isso é o comportamento desejado —
> o percentual de cada NF sempre é sobre o total real do CT-e, não sobre a página.

### Query

Igual ao Select 2, com o `WHERE` trocado por:

```sql
WHERE       COALESCE(nfe.DATA_EMISSAO, cte.DATA_EMISSAO) >= :DATA_INI
  AND       COALESCE(nfe.DATA_EMISSAO, cte.DATA_EMISSAO) <  :DATA_FIM + 1
```

**Por que o `COALESCE`:** o join da NF é `LEFT JOIN`, então uma NF sem cabeçalho na
`OBRF_010` tem `DATA_EMISSAO` nula. Filtrando direto por `nfe.DATA_EMISSAO`, essas linhas
sumiriam do relatório sem nenhuma indication. O `COALESCE` com a data do CT-e garante que
nenhuma linha seja perdida silenciosamente. Documentar essa decisão na API para que ninguém
"simplifique" removendo o `COALESCE`.

**Para filtrar pela data do CT-e** em vez da NF:

```sql
WHERE  cte.DATA_EMISSAO >= :DATA_INI
  AND  cte.DATA_EMISSAO <  :DATA_FIM + 1
```

### 3.1 Consulta auxiliar (para diferenciar 404 de "sem CT-e")

A query principal devolve **0 linhas** tanto quando a NF não existe quanto quando ela existe
mas não tem CT-e. Para separar os dois casos, rode antes:

```sql
SELECT COUNT(*) AS TOTAL
FROM OBRF_016
WHERE NUMERO_NOTA = :NUMERO_NF
  AND SERIE_NOTA  = :SERIE_NF
```

| Resultado | Significado                              | HTTP |
|-----------|------------------------------------------|------|
| `0`       | NF não existe no vínculo de CT-e         | 404  |
| `> 0` e query principal vazia | NF existe, sem CT-e | 200 com lista vazia |
| `> 0` e query principal com linhas | sucesso | 200 |

---

## 4. Resposta

### 4.1 Formato recomendado (v1) — linhas planas

O SQL já devolve o formato final. Serializar direto, sem agrupar:

```json
{
  "consulta": { "numeroNF": 18814, "serieNF": "1" },
  "totalLinhas": 3,
  "linhas": [
    {
      "cte": {
        "numero": 9949,
        "serie": "1",
        "data": "23/03/2024",
        "valorTotal": 5028.12,
        "valorFrete": 0,
        "situacao": 4,
        "somaValorNotas": 83751.08,
        "pctCTeSobreTotalNotas": 6,
        "transportadoraRazaoSocial": "TRANSPORTES ANESI LTDA",
        "transportadoraNomeFantasia": "ANESI TRANSPORTES",
        "tomadorRazaoSocial": "TRANSPORTES ANESI LTDA",
        "tomadorNomeFantasia": "ANESI TRANSPORTES"
      },
      "nf": {
        "numero": 18813,
        "serie": "1",
        "pesquisada": false,
        "data": "22/03/2024",
        "valorTotal": 20737.52,
        "freteRateado": 0,
        "situacao": 4,
        "pctNFNoTotalCte": 24.76,
        "fornecedorRazaoSocial": "SEMEAR ECOTEXTIL LTDA",
        "fornecedorNomeFantasia": "PGFIOS"
      }
    },
    {
      "cte": { "numero": 9949, "serie": "1", "...": "repete em todas as linhas" },
      "nf": {
        "numero": 18814,
        "serie": "1",
        "pesquisada": true,
        "valorTotal": 21299.74,
        "pctNFNoTotalCte": 25.43
      }
    }
  ]
}
```

> Os campos de `cte` vêm repetidos em cada linha. Isso é proposital: o front-end pode
> agrupar por `cte.numero + cte.serie` sem fazer nada de especial. Se preferir o formato
> aninhado (um objeto por CT-e com a lista de NFs dentro), veja a seção 4.2.

### 4.2 Formato alternativo — aninhado por CT-e

Útil quando o front-end quer um card por CT-e. O agrupamento é feito na aplicação:

```json
{
  "consulta": { "numeroNF": 18814, "serieNF": "1" },
  "totalCTes": 1,
  "ctes": [
    {
      "numero": 9949,
      "serie": "1",
      "data": "23/03/2024",
      "valorTotal": 5028.12,
      "somaValorNotas": 83751.08,
      "pctCTeSobreTotalNotas": 6,
      "transportadoraRazaoSocial": "TRANSPORTES ANESI LTDA",
      "quantidadeNotas": 3,
      "notas": [
        { "numero": 18813, "serie": "1", "valorTotal": 20737.52, "pctNFNoTotalCte": 24.76, "pesquisada": false },
        { "numero": 18814, "serie": "1", "valorTotal": 21299.74, "pctNFNoTotalCte": 25.43, "pesquisada": true  },
        { "numero": 18815, "serie": "1", "valorTotal": 41713.82, "pctNFNoTotalCte": 49.81, "pesquisada": false }
      ]
    }
  ]
}
```

---

## 5. Dicionário de campos

### CT-e (`OBRF_010` com `ESPECIE_DOCTO = 'CTE'`)

| Campo no JSON | Alias do SQL | Origem | Tipo | Observação |
|---|---|---|---|---|
| `numero` | `CTE_NUMERO` | `OBRF_010.DOCUMENTO` | número | Também é `OBRF_016.NUM_CONHECIMENTO` |
| `serie` | `CTE_SERIE` | `OBRF_010.SERIE` | texto(3) | Também é `OBRF_016.SER_CONHECIMENTO` |
| `data` | `CTE_DATA` | `OBRF_010.DATA_EMISSAO` | `DD/MM/AAAA` | Formatada no SQL |
| `valorTotal` | `CTE_VALOR_TOTAL` | `OBRF_010.TOTAL_DOCTO` | decimal(15,2) | |
| `valorFrete` | `CTE_VALOR_FRETE` | `OBRF_010.VALOR_FRETE` | decimal(15,2) | |
| `situacao` | `CTE_SITUACAO` | `OBRF_010.SITUACAO_ENTRADA` | inteiro | Sem tabela de domínio documentada |
| `somaValorNotas` | `SOMA_NF_DO_CTE` | calculada | decimal | Soma de `TOTAL_DOCTO` das NFs do CT-e |
| `pctCTeSobreTotalNotas` | `PCT_CTE_SOBRE_TOTAL_NFS` | calculada | % | `valorTotal / somaValorNotas * 100` |
| `transportadoraRazaoSocial` | `CTE_TRANSPORTADORA_RAZAO` | `SUPR_010.NOME_FORNECEDOR` | texto(60) | Via `OBRF_010.TRANSPA_FORNE9/4/2` |
| `transportadoraNomeFantasia` | `CTE_TRANSPORTADORA_FANTASIA` | `SUPR_010.NOME_FANTASIA` | texto(60) | |
| `tomadorRazaoSocial` | `CTE_TOMADOR_RAZAO` | `SUPR_010.NOME_FORNECEDOR` | texto(60) | Via `OBRF_010.CGC_CLI_FOR_9/4/2` |
| `tomadorNomeFantasia` | `CTE_TOMADOR_FANTASIA` | `SUPR_010.NOME_FANTASIA` | texto(60) | |
| `quantidadeNotas` | — | contagem | inteiro | Só no formato 4.2 |

### NF-e

| Campo no JSON | Alias do SQL | Origem | Tipo | Observação |
|---|---|---|---|---|
| `numero` | `NF_NUMERO` | `OBRF_016.NUMERO_NOTA` | número | |
| `serie` | `NF_SERIE` | `OBRF_016.SERIE_NOTA` | texto(3) | |
| `pesquisada` | `MARCA` | derivado | booleano | `true` só na linha da NF pesquisada |
| `data` | `NF_DATA` | `OBRF_010.DATA_EMISSAO` | `DD/MM/AAAA` | |
| `valorTotal` | `NF_VALOR_TOTAL` | `OBRF_010.TOTAL_DOCTO` | decimal(15,2) | |
| `freteRateado` | `NF_FRETE_RATEADO` | `OBRF_010.VALOR_FRETE` | decimal(15,2) | |
| `situacao` | `NF_SITUACAO` | `OBRF_010.SITUACAO_ENTRADA` | inteiro | |
| `pctNFNoTotalCte` | `PCT_NF_NO_TOTAL_CTE` | calculada | % | Peso da NF dentro do CT-e |
| `fornecedorRazaoSocial` | `NF_FORNECEDOR_RAZAO` | `SUPR_010.NOME_FORNECEDOR` | texto(60) | Via `OBRF_016.FORNECEDOR9/4/2` |
| `fornecedorNomeFantasia` | `NF_FORNECEDOR_FANTASIA` | `SUPR_010.NOME_FANTASIA` | texto(60) | |
| `empresa` | — | `FATU_500` | objeto | ⚠️ **Pendente** — ver seção 7 |

---

## 6. Regras de negócio

1. **Chave do vínculo.** `OBRF_016.NUM_CONHECIMENTO` + `SER_CONHECIMENTO` = CT-e.
   `OBRF_016.NUMERO_NOTA` + `SERIE_NOTA` = NF-e. Nada mais é usado como chave.
2. **CT-e é um documento normal.** Vive na `OBRF_010` com `ESPECIE_DOCTO = 'CTE'`.
   O `JOIN` do SQL é obrigatório — sem ele o relatório não sabe nem data, nem valor, nem
   transportadora do CT-e.
3. **Uma NF pode estar em mais de um CT-e.** Existem **21 casos** na base atual. Nesse caso o
   endpoint devolve um bloco por CT-e. O relatório **não** escolhe um CT-e "principal".
4. **CNPJ desambigua a nota.** O mesmo número/série pode existir para fornecedores diferentes.
   Por isso o join com `OBRF_010` compara `CGC_CLI_FOR_9/4/2` junto com documento e série.
5. **NF sem `OBRF_010`.** O `LEFT JOIN` garante que a linha aparece mesmo se a nota ainda não
   tiver cabeçalho na `OBRF_010` — nesse caso data, valor e situação vêm `null`.
6. **`TOTAL_DOCTO` do CT-e é o valor do frete**, não o valor da carga. Por isso
   `pctCTeSobreTotalNotas` costuma dar um percentual baixo (6,00% no caso de teste). Isso é
   comportamento correto do dado, não bug.
7. **Nome de terceiro pode ser `null`** se o CNPJ não estiver cadastrado na `SUPR_010` —
   os `LEFT JOIN` preservam a linha mesmo assim.

---

## 7. Pendências

| # | Pendência | Impacto | Como resolver |
|---|---|---|---|
| 1 | **Razão social da empresa** no relatório | Campos `empresa` e `codigoEmpresa` ficam fora | A `OBRF_010` não tem coluna com "EMPRESA" no nome. Descobrir entre as colunas 6–25 e ligar em `FATU_500.CODIGO_EMPRESA` |
| 2 | Domínio do `SITUACAO_ENTRADA` | Cliente mostra número cru | `OBRF_010.SITUACAO_ENTRADA` é inteiro; falta a tabela que traduz o código |
| 3 | Índice em `OBRF_016(NUMERO_NOTA, SERIE_NOTA)` | Irrelevante agora (4.417 linhas) | Criar quando a base crescer ou se a tabela virar milhões de linhas |
| 4 | CNPJ formatado no JSON | Ausente | O SQL de origem (`docs/rel-nf-cte.sql`, Select 1) monta o CNPJ com `LPAD`; incluir se a API precisar |

---

## 8. Desempenho e observabilidade

- A consulta é **um único statement**, sem CDUA, sem stored procedure, sem tabela temporária.
- As funções de janela (`SUM() OVER (PARTITION BY ...)`) calculam a soma das NFs do CT-e na
  mesma passada — **não** fazer um segundo `SELECT` para isso.
- `OBRF_016` tem 4.417 linhas e não tem índice na coluna de busca. Full scan é aceitável hoje;
  monitore o tempo de resposta conforme a base cresce.
- Logar sempre `numeroNF`, `serieNF`, quantidade de linhas retornadas e tempo de execução.

---

## 9. Exemplo real de resposta (validado em produção)

Consulta: `numeroNF=18814`, `serieNF=1`

```
CT-e  9949/1 · 23/03/2024 · 5.028,12 · soma NFs 83.751,08 · 6,00% do frete
      TRANSPORTES ANESI LTDA (ANESI TRANSPORTES) · tomador idem · situação 4
  ├── NF 18813/1 · 22/03/2024 · 20.737,52 · 24,76% · SEMEAR ECOTEXTIL LTDA (PGFIOS) · situação 4
  ├── NF 18814/1 · 22/03/2024 · 21.299,74 · 25,43% · SEMEAR ECOTEXTIL LTDA (PGFIOS) · situação 4  ◀ PESQUISADA
  └── NF 18815/1 · 22/03/2024 · 41.713,82 · 49,81% · SEMEAR ECOTEXTIL LTDA (PGFIOS) · situação 4
```

---

## 10. Documentos relacionados

| Arquivo | Conteúdo |
|---|---|
| `docs/rel-nf-cte.sql` | Os 3 selects prontos para rodar no banco (1 e 2 por NF, 3 por período) |
| `docs/plano-rel-nf-cte.md` | Como o modelo de dados foi descoberto, passo a passo |
| `docs/rel_cte_nfe.md` | Pedido original + prints da tela `OBRF_F275` |
| `docs/api-nf-cte.md` | **Este documento** |
