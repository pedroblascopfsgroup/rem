OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE HAYA02.MIG_ANOTACIONES 
TRUNCATE 
TRAILING NULLCOLS
-- 17,22,28,45,53,4053
(
   ID_ANOTACION							SEQUENCE
  ,CD_ANOTACION                         POSITION(1:17)     CHAR "to_number(replace (replace(replace(TRIM(:CD_ANOTACION),';',' '), '\"',''),'''',''))"
  ,CODIGO_ENTIDAD                       POSITION(18:22)    CHAR "to_number(replace (replace(replace(TRIM(:CODIGO_ENTIDAD),';',' '), '\"',''),'''',''))"
  ,CODIGO_PROPIETARIO                   POSITION(23:28)    CHAR "to_number(replace (replace(replace(TRIM(:CODIGO_PROPIETARIO),';',' '), '\"',''),'''',''))"
  ,CODIGO_PERSONA                       POSITION(29:45)    CHAR "to_number(replace (replace(replace(TRIM(:CODIGO_PERSONA),';',' '), '\"',''),'''',''))"
  ,FECHA_ANOTACION                      POSITION(46:53)    DATE 'DDMMYYYY' nullif (FECHA_ANOTACION=BLANKS) "replace( replace(:FECHA_ANOTACION, '01010001', ''), '00000000', '')"
  ,TEXTO_ANOTACION                      POSITION(54:4053)  CHAR nullif(TEXTO_ANOTACION=BLANKS)  "replace (replace(replace(TRIM(:TEXTO_ANOTACION),';',' '), '\"',''),'''','')"
)

