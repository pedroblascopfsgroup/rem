OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999, SKIP=1)
LOAD DATA
CHARACTERSET WE8ISO8859P15
INFILE './CTL/IN/Carterizacion_Onboarding_Administracion.csv'
INFILE './CTL/IN/Carterizacion_Onboarding_Admision.csv'
INFILE './CTL/IN/Carterizacion_Onboarding_Alquiler.csv'
INFILE './CTL/IN/Carterizacion_Onboarding_Comercial.csv'
INFILE './CTL/IN/Carterizacion_Onboarding_Formalizacion.csv'
INFILE './CTL/IN/Carterizacion_Onboarding_GestionActivos.csv'
INFILE './CTL/IN/Carterizacion_Onboarding_MidleOffice.csv'
INFILE './CTL/IN/Carterizacion_Onboarding_Publicaciones.csv'
BADFILE './CTL/BAD/Carterizacion_Onboarding.bad'
DISCARDFILE './CTL/REJECTS/Carterizacion_Onboarding.bad'
INTO TABLE REM01.TMP_ASIGNACION_GESTOR_ACTIVO
TRUNCATE
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
	ID_HAYA "TRIM(:ID_HAYA)",
    GESTOR "TRIM(:GESTOR)",
	USUARIO	"TRIM(:USUARIO)"    
)
