OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/OFERTAS_OBSERVACIONES.dat'
BADFILE './CTLs_DATs/bad/OFERTAS_OBSERVACIONES.bad'
DISCARDFILE './CTLs_DATs/rejects/OFERTAS_OBSERVACIONES.bad'
INTO TABLE REM01.MIG2_OBF_OBSERVACIONES_OFERTAS
TRUNCATE
TRAILING NULLCOLS
(
	OBF_COD_OFERTA			POSITION(1:17)			INTEGER EXTERNAL			"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:OBF_COD_OFERTA),';',' '), '\"',''),'''',''),2,16))",
	OBF_COD_TIPO_OBS		POSITION(18:37)			CHAR 						"REPLACE(REPLACE(REPLACE(TRIM(:OBF_COD_TIPO_OBS),';',' '), '\"',''),'''','')",
	OBF_FECHA				POSITION(38:45)			DATE 'YYYYMMDD'				"REPLACE(:OBF_FECHA, '00000000', '')",
	OBF_OBSERVACION			POSITION(46:1069)		CHAR 						"REPLACE(REPLACE(REPLACE(TRIM(:OBF_OBSERVACION),';',' '), '\"',''),'''','')"    
)
