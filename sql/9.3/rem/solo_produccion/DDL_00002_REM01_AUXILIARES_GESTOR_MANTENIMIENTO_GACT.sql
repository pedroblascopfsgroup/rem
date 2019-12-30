--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191219
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5874
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla 'AUX_GEE_REMVIP_5874' , 'AUX_GAC_REMVIP_5874' , 'AUX_GEH_REMVIP_5874' , 'AUX_GAH_REMVIP_5874'
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
V_TABLA1 VARCHAR2(40 CHAR) := 'AUX_GEE_REMVIP_5874';
V_TABLA2 VARCHAR2(40 CHAR) := 'AUX_GAC_REMVIP_5874';
V_TABLA3 VARCHAR2(40 CHAR) := 'AUX_GEH_REMVIP_5874';
V_TABLA4 VARCHAR2(40 CHAR) := 'AUX_GAH_REMVIP_5874';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA1||'' AND OWNER= ''||V_ESQUEMA_1||'';
IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA1||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA1||'';
END IF;
EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA1||' AS 
  ( SELECT GEE.* FROM '||V_ESQUEMA_1||'.ACT_ACTIVO ACT
    JOIN '||V_ESQUEMA_1||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
    JOIN '||V_ESQUEMA_1||'.GEE_GESTOR_ENTIDAD GEE ON '||V_ESQUEMA_1||'.GEE.GEE_ID = GAC.GEE_ID
    JOIN '||V_ESQUEMA_1||'.BIE_LOCALIZACION LOC ON LOC.BIE_ID = ACT.BIE_ID
    JOIN '||V_ESQUEMA_2||'.DD_PRV_PROVINCIA PRV ON LOC.DD_PRV_ID = PRV.DD_PRV_ID 
    JOIN '||V_ESQUEMA_2||'.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID
    WHERE DD_TGE_ID IN (362) AND ACT.DD_CRA_ID IN (21,43) AND usu.usu_username <> ''usugruhpm''
  ) ';

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA1||' CREADA');  

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA2||'' AND OWNER= ''||V_ESQUEMA_1||'';
IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA2||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA2||'';
END IF;
EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA2||' AS 
  ( SELECT GAC.* FROM '||V_ESQUEMA_1||'.ACT_ACTIVO ACT
    JOIN '||V_ESQUEMA_1||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
    JOIN '||V_ESQUEMA_1||'.GEE_GESTOR_ENTIDAD GEE ON '||V_ESQUEMA_1||'.GEE.GEE_ID = GAC.GEE_ID
    JOIN '||V_ESQUEMA_1||'.BIE_LOCALIZACION LOC ON LOC.BIE_ID = ACT.BIE_ID
    JOIN '||V_ESQUEMA_2||'.DD_PRV_PROVINCIA PRV ON LOC.DD_PRV_ID = PRV.DD_PRV_ID 
    JOIN '||V_ESQUEMA_2||'.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID
    WHERE DD_TGE_ID IN (362) AND ACT.DD_CRA_ID  IN (21,43) AND usu.usu_username <> ''usugruhpm''
  ) ';

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA2||' CREADA');  

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA3||'' AND OWNER= ''||V_ESQUEMA_1||'';
IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA3||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA3||'';
END IF;
EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA3||' AS 
  ( SELECT GEH.* FROM '||V_ESQUEMA_1||'.ACT_ACTIVO ACT
    JOIN '||V_ESQUEMA_1||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
    JOIN '||V_ESQUEMA_1||'.GEH_GESTOR_ENTIDAD_HIST GEH ON '||V_ESQUEMA_1||'.GEH.GEH_ID = GAH.GEH_ID
    JOIN '||V_ESQUEMA_1||'.BIE_LOCALIZACION LOC ON LOC.BIE_ID = ACT.BIE_ID
    JOIN '||V_ESQUEMA_2||'.DD_PRV_PROVINCIA PRV ON LOC.DD_PRV_ID = PRV.DD_PRV_ID 
    JOIN '||V_ESQUEMA_2||'.USU_USUARIOS USU ON GEH.USU_ID = USU.USU_ID
    WHERE DD_TGE_ID IN (362) AND ACT.DD_CRA_ID IN (21,43) 
    AND usu.usu_username <> ''usugruhpm'' AND GEH.GEH_FECHA_HASTA IS NULL
  ) ';
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA3||' CREADA');  

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA4||'' AND OWNER= ''||V_ESQUEMA_1||'';
IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA4||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA4||'';
END IF;
EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA4||' AS 
  ( SELECT GAH.* FROM '||V_ESQUEMA_1||'.ACT_ACTIVO ACT
    JOIN '||V_ESQUEMA_1||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.ACT_ID = ACT.ACT_ID
    JOIN '||V_ESQUEMA_1||'.GEH_GESTOR_ENTIDAD_HIST GEH ON '||V_ESQUEMA_1||'.GEH.GEH_ID = GAH.GEH_ID
    JOIN '||V_ESQUEMA_1||'.BIE_LOCALIZACION LOC ON LOC.BIE_ID = ACT.BIE_ID
    JOIN '||V_ESQUEMA_2||'.DD_PRV_PROVINCIA PRV ON LOC.DD_PRV_ID = PRV.DD_PRV_ID 
    JOIN '||V_ESQUEMA_2||'.USU_USUARIOS USU ON GEH.USU_ID = USU.USU_ID
    WHERE DD_TGE_ID IN (362) AND ACT.DD_CRA_ID  IN (21,43) 
    AND usu.usu_username <> ''usugruhpm'' AND GEH.GEH_FECHA_HASTA IS NULL
  ) ';
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA4||' CREADA');  


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

	V_MSQL := 'CREATE INDEX IDX_AUX_GEE_GEE_ID_5874 ON '||V_ESQUEMA_1||'.AUX_GEE_REMVIP_5874(GEE_ID)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] CREADO INDICE PARA AUX_GEE_REMVIP_5874'); 

	V_MSQL := 'CREATE INDEX IDX_AUX_GAC_GAC_ID_5874 ON '||V_ESQUEMA_1||'.AUX_GAC_REMVIP_5874(GEE_ID)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] CREADO INDICE PARA AUX_GAC_REMVIP_5874'); 

	V_MSQL := 'CREATE INDEX IDX_AUX_GEH_GEH_ID_5874 ON '||V_ESQUEMA_1||'.AUX_GEH_REMVIP_5874(GEH_ID)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] CREADO INDICE PARA AUX_GEH_REMVIP_5874'); 

	V_MSQL := 'CREATE INDEX IDX_AUX_GAH_GAH_ID_5874 ON '||V_ESQUEMA_1||'.AUX_GAH_REMVIP_5874(GEH_ID)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] CREADO INDICE PARA AUX_GAH_REMVIP_5874'); 

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
