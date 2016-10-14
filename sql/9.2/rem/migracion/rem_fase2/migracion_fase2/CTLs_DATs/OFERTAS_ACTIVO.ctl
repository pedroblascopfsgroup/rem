OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/OFERTAS_ACTIVO.dat'
BADFILE './CTLs_DATs/bad/OFERTAS_ACTIVO.bad'
DISCARDFILE './CTLs_DATs/rejects/OFERTAS_ACTIVO.bad'
INTO TABLE REM01.MIG2_OFA_OFERTAS_ACTIVO
TRUNCATE
TRAILING NULLCOLS
(
	OFA_COD_OFERTA						POSITION(1:17)		INTEGER EXTERNAL												"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFA_COD_OFERTA),';',' '), '\"',''),'''',''),2,16))",
	OFA_ACT_NUMERO_ACTIVO				POSITION(18:34)		INTEGER EXTERNAL												"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OFA_ACT_NUMERO_ACTIVO),';',' '), '\"',''),'''',''),2,16))",
	OFA_PORCENTAJE_PARTICIPACION		POSITION(35:40)		INTEGER EXTERNAL NULLIF(OFA_PORCENTAJE_PARTICIPACION=BLANKS)	"CASE WHEN (:OFA_PORCENTAJE_PARTICIPACION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:OFA_PORCENTAJE_PARTICIPACION,1,4)||','||SUBSTR(:OFA_PORCENTAJE_PARTICIPACION,5,2)),';',' '), '\"',''),'''','')) END",
	OFA_IMPORTE_PARTICIPACION			POSITION(41:57)		INTEGER EXTERNAL NULLIF(OFA_IMPORTE_PARTICIPACION=BLANKS)		"CASE WHEN (:OFA_IMPORTE_PARTICIPACION) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:OFA_IMPORTE_PARTICIPACION,1,15)||','||SUBSTR(:OFA_IMPORTE_PARTICIPACION,16,2)),';',' '), '\"',''),'''','')) END"
)
