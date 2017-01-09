--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20170105
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1337
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el Tramite sancion oferta alquiler
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versi&oacute;n inicial
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
	
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO CAMPO '||V_TFI_CAMPO||' DE TABLA TFI PARA T. EMISION CEE - TITULOS');



-- CAMBIO EN LOS TITULOS DE LAS TAREAS --------------------------------------------------

--T003_AnalisisPeticion ----------------------------

/*
<p style="margin-bottom: 10px">Se ha formulado una solicitud para la emisi&oacute;n de un Certificado de Eficiencia Energ&eacute;tica (CEE), por lo que en la presente tarea deber&aacute; anotar si acepta o no la petici&oacute;n y se solicita la emisi&oacute;n del CEE al proveedor correspondiente.</p><p style="margin-bottom: 10px">Si deniega la petici&oacute;n, deber&aacute; hacer constar el motivo y finalizar&aacute; el tr&aacute;mite.</p><p style="margin-bottom: 10px">Si acepta la petici&oacute;n, deber&aacute; seleccionar el proveedor al que se le encarga la gesti&oacute;n e indicar la tarifa que resulta de aplicaci&oacute;n. Ambas acciones deber&aacute; realizarlas en la pestaña "gesti&oacute;n econ&oacute;mica" del trabajo.</p><p style="margin-bottom: 10px">En el caso de que haya saldo suficiente en el activo, la siguiente tarea ser&aacute; la de "emisi&oacute;n certificado" y se lanzar&aacute; al proveedor encargado de emitir el CEE.</p><p style="margin-bottom: 10px">Por el contrario, en el caso de que no haya saldo suficiente asociado al activo, la siguiente tarea ser&aacute; la de "solicitud de disposici&oacute;n extraordinaria al propietario".</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>
*/
  V_TFI_TAP_CODIGO := 'T003_AnalisisPeticion';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Se ha formulado una solicitud para la emisi&oacute;n de un Certificado de Eficiencia Energ&eacute;tica (CEE), por lo que en la presente tarea deber&aacute; anotar si acepta o no la petici&oacute;n y se solicita la emisi&oacute;n del CEE al proveedor correspondiente.</p><p style="margin-bottom: 10px">Si deniega la petici&oacute;n, deber&aacute; hacer constar el motivo y finalizar&aacute; el tr&aacute;mite.</p><p style="margin-bottom: 10px">Si acepta la petici&oacute;n, deber&aacute; seleccionar el proveedor al que se le encarga la gesti&oacute;n e indicar la tarifa que resulta de aplicaci&oacute;n. Ambas acciones deber&aacute; realizarlas en la pestaña "gesti&oacute;n econ&oacute;mica" del trabajo.</p><p style="margin-bottom: 10px">En el caso de que haya saldo suficiente en el activo, la siguiente tarea ser&aacute; la de "emisi&oacute;n certificado" y se lanzar&aacute; al proveedor encargado de emitir el CEE.</p><p style="margin-bottom: 10px">Por el contrario, en el caso de que no haya saldo suficiente asociado al activo, la siguiente tarea ser&aacute; la de "solicitud de disposici&oacute;n extraordinaria al propietario".</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


--T003_EmisionCertificado ----------------------------
/*
<p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; adjuntar previamente copia del certificado de CEE a la pestaña "documentos" del trabajo, haciendo constar en el campo correspondiente de esta tarea la fecha en que se ha emitido el documento as&iacute; como la calificaci&oacute;n resultante.</p><p style="margin-bottom: 10px">Si una vez emitido el certificado no fuese preceptiva su inscripci&oacute;n ni la obtenci&oacute;n de la etiqueta, deber&aacute; indicarse as&iacute;.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>
*/
  V_TFI_TAP_CODIGO := 'T003_EmisionCertificado';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Para dar por terminada esta tarea, deber&aacute; adjuntar previamente copia del certificado de CEE a la pestaña "documentos" del trabajo, haciendo constar en el campo correspondiente de esta tarea la fecha en que se ha emitido el documento as&iacute; como la calificaci&oacute;n resultante.</p><p style="margin-bottom: 10px">Si una vez emitido el certificado no fuese preceptiva su inscripci&oacute;n ni la obtenci&oacute;n de la etiqueta, deber&aacute; indicarse as&iacute;.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


--T003_ObtencionEtiqueta ----------------------------
/*
<p style="margin-bottom: 10px">Previamente a la cumplimentaci&oacute;n de la presente tarea, deber&aacute; subir a la pestaña "documentos" del trabajo la etiqueta de eficiencia energ&eacute;tica as&iacute; como el documento justificativo del registro.</p><p style="margin-bottom: 10px">Una vez subidos los documentos, deber&aacute; hacer constar la fecha en que se han obtenido as&iacute; como su referencia.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe ser tenido en cuenta en este punto del tr&aacute;mite.</p>
*/
  V_TFI_TAP_CODIGO := 'T003_ObtencionEtiqueta';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Previamente a la cumplimentaci&oacute;n de la presente tarea, deber&aacute; subir a la pestaña "documentos" del trabajo la etiqueta de eficiencia energ&eacute;tica as&iacute; como el documento justificativo del registro.</p><p style="margin-bottom: 10px">Una vez subidos los documentos, deber&aacute; hacer constar la fecha en que se han obtenido as&iacute; como su referencia.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe ser tenido en cuenta en este punto del tr&aacute;mite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


--T003_CierreEconomico ----------------------------
/*
<p style="margin-bottom: 10px">Para dar por cumplimentada esta tarea deber&aacute; realizar el cierre econ&oacute;mico del trabajo.</p><p style="margin-bottom: 10px">Para ello, si no lo ha hecho previamente, deber&aacute; seleccionar la tarifa que resulta de aplicaci&oacute;n en la pestaña "gesti&oacute;n econ&oacute;mica" del trabajo, asign&aacute;ndole un importe si no lo tiene.</p><p style="margin-bottom: 10px">Debe tener en cuenta que, una vez cumplimentada esta tarea, ya no podr&aacute; modificar los importes que se hayan hecho constar en la pestaña de "gesti&oacute;n econ&oacute;mica", que ser&aacute;n los que se tomar&aacute;n para el proceso de facturaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p><p style="margin-bottom: 10px">Esta tarea pone fin al tr&aacute;mite de emisi&oacute;n de CEE.</p>
*/
  V_TFI_TAP_CODIGO := 'T003_CierreEconomico';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Para dar por cumplimentada esta tarea deber&aacute; realizar el cierre econ&oacute;mico del trabajo.</p><p style="margin-bottom: 10px">Para ello, si no lo ha hecho previamente, deber&aacute; seleccionar la tarifa que resulta de aplicaci&oacute;n en la pestaña "gesti&oacute;n econ&oacute;mica" del trabajo, asign&aacute;ndole un importe si no lo tiene.</p><p style="margin-bottom: 10px">Debe tener en cuenta que, una vez cumplimentada esta tarea, ya no podr&aacute; modificar los importes que se hayan hecho constar en la pestaña de "gesti&oacute;n econ&oacute;mica", que ser&aacute;n los que se tomar&aacute;n para el proceso de facturaci&oacute;n.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p><p style="margin-bottom: 10px">Esta tarea pone fin al tr&aacute;mite de emisi&oacute;n de CEE.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


--T003_AutorizacionPropietario ----------------------------
/*
<p style="margin-bottom: 10px">Para cumplimentar esta tarea debe anotar la fecha en que ha recibido la respuesta del propietario aceptando o rechazando una ampliaci&oacute;n del presupuesto asociado al activo. Asimismo, deber&aacute; subir a la pestaña “documentos” del trabajo el correo remitido por el propietario que justifique el rechazo o aceptaci&oacute;n de la solicitud.</p><p style="margin-bottom: 10px">En el caso de que la ampliaci&oacute;n del presupuesto sea rechazada por el propietario, el tr&aacute;mite concluir&aacute; ya que no podr&aacute; llevarse a cabo la actuaci&oacute;n por falta de saldo.</p><p style="margin-bottom: 10px">En caso de que se conceda la ampliaci&oacute;n de presupuesto solicitada, deber&aacute; anotar su importe. La siguiente tarea ser&aacute; la de "emisi&oacute;n certificado" y se lanzar&aacute; directamente al proveedor.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>
*/
  V_TFI_TAP_CODIGO := 'T003_AutorizacionPropietario';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Para cumplimentar esta tarea debe anotar la fecha en que ha recibido la respuesta del propietario aceptando o rechazando una ampliaci&oacute;n del presupuesto asociado al activo. Asimismo, deber&aacute; subir a la pestaña “documentos” del trabajo el correo remitido por el propietario que justifique el rechazo o aceptaci&oacute;n de la solicitud.</p><p style="margin-bottom: 10px">En el caso de que la ampliaci&oacute;n del presupuesto sea rechazada por el propietario, el tr&aacute;mite concluir&aacute; ya que no podr&aacute; llevarse a cabo la actuaci&oacute;n por falta de saldo.</p><p style="margin-bottom: 10px">En caso de que se conceda la ampliaci&oacute;n de presupuesto solicitada, deber&aacute; anotar su importe. La siguiente tarea ser&aacute; la de "emisi&oacute;n certificado" y se lanzar&aacute; directamente al proveedor.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
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
