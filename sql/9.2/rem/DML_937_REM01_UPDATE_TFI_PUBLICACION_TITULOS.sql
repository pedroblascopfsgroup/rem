--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20161009
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=none
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza instrucciones del Trámite de Publicacion
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
	
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO CAMPO '||V_TFI_CAMPO||' DE TABLA TFI PARA T. PUBLICACION - TITULOS');

-- CAMBIO EN LOS TITULOS DE LAS TAREAS --------------------------------------------------


--T011_RevisionInformeComercial ----------------------------

  V_TFI_TAP_CODIGO := 'T011_RevisionInformeComercial';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Si acepta el informe comercial y el activo cuenta con la conformidad de los departamentos de Admisión y Gestión, simultáneamente podrá conferirle al activo la cualidad de publicable, seleccionando "Sí" en el campo "Continuar con el proceso de publicación", siempre y cuando haya completado la información necesaria en la pestaña "Datos de publicación" del activo.</p><p style="margin-bottom: 10px">Si acepta el informe y la tipología del activo que refleja el informe no coincide con la que figura actualmente en REM, se lanzará una tarea de verificación al gestor de admisión.</p><p style="margin-bottom: 10px">Si acepta el informe sin contar con la conformidad de los departamentos citados, o acepta pero paralizando el proceso de publicación, tendrá que acceder, desde módulo Publicación del menú lateral, al listado de activos no publicados para continuar el proceso de publicación.</p><p style="margin-bottom: 10px">Si rechaza el informe comercial, los datos recibidos quedarán almacenados pero el informe constará como rechazado. En este caso deberá indicar el motivo que ha generado este rechazo, que le será notificado al emisor para su corrección.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


--T011_AnalisisPeticionCorreccion ----------------------------

  V_TFI_TAP_CODIGO := 'T011_AnalisisPeticionCorreccion';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">El gestor de publicación ha validado un informe comercial en el que consigna una tipología distinta para el activo. Para finalizar esta tarea, indique si acepta o deniega el cambio propuesto.</p><p style="margin-bottom: 10px">Si deniega la propuesta, deberá indicar el motivo. Se le enviará una notificación al mediador y al gestor de publicación, y el informe actual quedará rechazado.</p><p style="margin-bottom: 10px">Si acepta el cambio, finalizará la tarea y se lanzará un nuevo el trámite de admisión. Se le enviará una notificación al mediador y al gestor de publicación.</p><p style="margin-bottom: 10px">En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';

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
