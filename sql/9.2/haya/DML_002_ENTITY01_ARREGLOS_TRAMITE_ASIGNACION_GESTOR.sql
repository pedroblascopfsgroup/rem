--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160315
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-763
--## PRODUCTO=SI
--## Finalidad: Actualizar TAREA Y TFI ASOCIADOS.
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	--TAP_TAREA_PROCEDIMIENTO
	V_MSQL:= 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET TAP_VIEW=NULL, TAP_DESCRIPCION=''Asignar Gestor Expediente'' '||
	' WHERE TAP_CODIGO = ''H067_SeleccionarProcedimientoAsignarGestor''';
	
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
		
	
	--TFI_TAREAS_FORM_ITEMS
	V_MSQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_TIPO=''combo'' and '||
	' TAP_ID=(select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''H067_SeleccionarProcedimientoAsignarGestor'') ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
		--BORAMOS el campo tipo combo que no se requiere en esta tarea
		V_MSQL:= 'DELETE FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TFI_TIPO=''combo'' and '||
			' TAP_ID=(select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''H067_SeleccionarProcedimientoAsignarGestor'') ';
		EXECUTE IMMEDIATE V_MSQL;
		
		-- Y actualizamos el TFI_ORDEN de los campos restantes
		V_MSQL:= 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN=0 '||
			' WHERE TAP_ID=(select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''H067_SeleccionarProcedimientoAsignarGestor'') '||
			' AND tfi_nombre=''titulo'' ';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL:= 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN=1 '||
			' WHERE TAP_ID=(select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''H067_SeleccionarProcedimientoAsignarGestor'') '||
			' AND tfi_nombre=''fecha'' ';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL:= 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS SET TFI_ORDEN=2 '||
			' WHERE TAP_ID=(select tap_id from '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO where TAP_CODIGO=''H067_SeleccionarProcedimientoAsignarGestor'') '||
			' AND tfi_nombre=''observaciones'' ';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registros actualizados en '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS');
	END IF;
COMMIT;

EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          
END;
/
EXIT	
