/* ============================================================================
 *  RELATORIO: NF-e  ->  CT-e  ->  todas as NFs vinculadas
 *  Systextil  |  OBRF_016 + OBRF_010 + SUPR_010 + FATU_500
 *
 *  ENTRADA: trocar os 2 valores marcados com <<< ALTERE AQUI >>>
 *  SAIDA  : o(s) CT-e(s) em que a NF esta vinculada + todas as NFs de cada CT-e
 *
 *  MODELO DE DADOS
 *    OBRF_016.NUM_CONHECIMENTO / SER_CONHECIMENTO  =  CT-e
 *    OBRF_016.NUMERO_NOTA        / SERIE_NOTA       =  NF-e
 *    OBRF_010.ESPECIE_DOCTO = 'CTE'                =  cabecalho do CT-e
 *
 *  TESTE JA VALIDADO:  NF 18814 / serie 1  -->  CT-e 9949/1  -->  NFs 18813, 18814, 18815
 *
 *  CONVENCAO DE NOMES CONFIRMADA NO BANCO
 *    OBRF_016.FORNECEDOR9/4/2  ==  SUPR_010.FORNECEDOR9/4/2   (mesmo nome, join direto)
 *    OBRF_010.CGC_CLI_FOR_9/4/2 (tomador)
 *    OBRF_010.TRANSPA_FORNE9/4/2 (transportadora)
 *    razao social -> SUPR_010.NOME_FORNECEDOR  / SUPR_010.NOME_FANTASIA
 *                    FATU_500.NOME_EMPRESA     / FATU_500.NOME_FANTASIA
 *    empresa      -> FATU_500.CODIGO_EMPRESA (CNPJ em CGC_9 / CGC_4 / CGC_2)
 * ========================================================================== */


/* ###########################################################################
 *  SELECT 1 - SEM nomes
 * ######################################################################### */
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
    LPAD(cte.TRANSPA_FORNE9, 9, '0') || '.' || LPAD(cte.TRANSPA_FORNE4, 4, '0')
        || '.' || LPAD(cte.TRANSPA_FORNE2, 2, '0')          AS CTE_CNPJ_TRANSPORTADORA,
    LPAD(cte.CGC_CLI_FOR_9, 9, '0') || '.' || LPAD(cte.CGC_CLI_FOR_4, 4, '0')
        || '.' || LPAD(cte.CGC_CLI_FOR_2, 2, '0')            AS CTE_CNPJ_TOMADOR,

    /* ---------------- NFs vinculadas ---------------- */
    nf.NUMERO_NOTA                           AS NF_NUMERO,
    nf.SERIE_NOTA                            AS NF_SERIE,
    CASE WHEN nf.NUMERO_NOTA = 18814          /* <<< ALTERE AQUI: numero da NF */
          AND nf.SERIE_NOTA  = '1'           /* <<< ALTERE AQUI: serie da NF  */
         THEN '>> NF PESQUISADA' END         AS MARCA,
    TO_CHAR(nfe.DATA_EMISSAO, 'DD/MM/YYYY')  AS NF_DATA,
    nfe.TOTAL_DOCTO                          AS NF_VALOR_TOTAL,
    ROUND(nfe.TOTAL_DOCTO
          / NULLIF(SUM(nfe.TOTAL_DOCTO) OVER (PARTITION BY cte.DOCUMENTO, cte.SERIE), 0)
          * 100, 2)                          AS PCT_NF_NO_TOTAL_CTE,
    nfe.VALOR_FRETE                          AS NF_FRETE_RATEADO,
    nfe.SITUACAO_ENTRADA                     AS NF_SITUACAO,
    LPAD(nf.FORNECEDOR9, 9, '0') || '.' || LPAD(nf.FORNECEDOR4, 4, '0')
        || '.' || LPAD(nf.FORNECEDOR2, 2, '0')               AS NF_CNPJ_FORNECEDOR

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
WHERE       rel.NUMERO_NOTA = 18814          /* <<< ALTERE AQUI: numero da NF */
  AND       rel.SERIE_NOTA  = '1'           /* <<< ALTERE AQUI: serie da NF  */
ORDER BY    cte.DOCUMENTO, cte.SERIE, nf.NUMERO_NOTA, nf.SERIE_NOTA;


/* ###########################################################################
 *  SELECT 2 - COM razao social da transportadora, do tomador e do fornecedor
 *
 *  PENDENTE: a razao social da EMPRESA depende de descobrir qual coluna da
 *  OBRF_010 guarda o codigo da empresa (ver consulta S4.2 no fim do arquivo).
 * ######################################################################### */
SELECT
    /* ---------------- CT-e ---------------- */
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
    transp.NOME_FANTASIA                     AS CTE_TRANSPORTADORA,
    transp.NOME_FORNECEDOR                   AS CTE_TRANSPORTADORA_RAZAO,
    tomador.NOME_FANTASIA                    AS CTE_TOMADOR,
    tomador.NOME_FORNECEDOR                   AS CTE_TOMADOR_RAZAO,

    /* ---------------- NFs vinculadas ---------------- */
    nf.NUMERO_NOTA                           AS NF_NUMERO,
    nf.SERIE_NOTA                            AS NF_SERIE,
    CASE WHEN nf.NUMERO_NOTA = 18814
          AND nf.SERIE_NOTA  = '1'   THEN '>> NF PESQUISADA' END AS MARCA,
    TO_CHAR(nfe.DATA_EMISSAO, 'DD/MM/YYYY')  AS NF_DATA,
    nfe.TOTAL_DOCTO                          AS NF_VALOR_TOTAL,
    ROUND(nfe.TOTAL_DOCTO
          / NULLIF(SUM(nfe.TOTAL_DOCTO) OVER (PARTITION BY cte.DOCUMENTO, cte.SERIE), 0)
          * 100, 2)                          AS PCT_NF_NO_TOTAL_CTE,
    nfe.VALOR_FRETE                          AS NF_FRETE_RATEADO,
    nfe.SITUACAO_ENTRADA                     AS NF_SITUACAO,
    forn.NOME_FANTASIA                       AS NF_FORNECEDOR,
    forn.NOME_FORNECEDOR                     AS NF_FORNECEDOR_RAZAO

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
WHERE       rel.NUMERO_NOTA = 18814
  AND       rel.SERIE_NOTA  = '1'
ORDER BY    cte.DOCUMENTO, cte.SERIE, nf.NUMERO_NOTA, nf.SERIE_NOTA;



/* ###########################################################################
 *  SELECT 3 - POR PERIODO (lista todas as NFs com CT-e de 2 meses atras ate hoje)
 *
 *  Troque os 2 valores marcados com <<< ALTERE AQUI >>>. Para o endpoint, use os
 *  bind variables :DATA_INI / :DATA_FIM.
 *
 *  DECISAO IMPORTANTE: o periodo e filtrado pela DATA DA NF (OBRF_010.DATA_EMISSAO).
 *  Como o join da NF e LEFT JOIN, uma NF sem cabecalho na OBRF_010 teria data nula e
 *  sumiria do resultado sem aviso. Por isso o COALESCE usa a data do CT-e como reserva.
 *  Assim nenhuma linha some do relatorio.
 *
 *  Para filtrar pela data do CT-e em vez disso, troque as duas condicoes do WHERE por:
 *      AND cte.DATA_EMISSAO >= :DATA_INI
 *      AND cte.DATA_EMISSAO <  :DATA_FIM + 1
 * ######################################################################### */
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

    /* ---------------- NFs ---------------- */
    nf.NUMERO_NOTA                           AS NF_NUMERO,
    nf.SERIE_NOTA                            AS NF_SERIE,
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
WHERE       COALESCE(nfe.DATA_EMISSAO, cte.DATA_EMISSAO) >= ADD_MONTHS(TRUNC(SYSDATE), -2)  /* <<< ALTERE AQUI: data inicial */
  AND       COALESCE(nfe.DATA_EMISSAO, cte.DATA_EMISSAO) <  TRUNC(SYSDATE) + 1               /* <<< ALTERE AQUI: data final   */
ORDER BY    cte.DATA_EMISSAO DESC, cte.DOCUMENTO, cte.SERIE, nf.NUMERO_NOTA, nf.SERIE_NOTA;


/* ###########################################################################
 *  S4 - CONSULTAS DE CONFIRMACAO
 * ######################################################################### */
--
-- S4.1  Colunas de CNPJ e nome de SUPR_010
-- SELECT COLUMN_ID, COLUMN_NAME, DATA_TYPE, DATA_LENGTH
-- FROM ALL_TAB_COLUMNS
-- WHERE OWNER='SYSTEXTIL' AND TABLE_NAME='SUPR_010' AND COLUMN_ID <= 20
-- ORDER BY COLUMN_ID;
--
-- S4.2  Como a OBRF_010 guarda a empresa da nota (colunas 6 a 25)
-- SELECT COLUMN_ID, COLUMN_NAME, DATA_TYPE, DATA_LENGTH
-- FROM ALL_TAB_COLUMNS
-- WHERE OWNER='SYSTEXTIL' AND TABLE_NAME='OBRF_010' AND COLUMN_ID BETWEEN 6 AND 25
-- ORDER BY COLUMN_ID;
--
-- ---------------------------------------------------------------------------
--  PENDENCIA ADIADA: razao social da empresa
--
--  DECISAO: o relatorio segue SEM a empresa. Nao vale forcar um join chutado.
--  Quando for retomada, rodar S4.3 e S4.4 abaixo e so entao escolher o caminho.
--
--  Indicio: a tela OBRF_F275 exibe a coluna "Empresa", e a interface I_OBRF_010
--  declara um campo EMPRESA. Porem a tabela fisica OBRF_010 nao tem nenhuma coluna
--  com esse nome nas 5 primeiras posicoes. Provavelmente o nome fisico seja outro.
-- ---------------------------------------------------------------------------
--
-- S4.3  Todas as colunas do OBRF_016 (17 linhas).
--       A interface I_OBRF_016 tem COD_EMPRESA; confirmar se a tabela fisica tambem tem.
-- SELECT COLUMN_ID, COLUMN_NAME, DATA_LENGTH
-- FROM ALL_TAB_COLUMNS
-- WHERE OWNER='SYSTEXTIL' AND TABLE_NAME='OBRF_016'
-- ORDER BY COLUMN_ID;
--
-- S4.4  Procurar "empresa" sob qualquer nome dentro da OBRF_010.
--       Se vier vazia, a empresa nao esta na OBRF_010 e o caminho passa a ser
--       a I_OBRF_016 (ou outra tabela) — documentar como decisao de arquitetura.
-- SELECT COLUMN_ID, COLUMN_NAME, DATA_LENGTH
-- FROM ALL_TAB_COLUMNS
-- WHERE OWNER='SYSTEXTIL' AND TABLE_NAME='OBRF_010'
--   AND (UPPER(COLUMN_NAME) LIKE '%EMPR%' OR UPPER(COLUMN_NAME) LIKE '%FILIAL%'
--        OR UPPER(COLUMN_NAME) LIKE '%ESTAB%' OR UPPER(COLUMN_NAME) LIKE '%CNPJ%'
--        OR UPPER(COLUMN_NAME) LIKE '%CGC%')
-- ORDER BY COLUMN_ID;
