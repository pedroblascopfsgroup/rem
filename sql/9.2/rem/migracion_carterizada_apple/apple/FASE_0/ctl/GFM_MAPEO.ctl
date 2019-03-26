OPTIONS ( BINDSIZE=512000, ROWS=10000, ERRORS=999999, SKIP=1)
LOAD DATA
INTO TABLE REM01.GFM_MAPEO
TRUNCATE 
FIELDS TERMINATED BY ","
OPTIONALLY ENCLOSED BY "\""
TRAILING NULLCOLS
(
INTERFAZ "REPLACE(TRIM(:INTERFAZ),' ','')",
DAT_ORIGEN "REPLACE(TRIM(:DAT_ORIGEN),' ','')",
DAT_NUESTRO "REPLACE(TRIM(:DAT_NUESTRO),' ','')",
TABLA "REPLACE(TRIM(:TABLA),' ','')",
COLUMNAS "TO_NUMBER(:COLUMNAS ,'999,999,999.99')",
DDL "REPLACE(TRIM(:DDL),' ','')",
CTL "REPLACE(TRIM(:CTL),' ','')"
)


