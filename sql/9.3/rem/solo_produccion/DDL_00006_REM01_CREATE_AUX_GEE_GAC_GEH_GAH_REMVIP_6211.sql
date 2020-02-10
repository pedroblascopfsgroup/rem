--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20200210
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6211
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla 'AUX_GEE_REMVIP_6211' , 'AUX_GAC_REMVIP_6211' , 'AUX_GEH_REMVIP_6211' , 'AUX_GAH_REMVIP_6211'
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER'; --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := 'REM_IDX';
V_TABLA1 VARCHAR2(40 CHAR) := 'AUX_GEE_REMVIP_6211';
V_TABLA2 VARCHAR2(40 CHAR) := 'AUX_GAC_REMVIP_6211';
V_TABLA3 VARCHAR2(40 CHAR) := 'AUX_GEH_REMVIP_6211';
V_TABLA4 VARCHAR2(40 CHAR) := 'AUX_GAH_REMVIP_6211';

BEGIN


-----------------------------------------------------------------------

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA1||'' AND OWNER= ''||V_ESQUEMA_1||'';
IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA1||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA1||'';
END IF;

EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA1||' AS 
  ( 

	SELECT GEE_ID, USU_ID, DD_TGE_ID
	FROM REM01.GEE_GESTOR_ENTIDAD
	WHERE TRUNC(FECHACREAR) = TO_DATE( ''07/02/2020'', ''DD/MM/YYYY'' )
	AND USUARIOCREAR = ''ALT_SAREB''

  )

';

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA1||' CREADA');  


-----------------------------------------------------------------------

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA2||'' AND OWNER= ''||V_ESQUEMA_1||'';
IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA2||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA2||'';
END IF;


EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA2||' AS 
	(
		SELECT GEE_ID, ACT_ID
		FROM REM01.GAC_GESTOR_ADD_ACTIVO GAC
		WHERE EXISTS 
		(
			SELECT 1
			FROM REM01.GEE_GESTOR_ENTIDAD GEE
			WHERE TRUNC(FECHACREAR) = TO_DATE( ''07/02/2020'', ''DD/MM/YYYY'' )
			AND USUARIOCREAR = ''ALT_SAREB''
			AND GEE.GEE_ID = GAC.GEE_ID )
		)
';

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA2||' CREADA');  


-----------------------------------------------------------------------


SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA3||'' AND OWNER= ''||V_ESQUEMA_1||'';
IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA3||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA3||'';
END IF;

EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA3||' AS 

  ( 

	SELECT GEH_ID, USU_ID, DD_TGE_ID
	FROM REM01.GEH_GESTOR_ENTIDAD_HIST
	WHERE TRUNC(FECHACREAR) = TO_DATE( ''07/02/2020'', ''DD/MM/YYYY'' )
	AND USUARIOCREAR = ''ALT_SAREB''	

  ) ';
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA3||' CREADA');  


-----------------------------------------------------------------------

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA4||'' AND OWNER= ''||V_ESQUEMA_1||'';
IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA4||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA4||'';
END IF;
EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA4||' AS 

  ( 
	SELECT GEH_ID, ACT_ID
	FROM REM01.GAH_GESTOR_ACTIVO_HISTORICO GAH
	WHERE EXISTS (	

		SELECT 1
		FROM REM01.GEH_GESTOR_ENTIDAD_HIST GEH
		WHERE TRUNC(FECHACREAR) = TO_DATE( ''07/02/2020'', ''DD/MM/YYYY'' )
		AND USUARIOCREAR = ''ALT_SAREB''	
		AND GEH.GEH_ID = GAH.GEH_ID
	
	)


  ) ';
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA4||' CREADA'); 
 

-----------------------------------------------------------------------


IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA1||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA1||' OTORGADOS A '||V_ESQUEMA_2||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA2||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA2||' OTORGADOS A '||V_ESQUEMA_2||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA3||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA3||' OTORGADOS A '||V_ESQUEMA_2||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA4||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA4||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;


IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA1||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA1||' OTORGADOS A '||V_ESQUEMA_4||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA2||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA2||' OTORGADOS A '||V_ESQUEMA_4||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA3||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA3||' OTORGADOS A '||V_ESQUEMA_4||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA4||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA4||' OTORGADOS A '||V_ESQUEMA_4||''); 

END IF;

	V_MSQL := 'CREATE INDEX IDX_AUX_REMVIP_6211_GEE_GEE_ID ON '||V_ESQUEMA_1||'.AUX_GEE_REMVIP_6211(GEE_ID)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] CREADO INDICE PARA AUX_GEE_REMVIP_6211'); 

	V_MSQL := 'CREATE INDEX IDX_AUX_REMVIP_6211_GAC_GAC_ID ON '||V_ESQUEMA_1||'.AUX_GAC_REMVIP_6211(GEE_ID)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] CREADO INDICE PARA AUX_GAC_REMVIP_6211'); 

	V_MSQL := 'CREATE INDEX IDX_AUX_REMVIP_6211_GEH_GEH_ID ON '||V_ESQUEMA_1||'.AUX_GEH_REMVIP_6211(GEH_ID)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] CREADO INDICE PARA AUX_GEH_REMVIP_6211'); 

	V_MSQL := 'CREATE INDEX IDX_AUX_REMVIP_6211_GAH_GAH_ID ON '||V_ESQUEMA_1||'.AUX_GAH_REMVIP_6211(GEH_ID)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] CREADO INDICE PARA AUX_GAH_REMVIP_6211'); 

	COMMIT;

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
