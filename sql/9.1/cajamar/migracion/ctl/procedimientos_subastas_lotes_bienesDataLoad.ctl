OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE CM01.MIG_PROCS_SUBASTAS_LOTES_BIEN
TRUNCATE 
TRAILING NULLCOLS
(
   MIG_ID_PROCS_SUBASTA_LOTE_BIEN							SEQUENCE
  ,CD_LOTE                                              POSITION(1:30)     CHAR "replace (replace(replace(TRIM(:CD_LOTE),';',' '), '\"',''),'''','')"
  ,CD_BIEN                                              POSITION(31:50)    CHAR "replace (replace(replace(TRIM(:CD_LOTE),';',' '), '\"',''),'''','')"
  ,VALOR_JUDICIAL_SUBASTA                               POSITION(51:66)     DECIMAL EXTERNAL "to_number(TRIM(SUBSTR(:VALOR_JUDICIAL_SUBASTA,1,14)||','||SUBSTR(:VALOR_JUDICIAL_SUBASTA,15,2)))"  
)
