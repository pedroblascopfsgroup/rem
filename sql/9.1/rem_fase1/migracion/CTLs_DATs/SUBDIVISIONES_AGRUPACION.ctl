OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/SUBDIVISIONES_AGRUPACION.dat'
BADFILE './CTLs_DATs/bad/SUBDIVISIONES_AGRUPACION.bad'
DISCARDFILE './CTLs_DATs/rejects/SUBDIVISIONES_AGRUPACION.bad'
INTO TABLE REM01.MIG_ASA_SUBDIVISIONES_AGRUP
TRUNCATE
TRAILING NULLCOLS
(	
	AGR_UVEM						POSITION(1:17)				INTEGER EXTERNAL 													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:AGR_UVEM),';',' '), '\"',''),'''',''),2,16))",
	SDV_COD_UVEM					POSITION(18:34)				INTEGER EXTERNAL													"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:SDV_COD_UVEM),';',' '), '\"',''),'''',''),2,16))",
	TIPO_SUBDIVISION				POSITION(35:54)				CHAR NULLIF(TIPO_SUBDIVISION=BLANKS) 								"REPLACE(REPLACE(REPLACE(TRIM(:TIPO_SUBDIVISION),';',' '), '\"',''),'''','')",
	SDV_NOMBRE						POSITION(55:304)			CHAR NULLIF(SDV_NOMBRE=BLANKS) 										"REPLACE(REPLACE(REPLACE(TRIM(:SDV_NOMBRE),';',' '), '\"',''),'''','')",
	SDV_NUM_HABITACIONES			POSITION(305:313)			INTEGER EXTERNAL NULLIF(SDV_NUM_HABITACIONES=BLANKS) 				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:SDV_NUM_HABITACIONES),';',' '), '\"',''),'''',''),2,8))",
	SDV_NUM_PLANTAS_INTER			POSITION(314:322)			INTEGER EXTERNAL NULLIF(SDV_NUM_PLANTAS_INTER=BLANKS)				"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:SDV_NUM_PLANTAS_INTER),';',' '), '\"',''),'''',''),2,8))"
)
