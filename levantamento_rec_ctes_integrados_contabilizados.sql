select date(t_data_o) as data_integracao, 
       hour(t_data_o) as hora_integracao, 
       count(*)       as qtd_integracao        
  from baan.ttdcba032021 sta,
       baan.ttdrec940021 rec
where sta.t_acao_o = 3
   and sta.t_fire_o = rec.t_fire_l
   and rec.t_fire_l between 'C00000000' AND 'C99999999'
   AND rec.T_FDTC_L = 'CTE'
--  and date(sta.t_data_o) = '27.03.2026' -- PARAMETRO
   and sta.t_data_o >= current timestamp - 2 hours
   AND rec.t_date_l BETWEEN TIMESTAMP('2025-12-01-03.00.00.000000')   
                        AND TIMESTAMP('2026-04-01-03.00.00.000000')   
   AND rec.T_FOVN_L IN ('04221023/0010-78','04221023/0001-87','04221023/0026-35',
                        '04221023/0014-00','04221023/0027-16','04221023/0005-00',
                        '04221023/0009-34','04221023/0016-63','04221023/0024-73',
                        '04221023/0035-26','04221023/0025-54','04221023/0038-79')      
group by date(t_data_o),
          hour(t_data_o)
  with ur;
