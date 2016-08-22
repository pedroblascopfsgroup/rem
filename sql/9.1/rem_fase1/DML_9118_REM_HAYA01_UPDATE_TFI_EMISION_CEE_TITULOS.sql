--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-287
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el Trámite de Emisión CEE
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
	
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO CAMPO '||V_TFI_CAMPO||' DE TABLA TFI PARA T. EMISIÓN CEE - TITULOS');



-- CAMBIO EN LOS TITULOS DE LAS TAREAS --------------------------------------------------

--T003_AnalisisPeticion ----------------------------

  V_TFI_TAP_CODIGO := 'T003_AnalisisPeticion';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Se ha formulado una solicitud para la emisi&oacute;n de un Certificado de Eficiencia Energ&eacute;tica (CEE), por lo que en la presente tarea deber&aacute; anotar si acepta o no la petici&oacute;n y se solicita la emisi&oacute;n del CEE al t&eacute;cnico correspondiente.</p><p>Si deniega la petici&oacute;n, deber&aacute; hacer constar el motivo y finalizar&aacute; el tr&aacute;mite.</p><p>Si acepta la petici&oacute;n, deber&aacute; seleccionar el proveedor al que se le encarga la gesti&oacute;n e indicar la tarifa que resulta de aplicaci&oacute;n. Ambas acciones deber&aacute; realizarlas en la pesta&ntilde;a "gesti&oacute;n econ&oacute;mica" del trabajo y, tras ello, comprobar si el importe resultante supera el l&iacute;mite presupuestario asignado al activo.</p><p>En el caso de que haya saldo suficiente, la siguiente tarea ser&aacute; la de "emisi&oacute;n certificado" y se lanzar&aacute; al t&eacute;cnico encargado de emitir el CEE.</p><p>Por el contrario, en el caso de que no haya saldo suficiente asociado al activo, la siguiente tarea ser&aacute; la de "solicitud de disposici&oacute;n extraordinaria al propietario".</p><p>En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  EXECUTE IMMEDIATE V_MSQL;


--T003_ObtencionEtiqueta ----------------------------

  V_TFI_TAP_CODIGO := 'T003_ObtencionEtiqueta';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Previamente a la cumplimentaci&oacute;n de la presente tarea, deber&aacute; subir a la pesta&ntilde;a "documentos" del trabajo la etiqueta de eficiencia energ&eacute;tica as&iacute; como el documento justificativo del registro.</p><p style="margin-bottom: 10px">Una vez subidos los documentos, deber&aacute; hacer constar la fecha en que se han obtenido as&iacute; como su referencia.</p><p style="margin-bottom: 10px">Si ha satisfecho alg&uacute;n suplido en concepto de tasa administrativa, deber&aacute; hacer constar su importe en la pesta&ntilde;a "gesti&oacute;n econ&oacute;mica" del trabajo.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe ser tenido en cuenta en este punto del tr&aacute;mite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  EXECUTE IMMEDIATE V_MSQL;


--T003_CierreEconomico ----------------------------

  V_TFI_TAP_CODIGO := 'T003_CierreEconomico';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Para dar por cumplimentada esta tarea deber&aacute; realizar el cierre econ&oacute;mico del trabajo.</p><p>Para ello, si no lo ha hecho previamente, deber&aacute; seleccionar la tarifa que resulta de aplicaci&oacute;n en la pesta&ntilde;a "gesti&oacute;n econ&oacute;mica" del trabajo, asign&aacute;ndole un importe si no lo tiene.</p><p>Debe tener en cuenta que, una vez cumplimentada esta tarea, ya no podr&aacute; modificar los importes que se hayan hecho constar en la pesta&ntilde;a de "gesti&oacute;n econ&oacute;mica", que ser&aacute;n los que se tomar&aacute;n para el proceso de facturaci&oacute;n.</p><p>En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p><p>Esta tarea pone fin al tr&aacute;mite de emisi&oacute;n de CEE.</p>';

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

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuci&oacute;n:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
