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


-- Comparar as tabelas e realizar validações coluna a coluna
SELECT 
  COALESCE(local.ID, gcp.ID) AS ID,  -- Mostra o ID de qualquer tabela

  -- Comparação de cada coluna (local vs gcp)
  local.CODE_GENDER AS CODE_GENDER_local, 
  gcp.CODE_GENDER AS CODE_GENDER_gcp,
  CASE
    WHEN local.CODE_GENDER IS NULL OR gcp.CODE_GENDER IS NULL THEN 'valor nulo'
    WHEN local.CODE_GENDER != gcp.CODE_GENDER THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_CODE_GENDER,

  local.FLAG_OWN_CAR AS FLAG_OWN_CAR_local, 
  gcp.FLAG_OWN_CAR AS FLAG_OWN_CAR_gcp,
  CASE
    WHEN local.FLAG_OWN_CAR IS NULL OR gcp.FLAG_OWN_CAR IS NULL THEN 'valor nulo'
    WHEN local.FLAG_OWN_CAR != gcp.FLAG_OWN_CAR THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_FLAG_OWN_CAR,

  local.FLAG_OWN_REALTY AS FLAG_OWN_REALTY_local,
  gcp.FLAG_OWN_REALTY AS FLAG_OWN_REALTY_gcp,
  CASE
    WHEN local.FLAG_OWN_REALTY IS NULL OR gcp.FLAG_OWN_REALTY IS NULL THEN 'valor nulo'
    WHEN local.FLAG_OWN_REALTY != gcp.FLAG_OWN_REALTY THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_FLAG_OWN_REALTY,

  local.CNT_CHILDREN AS CNT_CHILDREN_local,
  gcp.CNT_CHILDREN AS CNT_CHILDREN_gcp,
  CASE
    WHEN local.CNT_CHILDREN IS NULL OR gcp.CNT_CHILDREN IS NULL THEN 'valor nulo'
    WHEN local.CNT_CHILDREN != gcp.CNT_CHILDREN THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_CNT_CHILDREN,

  local.AMT_INCOME_TOTAL AS AMT_INCOME_TOTAL_local,
  gcp.AMT_INCOME_TOTAL AS AMT_INCOME_TOTAL_gcp,
  CASE
    WHEN local.AMT_INCOME_TOTAL IS NULL OR gcp.AMT_INCOME_TOTAL IS NULL THEN 'valor nulo'
    WHEN local.AMT_INCOME_TOTAL != gcp.AMT_INCOME_TOTAL THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_AMT_INCOME_TOTAL,

  local.NAME_INCOME_TYPE AS NAME_INCOME_TYPE_local,
  gcp.NAME_INCOME_TYPE AS NAME_INCOME_TYPE_gcp,
  CASE
    WHEN local.NAME_INCOME_TYPE IS NULL OR gcp.NAME_INCOME_TYPE IS NULL THEN 'valor nulo'
    WHEN local.NAME_INCOME_TYPE != gcp.NAME_INCOME_TYPE THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_NAME_INCOME_TYPE,

  local.NAME_EDUCATION_TYPE AS NAME_EDUCATION_TYPE_local,
  gcp.NAME_EDUCATION_TYPE AS NAME_EDUCATION_TYPE_gcp,
  CASE
    WHEN local.NAME_EDUCATION_TYPE IS NULL OR gcp.NAME_EDUCATION_TYPE IS NULL THEN 'valor nulo'
    WHEN local.NAME_EDUCATION_TYPE != gcp.NAME_EDUCATION_TYPE THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_NAME_EDUCATION_TYPE,

  local.NAME_FAMILY_STATUS AS NAME_FAMILY_STATUS_local,
  gcp.NAME_FAMILY_STATUS AS NAME_FAMILY_STATUS_gcp,
  CASE
    WHEN local.NAME_FAMILY_STATUS IS NULL OR gcp.NAME_FAMILY_STATUS IS NULL THEN 'valor nulo'
    WHEN local.NAME_FAMILY_STATUS != gcp.NAME_FAMILY_STATUS THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_NAME_FAMILY_STATUS,

  local.NAME_HOUSING_TYPE AS NAME_HOUSING_TYPE_local,
  gcp.NAME_HOUSING_TYPE AS NAME_HOUSING_TYPE_gcp,
  CASE
    WHEN local.NAME_HOUSING_TYPE IS NULL OR gcp.NAME_HOUSING_TYPE IS NULL THEN 'valor nulo'
    WHEN local.NAME_HOUSING_TYPE != gcp.NAME_HOUSING_TYPE THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_NAME_HOUSING_TYPE,

  local.DAYS_BIRTH AS DAYS_BIRTH_local,
  gcp.DAYS_BIRTH AS DAYS_BIRTH_gcp,
  CASE
    WHEN local.DAYS_BIRTH IS NULL OR gcp.DAYS_BIRTH IS NULL THEN 'valor nulo'
    WHEN local.DAYS_BIRTH != gcp.DAYS_BIRTH THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_DAYS_BIRTH,

  local.DAYS_EMPLOYED AS DAYS_EMPLOYED_local,
  gcp.DAYS_EMPLOYED AS DAYS_EMPLOYED_gcp,
  CASE
    WHEN local.DAYS_EMPLOYED IS NULL OR gcp.DAYS_EMPLOYED IS NULL THEN 'valor nulo'
    WHEN local.DAYS_EMPLOYED != gcp.DAYS_EMPLOYED THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_DAYS_EMPLOYED,

  local.FLAG_MOBIL AS FLAG_MOBIL_local,
  gcp.FLAG_MOBIL AS FLAG_MOBIL_gcp,
  CASE
    WHEN local.FLAG_MOBIL IS NULL OR gcp.FLAG_MOBIL IS NULL THEN 'valor nulo'
    WHEN local.FLAG_MOBIL != gcp.FLAG_MOBIL THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_FLAG_MOBIL,

  local.FLAG_WORK_PHONE AS FLAG_WORK_PHONE_local,
  gcp.FLAG_WORK_PHONE AS FLAG_WORK_PHONE_gcp,
  CASE
    WHEN local.FLAG_WORK_PHONE IS NULL OR gcp.FLAG_WORK_PHONE IS NULL THEN 'valor nulo'
    WHEN local.FLAG_WORK_PHONE != gcp.FLAG_WORK_PHONE THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_FLAG_WORK_PHONE,

  local.FLAG_PHONE AS FLAG_PHONE_local,
  gcp.FLAG_PHONE AS FLAG_PHONE_gcp,
  CASE
    WHEN local.FLAG_PHONE IS NULL OR gcp.FLAG_PHONE IS NULL THEN 'valor nulo'
    WHEN local.FLAG_PHONE != gcp.FLAG_PHONE THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_FLAG_PHONE,

  local.FLAG_EMAIL AS FLAG_EMAIL_local,
  gcp.FLAG_EMAIL AS FLAG_EMAIL_gcp,
  CASE
    WHEN local.FLAG_EMAIL IS NULL OR gcp.FLAG_EMAIL IS NULL THEN 'valor nulo'
    WHEN local.FLAG_EMAIL != gcp.FLAG_EMAIL THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_FLAG_EMAIL,

  local.OCCUPATION_TYPE AS OCCUPATION_TYPE_local,
  gcp.OCCUPATION_TYPE AS OCCUPATION_TYPE_gcp,
  CASE
    WHEN local.OCCUPATION_TYPE IS NULL OR gcp.OCCUPATION_TYPE IS NULL THEN 'valor nulo'
    WHEN local.OCCUPATION_TYPE != gcp.OCCUPATION_TYPE THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_OCCUPATION_TYPE,

  local.CNT_FAM_MEMBERS AS CNT_FAM_MEMBERS_local,
  gcp.CNT_FAM_MEMBERS AS CNT_FAM_MEMBERS_gcp,
  CASE
    WHEN local.CNT_FAM_MEMBERS IS NULL OR gcp.CNT_FAM_MEMBERS IS NULL THEN 'valor nulo'
    WHEN local.CNT_FAM_MEMBERS != gcp.CNT_FAM_MEMBERS THEN 'não ok'
    ELSE 'ok'
  END AS Validacao_CNT_FAM_MEMBERS,

  -- Determinar a origem dos registros (se estão apenas em uma das tabelas ou em ambas)
  CASE 
    WHEN local.ID IS NULL THEN 'right_only'  -- Só está no GCP
    WHEN gcp.ID IS NULL THEN 'left_only'    -- Só está no Local
    ELSE 'both'                             -- Está em ambas
  END AS origem
FROM distinct_local AS local
FULL OUTER JOIN distinct_gcp AS gcp
ON local.ID = gcp.ID
