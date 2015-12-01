--/*
--##########################################
--## AUTOR=OSCAR
--## FECHA_CREACION=20151125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.18-bk
--## INCIDENCIA_LINK=BKREC-1408
--## PRODUCTO=NO
--## Finalidad: DML
--## 
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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

BEGIN

     DBMS_OUTPUT.PUT_LINE('[INICIO]');

     --procedimientos a estado Cerrado
	execute immediate 'UPDATE '||V_ESQUEMA||'.prc_procedimientos set usuariomodificar= ''BKREC-1408'', fechamodificar= sysdate, DD_EPR_ID = (select dd_epr_id from bankmaster.dd_epr_estado_procedimiento where dd_epr_descripcion = ''Cerrado'')
		where prc_id in (
		select distinct prc.prc_id
		from '||V_ESQUEMA||'.asu_asuntos asu
		join '||V_ESQUEMA||'.prc_procedimientos prc on asu.asu_id = prc.asu_id and asu.borrado = 0 and prc.borrado = 0
		join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on prc.prc_id = tar.prc_id and tar.TAR_FECHA_FIN is null and (tar_tarea_finalizada is null or tar_tarea_finalizada = 0) and tar.borrado = 0
		join '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on asu.dd_pas_id = pas.dd_pas_id 
		where pas.dd_pas_descripcion = ''SAREB''
		)';

--Finalizamos tareas externas
	execute immediate 'UPDATE '||V_ESQUEMA||'.tex_tarea_externa set usuariomodificar= ''BKREC-1408'', fechamodificar= sysdate, usuarioborrar= ''BKREC-1408'', fechaborrar = sysdate, borrado = 1
		where tar_id in (
		select distinct tar_id
		from '||V_ESQUEMA||'.asu_asuntos asu
		join '||V_ESQUEMA||'.prc_procedimientos prc on asu.asu_id = prc.asu_id and asu.borrado = 0 and prc.borrado = 0
		join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on prc.prc_id = tar.prc_id and tar.TAR_FECHA_FIN is null and (tar_tarea_finalizada is null or tar_tarea_finalizada = 0) and tar.borrado = 0
		join '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on asu.dd_pas_id = pas.dd_pas_id 
		where pas.dd_pas_descripcion = ''SAREB''
		)';

--Finalizamos tareas
	execute immediate 'UPDATE '||V_ESQUEMA||'.tar_tareas_notificaciones set usuariomodificar= ''BKREC-1408'', fechamodificar= sysdate, tar_tarea_finalizada = 1, tar_fecha_fin = sysdate
		where tar_id in (
		select distinct tar_id
		from '||V_ESQUEMA||'.asu_asuntos asu
		join '||V_ESQUEMA||'.prc_procedimientos prc on asu.asu_id = prc.asu_id and asu.borrado = 0 and prc.borrado = 0
		join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on prc.prc_id = tar.prc_id and tar.TAR_FECHA_FIN is null and (tar_tarea_finalizada is null or tar_tarea_finalizada = 0) and tar.borrado = 0
		join '||V_ESQUEMA||'.dd_pas_propiedad_asunto pas on asu.dd_pas_id = pas.dd_pas_id 
		where pas.dd_pas_descripcion = ''SAREB''
		)';
    
    COMMIT;
    
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          
END;
/
EXIT;