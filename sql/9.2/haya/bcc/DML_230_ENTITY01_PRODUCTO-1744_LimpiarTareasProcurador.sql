--/*
--##########################################
--## AUTOR=OSCAR DORADO
--## FECHA_CREACION=20160609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1744
--## PRODUCTO=NO
--##
--## Finalidad: Actualizacion masiva bie:numero_activo
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN		
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    V_SQL :='delete from '||V_ESQUEMA||'.ter_tarea_externa_Recuperacion where tex_id in (
		select tex.tex_id
		from '||V_ESQUEMA||'.tex_tarea_externa tex
		join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tex.tar_id = tar.tar_id and tar_tarea_finalizada is null and tar_fecha_fin is null
		join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id
		where tap_codigo=''PCO_PreasignarProcurador''
		)';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;

	V_SQL :='delete from '||V_ESQUEMA||'.tex_tarea_externa where tex_id in (
		select tex.tex_id
		from '||V_ESQUEMA||'.tex_tarea_externa tex
		join '||V_ESQUEMA||'.tar_tareas_notificaciones tar on tex.tar_id = tar.tar_id and tar_tarea_finalizada is null and tar_fecha_fin is null
		join '||V_ESQUEMA||'.tap_tarea_procedimiento tap on tex.tap_id = tap.tap_id
		where tap_codigo=''PCO_PreasignarProcurador''
		)';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;

	V_SQL :='delete from '||V_ESQUEMA||'.tar_tareas_notificaciones tar where tar_descripcion =''Preasignar procurador''  and tar_tarea_finalizada is null and tar_fecha_fin is null';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;
    
    COMMIT;
    
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
