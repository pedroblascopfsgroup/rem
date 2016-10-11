--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20161008
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=none
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza instrucciones del Trámite de Propuesta de precios
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
	
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO CAMPO '||V_TFI_CAMPO||' DE TABLA TFI PARA T. PROPEUSTA PRECIOS - TITULOS');

-- CAMBIO EN LOS TITULOS DE LAS TAREAS --------------------------------------------------


--T009_AnalisisPeticion ----------------------------

  V_TFI_TAP_CODIGO := 'T009_AnalisisPeticion';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Se ha formulado una petición para tramitar una propuesta de precios, por lo que en la presente tarea deberá indicar si la acepta o la deniega.</p><p style="margin-bottom: 10px">Puede consultar el listado de activos a preciar o repreciar en el trabajo.</p><p style="margin-bottom: 10px">Si deniega la petición deberá hacer constar el motivo, finalizándose el trámite.</p><p style="margin-bottom: 10px">Si acepta la petición, la siguiente tarea que se lanzará será "generar propuesta de precios".</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


--T009_GenerarPropuestaPrecios ----------------------------

  V_TFI_TAP_CODIGO := 'T009_GenerarPropuestaPrecios';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Antes de cumplimentar la presente tarea, deberá generar la propuesta de precios relativa a los activos objeto del trabajo correspondiente. La generación de la propuesta de precios deberá hacerla desde el listado de activos del trabajo.</p><p style="margin-bottom: 10px">Una vez generada, la Excel en la que se contiene la propuesta de precios se guardará como un documento adjunto del trabajo, pudiéndosela descargar en su equipo para su modificación si así lo desea, </p><p style="margin-bottom: 10px">La Excel de propuesta de precios modificada, deberá ser subida a la pestaña de adjuntos del trabajo para su ulterior consulta.</p><p style="margin-bottom: 10px">La siguiente tarea que se lanzará es "Envío de la propuesta al propietario".</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


--T009_EnvioPropuestaPropietario ----------------------------

  V_TFI_TAP_CODIGO := 'T009_EnvioPropuestaPropietario';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Antes de cumplimentar esta tarea, deberá remitir la propuesta de precios al propietario para su sanción, haciendo constar la fecha en que realiza dicho envío.</p><p style="margin-bottom: 10px">En el campo "email del propietario", puede hacer constar la dirección de correo electrónico del propietario. Dicha dirección de correo será utilizada por la aplicación para, una vez finalizado el trámite, remitir un aviso al propietario informándole de que se ha cargado la propuesta de precios.</p><p style="margin-bottom: 10px">La siguiente tarea que se lanzará en el trámite es "carga de propuesta sacionada".</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

 
 --T009_SancionCargaPropuesta ----------------------------

  V_TFI_TAP_CODIGO := 'T009_SancionCargaPropuesta';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Una vez sancionada y recibida la propuesta de precios del propietario, deberá cargarla en la aplicación para que su contenido se traslade a cada uno de los activos incluidos en la propuesta de precios.</p><p style="margin-bottom: 10px">La carga de la propuesta de precios se hará a través del módulo de carga masiva, donde se validarán los posibles errores de que pueda adolecer.</p><p style="margin-bottom: 10px">Una vez actualizados los precios de los activos, puede subir la Excel como un documento adjunto al trabajo para permitir su consulta en el futuro.</p><p style="margin-bottom: 10px">La cumplimentación de esta tarea finaliza el trámite de propuesta de precios.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';

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
