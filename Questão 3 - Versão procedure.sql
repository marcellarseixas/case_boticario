CREATE OR REPLACE PROCEDURE `phrasal-agility-438319-r9.Dados.p_calcular_atrasos_e_faturamento`(p_data_final DATE)
BEGIN
    -- CTE para calcular atrasos
    WITH CTE_atrasos AS (
        SELECT
            r.id_revendedor,
            -- Cálculo da quantidade máxima de dias de atraso nos últimos 1 e 3 meses, considerando p_data_final quando dt_pagamento está vazio
            MAX(CASE 
                    WHEN t.dt_vencimento >= DATE_SUB(COALESCE(t.dt_pagamento, p_data_final), INTERVAL 30 DAY)
                    THEN DATE_DIFF(COALESCE(t.dt_pagamento, p_data_final), t.dt_vencimento, DAY)
                    ELSE NULL
                END) AS MAX_DIAS_ATRASO_1M,
            MAX(CASE 
                    WHEN t.dt_vencimento >= DATE_SUB(COALESCE(t.dt_pagamento, p_data_final), INTERVAL 90 DAY)
                    THEN DATE_DIFF(COALESCE(t.dt_pagamento, p_data_final), t.dt_vencimento, DAY)
                    ELSE NULL
                END) AS MAX_DIAS_ATRASO_3M
        FROM
            `phrasal-agility-438319-r9.Dados.tb_revendedor` r
        JOIN
            `phrasal-agility-438319-r9.Dados.tb_titulos` t
        ON
            r.id_revendedor = t.id_revendedor
        WHERE
            COALESCE(t.dt_pagamento, p_data_final) > t.dt_vencimento -- Considerar apenas os títulos pagos com atraso
        GROUP BY
            r.id_revendedor
    ),

    -- CTE para calcular faturamento dos títulos
    CTE_faturamento_titulos AS (
        SELECT
            r.id_revendedor,
            -- Cálculo do total faturado nos últimos 3 meses, considerando p_data_final quando dt_pagamento está vazio
            SUM(CASE 
                    WHEN t.dt_vencimento >= DATE_SUB(COALESCE(t.dt_pagamento, p_data_final), INTERVAL 90 DAY)
                    THEN t.vlr_pedido 
                    ELSE 0 
                END) AS TOTAL_FATURADO_3M,
            -- Contagem dos títulos pagos por boleto nos últimos 3 meses
            COUNT(CASE 
                    WHEN t.dt_vencimento >= DATE_SUB(COALESCE(t.dt_pagamento, p_data_final), INTERVAL 90 DAY)
                         AND t.forma_pagamento = 'Boleto a Prazo' 
                    THEN 1 
                    ELSE NULL 
                END) AS QTD_TITULOS_BOLETO_3M
        FROM
            `phrasal-agility-438319-r9.Dados.tb_revendedor` r
        JOIN
            `phrasal-agility-438319-r9.Dados.tb_titulos` t
        ON
            r.id_revendedor = t.id_revendedor
        GROUP BY
            r.id_revendedor
    )

    -- Query final para combinar os resultados das duas CTEs
    SELECT
        a.id_revendedor,
        a.MAX_DIAS_ATRASO_1M,
        a.MAX_DIAS_ATRASO_3M,
        FORMAT('%.2f', f.TOTAL_FATURADO_3M) AS TOTAL_FATURADO_3M,
        f.QTD_TITULOS_BOLETO_3M
    FROM
        CTE_atrasos a
    JOIN
        CTE_faturamento_titulos f
    ON
        a.id_revendedor = f.id_revendedor
    ORDER BY 
        a.id_revendedor;
END;
