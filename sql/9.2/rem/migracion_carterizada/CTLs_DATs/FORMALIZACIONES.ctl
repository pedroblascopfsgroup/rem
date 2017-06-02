OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/FORMALIZACIONES.dat'
BADFILE './CTLs_DATs/bad/FORMALIZACIONES.bad'
DISCARDFILE './CTLs_DATs/rejects/FORMALIZACIONES.bad'
INTO TABLE REM01.MIG2_FOR_FORMALIZACIONES
TRUNCATE
TRAILING NULLCOLS
(
	FOR_COD_OFERTA				POSITION(1:17)		INTEGER EXTERNAL											"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:FOR_COD_OFERTA),';',' '), '\"',''),'''',''),2,16))",
	FOR_COD_NOTARIO				POSITION(18:37)		CHAR NULLIF(FOR_COD_NOTARIO=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:FOR_COD_NOTARIO),';',' '), '\"',''),'''','')",
	FOR_PETICIONARIO			POSITION(38:87)		CHAR NULLIF(FOR_PETICIONARIO=BLANKS)						"REPLACE(REPLACE(REPLACE(TRIM(:FOR_PETICIONARIO),';',' '), '\"',''),'''','')",
	FOR_FECHA_PETICION			POSITION(88:95)		DATE 'YYYYMMDD' NULLIF(FOR_FECHA_PETICION=BLANKS)			"REPLACE(:FOR_FECHA_PETICION, '00000000', '')",
	FOR_FECHA_RESOLUCION		POSITION(96:103)	DATE 'YYYYMMDD' NULLIF(FOR_FECHA_RESOLUCION=BLANKS)			"REPLACE(:FOR_FECHA_RESOLUCION, '00000000', '')",
	FOR_FECHA_ESCRITURA			POSITION(104:111)	DATE 'YYYYMMDD' NULLIF(FOR_FECHA_ESCRITURA=BLANKS)			"REPLACE(:FOR_FECHA_ESCRITURA, '00000000', '')",
	FOR_FECHA_CONTABILIZACION	POSITION(112:119)	DATE 'YYYYMMDD' NULLIF(FOR_FECHA_CONTABILIZACION=BLANKS)	"REPLACE(:FOR_FECHA_CONTABILIZACION, '00000000', '')",
	FOR_FECHA_PAGO				POSITION(120:127)	DATE 'YYYYMMDD' NULLIF(FOR_FECHA_PAGO=BLANKS)				"REPLACE(:FOR_FECHA_PAGO, '00000000', '')",
	FOR_IMPORTE					POSITION(128:144)	INTEGER EXTERNAL NULLIF(FOR_IMPORTE=BLANKS)					"CASE WHEN (:FOR_IMPORTE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:FOR_IMPORTE,1,15)||','||SUBSTR(:FOR_IMPORTE,16,2)),';',' '), '\"',''),'''','')) END",
	FOR_FORMA_PAGO				POSITION(145:194)	CHAR NULLIF(FOR_FORMA_PAGO=BLANKS)							"REPLACE(REPLACE(REPLACE(TRIM(:FOR_FORMA_PAGO),';',' '), '\"',''),'''','')",
	FOR_MOTIVO_RESOLUCION		POSITION(195:706)	CHAR NULLIF(FOR_MOTIVO_RESOLUCION=BLANKS)					"REPLACE(REPLACE(REPLACE(TRIM(:FOR_MOTIVO_RESOLUCION),';',' '), '\"',''),'''','')"	 ,
	VALIDACION CONSTANT "0"	
	 
)
