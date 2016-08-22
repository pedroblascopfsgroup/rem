--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-288
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el Tr&aacute;mite de Emisión INFORME
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
	
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO CAMPO '||V_TFI_CAMPO||' DE TABLA TFI PARA T. EMISIÓN INFORME - TITULOS');



-- CAMBIO EN LOS TITULOS DE LAS TAREAS --------------------------------------------------

--T006_AnalisisPeticion ----------------------------

  V_TFI_TAP_CODIGO := 'T006_AnalisisPeticion';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Se ha formulado una solicitud para la emisi&oacute;n de un informe, por lo que en la presente tarea deber&aacute; anotar si acepta o no la petici&oacute;n y se solicita la emisi&oacute;n del informe al proveedor correspondiente.</p><p style="margin-bottom: 10px">Si deniega la petici&oacute;n, deber&aacute; hacer constar el motivo y finalizar&aacute; el tr&aacute;mite.</p><p style="margin-bottom: 10px">Si acepta la petici&oacute;n, deber&aacute; seleccionar al proveedor en la pestaña "gesti&oacute;n econ&oacute;mica" del trabajo, verificando asimismo que la tarifa que resulte aplicable tiene un importe y que este es correcto.</p><p>En el caso de que haya saldo suficiente en el activo para ejecutarse el trabajo, la siguiente tarea ser&aacute; la de "emisi&oacute;n informe" y se lanzar&aacute; al proveedor seleccionado.</p><p>Por el contrario, en el caso de que no haya saldo suficiente asociado al activo, la siguiente tarea ser&aacute; la de "solicitud de disposici&oacute;n extraordinaria al propietario".</p><p>En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


--T006_EmisionInforme ----------------------------

  V_TFI_TAP_CODIGO := 'T006_EmisionInforme';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Para dar por terminada esta tarea haciendo constar la fecha en que se ha emitido el informe, previamente deber&aacute; subir una copia del mismo a la pestaña "documentos" del trabajo.</p><p style="margin-bottom: 10px">En el supuesto de que no sea posible emitir el informe porque no ha podido acceder al inmueble o por cualquier otro motivo, deber&aacute; anotar NO en el campo "informe emitido", haciendo constar el motivo de tal imposibilidad.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


--T006_ValidacionInforme ----------------------------

  V_TFI_TAP_CODIGO := 'T006_ValidacionInforme';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Antes de dar por terminada esta tarea, deber&aacute; acceder a la pestaña "documentos" del trabajo y comprobar que el informe que se ha subido a la aplicaci&oacute;n tiene el contenido que se hab&iacute;a solicitado, haciendo constar en el campo "correcci&oacute;n del informe" si se corresponde con la petici&oacute;n realizada. En caso negativo, deber&aacute; hacer constar el motivo de la incorrecci&oacute;n. En este supuesto, se le volver&aacute; a lanzar la tarea correspondiente al proveedor para que subsane los errores detectados.</p><p style="margin-bottom: 10px">En el caso de que el informe sea correcto, deber&aacute; hacer constar la valoraci&oacute;n que concede al proveedor que lo ha realizado. En este supuesto, la siguiente tarea ser&aacute; la de "cierre econ&oacute;mico".</p><p style="margin-bottom: 10px">Puede utilizar el campo "observaciones" para consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del tr&aacute;mite.</p>';

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
