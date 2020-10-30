--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20201029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8111
--## PRODUCTO=NO
--##
--## Finalidad: Finaliar tareas Informe Jurídico vivas y lanzar trámite a ultima versión T013 y T017
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8111';

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'merge into '||V_ESQUEMA||'.tar_tareas_notificaciones t1
                using (
                    select distinct tar.tar_id
                    from '||V_ESQUEMA||'.eco_expediente_comercial eco
                    JOIN '||V_ESQUEMA||'.act_tbj_trabajo tbj on tbj.tbj_id = eco.tbj_id and tbj.borrado = 0
                    JOIN '||V_ESQUEMA||'.act_tra_tramite tra on tra.tbj_id = tbj.tbj_id and tra.borrado = 0
                    JOIN '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id = tra.dd_tpo_id and dd_tpo_codigo in (''T013'', ''T017'')
                    JOIN '||V_ESQUEMA||'.tac_tareas_activos tac on tac.tra_id = tra.tra_id and tac.borrado = 0
                    JOIN '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tar.tar_id = tac.tar_id and tar.borrado = 0
                    JOIN '||V_ESQUEMA||'.tex_tarea_externa tex on tex.tar_id = tar.tar_id and tex.borrado = 0
                    JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tap.tap_id = tex.tap_id 
                    WHERE TAP.TAP_CODIGO in (''T013_InformeJuridico'', ''T017_InformeJuridico'')
                ) t2
                on (t1.tar_id = t2.tar_id)
                when matched then UPDATE SET
                    TAR_FECHA_FIN = sysdate,
                    TAR_TAREA_FINALIZADA = 1,
                    USUARIOMODIFICAR = '''||V_USUARIO||''',
                    FECHAMODIFICAR = sysdate';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'merge into '||V_ESQUEMA||'.tac_tareas_activos t1
                using (
                    select distinct tar.tar_id
                    from '||V_ESQUEMA||'.eco_expediente_comercial eco
                    join '||V_ESQUEMA||'.act_tbj_trabajo tbj on tbj.tbj_id = eco.tbj_id and tbj.borrado = 0
                    join '||V_ESQUEMA||'.act_tra_tramite tra on tra.tbj_id = tbj.tbj_id and tra.borrado = 0
                    join '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo on tpo.dd_tpo_id = tra.dd_tpo_id and dd_tpo_codigo in (''T013'', ''T017'')
                    join '||V_ESQUEMA||'.tac_tareas_activos tac on tac.tra_id = tra.tra_id and tac.borrado = 0
                    join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tar.tar_id = tac.tar_id and tar.borrado = 0
                    join '||V_ESQUEMA||'.tex_tarea_externa tex on tex.tar_id = tar.tar_id and tex.borrado = 0
                    join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tap.tap_id = tex.tap_id and TAP.TAP_CODIGO in (''T013_InformeJuridico'', ''T017_InformeJuridico'')
                ) t2
                on (t1.tar_id = t2.tar_id)
                when matched then UPDATE SET
                    USUARIOBORRAR = '''||V_USUARIO||''',
                    FECHABORRAR = sysdate,
                    borrado = 1';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'CALL '||V_ESQUEMA||'.TRAMITE_A_ULTIMA_VERSION(''T013'')';
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'CALL '||V_ESQUEMA||'.TRAMITE_A_ULTIMA_VERSION(''T017'')';
    EXECUTE IMMEDIATE V_MSQL;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;