--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-286
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el Trámite de Admisión
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);

    --REGISTRO TFI ELEGIDO
    V_TFI_TAP_CODIGO VARCHAR2(100 CHAR) := '';
    V_TFI_TFI_NOMBRE VARCHAR2(100 CHAR) := 'titulo';

    --CAMPO TFI PARA ACTUALIZAR
    V_TFI_CAMPO VARCHAR2(100 CHAR)  := 'tfi_label';
    V_TFI_VALOR VARCHAR2(4000 CHAR) := '';

  
BEGIN	
	
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO CAMPO '||V_TFI_CAMPO||' DE TABLA TFI PARA T. ADMISIÓN - TITULOS');



-- CAMBIO EN LOS TITULOS DE LAS TAREAS --------------------------------------------------

--T001_CheckingInformacion ----------------------------

  V_TFI_TAP_CODIGO := 'T001_CheckingInformacion';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Para dar por completada esta tarea, deber&aacute; verificar que se han cumplimentado todos los campos b&aacute;sicos de la pesta&ntilde;a "checking de informaci&oacute;n" del activo, anotando a continuaci&oacute;n en la presente pantalla la fecha en que ha cumplimentado y verificado la informaci&oacute;n b&aacute;sica del activo.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  EXECUTE IMMEDIATE V_MSQL;


--T001_CheckingDocumentacionAdmision ----------------------------

  V_TFI_TAP_CODIGO := 'T001_CheckingDocumentacionAdmision';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Para cumplimentar esta tarea deber&aacute; comprobar, en la pesta&ntilde;a "checking de documentaci&oacute;n" del activo, qu&eacute; documentos son necesarios para el activo de que se trate, haciendo constar para ello si aplica o no.</p><p style="margin-bottom: 10px">En el caso de que el documento aplique pero no se desee obtenerlo, deber&aacute; hacer constar un estado en el campo correspondiente, pues de lo contrario la aplicaci&oacute;n volver&aacute; a solicitarlo al finalizar esta tarea.</p><p style="margin-bottom: 10px">En la presente pantalla deber&aacute; anotar la fecha en que ha realizado dicha verificaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p><p style="margin-bottom: 10px">Al finalizar la presente tarea, la aplicaci&oacute;n lanzar&aacute; autom&aacute;ticamente un tr&aacute;mite de obtenci&oacute;n de todos aquellos documentos en los que se haya hecho constar que s&iacute; que aplican y no tengan asignado un estado.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  EXECUTE IMMEDIATE V_MSQL;


--T001_CheckingDocumentacionGestion ----------------------------

  V_TFI_TAP_CODIGO := 'T001_CheckingDocumentacionGestion';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Para cumplimentar esta tarea deber&aacute; comprobar, en la pesta&ntilde;a "checking de documentaci&oacute;n" del activo, qu&eacute; documentos son necesarios para el activo de que se trate, haciendo constar para ello si aplica o no.</p><p style="margin-bottom: 10px">En el caso de que el documento aplique pero no se desee obtenerlo, deber&aacute; hacer constar un estado en el campo correspondiente, pues de lo contrario la aplicaci&oacute;n volver&aacute; a solicitarlo al finalizar esta tarea.</p><p style="margin-bottom: 10px">En la presente pantalla deber&aacute; anotar la fecha en que ha realizado dicha verificaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p><p style="margin-bottom: 10px">Al finalizar la presente tarea, la aplicaci&oacute;n lanzar&aacute; autom&aacute;ticamente un tr&aacute;mite de obtenci&oacute;n de todos aquellos documentos en los que se haya hecho constar que s&iacute; que aplican y no tengan asignado un estado.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  EXECUTE IMMEDIATE V_MSQL;


  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN] TFI ACTUALIZADO CORRECTAMENTE ');

  
EXCEPTION
     WHEN OTHERS THEN
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
