OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_2347
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	PVE_ID				NULLIF(PVE_ID=BLANKS)						"TRIM(:PVE_ID)",
	PR_PVE_COD_PRINEX		NULLIF(PR_PVE_COD_PRINEX=BLANKS)		                "TRIM(:PR_PVE_COD_PRINEX)"
	
)
