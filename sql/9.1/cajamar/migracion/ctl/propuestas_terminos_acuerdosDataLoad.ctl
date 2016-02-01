OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE CM01.MIG_PROPUESTAS_TERMINO_ACUERDO
TRUNCATE 
TRAILING NULLCOLS
--17,34,51,71,79,96,112
(
     MIG_PROP_TERM_ACU_ID               SEQUENCE
   , ID_PROPUESTA                       POSITION(1:17)    INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:ID_PROPUESTA),'+',''),16,'0'))"
   , ID_TERMINO                         POSITION(18:34)   INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:ID_TERMINO),'+',''),16,'0'))"
   , TIPO_ACUERDO                       POSITION(35:51)   INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:TIPO_ACUERDO),'+',''),16,'0'))"
   , SUBTIPO_ACUERDO                    POSITION(52:71)   CHAR "replace (replace(replace(TRIM(:SUBTIPO_ACUERDO),';',' '), '\"',''),'''','')"
   , FECHA_PAGO                         POSITION(72:79)   DATE 'DDMMYYYY' nullif (FECHA_PAGO=BLANKS) "replace( replace(:FECHA_PAGO, '01010001', ''), '00000000', '')"  
   , PERIODICIDAD                       POSITION(80:96)   INTEGER EXTERNAL "TO_NUMBER( LPAD( REPLACE(TO_CHAR(:PERIODICIDAD),'+',''),16,'0'))"
   , IMPORTE                            POSITION(97:112)  DECIMAL EXTERNAL nullif (IMPORTE=BLANKS) "to_number(TRIM(SUBSTR(:IMPORTE,1,15)||','||SUBSTR(:IMPORTE,16,2)))"   
)
