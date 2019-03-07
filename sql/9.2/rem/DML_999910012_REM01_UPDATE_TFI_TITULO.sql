--/*
--##########################################
--## AUTOR=JINLI HU
--## FECHA_CREACION=20190228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5457
--## PRODUCTO=SI
--##
--## Finalidad: 
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


--T004_EleccionPresupuesto ----------------------------

  V_TFI_TAP_CODIGO := 'T004_EleccionPresupuesto';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">Una vez recibidos los presupuestos de los proveedores, debe proceder a la elección de uno de ellos.</p><p>Para ello, con carácter previo a la cumplimentación de la presente tarea, deberá anotar la información relativa a los presupuestos recibidos en la pestaña "gestión económica" del trabajo, autorizando uno de ellos.</p><p>Si no puede aceptar ningún presupuesto porque ninguno de los que le han sido remitidos es válido, deberá hacer constar el motivo. En este caso, la siguiente tarea del trámite será de nuevo la de "solicitud presupuestos".</p><p>En el caso de que sí que haya algún presupuesto que pueda ser seleccionado, deberá hacer constar la fecha en que efectúa la elección. Si la cartera es Jaipur, Ágora o Egeo la siguiente tarea que se lanzará será la de "Solicitud disposición extraordinaria al propietario". En caso de que la cartera no es ni Jaipur ni Ágora ni Egeo la siguiente tarea que se lanzará será la de "disponibilidad de saldo".</p><p>En el campo "observaciones" puede consignar cualquier aspecto que considere levante  y que debe quedar reflejado en este punto del trámite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''',
             USUARIOMODIFICAR = ''HREOS-5457'', 
			 FECHAMODIFICAR = SYSDATE 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';
  EXECUTE IMMEDIATE V_MSQL;

--T004_SolicitudPresupuestoComplementario ----------------------------

  V_TFI_TAP_CODIGO := 'T004_SolicitudPresupuestoComplementario';
  V_TFI_TFI_NOMBRE := 'titulo';
  V_TFI_CAMPO := 'tfi_label';
  V_TFI_VALOR := '<p style="margin-bottom: 10px">El proveedor ha solicitado una modificación del presupuesto presentado inicialmente por lo que, con carácter previo a la cumplimentación de la presente tarea, deberá anotar la información relativa al nuevo presupuesto en la pestaña "gestión económica" del trabajo y proceder a su autorización.</p><p style="margin-bottom: 10px">Una vez cumplimentada la presente tarea, si la cartera es Jaipur, Ágora o Egeo la siguiente que se lanzará será la de "Solicitud disposición extraordinaria al propietario" sino se lanzará la de "disponibilidad de saldo".</p><p style="margin-bottom: 10px">En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite.</p>';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''',
             USUARIOMODIFICAR = ''HREOS-5457'', 
			 FECHAMODIFICAR = SYSDATE 
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
