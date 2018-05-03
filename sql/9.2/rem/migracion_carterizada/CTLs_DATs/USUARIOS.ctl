OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/USUARIOS.dat'
BADFILE './CTLs_DATs/bad/USUARIOS.bad'
DISCARDFILE './CTLs_DATs/rejects/USUARIOS.bad'
INTO TABLE REM01.MIG2_USU_USUARIOS
TRUNCATE
TRAILING NULLCOLS
(
	USU_USERNAME          	POSITION(1:50)    		CHAR                       		      	"REPLACE(REPLACE(REPLACE(TRIM(:USU_USERNAME),';',' '), '\"',''),'''','')",
	USU_NOMBRE          	POSITION(51:100)    	CHAR                     		       	"REPLACE(REPLACE(REPLACE(TRIM(:USU_NOMBRE),';',' '), '\"',''),'''','')",
	USU_APELLIDO1          	POSITION(101:150)    	CHAR                            		"REPLACE(REPLACE(REPLACE(TRIM(:USU_APELLIDO1),';',' '), '\"',''),'''','')",
	USU_APELLIDO2          	POSITION(151:200)   	CHAR NULLIF(USU_APELLIDO2=BLANKS)   	"REPLACE(REPLACE(REPLACE(TRIM(:USU_APELLIDO2),';',' '), '\"',''),'''','')",
	USU_EMAIL          		POSITION(201:250)   	CHAR                     				"REPLACE(REPLACE(REPLACE(TRIM(:USU_EMAIL),';',' '), '\"',''),'''','')",
	USU_CODIGO_PERFIL       POSITION(251:300)   	CHAR                      		      	"REPLACE(REPLACE(REPLACE(TRIM(:USU_CODIGO_PERFIL),';',' '), '\"',''),'''','')",
	USU_ACCESO_APLICACION	POSITION(301:302)		INTEGER EXTERNAL						"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:USU_ACCESO_APLICACION),';',' '), '\"',''),'''',''),2,1))",
	VALIDACION CONSTANT "0"
)