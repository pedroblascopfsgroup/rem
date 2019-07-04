--/*
--#########################################
--## AUTOR=SERGIO GIMENEZ
--## FECHA_CREACION=20190701
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=HREOS-6789
--## PRODUCTO=NO
--## 
--## Finalidad: Actualización tabla AUX_HREOS_6789
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
    V_MSQL VARCHAR2(4000 CHAR);
    TABLE_COUNT NUMBER(1,0) := 0; 
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; 
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
	V_NUM NUMBER(16);
	ERR_NUM NUMBER(25);  
	ERR_MSG VARCHAR2(1024 CHAR); 
	V_TABLA VARCHAR2(30 CHAR):= 'AUX_HREOS_6789_CARTERA';

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = V_TABLA AND OWNER = V_ESQUEMA;

IF TABLE_COUNT > 0 THEN
   EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
   
   DBMS_OUTPUT.PUT_LINE('[INFO] TABLA AUX ELIMINADA');
END IF;

V_MSQL := '
    CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
        ACT_ID NUMBER(16),
        USU_ID_GEE NUMBER(16),
        USU_ID_DIST NUMBER(16),
        GEE_CUR NUMBER(16),
        GEH_CUR NUMBER(16),
        GEH_NEXT NUMBER(16),
        CRA_CARTERA NUMBER(16)
    )
';
EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] TABLA AUX CREADA');

V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
    (ACT_ID,GEE_CUR,USU_ID_GEE, CRA_CARTERA)
    SELECT ACT.ACT_ID, GEE.GEE_ID, GEE.USU_ID, CRA.DD_CRA_ID
    FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE 
    INNER JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GAC.ACT_ID = ACT.ACT_ID
    INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID
    INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEE.DD_TGE_ID = TGE.DD_TGE_ID
    INNER JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    WHERE CRA.DD_CRA_CODIGO IN (''06'', ''10'', ''12'', ''15'')
    AND DD_TGE_CODIGO = ''HAYAGBOINM''
    AND GEE.BORRADO = 0
';
EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] AUX CON  '|| SQL%ROWCOUNT ||' FILAS ');

V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' AUX
    USING(
    SELECT ACT_ID, USU_ID
    FROM '||V_ESQUEMA||'.V_GESTORES_ACTIVO VGES
    INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU
    ON VGES.USERNAME = USU.USU_USERNAME
    WHERE VGES.DD_CRA_CODIGO IN (13)
    AND VGES.DD_SCR_CODIGO IN (41)
    AND VGES.TIPO_GESTOR = ''HAYAGBOINM'') TMP
    ON (TMP.ACT_ID = AUX.ACT_ID)
    WHEN MATCHED THEN UPDATE
    SET AUX.USU_ID_DIST = TMP.USU_ID
';
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' AUX
    USING(
    SELECT DISTINCT ACT_ID, USU_ID
    FROM '||V_ESQUEMA||'.V_GESTORES_ACTIVO VGES
    INNER JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU
    ON VGES.USERNAME = USU.USU_USERNAME
    WHERE VGES.DD_CRA_CODIGO IN (13)
    AND VGES.DD_SCR_CODIGO IN (41)
    AND VGES.TIPO_GESTOR = ''HAYAGBOINM''
    AND VGES.DD_PRV_CODIGO IS NOT NULL) TMP
    ON (TMP.ACT_ID = AUX.ACT_ID)
    WHEN MATCHED THEN UPDATE
    SET AUX.USU_ID_DIST = TMP.USU_ID
';
EXECUTE IMMEDIATE V_MSQL;

-- ELIMINAR LOS DE PROVINCIAS VACÍAS
V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USU_ID_DIST IS NULL'; 
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' AUX
    USING(
    SELECT GEH.GEH_ID, ACT.ACT_ID
    FROM '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
    INNER JOIN '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH ON GAH.GEH_ID = GEH.GEH_ID
    INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON GAH.ACT_ID = ACT.ACT_ID
    INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON ACT.DD_CRA_ID = CRA.DD_CRA_ID
    INNER JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON GEH.DD_TGE_ID = TGE.DD_TGE_ID
    INNER JOIN DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    WHERE CRA.DD_CRA_CODIGO IN (''06'', ''10'', ''11'', ''12'', ''13'', ''15'')
    AND DD_TGE_CODIGO = ''HAYAGBOINM''
    AND GEH.GEH_FECHA_HASTA IS NULL 
    AND GEH.BORRADO = 0
    ) TMP
    ON (TMP.ACT_ID = AUX.ACT_ID)
    WHEN MATCHED THEN UPDATE
    SET AUX.GEH_CUR = TMP.GEH_ID
';
EXECUTE IMMEDIATE V_MSQL;

V_MSQL := '
    UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
    SET GEH_NEXT = S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL 
    WHERE USU_ID_DIST <> USU_ID_GEE
';
EXECUTE IMMEDIATE V_MSQL;


DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS A MODIFICAR:  '|| SQL%ROWCOUNT ||' FILAS ');

-----PASO A TABLAS FINALES
--CAMBIO USUARIO GEE
V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
    USING 
    (SELECT * FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USU_ID_DIST <> USU_ID_GEE ) TMP
    ON (GEE.GEE_ID = TMP.GEE_CUR)
    WHEN MATCHED THEN UPDATE
    SET
    GEE.USU_ID = TMP.USU_ID_DIST,
    GEE.USUARIOMODIFICAR = ''HREOS-6789'',
    GEE.FECHAMODIFICAR = SYSDATE
';
EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS MODIFICADOS GEE:  '|| SQL%ROWCOUNT ||' FILAS ');

--FINALIZAMOS GEH
V_MSQL := '
    MERGE INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH
    USING 
    (SELECT * FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USU_ID_DIST <> USU_ID_GEE ) TMP
    ON (GEH.GEH_ID = TMP.GEH_CUR)
    WHEN MATCHED THEN UPDATE
    SET
    GEH.GEH_FECHA_HASTA = TRUNC(SYSDATE),
    GEH.USUARIOMODIFICAR = ''HREOS-6789'',
    GEH.FECHAMODIFICAR = SYSDATE
';
EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS MODIFICADOS GEH:  '|| SQL%ROWCOUNT ||' FILAS ');

--INSERTAMOS NUEVO GEH

V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST
    (GEH_ID,
    USU_ID,
    DD_TGE_ID,
    GEH_FECHA_DESDE,
    USUARIOCREAR,
    FECHACREAR)
    SELECT GEH_NEXT AS GEH_ID , 
    USU_ID_DIST AS USU_ID,
    (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''HAYAGBOINM''),
    TRUNC(SYSDATE) AS GEH_FECHA_DESDE,
    ''HREOS-6789'' AS USUARIOCREAR,
    SYSDATE AS FECHACREAR
    FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USU_ID_DIST <> USU_ID_GEE
';
EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS INSERTADOS GEH:  '|| SQL%ROWCOUNT ||' FILAS ');

--INSERTAMOS NUEVO GAH
V_MSQL := '
    INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO
    (GEH_ID, ACT_ID)
    SELECT GEH_NEXT AS GEH_ID, ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USU_ID_DIST <> USU_ID_GEE
';
EXECUTE IMMEDIATE V_MSQL;

DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS INSERTADOS GAH:  '|| SQL%ROWCOUNT ||' FILAS ');

COMMIT;

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        DBMS_OUTPUT.put_line(V_MSQL);
        ROLLBACK;
        RAISE;
END;
/
EXIT;
