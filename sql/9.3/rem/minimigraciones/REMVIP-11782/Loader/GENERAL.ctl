OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET AL32UTF8
INTO TABLE REM01.AUX_REMVIP_11782
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	   BASE			NULLIF(BASE=BLANKS)				"TRIM(:BASE)",
	   TIPO_GASTO			NULLIF(TIPO_GASTO=BLANKS)			"TRIM(:TIPO_GASTO)",
   	   SUBTIPO_GASTO		NULLIF(SUBTIPO_GASTO=BLANKS)			"TRIM(:SUBTIPO_GASTO)",
   	   PP_2022			NULLIF(PP_2022=BLANKS)				"TRIM(:PP_2022)",
   	   CC_APPLE_JAGUAR		NULLIF(CC_APPLE_JAGUAR=BLANKS)		"TRIM(:CC_APPLE_JAGUAR)",
   	   CC_DIVARIAN			NULLIF(CC_DIVARIAN=BLANKS)			"TRIM(:CC_DIVARIAN)",
   	   REGLA_IBI			NULLIF(REGLA_IBI=BLANKS)			"TRIM(:REGLA_IBI)"

	
)

