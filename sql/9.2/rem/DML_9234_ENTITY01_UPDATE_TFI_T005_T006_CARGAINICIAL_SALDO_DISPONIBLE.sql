--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160519
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0.4
--## INCIDENCIA_LINK=HREOS-472
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza los Trámites de INFORME y TASACION para cargar saldo Disponible automáticamente
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
    V_TFI_TFI_NOMBRE VARCHAR2(100 CHAR) := '';

    --CAMPO TFI PARA ACTUALIZAR
    V_TFI_CAMPO VARCHAR2(100 CHAR)  := 'tfi_tipo';
    V_TFI_VALOR VARCHAR2(4000 CHAR) := '';

  
BEGIN	
	
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO TFI...');


--T005_AnalisisPeticion -------------------------------------------------------

  V_TFI_TAP_CODIGO := 'T005_AnalisisPeticion';
  V_TFI_TFI_NOMBRE := 'saldoDisponible';
  V_TFI_CAMPO := 'tfi_tipo';
  V_TFI_VALOR := 'textinf';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

--  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO CAMPO '||V_TFI_TFI_NOMBRE||' DE TABLA TFI EN TAREA '||V_TFI_TAP_CODIGO||' PARA CARGA INICIAL SALDO DISP.');
  EXECUTE IMMEDIATE V_MSQL;


--T006_AnalisisPeticion -------------------------------------------------------

  V_TFI_TAP_CODIGO := 'T006_AnalisisPeticion';
  V_TFI_TFI_NOMBRE := 'saldoDisponible';
  V_TFI_CAMPO := 'tfi_tipo';
  V_TFI_VALOR := 'textinf';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
             WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
               AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
             ';

--  DBMS_OUTPUT.PUT_LINE('[SQL]: '||V_MSQL);
  DBMS_OUTPUT.PUT_LINE('ACTUALIZANDO CAMPO '||V_TFI_TFI_NOMBRE||' DE TABLA TFI EN TAREA '||V_TFI_TAP_CODIGO||' PARA CARGA INICIAL SALDO DISP.');
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
