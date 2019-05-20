OPTIONS (DIRECT=TRUE, BINDSIZE=512000, ROWS=10000, ERRORS=999999)
LOAD DATA
CHARACTERSET WE8ISO8859P1
INFILE './CTLs_DATs/DATs/AGRUPACIONES.dat'
BADFILE './CTLs_DATs/bad/AGRUPACIONES.bad'
DISCARDFILE './CTLs_DATs/rejects/AGRUPACIONES.bad'
INTO TABLE REM01.MIG_AAG_AGRUPACIONES
TRUNCATE
TRAILING NULLCOLS
(
	AGR_EXTERNO           						POSITION(1:17)                	   INTEGER EXTERNAL                   							"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:AGR_EXTERNO),';',' '), '\"',''),'''',''),2,16))",
	AGR_GESTOR           						POSITION(18:34)                	   INTEGER EXTERNAL                   							"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:AGR_GESTOR),';',' '), '\"',''),'''',''),2,16))",
	AGR_MEDIADOR           						POSITION(35:51)                	   INTEGER EXTERNAL  NULLIF(AGR_MEDIADOR=BLANKS)                "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:AGR_MEDIADOR),';',' '), '\"',''),'''',''),2,16))",
	TIPO_AGRUPACION           					POSITION(52:71)                	   CHAR                   										"REPLACE(REPLACE(REPLACE(TRIM(:TIPO_AGRUPACION),';',' '), '\"',''),'''','')",
	AGR_NOMBRE           						POSITION(72:321)                   CHAR                  									    "REPLACE(REPLACE(REPLACE(TRIM(:AGR_NOMBRE),';',' '), '\"',''),'''','')",
	AGR_DESCRIPCION           					POSITION(322:571)                  CHAR  NULLIF(AGR_DESCRIPCION=BLANKS)                  		"REPLACE(REPLACE(REPLACE(TRIM(:AGR_DESCRIPCION),';',' '), '\"',''),'''','')",
	AGR_FECHA_ALTA           					POSITION(572:579)                  DATE 'DDMMYYYY'  NULLIF(AGR_FECHA_ALTA=BLANKS)               "REPLACE(:AGR_FECHA_ALTA, '00000000', '')",
	AGR_ELIMINADO           					POSITION(580:581)                  INTEGER EXTERNAL  NULLIF(AGR_ELIMINADO=BLANKS)               "TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:AGR_ELIMINADO),';',' '), '\"',''),'''',''),2,1))",
	AGR_FECHA_BAJA           					POSITION(582:589)                  DATE 'DDMMYYYY'  NULLIF(AGR_FECHA_BAJA=BLANKS)               "REPLACE(:AGR_FECHA_BAJA, '00000000', '')",
	AGR_PUBLICADO           					POSITION(590:591)                  INTEGER EXTERNAL                   							"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:AGR_PUBLICADO),';',' '), '\"',''),'''',''),2,1))",
	AGR_TEXTO_WEB           					POSITION(592:1103)                 CHAR                   										"REPLACE(REPLACE(REPLACE(TRIM(:AGR_TEXTO_WEB),';',' '), '\"',''),'''','')",
	AGR_ACT_PRINCIPAL           				POSITION(1104:1120)                INTEGER EXTERNAL                   							"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:AGR_ACT_PRINCIPAL),';',' '), '\"',''),'''',''),2,16))",
	LOC_AGRUP_OBRA_NUEVA           				POSITION(1121:1140)                CHAR                   										"LPAD(NVL(REPLACE(REPLACE(REPLACE(TRIM(:LOC_AGRUP_OBRA_NUEVA),';',' '),'\"',''),'''',''),'00000'),5,'0')",
	PROV_AGRUP_OBRA_NUEVA           			POSITION(1141:1160)                CHAR                  										"REPLACE(REPLACE(REPLACE(TRIM(:PROV_AGRUP_OBRA_NUEVA),';',' '), '\"',''),'''','')",
	ESTADO_AGRUP_OBRA_NUEVA           			POSITION(1161:1180)                CHAR                   										"REPLACE(REPLACE(REPLACE(TRIM(:ESTADO_AGRUP_OBRA_NUEVA),';',' '), '\"',''),'''','')",
	ONV_DIR_AGRUP_OBRA_NUEVA         			POSITION(1181:1435)                CHAR                   										"REPLACE(REPLACE(REPLACE(TRIM(:ONV_DIR_AGRUP_OBRA_NUEVA),';',' '), '\"',''),'''','')",
	ONV_CP_AGRUP_OBRA_NUEVA           			POSITION(1436:1444)                INTEGER EXTERNAL                   							"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:ONV_CP_AGRUP_OBRA_NUEVA),';',' '), '\"',''),'''',''),2,8))",
	ONV_ACR_PDV_AGRUP_OBRA_NUEVA      			POSITION(1445:1699)                CHAR  NULLIF(ONV_ACR_PDV_AGRUP_OBRA_NUEVA=BLANKS)  			"REPLACE(REPLACE(REPLACE(TRIM(:ONV_ACR_PDV_AGRUP_OBRA_NUEVA),';',' '), '\"',''),'''','')",
	LOC_AGRUP_LOTE_RESTRINGIDO       			POSITION(1700:1719)                CHAR                   										"LPAD(NVL(REPLACE(REPLACE(REPLACE(TRIM(:LOC_AGRUP_LOTE_RESTRINGIDO),';',' '),'\"',''),'''',''),'00000'),5,'0')",
	PRO_AGRUP_LOTE_RESTRINGIDO       			POSITION(1720:1739)                CHAR                   										"REPLACE(REPLACE(REPLACE(TRIM(:PRO_AGRUP_LOTE_RESTRINGIDO),';',' '), '\"',''),'''','')",
	RES_DIR_AGRUP_LOTE_RESTRINGIDO   			POSITION(1740:1994)                CHAR                   										"REPLACE(REPLACE(REPLACE(TRIM(:RES_DIR_AGRUP_LOTE_RESTRINGIDO),';',' '), '\"',''),'''','')",
	RES_CP_AGRUP_LOTE_RESTRINGIDO          		POSITION(1995:2003)                INTEGER EXTERNAL                   							"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:RES_CP_AGRUP_LOTE_RESTRINGIDO),';',' '), '\"',''),'''',''),2,8))",
	AGR_FECHA_FIRMA           				    POSITION(2004:2011)                DATE 'YYYYMMDD'                   							"REPLACE(:AGR_FECHA_FIRMA, '00000000', '')",
	AGR_FECHA_VENCIMIENTO           			POSITION(2012:2019)                DATE 'YYYYMMDD'                   							"REPLACE(:AGR_FECHA_VENCIMIENTO, '00000000', '')",
	AGR_IS_FORMALIZACION           				POSITION(2020:2021)                INTEGER EXTERNAL                   							"TO_NUMBER(SUBSTR(REPLACE(REPLACE(REPLACE(TRIM(:AGR_IS_FORMALIZACION),';',' '), '\"',''),'''',''),2,1))",
VALIDACION CONSTANT "0")
