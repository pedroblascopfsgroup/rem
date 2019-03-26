OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/INFOCOMERCIAL_DISTRIBUCION.dat'
BADFILE './CTLs_DATs/bad/INFOCOMERCIAL_DISTRIBUCION.bad'
DISCARDFILE './CTLs_DATs/rejects/INFOCOMERCIAL_DISTRIBUCION.bad'
INTO TABLE REM01.MIG_AID_INFCOMERCIAL_DISTR
TRUNCATE
TRAILING NULLCOLS
(	
	ACT_NUMERO_ACTIVO				POSITION(1:17)				INTEGER EXTERNAL 										"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ACT_NUMERO_ACTIVO),';',' '), '\"',''),'''',''),2,16))",
	DIS_NUM_PLANTA					POSITION(18:34)				INTEGER EXTERNAL										"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:DIS_NUM_PLANTA),';',' '), '\"',''),'''',''),1,17))",
	TIPO_HABITACULO					POSITION(35:54)				CHAR 													"REPLACE(REPLACE(REPLACE(TRIM(:TIPO_HABITACULO),';',' '), '\"',''),'''','')",
	DIS_CANTIDAD					POSITION(55:63)				INTEGER EXTERNAL NULLIF(DIS_CANTIDAD=BLANKS) 			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:DIS_CANTIDAD),';',' '), '\"',''),'''',''),2,8))",
	DIS_SUPERFICIE					POSITION(64:80)				INTEGER EXTERNAL NULLIF(DIS_SUPERFICIE=BLANKS)			"CASE WHEN (:DIS_SUPERFICIE) IS NULL THEN NULL ELSE TO_NUMBER(REPLACE(REPLACE(REPLACE(TRIM(SUBSTR(:DIS_SUPERFICIE,1,15)||','||SUBSTR(:DIS_SUPERFICIE,16,2)),';',' '), '\"',''),'''','')) END",
	DIS_DESCRIPCION 				POSITION(81:230) 			CHAR NULLIF(DIS_DESCRIPCION=BLANKS) 				"REPLACE(REPLACE(REPLACE(TRIM(:DIS_DESCRIPCION),';',' '), '\"',''),'''','')",
VALIDACION CONSTANT "0")
