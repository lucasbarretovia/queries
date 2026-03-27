SELECT 
      CASE 
          WHEN fat.t_stat_o = 1 THEN '1-Criado / Logistica'
          WHEN fat.t_stat_o = 2 THEN '2-Liberado / Logistica'
          WHEN fat.t_stat_o = 3 THEN '3-Aprovado - Transportadora / Logistica'
          WHEN fat.t_stat_o = 4 THEN '4-Fatura Gerada / Logistica'
          WHEN fat.t_stat_o = 5 THEN '5-Aprovado - Frete / CSC Fiscal'
          WHEN fat.t_stat_o = 6 THEN '6-Cancelado - Frete / CSC Fiscal'
          WHEN fat.t_stat_o = 7 THEN '7-Aprovado Fiscal / TI Contabilizar'
          WHEN fat.t_stat_o = 8 THEN '8-Cancelado - Fiscal / TI Contabilizar'
          WHEN fat.t_stat_o = 9 THEN '9-Rec Fiscal Gerado / Concluido'
          ELSE 'Desconhecido'
      END AS status_fatura,    
      CASE 
          WHEN fat.t_stat_o IN (1,2,3,4) THEN '1-Geracao Fatura'
          WHEN fat.t_stat_o IN (5,6)     THEN '2-Aprovacao Fatura'
          WHEN fat.t_stat_o IN (7,8)     THEN '3-A Contabilizar'
          WHEN fat.t_stat_o = 9          THEN '4-Contabilizado'
          ELSE 'Outros'
      END AS status_relatorio,          
      COUNT(DISTINCT fat.T_ORNO_O) AS QTD_FATURA,      
      CASE 
          WHEN xml.t_stat_l = 1 THEN '1-Aberto' 
          WHEN xml.t_stat_l = 4 THEN '4-Aprovado / Concluido'
          WHEN xml.t_stat_l = 5 THEN '5-Aprovado com Erro'
          WHEN xml.t_stat_l = 6 THEN '6-Cancelado'
          ELSE CHAR(xml.t_stat_l)
      END AS status_cte,
      CASE 
          WHEN xml.t_pstd_l = 1 THEN 'Sim'
          ELSE 'Nao'
      END AS cte_contabilizacao,
      COUNT(*) AS QTD_CTE,
      SUM(xml.t_tfda_l) AS VALOR_TOTAL,
      MONTH(fat.t_datc_o) AS MES_FAT,
      YEAR(fat.t_datc_o) AS ANO_FAT,
      MONTH(xml.t_date_l) AS MES_XML,
      YEAR(xml.t_date_l) AS ANO_XML
FROM baan.tfmcba020021 fat
INNER JOIN baan.tfmcba021021 lin ON fat.T_ORNO_O = lin.T_ORNO_O
INNER JOIN baan.ttdrec940021 xml ON lin.T_FIRE_O = xml.t_fire_l
WHERE fat.t_datc_o BETWEEN '2025-12-01-03.00.00' AND '2026-04-01-03.00.00'
  AND xml.t_date_l BETWEEN '2025-12-01-03.00.00' AND '2026-04-01-03.00.00'
  AND fat.t_fovn_o IN ('04221023/0010-78','04221023/0001-87','04221023/0026-35','04221023/0014-00','04221023/0027-16','04221023/0005-00','04221023/0009-34','04221023/0016-63','04221023/0024-73','04221023/0035-26','04221023/0025-54','04221023/0038-79')
GROUP BY 
    fat.t_stat_o, xml.t_stat_l, xml.t_pstd_l,
    MONTH(fat.t_datc_o), YEAR(fat.t_datc_o),
    MONTH(xml.t_date_l), YEAR(xml.t_date_l)
WITH UR;
