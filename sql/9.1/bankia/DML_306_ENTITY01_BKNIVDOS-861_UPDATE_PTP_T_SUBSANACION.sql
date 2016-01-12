--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160112
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.19-bk
--## INCIDENCIA_LINK=BKNIVDOS-861
--## PRODUCTO=NO
--##
--## Finalidad: Actualiza campo de calculo de plazos para una tarea migrada sin existir tareas anteriores y que no falle
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
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION PTP P413_ConfirmarTestimonio');
    V_SQL := 
    'UPDATE '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas ptp
        SET ptp.dd_ptp_plazo_script = ''((valores[''''P413_SolicitudTestimonioDecretoAdjudicacion''''] != null && valores[''''P413_SolicitudTestimonioDecretoAdjudicacion''''][''''fecha'''']) != '''''''' && (valores[''''P413_SolicitudTestimonioDecretoAdjudicacion''''][''''fecha''''] != null)) ? damePlazo(valores[''''P413_SolicitudTestimonioDecretoAdjudicacion''''][''''fecha''''])+30*24*60*60*1000L : 30*24*60*60*1000L''
        WHERE ptp.dd_ptp_id         =
            (SELECT ptp1.dd_ptp_id
            FROM '||V_ESQUEMA||'.dd_ptp_plazos_tareas_plazas ptp1
            INNER JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap1
            ON ptp1.tap_id = tap1.tap_id
            WHERE tap1.tap_codigo = ''P413_ConfirmarTestimonio''
            )
    ';
    EXECUTE IMMEDIATE V_SQL;
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION PTP P413_ConfirmarTestimonio' );    

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