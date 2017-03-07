--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170307
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1603
--## PRODUCTO=NO
--##
--## Finalidad: Script que MODIFICA a 'Fecha designación' el TFI_LABEL y TFI_ERROR_VALIDACION en la tabla TFI_TAREAS_FORM_ITEMS
--## INSTRUCCIONES:
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TFI_NOMBRE VARCHAR2(50 CHAR);
    
        --REGISTRO TFI ELEGIDO
    V_TFI_TAP_CODIGO VARCHAR2(100 CHAR) := '';
    V_TFI_TFI_NOMBRE VARCHAR2(100 CHAR) := 'fechaAsignacion';

    --CAMPO TFI PARA ACTUALIZAR
    V_TFI_CAMPO VARCHAR2(100 CHAR)  := 'TFI_LABEL';
    V_TFI_VALOR VARCHAR2(4000 CHAR) := '';
        --CAMPO TFI PARA ACTUALIZAR
    V_TFI_CAMPO2 VARCHAR2(100 CHAR)  := 'TFI_ERROR_VALIDACION';
    V_TFI_VALOR2 VARCHAR2(4000 CHAR) := '';

    
BEGIN

	V_TFI_TAP_CODIGO := 'T009_SancionCargaPropuesta';
	V_TFI_TFI_NOMBRE := 'observaciones';
	V_TFI_CAMPO := 'TFI_LABEL';
	V_TFI_VALOR := 'Observaciones';
	V_TFI_CAMPO2 := 'TFI_ERROR_VALIDACION';
	V_TFI_VALOR2 := NULL;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	   SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''', '||V_TFI_CAMPO2||'='''||V_TFI_VALOR2||''' 
	   WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
	     AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
	   ';
	
	DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando .......');
	EXECUTE IMMEDIATE V_MSQL;
	
		V_TFI_TAP_CODIGO := 'T011_RevisionInformeComercial';
	V_TFI_TFI_NOMBRE := 'titulo';
	V_TFI_CAMPO := 'TFI_LABEL';
	V_TFI_VALOR := '<p style="margin-bottom: 10px">Si acepta el informe comercial y el activo cuenta con la conformidad de los departamentos de Admisión y Gestión, simultáneamente podrá conferirle al activo la cualidad de publicable, seleccionando "Sí" en el campo "Continuar con el proceso de publicación", siempre y cuando haya completado la información necesaria en la pestaña "Datos de publicación" del activo.</p><p style="margin-bottom: 10px">Si acepta el informe y la tipología del activo que refleja el informe no coincide con la que figura actualmente en REM, se lanzará una tarea de verificación al gestor de admisión.</p><p style="margin-bottom: 10px">Si acepta el informe sin contar con la conformidad de los departamentos citados, o acepta pero paralizando el proceso de publicación, tendrá que acceder, desde módulo Publicación del menú lateral, al listado de activos no publicados para continuar el proceso de publicación.</p><p style="margin-bottom: 10px">Si rechaza el informe comercial, los datos recibidos quedarán almacenados pero el informe constará como rechazado. En este caso deberá indicar el motivo que ha generado este rechazo, que le será notificado al emisor para su corrección.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';
	V_TFI_CAMPO2 := 'TFI_ERROR_VALIDACION';
	V_TFI_VALOR2 := NULL;
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	   SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''', '||V_TFI_CAMPO2||'='''||V_TFI_VALOR2||''' 
	   WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
	     AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
	   ';
	
	DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando .......');
	EXECUTE IMMEDIATE V_MSQL;
	
	V_TFI_TAP_CODIGO := 'T001_DesignarMediador';
	V_TFI_TFI_NOMBRE := 'fechaAsignacion';
	V_TFI_CAMPO := 'TFI_LABEL';
	V_TFI_VALOR := 'Fecha designaci&oacute;n';
	V_TFI_CAMPO2 := 'TFI_ERROR_VALIDACION';
	V_TFI_VALOR2 := 'Debe indicar fecha de designaci&oacute;n';
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	   SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''', '||V_TFI_CAMPO2||'='''||V_TFI_VALOR2||''' 
	   WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
	     AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
	   ';
	
	DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando .......');
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizado correctamente! .......');
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