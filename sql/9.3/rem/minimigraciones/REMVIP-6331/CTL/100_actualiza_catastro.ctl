OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999, SKIP=1)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTL/IN/UPDATE_REF_CATASTRAL.csv'
BADFILE './CTL/BAD/UPDATE_REF_CATASTRAL.bad'
DISCARDFILE './CTL/REJECTS/UPDATE_REF_CATASTRAL.bad'
INTO TABLE REM01.TMP_ACTUALIZA_ACT_CAT_CATASTRO
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ACT_ID_HAYA  "TRIM(:ACT_ID_HAYA)",
    ACT_ID_PRINEX "TRIM(:ACT_ID_PRINEX)",
	CAT_REF_CATASTRAL "TRIM(:CAT_REF_CATASTRAL)"
)
