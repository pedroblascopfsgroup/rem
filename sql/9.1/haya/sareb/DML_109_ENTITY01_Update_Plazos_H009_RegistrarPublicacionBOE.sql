--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.14-hy-rc01
--## INCIDENCIA_LINK=HR-1622
--## PRODUCTO=NO
--## Finalidad: DML para actualizar los plazos de las tareas
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);
   
BEGIN
	
	-- Update plazo tarea H009_RegistrarProyectoInventario
	V_MSQL := 'UPDATE ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			' SET DD_PTP_PLAZO_SCRIPT = ''valores[''''H009_RegistrarPublicacionBOE''''] == null || valores[''''H009_RegistrarPublicacionBOE''''][''''fecha''''] == null ? 60*24*60*60*1000L : (damePlazo(valores[''''H009_RegistrarPublicacionBOE''''][''''fecha'''']) + 60*24*60*60*1000L)''' ||
			' WHERE TAP_ID IN (SELECT TAP_ID FROM ' || V_ESQUEMA|| '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_RegistrarProyectoInventario'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando plazo de la tarea H009_RegistrarProyectoInventario');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Plazo de la tarea actualizado.');
    
    -- Update plazo tarea H009_RegistrarInsinuacionCreditos
   	V_MSQL := 'UPDATE ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			' SET DD_PTP_PLAZO_SCRIPT = ''valores[''''H009_RegistrarPublicacionBOE''''] == null || valores[''''H009_RegistrarPublicacionBOE''''][''''fecha''''] == null ? 15*24*60*60*1000L : (damePlazo(valores[''''H009_RegistrarPublicacionBOE''''][''''fecha'''']) + 15*24*60*60*1000L)''' ||
			' WHERE TAP_ID IN (SELECT TAP_ID FROM ' || V_ESQUEMA|| '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_RegistrarInsinuacionCreditos'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando plazo de la tarea H009_RegistrarInsinuacionCreditos');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Plazo de la tarea actualizado.');
    
    -- Update plazo tarea H009_PresentarEscritoInsinuacion
   	V_MSQL := 'UPDATE ' || V_ESQUEMA || '.DD_PTP_PLAZOS_TAREAS_PLAZAS' ||
			' SET DD_PTP_PLAZO_SCRIPT = ''valores[''''H009_RegistrarPublicacionBOE''''] == null || valores[''''H009_RegistrarPublicacionBOE''''][''''fecha''''] == null ? 28*24*60*60*1000L : (damePlazo(valores[''''H009_RegistrarPublicacionBOE''''][''''fecha'''']) + 28*24*60*60*1000L)''' ||
			' WHERE TAP_ID IN (SELECT TAP_ID FROM ' || V_ESQUEMA|| '.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''H009_PresentarEscritoInsinuacion'')';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando plazo de la tarea H009_PresentarEscritoInsinuacion');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Plazo de la tarea actualizado.');
     
   COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN-SCRIPT]');
	
EXCEPTION
     
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;