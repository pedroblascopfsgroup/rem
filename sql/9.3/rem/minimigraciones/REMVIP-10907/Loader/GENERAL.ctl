OPTIONS (DIRECT=TRUE, BINDSIZE=1024000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET AL32UTF8
INTO TABLE REM01.AUX_REMVIP_10907
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ID_PERSONA_HAYA_BANKIA			NULLIF(ID_PERSONA_HAYA_BANKIA=BLANKS)		"TRIM(:ID_PERSONA_HAYA_BANKIA)",
	DOC_IDENTIFICATIVO			NULLIF(DOC_IDENTIFICATIVO=BLANKS)		"TRIM(:DOC_IDENTIFICATIVO)",
	ID_PERSONA_HAYA_CAIXA 			NULLIF(ID_PERSONA_HAYA_CAIXA=BLANKS)		"TRIM(:ID_PERSONA_HAYA_CAIXA)",
	ID_PERSONA_HAYA_EDT			NULLIF(ID_PERSONA_HAYA_EDT=BLANKS)		"TRIM(:ID_PERSONA_HAYA_EDT)",
	ID_PERSONA_HAYA_TDA			NULLIF(ID_PERSONA_HAYA_TDA=BLANKS)		"TRIM(:ID_PERSONA_HAYA_TDA)",
	ID_PERSONA_HAYA_BFA			NULLIF(ID_PERSONA_HAYA_BFA=BLANKS)		"TRIM(:ID_PERSONA_HAYA_BFA)",
	ID_PERSONA_HAYA_BANKIA_MAESTRO	NULLIF(ID_PERSONA_HAYA_BANKIA_MAESTRO=BLANKS)	"TRIM(:ID_PERSONA_HAYA_BANKIA_MAESTRO)"


)

