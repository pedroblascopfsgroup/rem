--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11233
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  SELECT ACT.ACT_NUM_ACTIVO,TAP.TAP_CODIGO, TAC.TAR_ID,USU_TAC.USU_ID,
--##                 USU_TAC.USU_USERNAME AS USUARIO_TAREA, USU_ACT.USU_ID, USU_ACT.USU_USERNAME AS GESTOR_ALQUILER
--##                 SACAMOS ACTIVO, TAREA, USUARIO DE LA TAREA Y USUARIO GESTOR QUE DEBERIA TENERLA
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejECVtar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(30 CHAR) := 'REMVIP-11233';
	V_TEXT_TABLA VARCHAR2(50 CHAR) := 'TAC_TAREAS_ACTIVOS';
    V_GESTOR_COD VARCHAR2(50 CHAR) := 'GESTCOMALQ';
    V_CRA_COD VARCHAR2(50 CHAR) := '03';
    V_TPO_COD VARCHAR2(50 CHAR) := 'T015';
    
BEGIN

	 -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN '||V_TEXT_TABLA||'');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
                    SELECT TAC.TAR_ID,USU_ACT.USU_ID
                    FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' TAC
                    JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID AND TAR.TAR_TAREA_FINALIZADA = 0 AND TAR.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAC.TAR_ID AND TEX.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID AND TAP.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO ON TPO.DD_TPO_ID = TAP.DD_TPO_ID AND TPO.BORRADO = 0 AND TPO.DD_TPO_CODIGO = '''||V_TPO_COD||'''
                    JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU_TAC ON USU_TAC.USU_ID = TAC.USU_ID AND USU_TAC.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TAC.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
                    JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0 AND CRA.DD_CRA_CODIGO = '''||V_CRA_COD||'''
                    JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = ACT.ACT_ID
                    JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE ON GEE.GEE_ID = GAC.GEE_ID AND GEE.BORRADO = 0
                    JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.BORRADO = 0 AND TGE.DD_TGE_CODIGO = '''||V_GESTOR_COD||'''
                    JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU_ACT ON USU_ACT.USU_ID = GEE.USU_ID AND USU_ACT.BORRADO = 0
                    AND TAC.BORRADO = 0 AND USU_TAC.USU_ID != USU_ACT.USU_ID) T2
                ON (T1.TAR_ID = T2.TAR_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.USU_ID = T2.USU_ID,
                T1.USUARIOMODIFICAR = '''||V_USU||''',
                T1.FECHAMODIFICAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '||SQL%ROWCOUNT||' REGISTROS EN '||V_TEXT_TABLA||'');

    COMMIT;

EXCEPTION
     WHEN OTHERS THEN 
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejECVción:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT;