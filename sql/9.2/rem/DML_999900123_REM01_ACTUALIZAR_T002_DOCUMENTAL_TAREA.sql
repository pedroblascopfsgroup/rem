--/*
--##########################################
--## AUTOR=BRUNO ANGLÉS
--## FECHA_CREACION=20170725
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2045
--## PRODUCTO=NO
--##
--## Finalidad: Resolver la reapertura del ítem
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master.
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_NUM_ENLACES NUMBER(16); -- Vble. para validar lineas a borrar de TFI.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
  
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN

  
  DBMS_OUTPUT.PUT_LINE('[INICIO] Realizando modificaciones en '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS ');
  
  
  DBMS_OUTPUT.PUT_LINE('Modificando la tarea ''Análisis de la petición'' (''T002_AnalisisPeticion'')');
  
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '||
              ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">Se ha formulado una petición para la obtención de un documento, por lo que en la presente tarea deberá aceptarla o rechazarla.</p><p>Si deniega la petición, deberá hacer constar el motivo y finalizará el trámite.</p><p>En el caso de que acepte la petición, deberá indicar si la gestión se va a encomendar a un proveedor o por el contrario va a ser realizada por un gestor interno. En este último caso la siguiente tarea será la de solicitud del documento por el gestor interno.</p><p>Si el trabajo se va a encargar a un proveedor, deberá seleccionarlo en la pestaña "gestión económica" del trabajo, verificando asimismo que la tarifa que resulte aplicable tiene un importe y que este es correcto.</p><p>En el caso de que haya saldo suficiente en el activo para tramitarse el trabajo, la siguiente tarea será la de "solicitud documento por proveedor", a quien se le lanzará directamente.</p><p>Por el contrario, en el caso de que no haya saldo suficiente asociado al activo, la siguiente tarea será la de "solicitud de disposición extraordinaria al propietario". En el caso de Bankia, esta tarea se lanzará al usuario de Capa de Control.</p><p>En el campo "observaciones" puede consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>''' ||
              ' , USUARIOMODIFICAR=''HREOS-2045'', FECHAMODIFICAR=SYSDATE'||
            ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T002_AnalisisPeticion'')'||
            ' AND TFI_ORDEN = 0'||
            ' AND TFI_TIPO = ''label'''||
            'AND TFI_NOMBRE = ''titulo''';
   DBMS_OUTPUT.PUT_LINE(V_MSQL);            
   
  EXECUTE IMMEDIATE V_MSQL;
  
  /* Duda 2.b
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '||
              ' SET BORRADO = 1' ||
              ' , USUARIOBORRAR=''HREOS-2045'', FECHABORRAR=SYSDATE'||
            ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T002_AnalisisPeticion'')'||
            ' AND TFI_TIPO = ''combo'''||
            'AND TFI_NOMBRE = ''comboSaldo''';
   DBMS_OUTPUT.PUT_LINE(V_MSQL);            
   
  EXECUTE IMMEDIATE V_MSQL;
  */
  
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Modificando la tarea ''Obtencion documento por proveedor'' (''T002_ObtencionDocumentoGestoria'')');
  
   V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '||
              ' SET TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T002_ObtencionDocumentoGestoria''''][''''comboObtencion''''] == DDSiNo.SI ? (esFechaMenor(valores[''''T002_ObtencionDocumentoGestoria''''][''''fechaObtencion''''], fechaAprobacionTrabajo()) ? ''''Fecha obtencion debe ser posterior o igual a fecha de aprobacion del trabajo'''' : existeAdjuntoUGValidacion("","T")) : null ''' ||
              ' , USUARIOMODIFICAR=''HREOS-2045'', FECHAMODIFICAR=SYSDATE'||
            ' WHERE TAP_CODIGO = ''T002_ObtencionDocumentoGestoria''';
   DBMS_OUTPUT.PUT_LINE(V_MSQL);            
   
  EXECUTE IMMEDIATE V_MSQL;
  
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '||
              ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">Para dar por terminada esta tarea deberá subir una copia del documento obtenido a la pestaña "documentos" del trabajo, haciendo constar a continuación en esta tarea la fecha en que se emitió o se obtuvo aquél así como su referencia, en su caso.</p><p>En el supuesto de que no sea posible obtener el documento, deberá hacerlo constar así en el campo "imposibilidad de obtener el documento", anotando el motivo de tal imposibilidad. La siguiente tarea será Cierre económico</p><p>En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>''' ||
              ' , USUARIOMODIFICAR=''HREOS-2045'', FECHAMODIFICAR=SYSDATE'||
            ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T002_ObtencionDocumentoGestoria'')'||
            ' AND TFI_ORDEN = 0'||
            ' AND TFI_TIPO = ''label'''||
            'AND TFI_NOMBRE = ''titulo''';
   DBMS_OUTPUT.PUT_LINE(V_MSQL);            
   
  EXECUTE IMMEDIATE V_MSQL;
  
  
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '||
              ' SET TFI_VALIDACION = NULL' ||
              ' , USUARIOMODIFICAR=''HREOS-2045'', FECHAMODIFICAR=SYSDATE'||
            ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T002_ObtencionDocumentoGestoria'')'||
            ' AND TFI_TIPO = ''text'''||
            'AND TFI_NOMBRE = ''refDocumento''';
   DBMS_OUTPUT.PUT_LINE(V_MSQL);            
   
  EXECUTE IMMEDIATE V_MSQL;
  
  
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE('Modificando la tarea ''Validación de actuación'' (''T002_ValidacionActuacion'')');
  
  
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '||
              ' SET TFI_LABEL = ''<p style="margin-bottom: 10px">Antes de dar por terminada esta tarea, deberá acceder a la pestaña "documentos" del trabajo y comprobar que el documento que se ha subido a la aplicación es el que se había solicitado, haciendo constar en el campo "corrección del documento" si se corresponde con la petición realizada. En caso negativo, deberá hacer consta el motivo de la incorrección.</p><p style="margin-bottom: 10px">Puede utilizar el campo "observaciones" para consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p><p style="margin-bottom: 10px">En el caso de que el documento sea correcto, la siguiente tarea será la de "cierre económico". En el supuesto de que el documento subido sea incorrecto, se lanzará de nuevo al proveedor la tarea de solicitud del documento, notificándole el motivo de incorrección que haya hecho constar en la presente tarea.</p><p>Puede utilizar el campo "observaciones" para consignar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>''' ||
              ' , USUARIOMODIFICAR=''HREOS-2045'', FECHAMODIFICAR=SYSDATE'||
            ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T002_ValidacionActuacion'')'||
            ' AND TFI_ORDEN = 0'||
            ' AND TFI_TIPO = ''label'''||
            'AND TFI_NOMBRE = ''titulo''';
   DBMS_OUTPUT.PUT_LINE(V_MSQL);            
   
  EXECUTE IMMEDIATE V_MSQL;
  
  
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '||
              ' SET BORRADO = 1' ||
              ' , USUARIOBORRAR=''HREOS-2045'', FECHABORRAR=SYSDATE'||
            ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T002_ValidacionActuacion'')'||
            ' AND TFI_TIPO = ''combo'''||
            'AND TFI_NOMBRE = ''documObtenido''';
   DBMS_OUTPUT.PUT_LINE(V_MSQL);            
   
  EXECUTE IMMEDIATE V_MSQL;
  
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '||
              ' SET BORRADO = 1' ||
              ' , USUARIOBORRAR=''HREOS-2045'', FECHABORRAR=SYSDATE'||
            ' WHERE TAP_ID = (SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T002_ValidacionActuacion'')'||
            ' AND TFI_TIPO = ''combo'''||
            'AND TFI_NOMBRE = ''sePagaProveedor''';
   DBMS_OUTPUT.PUT_LINE(V_MSQL);            
   
  EXECUTE IMMEDIATE V_MSQL;
  
  
  DBMS_OUTPUT.PUT_LINE('[FIN] Realizando modificaciones en '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS ');
    
  

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