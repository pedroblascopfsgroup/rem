--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200114
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6174
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas backup 
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
V_TABLA1 VARCHAR2(40 CHAR) := 'AUX_TBJ_TAR_EXCEL_REMVIP_6174';
V_TABLA2 VARCHAR2(40 CHAR) := 'AUX_TBJ_TAR_NO_EXCEL_REMVIP_6174';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA1||'' AND OWNER= ''||V_ESQUEMA_1||'';
IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA1||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA1||'';
END IF;
EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA1||' AS 
  ( SELECT DISTINCT TAR.TAR_ID, TBJ.TBJ_NUM_TRABAJO, TAP.TAP_CODIGO, TAC.USU_ID AS USU_TAC, TBJ.TBJ_RESPONSABLE_TRABAJO, TBJ.TBJ_GESTOR_ACTIVO_RESPONSABLE, ACT.ACT_NUM_ACTIVO
	FROM REM01.TAC_TAREAS_ACTIVOS TAC
	INNER JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TAC.TAR_ID = TAR.TAR_ID 
	INNER JOIN REM01.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID
	INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = TAC.ACT_ID 
	INNER JOIN REM01.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAC.TAR_ID
	INNER JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
	INNER JOIN REMMASTER.USU_USUARIOS USU ON TAC.USU_ID = USU.USU_ID
	INNER JOIN REM01.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = TRA.TBJ_ID 
    INNER JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON ACT.ACT_ID = GAC.ACT_ID 
    INNER JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.DD_TGE_ID = 362
    /*INNER JOIN REM01.AUX_REMVIP_5874 AUX ON TBJ.TBJ_NUM_TRABAJO = AUX.NUM_TRABAJO*/
    WHERE TRA.DD_EPR_ID = 30 
    AND (ACT.DD_CRA_ID = 21 OR ACT.DD_CRA_ID = 43) 
    AND TAP.DD_TGE_ID = 362 
    AND TAR.BORRADO = 0
    AND USU.USU_USERNAME <> ''usugruhpm'' 
    AND (TAP.TAP_CODIGO NOT LIKE ''%Result%'' 
        and TAP.TAP_CODIGO NOT LIKE ''%T003_EmisionCertificado%'' 
        and TAP.TAP_CODIGO NOT LIKE ''%T003_SolicitudEtiqueta%''
        and TAP.TAP_CODIGO NOT LIKE ''%T003_ObtencionEtiqueta%'' 
        and TAP.TAP_CODIGO NOT LIKE ''%T014_PosicionamientoFirma%'' 
        and TAP.TAP_CODIGO NOT LIKE ''%T014_DefinicionOferta%'')
    AND (TBJ.TBJ_GESTOR_ACTIVO_RESPONSABLE <> 50479 OR TBJ.TBJ_RESPONSABLE_TRABAJO <> 50479) 
    AND GEE.USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = ''grupgact'')
    AND TBJ.TBJ_RESPONSABLE_TRABAJO <> 87960
  ) ';

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA1||' CREADA');  

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA2||'' AND OWNER= ''||V_ESQUEMA_1||'';
IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA2||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA2||'';
END IF;
EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA2||' AS 
  ( 	SELECT DISTINCT TAR.TAR_ID,  TBJ.TBJ_NUM_TRABAJO,TAP.TAP_CODIGO, TBJ.USUARIOMODIFICAR, TAC.USU_ID AS USU_TAC, TBJ.TBJ_RESPONSABLE_TRABAJO, TBJ.TBJ_GESTOR_ACTIVO_RESPONSABLE, ACT.ACT_NUM_ACTIVO
        FROM  REM01.TAC_TAREAS_ACTIVOS TAC
        INNER JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR ON TAC.TAR_ID = TAR.TAR_ID 
        INNER JOIN REM01.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID
        INNER JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = TAC.ACT_ID 
        INNER JOIN REM01.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAC.TAR_ID
        INNER JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
        INNER JOIN REMMASTER.USU_USUARIOS USU ON TAC.USU_ID = USU.USU_ID
        INNER JOIN REM01.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = TRA.TBJ_ID 
        INNER JOIN REM01.GAC_GESTOR_ADD_ACTIVO GAC ON ACT.ACT_ID = GAC.ACT_ID 
        INNER JOIN REM01.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.DD_TGE_ID = 362
        WHERE TRA.DD_EPR_ID = 30 
        AND (ACT.DD_CRA_ID = 21 OR ACT.DD_CRA_ID = 43) 
        AND TAP.DD_TGE_ID = 362 
        AND TAR.BORRADO = 0
        AND USU.USU_USERNAME <> ''usugruhpm''
        AND (TAP.TAP_CODIGO NOT LIKE ''%Result%'' 
            and TAP.TAP_CODIGO NOT LIKE ''%T003_EmisionCertificado%''
            and TAP.TAP_CODIGO NOT LIKE ''%T003_SolicitudEtiqueta%''
            and TAP.TAP_CODIGO NOT LIKE ''%T003_ObtencionEtiqueta%''
            and TAP.TAP_CODIGO NOT LIKE ''%T014_PosicionamientoFirma%'' 
            and TAP.TAP_CODIGO NOT LIKE ''%T014_DefinicionOferta%'')
		AND ((TBJ.TBJ_GESTOR_ACTIVO_RESPONSABLE <> 50479 OR TBJ.TBJ_RESPONSABLE_TRABAJO <> 50479) OR TBJ.TBJ_GESTOR_ACTIVO_RESPONSABLE IS NULL)
		AND (TBJ.ACT_ID IS NOT NULL AND TBJ.AGR_ID IS NULL) 
		AND GEE.USU_ID = (SELECT USU_ID FROM REMMASTER.USU_USUARIOS WHERE USU_USERNAME = ''grupgact'') 
        AND TBJ.TBJ_RESPONSABLE_TRABAJO <> 87960
  ) ';

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA2||' CREADA');  

IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA1||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA1||' OTORGADOS A '||V_ESQUEMA_2||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA2||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA2||' OTORGADOS A '||V_ESQUEMA_2||''); 

END IF;


IF V_ESQUEMA_4 != V_ESQUEMA_1 THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA1||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA1||' OTORGADOS A '||V_ESQUEMA_4||''); 
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA2||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA2||' OTORGADOS A '||V_ESQUEMA_4||''); 

END IF;

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
