LOAD DATA
CHARACTERSET WE8ISO8859P1
INTO TABLE REM01.AUX_REMVIP_8542_1
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ACT_NUM_ACTIVO "TRIM(:ACT_NUM_ACTIVO)",
	ICO_DESCRIPCION CHAR(4000) "TRIM(:ICO_DESCRIPCION)",
	ICO_INFO_DISTRIBUCION_INTERIOR CHAR(1000) "TRIM(:ICO_INFO_DISTRIBUCION_INTERIOR)"
)
