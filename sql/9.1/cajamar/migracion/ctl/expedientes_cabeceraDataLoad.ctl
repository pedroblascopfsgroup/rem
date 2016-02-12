OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE CM01.MIG_EXPEDIENTES_CABECERA
TRUNCATE 
TRAILING NULLCOLS
(
     MIG_EXP_CAB_ID                    SEQUENCE
   , CD_EXPEDIENTE                     POSITION(1:17)      INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:CD_EXPEDIENTE),'+',''),16,'0'))"
   , ESTADO                            POSITION(18:37)     CHAR "replace (replace(replace(TRIM(:ESTADO),';',' '), '\"',''),'''','')"
   , CD_EDP                            POSITION(38:57)     CHAR "replace (replace(replace(TRIM(:CD_EDP),';',' '), '\"',''),'''','')"
   , FECHA_ASIGNACION                  POSITION(58:65)     DATE 'DDMMYYYY' nullif (FECHA_ASIGNACION=BLANKS) "replace( replace(:FECHA_ASIGNACION, '01010001', ''), '00000000', '')"
   , TIPO_PROCEDIMIENTO                POSITION(66:85)     CHAR  nullif (TIPO_PROCEDIMIENTO=BLANKS) "replace(replace(replace(TRIM(:TIPO_PROCEDIMIENTO),';',' '), '\"',''),'''','')" 
   , FECHA_ENVIO_LETRADO               POSITION(86:93)     DATE 'DDMMYYYY' nullif (FECHA_ENVIO_LETRADO=BLANKS) "replace( replace(:FECHA_ENVIO_LETRADO, '01010001', ''), '00000000', '')"  
   , FECHA_ACEPTACION_LETRADO          POSITION(94:101)    DATE 'DDMMYYYY' nullif (FECHA_ACEPTACION_LETRADO=BLANKS) "replace( replace(:FECHA_ACEPTACION_LETRADO, '01010001', ''), '00000000', '')" 
   , FECHA_PARALIZACION                POSITION(102:109)   DATE 'DDMMYYYY' nullif (FECHA_PARALIZACION=BLANKS) "replace( replace(:FECHA_PARALIZACION, '01010001', ''), '00000000', '')"  
   , MOTIVO_PARALIZACION               POSITION(110:609)   CHAR  nullif (MOTIVO_PARALIZACION=BLANKS) "replace(replace(replace(TRIM(:MOTIVO_PARALIZACION),';',' '), '\"',''),'''','')" 
   , OPERACION_PARALIZACION_VINCUL     POSITION(610:627)   INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:OPERACION_PARALIZACION_VINCUL),'+',''),17,'0'))"
   , FECHA_BAJA                        POSITION(628:635)   DATE 'DDMMYYYY' nullif (FECHA_BAJA=BLANKS) "replace( replace(:FECHA_BAJA, '01010001', ''), '00000000', '')"   
   , MOTIVO_BAJA                       POSITION(636:1135)  CHAR  nullif (MOTIVO_BAJA=BLANKS) "replace(replace(replace(TRIM(:MOTIVO_BAJA),';',' '), '\"',''),'''','')"
   , FECHA_REALIZ_ESTUDIO_SOLV         POSITION(1135:1142) DATE 'DDMMYYYY' nullif (FECHA_REALIZ_ESTUDIO_SOLV=BLANKS) "replace( replace(:FECHA_REALIZ_ESTUDIO_SOLV, '01010001', ''), '00000000', '')"
--   , FECHA_PREPARADO                   POSITION(1143:1150) DATE 'DDMMYYYY' nullif (FECHA_PREPARADO=BLANKS) "replace( replace(:FECHA_PREPARADO, '01010001', ''), '00000000', '')"        
)
