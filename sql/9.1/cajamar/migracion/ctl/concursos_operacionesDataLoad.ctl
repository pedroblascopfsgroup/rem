OPTIONS ( ROWS = 10000, DIRECT = TRUE)
LOAD DATA
INTO TABLE CM01.MIG_CONCURSOS_OPERACIONES --OJO QUITAR 2 PARA ENTREGA
TRUNCATE 
TRAILING NULLCOLS
(
   ID_CONCURSO_OPERAC              SEQUENCE
  ,CD_CONCURSO                     POSITION(1:17)     INTEGER EXTERNAL
  ,CODIGO_PROPIETARIO              POSITION(18:23)    INTEGER EXTERNAL
  ,TIPO_PRODUCTO                   POSITION(24:28)    CHAR "replace (replace(replace(TRIM(:TIPO_PRODUCTO),';',' '), '\"',''),'''','')"
  ,NUMERO_CONTRATO                 POSITION(29:46)    INTEGER EXTERNAL
  ,NUMERO_ESPEC                    POSITION(47:62)    INTEGER EXTERNAL
)
