OPTIONS (DIRECT=TRUE, BINDSIZE=1024000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET AL32UTF8
INTO TABLE REM01.AUX_REMVIP_11118
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	NUMOFERTA		NULLIF(NUMOFERTA=BLANKS)	"TRIM(:NUMOFERTA)",
	FECHAPENDIENTE		NULLIF(FECHAPENDIENTE=BLANKS)	"TRIM(:FECHAPENDIENTE)"

)

