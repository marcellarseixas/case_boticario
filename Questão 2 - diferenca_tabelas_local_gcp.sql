-- VALIDAÇÃO 1: Comparar metadados das tabelas 'application_record_local' e 'application_record_gcp' no schema 'phrasal-agility-438319-r9.Dados'

WITH tab_comparacao_local AS (
    SELECT
        table_schema,
        table_name,
        column_name,
        data_type,
        CASE
            WHEN data_type LIKE '%STRING%' THEN "''"
            WHEN data_type LIKE '%TIMESTAMP%' THEN "''"
            ELSE '0'
        END AS coalesce_value,
        ordinal_position
    FROM `phrasal-agility-438319-r9.Dados.INFORMATION_SCHEMA.COLUMNS`
    WHERE table_name = 'application_record_local'
),
tab_comparacao_gcp AS (
    SELECT
        table_schema,
        table_name,
        column_name,
        data_type,
        CASE
            WHEN data_type LIKE '%STRING%' THEN "''"
            WHEN data_type LIKE '%TIMESTAMP%' THEN "''"
            ELSE '0'
        END AS coalesce_value,
        ordinal_position
    FROM `phrasal-agility-438319-r9.Dados.INFORMATION_SCHEMA.COLUMNS`
    WHERE table_name = 'application_record_gcp'
)

-- Comparar colunas das duas tabelas
SELECT
    'TABELA LOCAL -->' AS TAB1,
    T1.*,
    'TABELA GCP -->' AS TAB2,
    T2.*,
    CASE
        WHEN T1.column_name = T2.column_name AND T1.data_type = T2.data_type
        THEN CONCAT(
            'CASE WHEN COALESCE(T1.', T1.column_name, ',', T1.coalesce_value, ') = COALESCE(T2.', T2.column_name, ',', T2.coalesce_value, ') THEN "OK" ELSE "N OK" END AS fl_comparacao_coluna_', T1.column_name
        )
        WHEN T1.column_name = T2.column_name AND T1.data_type != T2.data_type
        THEN 'TIPOS DE DADOS DAS COLUNAS SÃO DIFERENTES!'
        ELSE CASE
            WHEN T1.column_name IS NULL THEN 'COLUNA NÃO EXISTE NA TABELA LOCAL'
            WHEN T2.column_name IS NULL THEN 'COLUNA NÃO EXISTE NA TABELA GCP'
        END
    END AS script_de_comparacao
FROM tab_comparacao_local T1
FULL OUTER JOIN tab_comparacao_gcp T2
ON T1.column_name = T2.column_name
ORDER BY COALESCE(T1.ordinal_position, T2.ordinal_position);




-- VALIDAÇÃO 2: Contagem de linhas distintas de cada tabela no BigQuery
SELECT
    'application_record_local' AS table_name, COUNT(DISTINCT FORMAT('%t', T1)) AS distinct_row_count
FROM `phrasal-agility-438319-r9.Dados.application_record_local` T1
UNION ALL
SELECT
    'application_record_gcp' AS table_name, COUNT(DISTINCT FORMAT('%t', T2)) AS distinct_row_count
FROM `phrasal-agility-438319-r9.Dados.application_record_gcp` T2;

-- VALIDAÇÃO 3: Verificar a quantidade de valores diferentes em cada coluna

-- Remover duplicadas para verificar diferença entre as linhas das colunas
WITH distinct_local AS (
  -- Remover duplicatas da tabela 'application_record_local'
  SELECT DISTINCT *
  FROM `phrasal-agility-438319-r9.Dados.application_record_local`
),
distinct_gcp AS (
  -- Remover duplicatas da tabela 'application_record_gcp'
  SELECT DISTINCT *
  FROM `phrasal-agility-438319-r9.Dados.application_record_gcp`
)

-- Contagem de "N OK" considerando valores NULL e tipos adequados
SELECT 
    SUM(CASE WHEN COALESCE(T1.ID, -1) != COALESCE(T2.ID, -1) THEN 1 ELSE 0 END) AS count_N_OK_ID,
    SUM(CASE WHEN COALESCE(T1.CODE_GENDER, '') != COALESCE(T2.CODE_GENDER, '') THEN 1 ELSE 0 END) AS count_N_OK_CODE_GENDER,
    SUM(CASE WHEN COALESCE(T1.FLAG_OWN_CAR, FALSE) != COALESCE(T2.FLAG_OWN_CAR, FALSE) THEN 1 ELSE 0 END) AS count_N_OK_FLAG_OWN_CAR,
    SUM(CASE WHEN COALESCE(T1.FLAG_OWN_REALTY, FALSE) != COALESCE(T2.FLAG_OWN_REALTY, FALSE) THEN 1 ELSE 0 END) AS count_N_OK_FLAG_OWN_REALTY,
    SUM(CASE WHEN COALESCE(T1.CNT_CHILDREN, -1) != COALESCE(T2.CNT_CHILDREN, -1) THEN 1 ELSE 0 END) AS count_N_OK_CNT_CHILDREN,
    SUM(CASE WHEN COALESCE(T1.AMT_INCOME_TOTAL, -1.0) != COALESCE(T2.AMT_INCOME_TOTAL, -1.0) THEN 1 ELSE 0 END) AS count_N_OK_AMT_INCOME_TOTAL,
    SUM(CASE WHEN COALESCE(T1.NAME_INCOME_TYPE, '') != COALESCE(T2.NAME_INCOME_TYPE, '') THEN 1 ELSE 0 END) AS count_N_OK_NAME_INCOME_TYPE,
    SUM(CASE WHEN COALESCE(T1.NAME_EDUCATION_TYPE, '') != COALESCE(T2.NAME_EDUCATION_TYPE, '') THEN 1 ELSE 0 END) AS count_N_OK_NAME_EDUCATION_TYPE,
    SUM(CASE WHEN COALESCE(T1.NAME_FAMILY_STATUS, '') != COALESCE(T2.NAME_FAMILY_STATUS, '') THEN 1 ELSE 0 END) AS count_N_OK_NAME_FAMILY_STATUS,
    SUM(CASE WHEN COALESCE(T1.NAME_HOUSING_TYPE, '') != COALESCE(T2.NAME_HOUSING_TYPE, '') THEN 1 ELSE 0 END) AS count_N_OK_NAME_HOUSING_TYPE,
    SUM(CASE WHEN COALESCE(T1.DAYS_BIRTH, -1) != COALESCE(T2.DAYS_BIRTH, -1) THEN 1 ELSE 0 END) AS count_N_OK_DAYS_BIRTH,
    SUM(CASE WHEN COALESCE(T1.DAYS_EMPLOYED, -1) != COALESCE(T2.DAYS_EMPLOYED, -1) THEN 1 ELSE 0 END) AS count_N_OK_DAYS_EMPLOYED,
    SUM(CASE WHEN COALESCE(T1.FLAG_MOBIL, 0) != COALESCE(T2.FLAG_MOBIL, 0) THEN 1 ELSE 0 END) AS count_N_OK_FLAG_MOBIL,
    SUM(CASE WHEN COALESCE(T1.FLAG_WORK_PHONE, -1.0) != COALESCE(T2.FLAG_WORK_PHONE, -1.0) THEN 1 ELSE 0 END) AS count_N_OK_FLAG_WORK_PHONE,
    SUM(CASE WHEN COALESCE(T1.FLAG_PHONE, -1) != COALESCE(T2.FLAG_PHONE, -1) THEN 1 ELSE 0 END) AS count_N_OK_FLAG_PHONE,
    SUM(CASE WHEN COALESCE(T1.FLAG_EMAIL, -1) != COALESCE(T2.FLAG_EMAIL, -1) THEN 1 ELSE 0 END) AS count_N_OK_FLAG_EMAIL,
    SUM(CASE WHEN COALESCE(T1.OCCUPATION_TYPE, '') != COALESCE(T2.OCCUPATION_TYPE, '') THEN 1 ELSE 0 END) AS count_N_OK_OCCUPATION_TYPE,
    SUM(CASE WHEN COALESCE(T1.CNT_FAM_MEMBERS, -1.0) != COALESCE(T2.CNT_FAM_MEMBERS, -1.0) THEN 1 ELSE 0 END) AS count_N_OK_CNT_FAM_MEMBERS
FROM distinct_local T1
FULL JOIN distinct_gcp T2
ON T1.ID = T2.ID;

-- VALIDAÇÃO 4: Gerar base com os valores diferentes em cada coluna

WITH comparacao AS (
  SELECT
    T2.ID,
    T2.CODE_GENDER AS T2_CODE_GENDER,
    T1.CODE_GENDER AS T1_CODE_GENDER,
    T2.FLAG_OWN_CAR AS T2_FLAG_OWN_CAR,
    T1.FLAG_OWN_CAR AS T1_FLAG_OWN_CAR,
    T2.FLAG_OWN_REALTY AS T2_FLAG_OWN_REALTY,
    T1.FLAG_OWN_REALTY AS T1_FLAG_OWN_REALTY,
    T2.CNT_CHILDREN AS T2_CNT_CHILDREN,
    T1.CNT_CHILDREN AS T1_CNT_CHILDREN,
    T2.AMT_INCOME_TOTAL AS T2_AMT_INCOME_TOTAL,
    T1.AMT_INCOME_TOTAL AS T1_AMT_INCOME_TOTAL,
    T2.NAME_INCOME_TYPE AS T2_NAME_INCOME_TYPE,
    T1.NAME_INCOME_TYPE AS T1_NAME_INCOME_TYPE,
    T2.NAME_EDUCATION_TYPE AS T2_NAME_EDUCATION_TYPE,
    T1.NAME_EDUCATION_TYPE AS T1_NAME_EDUCATION_TYPE,
    T2.NAME_FAMILY_STATUS AS T2_NAME_FAMILY_STATUS,
    T1.NAME_FAMILY_STATUS AS T1_NAME_FAMILY_STATUS,
    T2.NAME_HOUSING_TYPE AS T2_NAME_HOUSING_TYPE,
    T1.NAME_HOUSING_TYPE AS T1_NAME_HOUSING_TYPE,
    T2.DAYS_BIRTH AS T2_DAYS_BIRTH,
    T1.DAYS_BIRTH AS T1_DAYS_BIRTH,
    T2.DAYS_EMPLOYED AS T2_DAYS_EMPLOYED,
    T1.DAYS_EMPLOYED AS T1_DAYS_EMPLOYED,
    T2.FLAG_MOBIL AS T2_FLAG_MOBIL,
    T1.FLAG_MOBIL AS T1_FLAG_MOBIL,
    T2.FLAG_WORK_PHONE AS T2_FLAG_WORK_PHONE,
    T1.FLAG_WORK_PHONE AS T1_FLAG_WORK_PHONE,
    T2.FLAG_PHONE AS T2_FLAG_PHONE,
    T1.FLAG_PHONE AS T1_FLAG_PHONE,
    T2.FLAG_EMAIL AS T2_FLAG_EMAIL,
    T1.FLAG_EMAIL AS T1_FLAG_EMAIL,
    T2.OCCUPATION_TYPE AS T2_OCCUPATION_TYPE,
    T1.OCCUPATION_TYPE AS T1_OCCUPATION_TYPE,
    T2.CNT_FAM_MEMBERS AS T2_CNT_FAM_MEMBERS,
    T1.CNT_FAM_MEMBERS AS T1_CNT_FAM_MEMBERS
  FROM 
    `phrasal-agility-438319-r9.Dados.application_record_local` AS T1
  FULL JOIN 
    `phrasal-agility-438319-r9.Dados.application_record_gcp` AS T2
  ON 
    T2.ID = T1.ID
)

-- Seleciona as linhas com valores diferentes entre T2 e T1
SELECT *
FROM comparacao
WHERE 
    T2_CODE_GENDER != T1_CODE_GENDER OR
    T2_FLAG_OWN_CAR != T1_FLAG_OWN_CAR OR
    T2_FLAG_OWN_REALTY != T1_FLAG_OWN_REALTY OR
    T2_CNT_CHILDREN != T1_CNT_CHILDREN OR
    T2_AMT_INCOME_TOTAL != T1_AMT_INCOME_TOTAL OR
    T2_NAME_INCOME_TYPE != T1_NAME_INCOME_TYPE OR
    T2_NAME_EDUCATION_TYPE != T1_NAME_EDUCATION_TYPE OR
    T2_NAME_FAMILY_STATUS != T1_NAME_FAMILY_STATUS OR
    T2_NAME_HOUSING_TYPE != T1_NAME_HOUSING_TYPE OR
    T2_DAYS_BIRTH != T1_DAYS_BIRTH OR
    T2_DAYS_EMPLOYED != T1_DAYS_EMPLOYED OR
    T2_FLAG_MOBIL != T1_FLAG_MOBIL OR
    T2_FLAG_WORK_PHONE != T1_FLAG_WORK_PHONE OR
    T2_FLAG_PHONE != T1_FLAG_PHONE OR
    T2_FLAG_EMAIL != T1_FLAG_EMAIL OR
    T2_OCCUPATION_TYPE != T1_OCCUPATION_TYPE OR
    T2_CNT_FAM_MEMBERS != T1_CNT_FAM_MEMBERS;
