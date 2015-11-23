--/*
--##########################################
--## AUTOR=José Luis Gauxachs
--## FECHA_CREACION=20151117
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.11-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-383
--## PRODUCTO=NO
--## Finalidad: DML para actualizar las validaciones de la tarea PCO_AsignacionGestores
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
	
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO' ||
			  ' SET TAP_SCRIPT_VALIDACION = ''existenGestoresCorrectos() ? null : ''''<div align="justify" style="font-size:8pt; font-family:Arial; margin-bottom:10px;">El asunto debe tener asignado Letrado, Supervisor del asunto, Director unidad de litigio y Preparador documental.</div>''''''' ||
			  ', TAP_SCRIPT_DECISION = null' ||
			  ' WHERE TAP_CODIGO = ''PCO_AsignacionGestores''';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando la validacion de la tarea PCO_AsignacionGestores');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Validacion de la tarea actualizada.');
    
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
