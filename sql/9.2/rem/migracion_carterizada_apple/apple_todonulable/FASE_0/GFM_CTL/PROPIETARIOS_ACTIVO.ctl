
OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/PROPIETARIOS_ACTIVO.dat'
BADFILE './CTLs_DATs/bad/PROPIETARIOS_ACTIVO.bad'
DISCARDFILE './CTLs_DATs/rejects/PROPIETARIOS_ACTIVO.bad'
INTO TABLE REM01.MIG_APA_PROP_ACTIVO
TRUNCATE
TRAILING NULLCOLS
(
ACT_NUMERO_ACTIVO POSITION(1:17) INTEGER EXTERNAL NULLIF(ACT_NUMERO_ACTIVO=BLANKS) "CASE WHEN (:ACT_NUMERO_ACTIVO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:ACT_NUMERO_ACTIVO,1,17)||','||SUBSTR(:ACT_NUMERO_ACTIVO,18,0)),';',' '), '\"',''),'''','')) END",
PRO_CODIGO POSITION(18:34) INTEGER EXTERNAL NULLIF(PRO_CODIGO=BLANKS) "CASE WHEN (:PRO_CODIGO) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:PRO_CODIGO,1,17)||','||SUBSTR(:PRO_CODIGO,18,0)),';',' '), '\"',''),'''','')) END",
GRADO_PROPIEDAD POSITION(35:54) CHAR NULLIF(GRADO_PROPIEDAD=BLANKS) "REPLACE(REPLACE(REPLACE(TRIM(:GRADO_PROPIEDAD),';',' '), '\"',''),'''','')",
PORCENTAJE POSITION(55:60) INTEGER EXTERNAL NULLIF(PORCENTAJE=BLANKS) "CASE WHEN (:PORCENTAJE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:PORCENTAJE,1,4)||','||SUBSTR(:PORCENTAJE,5,2)),';',' '), '\"',''),'''','')) END",
VALIDACION CONSTANT "0"
)




