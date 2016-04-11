OPTIONS ( ROWS = 10000, DIRECT = TRUE, ERRORS=99999)
LOAD DATA  characterset UTF8 LENGTH SEMANTICS CHARACTER      
INTO TABLE HAYA02.MIG_EXPEDIENTES_OBSER_TROZOS
TRUNCATE 
TRAILING NULLCOLS
(      
        ID_EXP_OBS_TROZOS             SEQUENCE
      , REF_TIPO_OBSERVACION          POSITION(1:10)     CHAR nullif (REF_TIPO_OBSERVACION=BLANKS) "replace (replace(replace(TRIM(:REF_TIPO_OBSERVACION),';',' '), '\"',''),'''','')" 
      , REF_ID_OBSERVACION            POSITION(11:27)    INTEGER EXTERNAL
      , ORDEN                         POSITION(28:44)    INTEGER EXTERNAL
      , TEXTO                         POSITION(45:3044)  CHAR nullif (TEXTO=BLANKS) "replace (replace(replace(TRIM(:TEXTO),';',' '), '\"',''),'''','')"       
)

