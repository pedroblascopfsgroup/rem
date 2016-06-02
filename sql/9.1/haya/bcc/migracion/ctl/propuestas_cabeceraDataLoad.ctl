OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE HAYA02.MIG_PROPUESTAS_CABECERA
TRUNCATE 
TRAILING NULLCOLS
--17,37,54,2054,2062,2070,2078,2086,2102
(
     MIG_PROP_CAB_ID                    SEQUENCE
   , ID_PROPUESTA                       POSITION(1:17)       INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:ID_PROPUESTA),'+',''),16,'0'))"
   , PROPONENTE                         POSITION(18:37)      CHAR "replace (replace(replace(TRIM(NVL(:PROPONENTE,'SIN-DEFINIR')),';',' '), '\"',''),'''','')"
   , ESTADO_ACUERDO                     POSITION(38:54)      INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:ESTADO_ACUERDO),'+',''),16,'0'))"
   , MOTIVO                             POSITION(55:2054)    CHAR "replace (replace(replace(TRIM(:MOTIVO),';',' '), '\"',''),'''','')"
   , FECHA_PROPUESTA                    POSITION(2055:2062)  DATE 'DDMMYYYY' nullif (FECHA_PROPUESTA=BLANKS) "replace( replace(:FECHA_PROPUESTA, '01010001', ''), '00000000', '')"  
   , FECHA_ESTADO                       POSITION(2063:2070)  DATE 'DDMMYYYY' nullif (FECHA_ESTADO=BLANKS) "replace( replace(:FECHA_ESTADO, '01010001', ''), '00000000', '')"  
   , FECHA_VIGENCIA                     POSITION(2071:2078)  DATE 'DDMMYYYY' nullif (FECHA_VIGENCIA=BLANKS) "replace( replace(:FECHA_VIGENCIA, '01010001', ''), '00000000', '')" 
   , FECHA_LIMITE                       POSITION(2079:2086)  DATE 'DDMMYYYY' nullif (FECHA_LIMITE=BLANKS) "replace( replace(:FECHA_LIMITE, '01010001', ''), '00000000', '')"  
   , IMPORTE_COSTAS                     POSITION(2087:2102)  DECIMAL EXTERNAL nullif (IMPORTE_COSTAS=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE_COSTAS,1,15)||','||SUBSTR(:IMPORTE_COSTAS,16,2)))"   
)
