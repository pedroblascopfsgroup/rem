OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_JPR_FOR_FORMALIZACION
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	numero_haya					NULLIF numero_haya='NULL' 						"REPLACE(REPLACE(REPLACE(TRIM(:numero_haya),';',' '), '\"',''),'''','')",
	num_expediente					NULLIF num_expediente='NULL' 						"REPLACE(REPLACE(REPLACE(TRIM(:num_expediente),';',' '), '\"',''),'''','')",
	capital_concedido				NULLIF capital_concedido='NULL' 					"REPLACE(REPLACE(REPLACE(TRIM(:capital_concedido),';',' '), '\"',''),'''','')"
)
