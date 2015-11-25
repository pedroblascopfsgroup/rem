OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE HAYA02.MIG_PROCEDIMIENTOS_EMBARGOS
TRUNCATE 
TRAILING NULLCOLS
(
    CD_PROCEDIMIENTO              POSITION(1:17   )  INTEGER EXTERNAL
  , CD_BIEN                       POSITION(18:37  )  CHAR "replace (replace(replace(TRIM(:CD_BIEN),';',' '), '\"',''),'''','')"
  , NUMERO_ACTIVO                 POSITION(38:47  )  INTEGER EXTERNAL  nullif (NUMERO_ACTIVO=BLANKS)
  , FECHA_SOLICITUD_EMBARGO       POSITION(48:55  )  DATE 'DDMMYYYY' nullif (FECHA_SOLICITUD_EMBARGO=BLANKS) "replace( replace(:FECHA_SOLICITUD_EMBARGO, '01010001', ''), '00000000', '')"
  , FECHA_DECRETO_EMBARGO         POSITION(56:63  )  DATE 'DDMMYYYY' nullif (FECHA_DECRETO_EMBARGO=BLANKS) "replace( replace(:FECHA_DECRETO_EMBARGO, '01010001', ''), '00000000', '')"
  , FECHA_SOLICITUD_DE_PRORROGA   POSITION(64:71  )  DATE 'DDMMYYYY' nullif (FECHA_SOLICITUD_DE_PRORROGA=BLANKS) "replace( replace(:FECHA_SOLICITUD_DE_PRORROGA, '01010001', ''), '00000000', '')"
  , FECHA_REGISTRO_EMBARGO        POSITION(72:79  )  DATE 'DDMMYYYY' nullif (FECHA_REGISTRO_EMBARGO=BLANKS) "replace( replace(:FECHA_REGISTRO_EMBARGO, '01010001', ''), '00000000', '')"
  , FECHA_ADJUDICACION_EMBARGO    POSITION(80:87  )  DATE 'DDMMYYYY' nullif (FECHA_ADJUDICACION_EMBARGO=BLANKS) "replace( replace(:FECHA_ADJUDICACION_EMBARGO, '01010001', ''), '00000000', '')"
  , IMPORTE_AVALUO                POSITION(88:103 )  DECIMAL EXTERNAL nullif (IMPORTE_AVALUO=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE_AVALUO,1,15)||','||SUBSTR(:IMPORTE_AVALUO,16,2)))"
  , FECHA_AVALUO                  POSITION(104:111)  DATE 'DDMMYYYY' nullif (FECHA_AVALUO=BLANKS) "replace( replace(:FECHA_AVALUO, '01010001', ''), '00000000', '')"
  , IMPORTE_TASACION              POSITION(112:127)  DECIMAL EXTERNAL nullif (IMPORTE_TASACION=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE_TASACION,1,15)||','||SUBSTR(:IMPORTE_TASACION,16,2)))"
  , FECHA_TASACION                POSITION(128:135)  DATE 'DDMMYYYY' nullif (FECHA_TASACION=BLANKS) "replace( replace(:FECHA_TASACION, '01010001', ''), '00000000', '')"
  , IMPORTE_VALOR                 POSITION(136:151)  DECIMAL EXTERNAL nullif (IMPORTE_VALOR=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE_VALOR,1,15)||','||SUBSTR(:IMPORTE_VALOR,16,2)))"
  , APREMIADO                     POSITION(152:153)  INTEGER EXTERNAL nullif (APREMIADO=BLANKS)
  , LETRA                         POSITION(154:155)  CHAR nullif(LETRA=BLANKS) "replace (replace(replace(TRIM(:LETRA),';',' '), '\"',''),'''','')"
)  
  
  
