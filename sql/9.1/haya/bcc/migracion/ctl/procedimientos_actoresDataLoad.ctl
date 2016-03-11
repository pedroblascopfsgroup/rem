OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE HAYA02.MIG_PROCEDIMIENTOS_ACTORES
TRUNCATE 
TRAILING NULLCOLS
(  
   ID_PROC_ACTORES             SEQUENCE
  ,CD_PROCEDIMIENTO            POSITION(1:17)      INTEGER EXTERNAL
  ,TIPO_ACTOR                  POSITION(18:19)     INTEGER EXTERNAL
  ,CD_ACTOR                    POSITION(20:39)     CHAR "replace (replace(replace(TRIM(:CD_ACTOR),';',' '), '\"',''),'''','')"
  ,FECHA_INICIO                POSITION(40:47)     DATE 'ddmmyyyy' 
  ,FECHA_FIN                   POSITION(48:55)     DATE 'DDMMYYYY' nullif (FECHA_FIN=BLANKS) "replace( replace(:FECHA_FIN, '01010001', ''), '00000000', '')"
)
