--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20170131
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1467
--## PRODUCTO=SI
--##
--## Finalidad: Realiza las modificaciones necesarias para el trámite sanción venta - texfield por combo motivo anulación.
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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_TAP_TAREA VARCHAR2(2000 CHAR); -- Tarea a cambiar
    V_TFI_NOMBRE VARCHAR2(1000 CHAR); -- Nombre de campo a cambiar
    V_TFI_COLUMNA VARCHAR2(1000 CHAR); -- Campo a cambiar en TFI
    V_TFI_VALOR_COLUMNA VARCHAR2(2000 CHAR); -- Valor a guardar en TFI
    
    
BEGIN

  
-- Cambio textfield a combo para motivoAnulacion en tarea T013_FirmaPropietario
  V_TAP_TAREA := ' ''T013_FirmaPropietario'' ';
  V_TFI_NOMBRE := ' ''motivoAnulacion'' ';
  V_TFI_COLUMNA := ' TFI_TIPO ';
  V_TFI_VALOR_COLUMNA := ' ''combo'' ';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
        ' SET '||V_TFI_COLUMNA||' = '||V_TFI_VALOR_COLUMNA||' '||
        ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '||V_TAP_TAREA||') ' ||
        '   AND TFI_NOMBRE = '||V_TFI_NOMBRE||' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] En tarea '||V_TAP_TAREA||' se ha actualizado el campo '||V_TFI_NOMBRE||' para dar a la columna '||V_TFI_COLUMNA||' el valor '||V_TFI_VALOR_COLUMNA||'.');

  V_TFI_COLUMNA := ' TFI_BUSINESS_OPERATION ';
  V_TFI_VALOR_COLUMNA := ' ''DDMotivoAnulacionExpediente'' ';
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
			  ' SET '||V_TFI_COLUMNA||' = '||V_TFI_VALOR_COLUMNA||' '||
			  ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '||V_TAP_TAREA||') ' ||
        '   AND TFI_NOMBRE = '||V_TFI_NOMBRE||' ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] En tarea '||V_TAP_TAREA||' se ha actualizado el campo '||V_TFI_NOMBRE||' para dar a la columna '||V_TFI_COLUMNA||' el valor '||V_TFI_VALOR_COLUMNA||'.');


-- Cambio textfield a combo para motivoAnulacion en tarea  T013_ResolucionExpediente
  V_TAP_TAREA := ' ''T013_ResolucionExpediente'' ';
  V_TFI_NOMBRE := ' ''motivoAnulacion'' ';
  V_TFI_COLUMNA := ' TFI_TIPO ';
  V_TFI_VALOR_COLUMNA := ' ''combo'' ';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
        ' SET '||V_TFI_COLUMNA||' = '||V_TFI_VALOR_COLUMNA||' '||
        ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '||V_TAP_TAREA||') ' ||
        '   AND TFI_NOMBRE = '||V_TFI_NOMBRE||' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el orden de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] En tarea '||V_TAP_TAREA||' se ha actualizado el campo '||V_TFI_NOMBRE||' para dar a la columna '||V_TFI_COLUMNA||' el valor '||V_TFI_VALOR_COLUMNA||'.');

  V_TFI_COLUMNA := ' TFI_BUSINESS_OPERATION ';
  V_TFI_VALOR_COLUMNA := ' ''DDMotivoAnulacionExpediente'' ';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
        ' SET '||V_TFI_COLUMNA||' = '||V_TFI_VALOR_COLUMNA||' '||
        ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '||V_TAP_TAREA||') ' ||
        '   AND TFI_NOMBRE = '||V_TFI_NOMBRE||' ';
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el orden de la tarea.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] En tarea '||V_TAP_TAREA||' se ha actualizado el campo '||V_TFI_NOMBRE||' para dar a la columna '||V_TFI_COLUMNA||' el valor '||V_TFI_VALOR_COLUMNA||'.');

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