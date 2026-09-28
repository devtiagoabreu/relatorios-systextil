no software systêxtil eu preciso criar um relatório que ao digitar uma nota fiscal o sistema me traga o cte e todas as notas restantes vinculadas a esse cte ... o sistema tem uma tela (print) obrf_f275, que faz o inverso eu digito o cte e ele me mostra as notas vinculadas..... aqui está a base de conhecimento systextil https://devsystextil.atlassian.net/wiki/spaces/BCST/overview nela deve ter algo sobre CTE... eu tenho tb os SQLs que a tela obrf_f275 do print utiliza'

'''sql
SELECT CGC_CLI_FOR_O, PERC_ICMS, CGC_CLI_FOR_R, CODIGO_TRANSACAO, FLAG_IMPORTACAO, VALOR_IBS_MUNICIPIO, SERIE, DATA_EMISSAO, ESPECIE_DOCTO, HISTORICO_CONT, VALOR_CBS, VALOR_IS, CONDICAO_PAGTO, TOTAL_DOCTO, CGC_CLI_FOR_2, NUM_CONTABIL, VALOR_IBS_UF, NUMERO_DANF_NFE, BASE_CALC_CBS_IBS_IS, COD_CIDADE_CTE_DEST, LOCAL_ENTREGA, TIPO_CONHECIMENTO, SEQUENCIA_PEDIDO, PEDIDO_COMPRA, BASE_ICMS, NATOPER_NAT_OPER, BASE_DIFERENCA, DATA_TRANSACAO, DOCUMENTO, COD_CIDADE_CTE, NATOPER_EST_OPER, OBSERVACAO1, ID_REGISTRO, VALOR_ICMS
FROM I_OBRF_010;

SELECT PERC_DIF_ALIQ, ALIQ_IBS_MUNIC_POS_REDUC, PERC_COFINS, NUM_NF_SAIDA, VALOR_PIS, COD_VLFISCAL_ICM, UNIDADE_MEDIDA, ALIQ_IBS_UF_POS_REDUC, BASE_CALC_CBS_IBS_IS, VALOR_IBS_MUNICIPIO, PROCEDENCIA, CODITEM_ITEM, RATEIO_DESPESAS, CST, DIF_ALIQUOTA, DESCRICAO_ITEM, CODIGO_DEPOSITO, PERC_PIS, CODIGO_TRANSACAO, VALOR_CBS, BASE_DIFERENCA, CLASSIFIC_FISCAL, CODIGO_CONTABIL, ALIQ_CBS_POS_REDUC, CVF_ICM_DIFERENC, VALOR_IBS_UF, SEQUENCIA, CENTRO_CUSTO, QUANTIDADE, VALOR_IS, SERVICO, CODITEM_NIVEL99, BASE_PIS_COFINS, CODITEM_GRUPO, ALIQ_IS, PERC_REDUC_CBS, BASE_CALC_ICM, PERC_REDUC_IBS, VALOR_COFINS, NATITEM_EST_OPER, CVF_PIS, VALOR_ICMS, VALOR_UNITARIO, CVF_COFINS, NATITEM_NAT_OPER, PERCENTUAL_ICM, PROJETO, CLASSIFICACAO_TRIB, CODITEM_SUBGRUPO, LOTE_ENTREGA, SUBPROJETO, SERIE_NF_SAIDA, VALOR_TOTAL
FROM I_OBRF_015;

SELECT DESCR_LOCAL, DESCR_MENSAGEM, LOG_TECNICO
FROM OPER_276;

SELECT SERIE_NOTA, NUMERO_NOTA, COD_EMPRESA, FORNECEDOR2, FORNECEDOR_O, FORNECEDOR_R
FROM I_OBRF_016;

SELECT VALOR_PARCELA, CODIGO_EMPRESA, DATA_VENCIMENTO, ORIGEM_DEBITO, PARCELA, NR_DUPLICATA, TIPO_TITULO, COD_PORTADOR
FROM I_CPAG_010;
'''

tela no systêxtil: obrf_f275


no software systêxtil eu preciso criar um relatório que ao digitar uma nota fiscal o sistema me traga o cte e todas as notas restantes vinculadas a esse cte ... o sistema tem uma tela (print)  obrf_f275, que faz o inverso eu digito o cte e ele me mostra as notas vinculadas..... aqui está a base de conhecimento systextil https://devsystextil.atlassian.net/wiki/spaces/BCST/overview nela deve ter algo sobre CTE... eu tenho tb os SQLs que a tela  obrf_f275 do print utiliza'''sql

SELECT CGC_CLI_FOR_O, PERC_ICMS, CGC_CLI_FOR_R, CODIGO_TRANSACAO, FLAG_IMPORTACAO, VALOR_IBS_MUNICIPIO, SERIE, DATA_EMISSAO, ESPECIE_DOCTO, HISTORICO_CONT, VALOR_CBS, VALOR_IS, CONDICAO_PAGTO, TOTAL_DOCTO, CGC_CLI_FOR_2, NUM_CONTABIL, VALOR_IBS_UF, NUMERO_DANF_NFE, BASE_CALC_CBS_IBS_IS, COD_CIDADE_CTE_DEST, LOCAL_ENTREGA, TIPO_CONHECIMENTO, SEQUENCIA_PEDIDO, PEDIDO_COMPRA, BASE_ICMS, NATOPER_NAT_OPER, BASE_DIFERENCA, DATA_TRANSACAO, DOCUMENTO, COD_CIDADE_CTE, NATOPER_EST_OPER, OBSERVACAO1, ID_REGISTRO, VALOR_ICMS

FROM I_OBRF_010;

SELECT PERC_DIF_ALIQ, ALIQ_IBS_MUNIC_POS_REDUC, PERC_COFINS, NUM_NF_SAIDA, VALOR_PIS, COD_VLFISCAL_ICM, UNIDADE_MEDIDA, ALIQ_IBS_UF_POS_REDUC, BASE_CALC_CBS_IBS_IS, VALOR_IBS_MUNICIPIO, PROCEDENCIA, CODITEM_ITEM, RATEIO_DESPESAS, CST, DIF_ALIQUOTA, DESCRICAO_ITEM, CODIGO_DEPOSITO, PERC_PIS, CODIGO_TRANSACAO, VALOR_CBS, BASE_DIFERENCA, CLASSIFIC_FISCAL, CODIGO_CONTABIL, ALIQ_CBS_POS_REDUC, CVF_ICM_DIFERENC, VALOR_IBS_UF, SEQUENCIA, CENTRO_CUSTO, QUANTIDADE, VALOR_IS, SERVICO, CODITEM_NIVEL99, BASE_PIS_COFINS, CODITEM_GRUPO, ALIQ_IS, PERC_REDUC_CBS, BASE_CALC_ICM, PERC_REDUC_IBS, VALOR_COFINS, NATITEM_EST_OPER, CVF_PIS, VALOR_ICMS, VALOR_UNITARIO, CVF_COFINS, NATITEM_NAT_OPER, PERCENTUAL_ICM, PROJETO, CLASSIFICACAO_TRIB, CODITEM_SUBGRUPO, LOTE_ENTREGA, SUBPROJETO, SERIE_NF_SAIDA, VALOR_TOTAL

FROM I_OBRF_015;

SELECT DESCR_LOCAL, DESCR_MENSAGEM, LOG_TECNICO

FROM OPER_276;

SELECT SERIE_NOTA, NUMERO_NOTA, COD_EMPRESA, FORNECEDOR2, FORNECEDOR_O, FORNECEDOR_R

FROM I_OBRF_016;

SELECT VALOR_PARCELA, CODIGO_EMPRESA, DATA_VENCIMENTO, ORIGEM_DEBITO, PARCELA, NR_DUPLICATA, TIPO_TITULO, COD_PORTADOR

FROM I_CPAG_010;

'''

tela no systêxtil: obrf_f275

Sim — dá para chegar nesse relatório, e os SQLs da OBRF_F275 que você trouxe são uma pista muito boa. Fiz uma varredura na Base de Conhecimento Systêxtil e também na documentação técnica pública do próprio Systêxtil.

O ponto mais importante é que não devemos simplesmente reproduzir os SELECTs da OBRF_F275, porque algumas dessas tabelas I_OBRF_* são estruturas de integração/apoio usadas pela tela. A própria documentação técnica do Systêxtil identifica I_OBRF_010 como a representação de integração da OBRF_010, enquanto OBRF_010 é a tabela da Nota Fiscal de Entrada.

O que já conseguimos identificar

Na sua tela OBRF_F275, a parte Relacionamento mostra:

Empresa | Documento | Série | Transportadora

e a parte Títulos mostra os documentos/títulos associados.

Na I_OBRF_010, temos campos particularmente importantes:

EMPRESA
DOCUMENTO
SERIE
TIPO_CONHECIMENTO
NUMERO_DANF_NFE
COD_CIDADE_CTE
COD_CIDADE_CTE_DEST
CGC_CLI_FOR_O
CGC_CLI_FOR_R
...

Isso é muito interessante porque:

DOCUMENTO → número do documento fiscal
SERIE → série
TIPO_CONHECIMENTO → informação relacionada ao conhecimento
NUMERO_DANF_NFE → referência ao documento fiscal
COD_CIDADE_CTE / COD_CIDADE_CTE_DEST → origem/destino do CT-e

Além disso, a documentação pública do Systêxtil confirma que o sistema possui tratamento específico para CT-e, inclusive uma classe denominada GrupoRateioFrete, descrita como acumulador de rateio de frete de CT-e por transação.

E a documentação do XML do sistema confirma que o Systêxtil trabalha com CT-e modelo 57 e com documentos fiscais associados ao CT-e.

O relatório que você quer

Eu entendi a lógica assim:

Hoje — OBRF_F275

Você informa:

CT-e: 123456

e o Systêxtil apresenta:

CT-e 123456
   │
   ├── NF 10001 / série 1
   ├── NF 10002 / série 1
   ├── NF 10003 / série 1
   └── NF 10004 / série 1
O que você quer

Fazer exatamente o inverso:

NF: 10003

e o relatório retornar:

CT-e: 123456
Transportadora: XXXXX
Data: XX/XX/XXXX
Valor: R$ XXXXX

Notas vinculadas ao CT-e:

NF       Série       Empresa
10001    1           001
10002    1           001
10003    1           001  <-- NF pesquisada
10004    1           001

Ou seja:

NF → CT-e → todas as NF vinculadas ao mesmo CT-e

Isso é perfeitamente viável.

Mas existe uma questão importante

Eu não quero te passar um JOIN chutado entre OBRF_010 e OBRF_016, porque os SQLs que você trouxe mostram que a OBRF_F275 está utilizando as tabelas I_OBRF_*.

Por exemplo:

SELECT
    SERIE_NOTA,
    NUMERO_NOTA,
    COD_EMPRESA,
    FORNECEDOR2,
    FORNECEDOR_O,
    FORNECEDOR_R
FROM I_OBRF_016;

Isso parece muito promissor para o relacionamento das notas, mas precisamos descobrir qual é a chave que conecta I_OBRF_016 ao CT-e.

E aqui podemos fazer algo melhor: usar o próprio Oracle para descobrir a estrutura real das tabelas.

Primeiro SQL que eu quero que você rode

No Oracle/Systêxtil, rode:

SELECT
    OWNER,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    DATA_LENGTH,
    DATA_PRECISION,
    DATA_SCALE,
    COLUMN_ID
FROM ALL_TAB_COLUMNS
WHERE TABLE_NAME IN (
    'OBRF_010',
    'OBRF_015',
    'OBRF_016',
    'I_OBRF_010',
    'I_OBRF_015',
    'I_OBRF_016'
)
ORDER BY
    TABLE_NAME,
    COLUMN_ID;

Esse SQL vai nos mostrar todos os campos dessas seis estruturas.

É especialmente importante descobrirmos os campos de:

OBRF_010
OBRF_016
I_OBRF_010
I_OBRF_016
Segundo SQL — descobrir as chaves

Depois rode:

SELECT
    a.CONSTRAINT_NAME,
    a.TABLE_NAME,
    a.COLUMN_NAME,
    a.POSITION
FROM ALL_CONS_COLUMNS a
WHERE a.TABLE_NAME IN (
    'OBRF_010',
    'OBRF_016',
    'I_OBRF_010',
    'I_OBRF_016'
)
ORDER BY
    a.TABLE_NAME,
    a.CONSTRAINT_NAME,
    a.POSITION;

Isso pode revelar diretamente a chave utilizada pelo Systêxtil.

Terceiro SQL — descobrir FKs

Esse é ainda mais importante:

SELECT
    a.TABLE_NAME,
    a.CONSTRAINT_NAME,
    a.COLUMN_NAME,
    c_pk.TABLE_NAME AS REFERENCED_TABLE,
    c_pk.COLUMN_NAME AS REFERENCED_COLUMN
FROM ALL_CONS_COLUMNS a
JOIN ALL_CONSTRAINTS c
    ON c.OWNER = a.OWNER
   AND c.CONSTRAINT_NAME = a.CONSTRAINT_NAME
JOIN ALL_CONSTRAINTS c_pk
    ON c_pk.OWNER = c.R_OWNER
   AND c_pk.CONSTRAINT_NAME = c.R_CONSTRAINT_NAME
JOIN ALL_CONS_COLUMNS c_pk_col
    ON c_pk_col.OWNER = c_pk.OWNER
   AND c_pk_col.CONSTRAINT_NAME = c_pk.CONSTRAINT_NAME
   AND c_pk_col.POSITION = a.POSITION
WHERE a.TABLE_NAME IN (
    'OBRF_010',
    'OBRF_016',
    'I_OBRF_010',
    'I_OBRF_016'
)
ORDER BY
    a.TABLE_NAME,
    a.CONSTRAINT_NAME,
    a.POSITION;
E tem uma quarta investigação que eu acho ainda melhor

Podemos descobrir exatamente quais tabelas a OBRF_F275 usa para fazer o relacionamento, sem precisar adivinhar.

O Systêxtil possui uma documentação técnica pública onde a arquitetura mostra que as classes DAO encapsulam os SQLs das tabelas e que objetos podem carregar objetos relacionados.

Portanto, se conseguirmos localizar o código/documentação correspondente à rotina da OBRF_F275, conseguimos reproduzir a lógica.

A própria Base de Conhecimento ensina como identificar o código de uma tela do Systêxtil através do ícone de informações do programa.

Uma coisa que já podemos descartar

Eu não usaria I_OBRF_016 diretamente no relatório final sem antes entender seu ciclo de preenchimento.

Isso porque:

I_OBRF_010
I_OBRF_015
I_OBRF_016

são estruturas de integração da obrigação fiscal.

A documentação pública do Systêxtil identifica explicitamente:

NotaFiscalDeEntrada
    → OBRF_010

NotaFiscalDeEntradaIntegracao
    → I_OBRF_010

NotaFiscalDeEntradaItem
    → OBRF_015

NotaFiscalDeEntradaIntegracaoItem
    → I_OBRF_015

Isso significa que precisamos descobrir se:

I_OBRF_016

é:

uma tabela persistente de relacionamento;
uma tabela temporária;
uma tabela de integração;
ou uma estrutura populada especificamente durante a execução da OBRF_F275.

Essa diferença é fundamental.

Outra pista muito boa: NUMERO_DANF_NFE

Esse campo da sua I_OBRF_010 chama bastante atenção:

NUMERO_DANF_NFE

Pode existir uma relação do tipo:

OBRF_010
   │
   │ DOCUMENTO
   │ SERIE
   │ EMPRESA
   │
   └── NUMERO_DANF_NFE

Mas eu não vou assumir que esse campo seja a chave do relacionamento CT-e ↔ NF sem verificar dados reais.

Precisamos descobrir isso no banco.

Podemos fazer uma investigação extremamente precisa

Se você tiver acesso ao Oracle, eu sugiro fazer o seguinte.

Escolha uma NF que você sabe que está vinculada a um CT-e.

Por exemplo:

NF = 123456
Série = 1
Empresa = 1

E me passe:

NF:
Série:
Empresa:
CT-e conhecido:

Não precisa me passar CNPJ ou informações sensíveis.

Aí podemos procurar essa NF em todo o conjunto OBRF.

Por exemplo, primeiro:

SELECT *
FROM OBRF_010
WHERE DOCUMENTO = 123456;

e:

SELECT *
FROM I_OBRF_010
WHERE DOCUMENTO = 123456;

Depois:

SELECT *
FROM I_OBRF_016
WHERE NUMERO_NOTA = 123456;

Se aparecer alguma coisa, já teremos uma pista enorme.

E podemos procurar a NF em todas as colunas candidatas

Inclusive podemos fazer uma investigação automática no Oracle para descobrir em quais tabelas/colunas existe o número da NF.

Algo como:

SELECT
    OWNER,
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM ALL_TAB_COLUMNS
WHERE UPPER(COLUMN_NAME) LIKE '%NOTA%'
   OR UPPER(COLUMN_NAME) LIKE '%DOCUMENTO%'
   OR UPPER(COLUMN_NAME) LIKE '%CTE%'
   OR UPPER(COLUMN_NAME) LIKE '%CONHECIMENTO%'
ORDER BY
    OWNER,
    TABLE_NAME,
    COLUMN_ID;

Isso pode revelar outras estruturas que nem aparecem nos SQLs da tela.

Minha proposta

Vamos fazer isso em duas etapas, para não criar um relatório baseado em uma associação errada:

Etapa 1 — descobrir o relacionamento real

Vamos mapear:

NF
 │
 ├── EMPRESA
 ├── DOCUMENTO
 ├── SÉRIE
 │
 ▼
estrutura de relacionamento
 │
 ▼
CT-e
 │
 ├── número
 ├── série
 ├── transportadora
 ├── data
 └── valor

e depois:

CT-e
 │
 ├── NF 1
 ├── NF 2
 ├── NF 3
 ├── NF 4
 └── NF N
Etapa 2 — construir o SQL definitivo

Aí podemos fazer algo nesse formato:

-- PARÂMETROS
-- :EMPRESA
-- :NUMERO_NF
-- :SERIE_NF

SELECT
    ...
FROM ...
WHERE ...

E o resultado já pode alimentar o relatório do Systêxtil, com algo como:

CT-e	Série	NF	Série NF	Empresa	Transportadora	Data
45879	1	125001	1	001	Transportadora X	25/09/2026
45879	1	125002	1	001	Transportadora X	25/09/2026
45879	1	125003	1	001	Transportadora X	25/09/2026
45879	1	125004	1	001	Transportadora X	25/09/2026

Assim, você digita uma NF e o relatório apresenta o CT-e e o conjunto completo de notas daquele CT-e.

Pode me mandar o resultado do primeiro SQL (ALL_TAB_COLUMNS). Com ele eu consigo montar o próximo passo já olhando os nomes reais das colunas, em vez de ficar especulando a estrutura do Systêxtil.

ManageEngine

IT Service Management Solution

Leverage out-of-the-box automation capabilities, low-code customizations, and more.

Ad
More options

Ótimo. Agora apareceu uma informação muito importante na I_OBRF_010:

NUM_CONHECIMENTO
VAL_CONHECIMENTO
TIPO_FRETE
TRANSPA_FORNE9
TRANSPA_FORNE4
TRANSPA_FORNE2
TIPO_CONHECIMENTO

Isso reforça bastante a hipótese de que a própria nota possui referência ao conhecimento/CT-e.

Principalmente:

NUM_CONHECIMENTO

Esse campo pode ser justamente o número do CT-e relacionado à NF. Mas ainda não vamos assumir isso — precisamos confirmar pelos dados reais.

Também temos:

TRANSPA_FORNE9
TRANSPA_FORNE4
TRANSPA_FORNE2

que provavelmente formam o código do transportador no padrão do Systêxtil.

Próximo passo

Ainda falta terminar a I_OBRF_010.

Rode:

SELECT
    COLUMN_ID,
    COLUMN_NAME,
    DATA_TYPE,
    DATA_LENGTH,
    DATA_PRECISION,
    DATA_SCALE
FROM ALL_TAB_COLUMNS
WHERE OWNER = 'SYSTEXTIL'
  AND TABLE_NAME = 'I_OBRF_010'
  AND COLUMN_ID > 50
ORDER BY COLUMN_ID;

Me mande somente o resultado.

Depois disso fechamos definitivamente a estrutura da I_OBRF_010 e aí vamos para a I_OBRF_016. Quero chegar ao relacionamento real:

NF
 ↓
NUM_CONHECIMENTO
 ↓
CT-e
 ↓
demais NF do mesmo CT-e

sem inventar JOIN.

{
  "items" :
  [
    {
      "COLUMN_ID" : 51,
      "COLUMN_NAME" : "SIT_DIVERGENCIA",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 1,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 52,
      "COLUMN_NAME" : "RESPONSAVEL9",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 9,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 53,
      "COLUMN_NAME" : "RESPONSAVEL4",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 4,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 54,
      "COLUMN_NAME" : "RESPONSAVEL2",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 2,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 55,
      "COLUMN_NAME" : "NATUREZA_STR",
      "DATA_TYPE" : "VARCHAR2",
      "DATA_LENGTH" : 10
    },
    {
      "COLUMN_ID" : 56,
      "COLUMN_NAME" : "TIPO_DOC_IMPORTACAO_SPED",
      "DATA_TYPE" : "VARCHAR2",
      "DATA_LENGTH" : 1
    },
    {
      "COLUMN_ID" : 57,
      "COLUMN_NAME" : "VALOR_PIS_IMPORT_SPED",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 15,
      "DATA_SCALE" : 2
    },
    {
      "COLUMN_ID" : 58,
      "COLUMN_NAME" : "VALOR_COFINS_IMPORT_SPED",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 15,
      "DATA_SCALE" : 2
    },
    {
      "COLUMN_ID" : 59,
      "COLUMN_NAME" : "NR_PROTOCOLO",
      "DATA_TYPE" : "VARCHAR2",
      "DATA_LENGTH" : 20
    },
    {
      "COLUMN_ID" : 60,
      "COLUMN_NAME" : "QTDE_ITENS",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 4,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 61,
      "COLUMN_NAME" : "SELO_INICIAL",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 12,
      "DATA_SCALE" : 1
    },
    {
      "COLUMN_ID" : 62,
      "COLUMN_NAME" : "SELO_FINAL",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 12,
      "DATA_SCALE" : 1
    },
    {
      "COLUMN_ID" : 63,
      "COLUMN_NAME" : "NUMERO_DI",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 12,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 64,
      "COLUMN_NAME" : "TIPO_VALOR_NF",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 2,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 65,
      "COLUMN_NAME" : "TIPO_VALORES_FISCAL",
      "DATA_TYPE" : "VARCHAR2",
      "DATA_LENGTH" : 1
    },
    {
      "COLUMN_ID" : 66,
      "COLUMN_NAME" : "NUM_PROCESSO_IMP",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 9,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 67,
      "COLUMN_NAME" : "COD_CANC_NFISC",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 2,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 68,
      "COLUMN_NAME" : "TIPO_NF_REFERENCIADA",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 1,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 69,
      "COLUMN_NAME" : "NOTA_REFERENCIADA",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 9,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 70,
      "COLUMN_NAME" : "SERIE_REFERENCIADA",
      "DATA_TYPE" : "VARCHAR2",
      "DATA_LENGTH" : 3
    },
    {
      "COLUMN_ID" : 71,
      "COLUMN_NAME" : "CNPJ9_REF",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 9,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 72,
      "COLUMN_NAME" : "CNPJ4_REF",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 4,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 73,
      "COLUMN_NAME" : "CNPJ2_REF",
      "DATA_TYPE" : "NUMBER",
      "DATA_LENGTH" : 22,
      "DATA_PRECISION" : 2,
      "DATA_SCALE" : 0
    },
    {
      "COLUMN_ID" : 74,
      "COLUMN_NAME" : "CHAVE_CONTINGENCIA",
      "DATA_TYPE" : "VARCHAR2",
      "DATA_LENGTH" : 36
    },
    {
      "COLUMN_ID" : 75,
      "COLUMN_NAME" : "DATA_AUTORIZACAO_NFE",
      "DATA_TYPE" : "DATE",
      "DATA_LENGTH" : 7
    }
  ]
}

Perfeito. Agora fechamos a estrutura da I_OBRF_010: são 75 colunas.

E apareceu outra pista importante:

NUM_CONHECIMENTO
TIPO_CONHECIMENTO
NOTA_REFERENCIADA
SERIE_REFERENCIADA
CNPJ9_REF
CNPJ4_REF
CNPJ2_REF

Mas, para o nosso objetivo, NUM_CONHECIMENTO é o campo que quero investigar primeiro.

Não vamos ainda para I_OBRF_016. Vamos verificar dados reais da I_OBRF_010 e descobrir se NUM_CONHECIMENTO realmente contém o número do CT-e.

Próximo SQL

Rode:

SELECT
    ID_REGISTRO,
    DOCUMENTO,
    SERIE,
    ESPECIE_DOCTO,
    NUM_CONHECIMENTO,
    TIPO_CONHECIMENTO,
    VAL_CONHECIMENTO,
    TIPO_FRETE,
    TRANSPA_FORNE9,
    TRANSPA_FORNE4,
    TRANSPA_FORNE2,
    NUMERO_DANF_NFE,
    NOTA_REFERENCIADA,
    SERIE_REFERENCIADA
FROM I_OBRF_010
WHERE NUM_CONHECIMENTO IS NOT NULL
ORDER BY ID_REGISTRO DESC
FETCH FIRST 30 ROWS ONLY;
O que quero descobrir com esse resultado

Queremos ver algo parecido com:

DOCUMENTO | SERIE | NUM_CONHECIMENTO | TIPO_CONHECIMENTO
---------------------------------------------------------
123456    | 1     | 98765            | ...
123457    | 1     | 98765            | ...
123458    | 1     | 98765            | ...

Se encontrarmos várias DOCUMENTOs com o mesmo NUM_CONHECIMENTO, é exatamente a relação que estamos procurando:

             CT-e 98765
                 │
       ┌─────────┼─────────┐
       ↓         ↓         ↓
     NF 123456 NF 123457 NF 123458

Mande o resultado desse SQL. Só esse agora. Depois decidimos o próximo passo com base nos dados reais.

ManageEngine

ITIL Configuration Management

Organize all your CIs centrally and improve your business outcomes. Try ServiceDesk Plus!

Ad
More options
Pasted text(4).txt
Document

Ótimo. Esse resultado foi muito útil, porque eliminou uma hipótese.

Nos registros reais que você consultou, inclusive registros cujo ESPECIE_DOCTO = 'CTE', temos:

DOCUMENTO          = número do CT-e
ESPECIE_DOCTO      = CTE
TIPO_CONHECIMENTO  = 3
NUM_CONHECIMENTO   = 0

Por exemplo, o registro 54851 é CT-e 195483, mas NUM_CONHECIMENTO = 0.

Então não vamos usar NUM_CONHECIMENTO como chave do nosso relacionamento. Isso é importante.

Ao mesmo tempo, o campo:

NUMERO_DANF_NFE

está preenchido tanto nos registros de NF-e quanto nos CT-e. No CT-e 195483, por exemplo, aparece uma chave de 44 dígitos começando por 352609..., e ela é claramente uma chave fiscal eletrônica.

Isso abre uma possibilidade muito interessante: a relação pode estar sendo construída através de outra tabela/estrutura, e não diretamente pelo NUM_CONHECIMENTO.

Próxima etapa: I_OBRF_016

Agora quero olhar a estrutura dessa tabela, porque o SQL da própria OBRF_F275 que você trouxe já mostrou:

SELECT
    SERIE_NOTA,
    NUMERO_NOTA,
    COD_EMPRESA,
    FORNECEDOR2,
    FORNECEDOR_O,
    FORNECEDOR_R
FROM I_OBRF_016;

Ela pode ser justamente a peça que falta.

Rode somente este SQL:

SELECT
    COLUMN_ID,
    COLUMN_NAME,
    DATA_TYPE,
    DATA_LENGTH,
    DATA_PRECISION,
    DATA_SCALE
FROM ALL_TAB_COLUMNS
WHERE OWNER = 'SYSTEXTIL'
  AND TABLE_NAME = 'I_OBRF_016'
ORDER BY COLUMN_ID;

Me mande o resultado.

Depois vamos analisar os campos da I_OBRF_016 e, principalmente, procurar nela alguma referência a:

CT-e
documento
nota
série
empresa
registro
conhecimento
chave fiscal

Ainda não vamos montar o SQL final. Primeiro vamos descobrir exatamente como a OBRF_F275 está fazendo essa ligação.

{

  "items" :

  [

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26695,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 25,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "31279686"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26704,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 43,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "45051387"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26708,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 6,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "27434088"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26705,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 6,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "37480680"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26730,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 58,

      "FORNECEDOR_O" : "0002",

      "FORNECEDOR_R" : "10694685"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26672,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 6,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "05578947"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26719,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 26,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "41001645"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26740,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 5,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "85275386"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26756,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 86,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "37086423"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26755,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 98,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "38258767"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26855,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 79,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "10158307"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26844,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 82,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "08020705"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 16410,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 50,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "06752238"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 26921,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 79,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "10158307"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 27036,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 9,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "22520650"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 27066,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 98,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "38258767"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 27160,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 73,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "76313618"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 27162,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 26,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "72484785"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 27176,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 87,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "18227450"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 27174,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 26,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "72484785"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 27177,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 26,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "72484785"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 27175,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 20,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "05537822"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 27184,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 8,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "27841613"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 27186,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 16,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "12635285"

    },

    {

      "SERIE_NOTA" : "1",

      "NUMERO_NOTA" : 27194,

      "COD_EMPRESA" : 1,

      "FORNECEDOR2" : 26,

      "FORNECEDOR_O" : "0001",

      "FORNECEDOR_R" : "41001645"

    }

  ]

}


