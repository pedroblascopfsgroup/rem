OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA  characterset UTF8 LENGTH SEMANTICS CHARACTER                
INTO TABLE CM01.MIG_PROCS_OBSERVACIONES_TROZOS --OJO COLOCAR LA LETRA S AL FINAL PARA LA ENTREGA
TRUNCATE 
TRAILING NULLCOLS
(
   ID_PROC_OBS_TROZOS								SEQUENCE
  ,REF_TIPO_OBSERVACION                             POSITION(1:10)     CHAR "replace (replace(replace(TRIM(:REF_TIPO_OBSERVACION),';',' '), '\"',''),'''','')"
  ,REF_ID_OBSERVACION                               POSITION(11:27)    CHAR "to_number(replace (replace(replace(TRIM(:REF_ID_OBSERVACION),';',' '), '\"',''),'''',''))"
  ,ORDEN                                            POSITION(28:44)    INTEGER EXTERNAL 
  ,TEXTO                                            POSITION(45:3044)  CHAR nullif(TEXTO=BLANKS)  "replace (replace(replace(TRIM(:TEXTO),';',' '), '\"',''),'''','')"
)
