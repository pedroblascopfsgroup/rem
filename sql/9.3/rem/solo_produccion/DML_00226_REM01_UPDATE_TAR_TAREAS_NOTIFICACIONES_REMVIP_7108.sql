--/*
--######################################### 
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20200422
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7108
--## PRODUCTO=NO
--## 
--## Finalidad: 
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	PL_OUTPUT VARCHAR2(32000 CHAR);

	V_COUNT NUMBER(25);
	
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] BORRADO LOGICO DE TAREAS');

	execute immediate 'create table '||V_ESQUEMA||'.TAREAS_REMVIP_7108 as SELECT tar.*, eco.eco_num_expediente
						FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR 
						left join '||V_ESQUEMA||'.tac_tareas_activos tac on tac.tar_id = tar.tar_id 
						left join '||V_ESQUEMA||'.act_tra_tramite tra on tra.tra_id = tac.tra_id
						left join '||V_ESQUEMA||'.act_tbj_trabajo tbj on tbj.tbj_id = tra.tbj_id
						left join '||V_ESQUEMA||'.eco_expediente_comercial eco on eco.tbj_id = tbj.tbj_id
						WHERE TAR.USUARIOCREAR = ''REMVIP-6940'' AND TAR_TAREA = ''Recomendación Advisory''';

    
    EXECUTE IMMEDIATE 'update '||V_ESQUEMA||'.tar_tareas_notificaciones set 
						usuarioborrar = ''REMVIP-7108'',
						fechaborrar = sysdate,
						borrado = 1,
						tar_fecha_fin = sysdate,
						tar_tarea_finalizada = 1
						where tar_id in (SELECT distinct tar.tar_id
						FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR 
						left join '||V_ESQUEMA||'.tac_tareas_activos tac on tac.tar_id = tar.tar_id 
						left join '||V_ESQUEMA||'.act_tra_tramite tra on tra.tra_id = tac.tra_id
						left join '||V_ESQUEMA||'.act_tbj_trabajo tbj on tbj.tbj_id = tra.tbj_id
						left join '||V_ESQUEMA||'.eco_expediente_comercial eco on eco.tbj_id = tbj.tbj_id
						WHERE TAR.USUARIOCREAR = ''REMVIP-6940'' AND TAR_TAREA = ''Recomendación Advisory'' and tar.borrado = 0)';

						DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en TAR_TAREAS_NOTIFICACIONES. Deberian ser 51 ');  

						COMMIT;

	v_msql := 'select count(1) FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR WHERE TAR.USUARIOCREAR = ''REMVIP-6940'' AND TAR_TAREA = ''Recomendación Advisory'' and tar.borrado = 0';
	execute immediate v_msql into v_count;

	DBMS_OUTPUT.PUT_LINE('[INFO] Quedan '||V_COUNT||' registros por borrar ');  


    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
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
