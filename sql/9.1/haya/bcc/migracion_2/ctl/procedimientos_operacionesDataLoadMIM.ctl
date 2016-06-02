OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE HAYA02.MIG_PROCEDIMS_OPERACIONES_MIM
TRUNCATE 
TRAILING NULLCOLS
(
   ID_PROC_OPERACIONES                      SEQUENCE
  ,CD_PROCEDIMIENTO                        POSITION(1:17)     INTEGER EXTERNAL
  ,CODIGO_ENTIDAD                          POSITION(18:22)    INTEGER EXTERNAL
  ,CODIGO_PROPIETARIO                      POSITION(23:28)    INTEGER EXTERNAL
  ,TIPO_PRODUCTO                           POSITION(29:33)    CHAR "replace (replace(replace(TRIM(:TIPO_PRODUCTO),';',' '), '\"',''),'''','')"
  ,NUMERO_CONTRATO                         POSITION(34:51)    INTEGER EXTERNAL
  ,NUMERO_ESPEC                            POSITION(52:67)    INTEGER EXTERNAL
  ,TIPO_RELACION                           POSITION(68:87)    CHAR "replace (replace(replace(TRIM(:TIPO_RELACION),';',' '), '\"',''),'''','')"
)
