--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20201029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11920
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica es estado de los trabajos antiguo al nuevo modelo
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(25 CHAR) := 'HREOS-11920';
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
            USING(
                    WITH NUM_TAREAS AS (
                        SELECT 
                        COUNT(*) NUM
                        , TBJ.TBJ_ID
                        FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ		
                        INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TBJ.TBJ_ID = TRA.TBJ_ID
                        INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
                        INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
                        INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
                        LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.BORRADO = 0
                        WHERE TBJ.BORRADO = 0
                        AND TAP.TAP_CODIGO = ''T004_FijacionPlazo''
                        GROUP BY TBJ.TBJ_ID
                    ) 
                    SELECT 
                    TBJ.TBJ_ID
                    , CASE WHEN NM.NUM = 1 THEN (SELECT EST_NUEVO.DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_NUEVO WHERE EST_NUEVO.DD_EST_CODIGO = ''CUR'')
                    WHEN NM.NUM > 1 THEN (SELECT EST_NUEVO.DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_NUEVO WHERE EST_NUEVO.DD_EST_CODIGO = ''REJ'') END DD_EST_ID
                    FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ		
                    INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TBJ.TBJ_ID = TRA.TBJ_ID
                    INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
                    INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
                    INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
                    LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.BORRADO = 0
                    LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST ON EST.DD_EST_ID = TBJ.DD_EST_ID AND EST.BORRADO = 0
                    LEFT JOIN NUM_TAREAS NM ON NM.TBJ_ID = TBJ.TBJ_ID
                    WHERE TBJ.BORRADO = 0
                    AND TAP.TAP_CODIGO = ''T004_FijacionPlazo'' and TAR.TAR_FECHA_FIN IS NULL AND TAR.TAR_TAREA_FINALIZADA = 0
                    AND EST.FLAG_ACTIVO = 0 AND EST.DD_EST_CODIGO = ''04''
            ) AUX
            ON (TBJ.TBJ_ID = AUX.TBJ_ID)
            WHEN MATCHED THEN
                UPDATE SET 
            TBJ.DD_EST_ID = AUX.DD_EST_ID
            /*, TBJ.USUARIOMODIFICAR = '''||V_USR||'''
            , TBJ.FECHAMODIFICAR = SYSDATE*/';

	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Fijación plazo de ejecución del trabajo: ' || SQL%ROWCOUNT || ' registros actualizados');
	      
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
            USING(
                WITH NUM_TAREAS AS (
                    SELECT 
                    COUNT(*) NUM
                    , TBJ.TBJ_ID
                    FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ		
                    INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TBJ.TBJ_ID = TRA.TBJ_ID
                    INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
                    INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
                    INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
                    LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.BORRADO = 0
                    WHERE TBJ.BORRADO = 0
                    AND TAP.TAP_CODIGO IN (''T004_ResultadoTarificada'',''T004_ResultadoNoTarificada'')
                    GROUP BY TBJ.TBJ_ID
                ) 
                SELECT 
                TBJ.TBJ_ID
                , CASE WHEN NM.NUM = 1 THEN (SELECT EST_NUEVO.DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_NUEVO WHERE EST_NUEVO.DD_EST_CODIGO = ''FIN'')
                WHEN NM.NUM > 1 THEN (SELECT EST_NUEVO.DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_NUEVO WHERE EST_NUEVO.DD_EST_CODIGO = ''SUB'') END DD_EST_ID
                FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ		
                INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TBJ.TBJ_ID = TRA.TBJ_ID
                INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
                INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
                INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
                LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.BORRADO = 0
                LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST ON EST.DD_EST_ID = TBJ.DD_EST_ID AND EST.BORRADO = 0
                LEFT JOIN NUM_TAREAS NM ON NM.TBJ_ID = TBJ.TBJ_ID
                WHERE TBJ.BORRADO = 0
                AND TAP.TAP_CODIGO IN (''T004_ResultadoTarificada'',''T004_ResultadoNoTarificada'') and TAR.TAR_FECHA_FIN IS NULL AND TAR.TAR_TAREA_FINALIZADA = 0
                AND EST.FLAG_ACTIVO = 0 AND EST.DD_EST_CODIGO = ''10''
            ) AUX
            ON (TBJ.TBJ_ID = AUX.TBJ_ID)
            WHEN MATCHED THEN
                UPDATE SET 
            TBJ.DD_EST_ID = AUX.DD_EST_ID
            /*, TBJ.USUARIOMODIFICAR = '''||V_USR||'''
            , TBJ.FECHAMODIFICAR = SYSDATE*/';

	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Resultado actuación técnica tarificada y Resultado actuación técnica no tarificada: ' || SQL%ROWCOUNT || ' registros actualizados');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
        USING(
            WITH NUM_TAREAS AS (
                SELECT 
                COUNT(*) NUM
                , TBJ.TBJ_ID
                FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ		
                INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TBJ.TBJ_ID = TRA.TBJ_ID
                INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
                INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
                INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
                LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.BORRADO = 0
                WHERE TBJ.BORRADO = 0
                AND TAP.TAP_CODIGO IN (''T002_SolicitudDocumentoGestoria'')
                GROUP BY TBJ.TBJ_ID
            ) 
            SELECT 
            TBJ.TBJ_ID
            , CASE WHEN NM.NUM = 1 THEN (SELECT EST_NUEVO.DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_NUEVO WHERE EST_NUEVO.DD_EST_CODIGO = ''CUR'')
            WHEN NM.NUM > 1 THEN (SELECT EST_NUEVO.DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_NUEVO WHERE EST_NUEVO.DD_EST_CODIGO = ''REJ'') END DD_EST_ID
            FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ		
            INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TBJ.TBJ_ID = TRA.TBJ_ID
            INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
            INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
            INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
            LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST ON EST.DD_EST_ID = TBJ.DD_EST_ID AND EST.BORRADO = 0
            LEFT JOIN NUM_TAREAS NM ON NM.TBJ_ID = TBJ.TBJ_ID
            WHERE TBJ.BORRADO = 0
            AND TAP.TAP_CODIGO IN (''T002_SolicitudDocumentoGestoria'') and TAR.TAR_FECHA_FIN IS NULL AND TAR.TAR_TAREA_FINALIZADA = 0
            AND EST.FLAG_ACTIVO = 0 AND EST.DD_EST_CODIGO = ''04''
        ) AUX
        ON (TBJ.TBJ_ID = AUX.TBJ_ID)
        WHEN MATCHED THEN
            UPDATE SET 
        TBJ.DD_EST_ID = AUX.DD_EST_ID
        /*, TBJ.USUARIOMODIFICAR = '''||V_USR||'''
        , TBJ.FECHAMODIFICAR = SYSDATE*/';

	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Solicitud documento por proveedor: ' || SQL%ROWCOUNT || ' registros actualizados');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
        USING(
            WITH NUM_TAREAS AS (
                SELECT 
                COUNT(*) NUM
                , TBJ.TBJ_ID
                FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ		
                INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TBJ.TBJ_ID = TRA.TBJ_ID
                INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
                INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
                INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
                LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.BORRADO = 0
                WHERE TBJ.BORRADO = 0
                AND TAP.TAP_CODIGO IN (''T002_SolicitudLPOGestorInterno'',''T008_SolicitudDocumento'')
                GROUP BY TBJ.TBJ_ID
            ) 
            SELECT 
            TBJ.TBJ_ID
            , CASE WHEN NM.NUM = 1 THEN (SELECT EST_NUEVO.DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_NUEVO WHERE EST_NUEVO.DD_EST_CODIGO = ''CUR'')
            WHEN NM.NUM > 1 THEN (SELECT EST_NUEVO.DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_NUEVO WHERE EST_NUEVO.DD_EST_CODIGO = ''REJ'') END DD_EST_ID
            FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ		
            INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TBJ.TBJ_ID = TRA.TBJ_ID
            INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
            INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
            INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
            LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST ON EST.DD_EST_ID = TBJ.DD_EST_ID AND EST.BORRADO = 0
            LEFT JOIN NUM_TAREAS NM ON NM.TBJ_ID = TBJ.TBJ_ID
            WHERE TBJ.BORRADO = 0
            AND TAP.TAP_CODIGO IN (''T002_SolicitudLPOGestorInterno'',''T008_SolicitudDocumento'') and TAR.TAR_FECHA_FIN IS NULL AND TAR.TAR_TAREA_FINALIZADA = 0
            AND EST.FLAG_ACTIVO = 0 AND EST.DD_EST_CODIGO = ''04''
        ) AUX
        ON (TBJ.TBJ_ID = AUX.TBJ_ID)
        WHEN MATCHED THEN
            UPDATE SET 
        TBJ.DD_EST_ID = AUX.DD_EST_ID
        /*, TBJ.USUARIOMODIFICAR = '''||V_USR||'''
        , TBJ.FECHAMODIFICAR = SYSDATE*/';

	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Solicitud documento por Gestor Interno y  Solicitud Cédula por gestoría: ' || SQL%ROWCOUNT || ' registros actualizados');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
        USING(
            WITH NUM_TAREAS AS (
                SELECT 
                COUNT(*) NUM
                , TBJ.TBJ_ID
                FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ		
                INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TBJ.TBJ_ID = TRA.TBJ_ID
                INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
                INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
                INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
                LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.BORRADO = 0
                WHERE TBJ.BORRADO = 0
                AND TAP.TAP_CODIGO IN (''T002_ObtencionDocumentoGestoria'')
                GROUP BY TBJ.TBJ_ID
            ) 
            SELECT 
            TBJ.TBJ_ID
            , CASE WHEN NM.NUM = 1 THEN (SELECT EST_NUEVO.DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_NUEVO WHERE EST_NUEVO.DD_EST_CODIGO = ''FIN'')
            WHEN NM.NUM > 1 THEN (SELECT EST_NUEVO.DD_EST_ID FROM '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_NUEVO WHERE EST_NUEVO.DD_EST_CODIGO = ''SUB'') END DD_EST_ID
            FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ		
            INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TBJ.TBJ_ID = TRA.TBJ_ID
            INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
            INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
            INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
            LEFT JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID AND TAP.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST ON EST.DD_EST_ID = TBJ.DD_EST_ID AND EST.BORRADO = 0
            LEFT JOIN NUM_TAREAS NM ON NM.TBJ_ID = TBJ.TBJ_ID
            WHERE TBJ.BORRADO = 0
            AND TAP.TAP_CODIGO IN (''T002_ObtencionDocumentoGestoria'') and TAR.TAR_FECHA_FIN IS NULL AND TAR.TAR_TAREA_FINALIZADA = 0
            AND EST.FLAG_ACTIVO = 0 AND EST.DD_EST_CODIGO = ''10''
        ) AUX
        ON (TBJ.TBJ_ID = AUX.TBJ_ID)
        WHEN MATCHED THEN
            UPDATE SET 
        TBJ.DD_EST_ID = AUX.DD_EST_ID
        /*, TBJ.USUARIOMODIFICAR = '''||V_USR||'''
        , TBJ.FECHAMODIFICAR = SYSDATE*/';

	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Obtencion documento por proveedor: ' || SQL%ROWCOUNT || ' registros actualizados');
	
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                USING(
                SELECT TRANSICION.TBJ_ID, EST_FINAL.DD_EST_ID
                FROM(SELECT 
                TBJ.TBJ_ID
                , EST.DD_EST_CODIGO ANTERIOR
                , DECODE(EST.DD_EST_CODIGO
                , ''01'', ''CUR''
                , ''02'', ''CAN''
                , ''04'', ''CUR''
                , ''05'', ''13''
                , ''06'', ''CIE''
                , ''14'', ''CIE''
                ) NUEVO
                FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST ON TBJ.DD_EST_ID = EST.DD_EST_ID AND EST.BORRADO = 0
                WHERE TBJ.BORRADO = 0 AND EST.FLAG_ACTIVO = 0) TRANSICION
                LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_FINAL ON TRANSICION.NUEVO = EST_FINAL.DD_EST_CODIGO AND EST_FINAL.BORRADO = 0 
                WHERE TRANSICION.NUEVO IS NOT NULL
                ) AUX
                ON (TBJ.TBJ_ID = AUX.TBJ_ID)
                WHEN MATCHED THEN
                    UPDATE SET 
                TBJ.DD_EST_ID = AUX.DD_EST_ID
                /*, TBJ.USUARIOMODIFICAR = '''||V_USR||'''
                , TBJ.FECHAMODIFICAR = SYSDATE*/';

	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Estados de trabajos nuevos: ' || SQL%ROWCOUNT || ' registros actualizados');
	      
  	DBMS_OUTPUT.PUT_LINE(' [INFO] REGISTROS MODIFICADOS CORRECTAMENTE');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] TABLA ACTUALIZADA CORRECTAMENTE ');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
