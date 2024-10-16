WITH titulos_ultimos_meses AS (

SELECT
  t.id_revendedor,
  t.dt_vencimento,
  t.dt_pagamento,
  t.vlr_pedido,
  t.forma_pagamento,
  CASE 
    --WHEN t.dt_pagamento IS NULL THEN DATE_DIFF(CURRENT_DATE(), t.dt_vencimento, DAY)
    WHEN t.dt_pagamento IS NULL THEN DATE_DIFF('2023-01-16', t.dt_vencimento, DAY)
    ELSE DATE_DIFF(t.dt_pagamento, t.dt_vencimento, DAY)
  END AS dias_atraso
FROM
  `phrasal-agility-438319-r9.Dados.tb_titulos` t)

  SELECT
  r.id_revendedor,
  r.nm_revendedor,
  
  -- Calcula a quantidade máxima de dias de atraso nos últimos 30 dias
  --MAX(IF(t.dt_vencimento >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY), t.dias_atraso, NULL)) AS MAX_DIAS_ATRASO_1M,
  MAX(IF(t.dt_vencimento >= DATE_SUB('2023-01-16', INTERVAL 30 DAY), t.dias_atraso, NULL)) AS MAX_DIAS_ATRASO_1M,
  -- Calcula a quantidade máxima de dias de atraso nos últimos 90 dias
  MAX(t.dias_atraso) AS MAX_DIAS_ATRASO_3M,
  
  -- Valor total dos pedidos nos últimos 90 dias
  FORMAT('%.2f', SUM(t.vlr_pedido)) AS TOTAL_FATURADO_3M,
  
  -- Quantidade de títulos pagos por boleto a prazo nos últimos 90 dias
  COUNTIF(t.forma_pagamento = 'Boleto a Prazo') AS QTD_TITULOS_BOLETO_3M

FROM `phrasal-agility-438319-r9.Dados.tb_revendedor` r
LEFT JOIN titulos_ultimos_meses t
ON r.id_revendedor = t.id_revendedor

GROUP BY r.id_revendedor, r.nm_revendedor;

