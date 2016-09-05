OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/OBSERVACIONES_ACTIVOS.dat'
BADFILE './CTLs_DATs/bad/OBSERVACIONES_ACTIVOS.bad'
DISCARDFILE './CTLs_DATs/rejects/OBSERVACIONES_ACTIVOS.bad'
INTO TABLE REM01.MIG_AOA_OBSERVACIONES_ACT_BNK
TRUNCATE
TRAILING NULLCOLS
(	
	ACT_NUMERO_ACTIVO				POSITION(1:17)				INTEGER EXTERNAL 										"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ACT_NUMERO_ACTIVO),';',' '), '\"',''),'''',''),2,16))",
	USU_ID							POSITION(18:34)				INTEGER EXTERNAL										"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:USU_ID),';',' '), '\"',''),'''',''),2,16))",
	AOB_OBSERVACION					POSITION(35:1058)			CHAR NULLIF(AOB_OBSERVACION=BLANKS) 					"REPLACE(REPLACE(REPLACE(TRIM(:AOB_OBSERVACION),';',' '), '\"',''),'''','')",
	AOB_FECHA						POSITION(1059:1066)			DATE 'YYYYMMDD' NULLIF(AOB_FECHA=BLANKS) 				"REPLACE(:AOB_FECHA, '00000000', '')"
)
