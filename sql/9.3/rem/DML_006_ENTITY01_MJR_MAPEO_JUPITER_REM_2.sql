--/*
--#########################################
--## AUTOR=PEDRO BLASCO
--## FECHA_CREACION=20190908
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.6.01
--## INCIDENCIA_LINK=RECOVERY-15050
--## PRODUCTO=NO
--##
--## FINALIDAD: [Explicación de la existencia de este script]
--##
--## INSTRUCCIONES:
--##	1. Especificar el esquema de la tabla en la variable 'V_TABLE_SCHEME' apuntando a la variables 'V_SCHEME' o 'V_MASTER_SCHEME'.
--##	2. Especificar el nombre de la tabla a crear o modificar en la variable 'V_TABLE_NAME'.
--##	3. Especificar el usuario que quedará registrado en la auditoria para los cambios en la tabla en la variable 'V_AUDIT_USER'.
--##	4. Configurar las columnas que se verán afectadas al crear un nuevo registro en la tabla en la variable 'V_COLUMNS_ARRAY'.
--##	5. Configurar los datos a generar en las columnas indicadas anteriormente de la tabla en la variable 'V_DATA_MATRIX' siguiendo el patrón de diseño.
--##
--##	** No modificar las zonas entre BEGIN -> EXIT, la lógica implementada lleva a cabo las operaciones necesarias con las variables en el DECLARE **
--##	Más información: http://bit.ly/pitertul-api
--##
--## VERSIONES:
--##	0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE
SET SERVEROUTPUT ON
SET DEFINE OFF

DECLARE
    -- Pitertul constants.
    V_SCHEME VARCHAR2(25 CHAR)          := '#ESQUEMA#'; -- Configuración de esquema. Asignada por Pitertul.
	V_MASTER_SCHEME VARCHAR2(25 CHAR)   := '#ESQUEMA_MASTER#'; -- Configuración de esquema master. Asignada por Pitertul.
    V_VERBOSITY_LEVEL NUMBER(1)         := OUTPUT_LEVEL.INFO; -- Configuración de nivel de verbosidad en el output log.

    -- User defined variables.
    V_TABLE_SCHEME VARCHAR2(25 CHAR)    := V_SCHEME; -- Indica el esquema de la tabla de referencia.
    V_TABLE_NAME VARCHAR2(125 CHAR)     := 'MJR_MAPEO_JUPITER_REM'; -- Indica el nombre de la tabla de referencia.
	V_AUDIT_USER VARCHAR2(50 CHAR)		:= 'HREOS-0000'; -- Indica el usuario para registrar en la auditoría con cada cambio.

	V_COLUMNS_ARRAY ARRAY_TABLE 		:= ARRAY_TABLE('MJR_CODIGO_JUPITER', 'MJR_NOMBRE', 'MJR_DESCRIPCION', 'MJR_CODIGO_REM', 'MJR_TIPO_PERFIL'); 
		-- Indica las columnas en las cuales insertar contenido.

	V_DATA_MATRIX MATRIX_TABLE := MATRIX_TABLE(
	--	Modificar estructura y contenido acorde con el número y orden de columnas especificadas en 'V_COLUMNS_ARRAY'.
ARRAY_TABLE('111','Perfil copia Gestor formalización','CPHAYAGESTFORM - Perfil copia Gestor formalización','CPHAYAGESTFORM','perfil-rol'),
ARRAY_TABLE('112','Seguridad REAM','SEGURIDAD_REAM - Seguridad REAM','SEGURIDAD_REAM','perfil-rol'),
ARRAY_TABLE('113','Superusuario de comercial','SUPERCOMERCIAL - Superusuario de comercial','SUPERCOMERCIAL','perfil-rol'),

ARRAY_TABLE('GR386','Usuario_grupo_grusbackoffice','Grupo de usuarios - grusbackoffice Grupo Supervisores Backoffice Inmobiliario','grusbackoffice','grupo'),
ARRAY_TABLE('GR387','Usuario_grupo_itaca','Grupo de usuarios - ITACA Itaca Avanza','ITACA','grupo'),
ARRAY_TABLE('GR388','Usuario_grupo_limpiezasycubos','Grupo de usuarios - limpiezasycubos Limpiezas y Cubos Madrid SL','limpiezasycubos','grupo'),

ARRAY_TABLE('1013','Otras carteras','Otras carteras','Otras carteras','cartera'),
ARRAY_TABLE('1014','Cartera sin definir','Cartera sin definir','Sin definir','cartera'),
ARRAY_TABLE('1015','Cartera HyT','Cartera HyT','HyT','cartera'),
ARRAY_TABLE('1016','Cartera Unicaja','Cartera Unicaja','Unicaja','cartera'),
ARRAY_TABLE('1017','Cartera Third Parties','Cartera Third Parties','Third Parties','cartera'),
ARRAY_TABLE('1018','Cartera Galeon','Cartera Galeon','Galeon','cartera'),

ARRAY_TABLE('1019','Subcartera BBVA / Anida','Subcartera BBVA / Anida','BBVA / Anida','subcartera'),
ARRAY_TABLE('1020','Subcartera BBVA / BBVA','Subcartera BBVA / BBVA','BBVA / BBVA','subcartera'),
ARRAY_TABLE('1021','Subcartera BBVA / CX','Subcartera BBVA / CX','BBVA / CX','subcartera'),
ARRAY_TABLE('1022','Subcartera BBVA / GAT','Subcartera BBVA / GAT','BBVA / GAT','subcartera'),
ARRAY_TABLE('1023','Subcartera BBVA / Usgai','Subcartera BBVA / Usgai','BBVA / Usgai','subcartera'),
ARRAY_TABLE('1024','Subcartera CaixaBank / BANKIA','Subcartera CaixaBank / BANKIA','CaixaBank / BANKIA','subcartera'),
ARRAY_TABLE('1025','Subcartera CaixaBank / BANKIA HABITAT','Subcartera CaixaBank / BANKIA HABITAT','CaixaBank / BANKIA HABITAT','subcartera'),
ARRAY_TABLE('1026','Subcartera CaixaBank / BFA','Subcartera CaixaBank / BFA','CaixaBank / BFA','subcartera'),
ARRAY_TABLE('1027','Subcartera CaixaBank / FINANCIERO','Subcartera CaixaBank / FINANCIERO','CaixaBank / FINANCIERO','subcartera'),
ARRAY_TABLE('1028','Subcartera CaixaBank / SAREB','Subcartera CaixaBank / SAREB','CaixaBank / SAREB','subcartera'),
ARRAY_TABLE('1029','Subcartera CaixaBank / SAREB Pre-IBERO','Subcartera CaixaBank / SAREB Pre-IBERO','CaixaBank / SAREB Pre-IBERO','subcartera'),
ARRAY_TABLE('1030','Subcartera CaixaBank / SOLVIA','Subcartera CaixaBank / SOLVIA','CaixaBank / SOLVIA','subcartera'),
ARRAY_TABLE('1031','Subcartera CaixaBank / TITULIZADA','Subcartera CaixaBank / TITULIZADA','CaixaBank / TITULIZADA','subcartera'),
ARRAY_TABLE('1032','Subcartera Cajamar / FINANCIERO','Subcartera Cajamar / FINANCIERO','Cajamar / FINANCIERO','subcartera'),
ARRAY_TABLE('1033','Subcartera Cajamar / INMOBILIARIO','Subcartera Cajamar / INMOBILIARIO','Cajamar / INMOBILIARIO','subcartera'),
ARRAY_TABLE('1034','Subcartera Cerberus / Agora - Financiero','Subcartera Cerberus / Agora - Financiero','Cerberus / Agora - Financiero','subcartera'),
ARRAY_TABLE('1035','Subcartera Cerberus / Agora - Inmobiliario','Subcartera Cerberus / Agora - Inmobiliario','Cerberus / Agora - Inmobiliario','subcartera'),
ARRAY_TABLE('1036','Subcartera Cerberus / Divarian Industrial Inmb','Subcartera Cerberus / Divarian Industrial Inmb','Cerberus / Divarian Industrial Inmb','subcartera'),
ARRAY_TABLE('1037','Subcartera Cerberus / Divarian Remaining Inmb','Subcartera Cerberus / Divarian Remaining Inmb','Cerberus / Divarian Remaining Inmb','subcartera'),
ARRAY_TABLE('1038','Subcartera Cerberus / Egeo','Subcartera Cerberus / Egeo','Cerberus / Egeo','subcartera'),
ARRAY_TABLE('1039','Subcartera Cerberus / INMOBILIARIO','Subcartera Cerberus / INMOBILIARIO','Cerberus / INMOBILIARIO','subcartera'),
ARRAY_TABLE('1040','Subcartera Cerberus / Jaipur - Financiero','Subcartera Cerberus / Jaipur - Financiero','Cerberus / Jaipur - Financiero','subcartera'),
ARRAY_TABLE('1041','Subcartera Cerberus / Jaipur - Inmobiliario','Subcartera Cerberus / Jaipur - Inmobiliario','Cerberus / Jaipur - Inmobiliario','subcartera'),
ARRAY_TABLE('1042','Subcartera Cerberus / Zeus - Financiero','Subcartera Cerberus / Zeus - Financiero','Cerberus / Zeus - Financiero','subcartera'),
ARRAY_TABLE('1043','Subcartera Cerberus / Zeus - Inmobiliario','Subcartera Cerberus / Zeus - Inmobiliario','Cerberus / Zeus - Inmobiliario','subcartera'),
ARRAY_TABLE('1044','Subcartera Egeo / ZEUS','Subcartera Egeo / ZEUS','Egeo / ZEUS','subcartera'),
ARRAY_TABLE('1045','Subcartera Galeon / Inmobiliario','Subcartera Galeon / Inmobiliario','Galeon / Inmobiliario','subcartera'),
ARRAY_TABLE('1046','Subcartera Giants / G-Giants REO I, S.L.','Subcartera Giants / G-Giants REO I, S.L.','Giants / G-Giants REO I, S.L.','subcartera'),
ARRAY_TABLE('1047','Subcartera Giants / G-Giants REO II, S.L.','Subcartera Giants / G-Giants REO II, S.L.','Giants / G-Giants REO II, S.L.','subcartera'),
ARRAY_TABLE('1048','Subcartera Giants / G-Giants REO III, S.L.','Subcartera Giants / G-Giants REO III, S.L.','Giants / G-Giants REO III, S.L.','subcartera'),
ARRAY_TABLE('1049','Subcartera Giants / G-Giants REO IV, S.L.','Subcartera Giants / G-Giants REO IV, S.L.','Giants / G-Giants REO IV, S.L.','subcartera'),
ARRAY_TABLE('1050','Subcartera Giants / Golden Tree','Subcartera Giants / Golden Tree','Giants / Golden Tree','subcartera'),
ARRAY_TABLE('1051','Subcartera HyT / INMOBILIARIO','Subcartera HyT / INMOBILIARIO','HyT / INMOBILIARIO','subcartera'),
ARRAY_TABLE('1052','Subcartera Otras carteras / FINSOLUTIA','Subcartera Otras carteras / FINSOLUTIA','Otras carteras / FINSOLUTIA','subcartera'),
ARRAY_TABLE('1053','Subcartera Otras carteras / INMOCAM','Subcartera Otras carteras / INMOCAM','Otras carteras / INMOCAM','subcartera'),
ARRAY_TABLE('1054','Subcartera Sareb / FINANCIERO','Subcartera Sareb / FINANCIERO','Sareb / FINANCIERO','subcartera'),
ARRAY_TABLE('1055','Subcartera Sareb / INMOBILIARIO','Subcartera Sareb / INMOBILIARIO','Sareb / INMOBILIARIO','subcartera'),
ARRAY_TABLE('1056','Subcartera Sin definir / SIN DEFINIR','Subcartera Sin definir / SIN DEFINIR','Sin definir / SIN DEFINIR','subcartera'),
ARRAY_TABLE('1057','Subcartera Tango / Blue Earth Invest, S.L.','Subcartera Tango / Blue Earth Invest, S.L.','Tango / Blue Earth Invest, S.L.','subcartera'),
ARRAY_TABLE('1058','Subcartera Tango / Tifios, S.L.','Subcartera Tango / Tifios, S.L.','Tango / Tifios, S.L.','subcartera'),
ARRAY_TABLE('1059','Subcartera Third Parties / Bankia LeaseBack','Subcartera Third Parties / Bankia LeaseBack','Third Parties / Bankia LeaseBack','subcartera'),
ARRAY_TABLE('1060','Subcartera Third Parties / Caser - Inmobiliario','Subcartera Third Parties / Caser - Inmobiliario','Third Parties / Caser - Inmobiliario','subcartera'),
ARRAY_TABLE('1061','Subcartera Third Parties / Comercial -ING','Subcartera Third Parties / Comercial -ING','Third Parties / Comercial -ING','subcartera'),
ARRAY_TABLE('1062','Subcartera Third Parties / Comercial-Particulares','Subcartera Third Parties / Comercial-Particulares','Third Parties / Comercial-Particulares','subcartera'),
ARRAY_TABLE('1063','Subcar. Third Parties / Garalma de Inversiones S.L','Subcartera Third Parties / Garalma de Inversiones S.L','Third Parties / Garalma de Inversiones S.L','subcartera'),
ARRAY_TABLE('1064','Subc. Third Parties / Inmoinvertia Offerhouse S.L','Subcartera Third Parties / Inmoinvertia Offerhouse S.L','Third Parties / Inmoinvertia Offerhouse S.L','subcartera'),
ARRAY_TABLE('1065','Subcartera Third Parties / MAPFRE','Subcartera Third Parties / MAPFRE','Third Parties / MAPFRE','subcartera'),
ARRAY_TABLE('1066','Subcartera Third Parties / Omega - Inmobiliario','Subcartera Third Parties / Omega - Inmobiliario','Third Parties / Omega - Inmobiliario','subcartera'),
ARRAY_TABLE('1067','Subcartera Third Parties / Quitas Bankia','Subcartera Third Parties / Quitas Bankia','Third Parties / Quitas Bankia','subcartera'),
ARRAY_TABLE('1068','Subcartera Third Parties / Quitas Cajamar','Subcartera Third Parties / Quitas Cajamar','Third Parties / Quitas Cajamar','subcartera'),
ARRAY_TABLE('1069','Subcartera Third Parties / Quitas Ibercaja','Subcartera Third Parties / Quitas Ibercaja','Third Parties / Quitas Ibercaja','subcartera'),
ARRAY_TABLE('1070','Subcartera Third Parties / Quitas ING','Subcartera Third Parties / Quitas ING','Third Parties / Quitas ING','subcartera'),
ARRAY_TABLE('1071','Subcartera Third Parties / Quitas Particulares','Subcartera Third Parties / Quitas Particulares','Third Parties / Quitas Particulares','subcartera'),
ARRAY_TABLE('1072','Subcartera Third Parties / Vimergo S.L','Subcartera Third Parties / Vimergo S.L','Third Parties / Vimergo S.L','subcartera'),
ARRAY_TABLE('1073','Subcartera Third Parties / Yubai','Subcartera Third Parties / Yubai','Third Parties / Yubai','subcartera'),
ARRAY_TABLE('1074','Subcartera Third Parties / 1 to 1','Subcartera Third Parties / 1 to 1','Third Parties / 1 to 1','subcartera'),
ARRAY_TABLE('1075','Subcartera Unicaja / Banco Castilla La Mancha','Subcartera Unicaja / Banco Castilla La Mancha','Unicaja / Banco Castilla La Mancha','subcartera'),
ARRAY_TABLE('1076','Subcartera Unicaja / Beyos y Ponga','Subcartera Unicaja / Beyos y Ponga','Unicaja / Beyos y Ponga','subcartera'),
ARRAY_TABLE('1077','Subcartera Unicaja / CONCEJO','Subcartera Unicaja / CONCEJO','Unicaja / CONCEJO','subcartera'),
ARRAY_TABLE('1078','Subcartera Unicaja / INMOBILIARIO','Subcartera Unicaja / INMOBILIARIO','Unicaja / INMOBILIARIO','subcartera'),
ARRAY_TABLE('1079','Subcartera Unicaja / Mosacata','Subcartera Unicaja / Mosacata','Unicaja / Mosacata','subcartera'),
ARRAY_TABLE('1080','Subcartera Unicaja / Postventa','Subcartera Unicaja / Postventa','Unicaja / Postventa','subcartera'),
ARRAY_TABLE('1081','Subcartera Unicaja / Retamar','Subcartera Unicaja / Retamar','Unicaja / Retamar','subcartera'),
ARRAY_TABLE('1082','Subcartera Unicaja / Unicaja','Subcartera Unicaja / Unicaja','Unicaja / Unicaja','subcartera')

	);
BEGIN
    pitertul.insert_common_table(V_TABLE_SCHEME, V_TABLE_NAME, V_COLUMNS_ARRAY, V_DATA_MATRIX, V_AUDIT_USER, V_VERBOSITY_LEVEL);
EXCEPTION
	WHEN OTHERS THEN
	DBMS_OUTPUT.PUT_LINE(SQLERRM);
	ROLLBACK;
	RAISE;
END;
/
EXIT