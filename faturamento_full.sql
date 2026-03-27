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
          ELSE NULL
      END AS status_fatura,    
      CASE 
          WHEN fat.t_stat_o = 1 THEN '1-Geracao Fatura'
          WHEN fat.t_stat_o = 2 THEN '1-Geracao Fatura'
          WHEN fat.t_stat_o = 3 THEN '1-Geracao Fatura'
          WHEN fat.t_stat_o = 4 THEN '1-Geracao Fatura'
          WHEN fat.t_stat_o = 5 THEN '2-Aprovacao Fatura'
          WHEN fat.t_stat_o = 6 THEN '2-Aprovacao Fatura'
          WHEN fat.t_stat_o = 7 THEN '3-A Contabilizar'
          WHEN fat.t_stat_o = 8 THEN '3-A Contabilizar'
          WHEN fat.t_stat_o = 9 THEN '4-Contabilizado'
          ELSE NULL
      END AS status_relatorio,          
      COUNT(DISTINCT fat.T_ORNO_O) AS QTD_FATURA,      
      case 
          when xml.t_stat_l = 1 then '1-Aberto' 
          when xml.t_stat_l = 4 then '4-Aprovado / Concluido'
          when xml.t_stat_l = 5 then '5-Aprovado com Erro'
          when xml.t_stat_l = 6 then '6-Cancelado'
          else char(xml.t_stat_l)
      end as status_cte,
      case 
          when xml.t_pstd_l = 1 then 'Sim'
          else 'Nao'
      end as cte_contabilizacao,
      COUNT(*)            AS QTD_CTE,
      sum(xml.t_tfda_l)   as VALOR_Total_CTE,
      month(fat.t_datc_o) as mes_geracao_fatura,
      year (fat.t_datc_o) as ano_geracao_fatura,
      month(xml.t_date_l) as mes_inclusao_cte,
      year (xml.t_date_l) as ano_inclusao_cte,      
      CURRENT TIMESTAMP   as hora_geracao
FROM baan.tfmcba020021 fat
JOIN baan.tfmcba021021 lin 
   ON fat.T_ORNO_O = lin.T_ORNO_O
JOIN baan.ttdrec940021 xml 
   ON lin.T_FIRE_O = xml.t_fire_l
WHERE fat.t_datc_o BETWEEN TIMESTAMP('2025-12-01-03.00.00.000000')  AND TIMESTAMP('2026-04-01-03.00.00.000000')  -- data geracao fatura
  AND xml.t_date_l BETWEEN TIMESTAMP('2025-12-01-03.00.00.000000')  AND TIMESTAMP('2026-04-01-03.00.00.000000')  -- data inclusao do rec fiscal / xml
  AND fat.t_fovn_o IN ('04221023/0010-78','04221023/0001-87','04221023/0026-35',
                       '04221023/0014-00','04221023/0027-16','04221023/0005-00',
                       '04221023/0009-34','04221023/0016-63','04221023/0024-73',
                       '04221023/0035-26','04221023/0025-54','04221023/0038-79')
GROUP BY fat.t_stat_o, 
         xml.t_stat_l, 
         xml.t_pstd_l,
         month(fat.t_datc_o),
         year (fat.t_datc_o),
         month(xml.t_date_l),
         year (xml.t_date_l)
WITH UR;
