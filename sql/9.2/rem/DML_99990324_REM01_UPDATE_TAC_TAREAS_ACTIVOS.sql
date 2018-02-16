--/*
--##########################################
--## AUTOR=ALBERTO CAMPOS
--## FECHA_CREACION=20180216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.15
--## INCIDENCIA_LINK=HREOS-3847
--## PRODUCTO=NO
--##
--## Finalidad: Se modifica el gestor y supervisor de la tarea Posicionamiento y firma
--## INSTRUCCIONES:
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
   V_COUNT NUMBER(16); -- Vble. para contar.
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_TABLA VARCHAR2(27 CHAR) := 'TAC_TAREAS_ACTIVOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
   V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-3847';

BEGIN

   DBMS_OUTPUT.PUT_LINE('[INICIO]');

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.tac_tareas_activos mtac USING
    ( SELECT
        tac.tar_id,
        gee.usu_id
    FROM
        '||V_ESQUEMA||'.tac_tareas_activos tac
        INNER JOIN '||V_ESQUEMA||'.tar_tareas_notificaciones tar ON tar.tar_id = tac.tar_id
        INNER JOIN '||V_ESQUEMA||'.tex_tarea_externa tex ON tar.tar_id = tex.tar_id
        INNER JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
        INNER JOIN '||V_ESQUEMA||'.act_tra_tramite att ON tac.tra_id = att.tra_id
        INNER JOIN '||V_ESQUEMA||'.act_tbj_trabajo tbj ON att.tbj_id = tbj.tbj_id
        INNER JOIN '||V_ESQUEMA||'.eco_expediente_comercial eco ON tbj.tbj_id = eco.tbj_id
        INNER JOIN '||V_ESQUEMA||'.gco_gestor_add_eco gco ON eco.eco_id = gco.eco_id
        INNER JOIN '||V_ESQUEMA||'.gee_gestor_entidad gee ON gco.gee_id = gee.gee_id
        INNER JOIN '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge ON gee.dd_tge_id = tge.dd_tge_id
        INNER JOIN '||V_ESQUEMA_M||'.usu_usuarios usu ON gee.usu_id = usu.usu_id
    WHERE
            tar.borrado = 0
        AND
            tar.tar_fecha_fin IS NULL
        AND
            nvl(
                tar.tar_tarea_finalizada,
                0
            ) = 0
        AND
            tap.tap_codigo = ''T013_PosicionamientoYFirma''
        AND
            tge.dd_tge_codigo = ''GFORM''
    )
res ON (
    mtac.tar_id = res.tar_id
) WHEN MATCHED THEN
    UPDATE
SET mtac.usu_id = res.usu_id WHERE
    mtac.usu_id <> res.usu_id';
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' gestores en TAC actualizado');
   
   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.tac_tareas_activos mtac USING
    ( SELECT
        tac.tar_id,
        gee.usu_id
    FROM
        '||V_ESQUEMA||'.tac_tareas_activos tac
        INNER JOIN '||V_ESQUEMA||'.tar_tareas_notificaciones tar ON tar.tar_id = tac.tar_id
        INNER JOIN '||V_ESQUEMA||'.tex_tarea_externa tex ON tar.tar_id = tex.tar_id
        INNER JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
        INNER JOIN '||V_ESQUEMA||'.act_tra_tramite att ON tac.tra_id = att.tra_id
        INNER JOIN '||V_ESQUEMA||'.act_tbj_trabajo tbj ON att.tbj_id = tbj.tbj_id
        INNER JOIN '||V_ESQUEMA||'.eco_expediente_comercial eco ON tbj.tbj_id = eco.tbj_id
        INNER JOIN '||V_ESQUEMA||'.gco_gestor_add_eco gco ON eco.eco_id = gco.eco_id
        INNER JOIN '||V_ESQUEMA||'.gee_gestor_entidad gee ON gco.gee_id = gee.gee_id
        INNER JOIN '||V_ESQUEMA_M||'.dd_tge_tipo_gestor tge ON gee.dd_tge_id = tge.dd_tge_id
        INNER JOIN '||V_ESQUEMA_M||'.usu_usuarios usu ON gee.usu_id = usu.usu_id
    WHERE
            tar.borrado = 0
        AND
            tar.tar_fecha_fin IS NULL
        AND
            nvl(
                tar.tar_tarea_finalizada,
                0
            ) = 0
        AND
            tap.tap_codigo = ''T013_PosicionamientoYFirma''
        AND
            tge.dd_tge_codigo = ''SFORM''
    )
res ON (
    mtac.tar_id = res.tar_id
) WHEN MATCHED THEN
    UPDATE
SET mtac.sup_id = res.usu_id WHERE
    mtac.sup_id <> res.usu_id';
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' supervisores en TAC actualizado');
   
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.PUT_LINE(ERR_MSG);
      ROLLBACK;
      RAISE;
END;
/
EXIT;