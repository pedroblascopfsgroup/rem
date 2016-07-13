/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20160706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-1415
--## PRODUCTO=NO
--##
--## Finalidad: Modificado plazo
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar   
    V_MSQL_1 VARCHAR2(32000 CHAR); -- Sentencia a ejecutar  
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN   
    
            V_SQL := 'update '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas set usuariomodificar=''RECOVERY-1415'', fechamodificar=sysdate, dd_ptp_plazo_script = ''[''''H005_BPMTramiteSubsanacionEmbargo2''''] != null ? 2*24*60*60*1000L : (damePlazo(valores[''''H005_SolicitudTestimonioDecretoAdjudicacion''''][''''fecha'''']) + 20*24*60*60*1000L)'' where tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''H005_ConfirmarTestimonio'')';
            --DBMS_OUTPUT.PUT_LINE(V_SQL);
            EXECUTE IMMEDIATE V_SQL;    
            DBMS_OUTPUT.PUT_LINE('[INFO] ... Actualizada la tarea');
         
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
