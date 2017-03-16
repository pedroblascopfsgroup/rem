--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170316
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1784
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el Trámite de actualización de estados
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
    V_TFI_TAP_CODIGO VARCHAR2(100 CHAR);
    V_TFI_TFI_NOMBRE VARCHAR2(100 CHAR);

    --CAMPO TFI PARA ACTUALIZAR
    V_TFI_CAMPO_1 VARCHAR2(100 CHAR);
    V_TFI_VALOR_1 VARCHAR2(4000 CHAR);
    V_TFI_CAMPO_2 VARCHAR2(100 CHAR);
    V_TFI_VALOR_2 VARCHAR2(4000 CHAR);

  
BEGIN	
	
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO TFI '||V_TFI_TFI_NOMBRE||' PARA Trámite '||V_TFI_TAP_CODIGO);



-- CAMBIO OBLIGATORIEDAD CAMPOS --------------------------------------------------

-- T012_AnalisisPeticionActualizacionEstado ----------------------------

  V_TFI_TAP_CODIGO := 'T012_AnalisisPeticionActualizacionEstado';
  V_TFI_TFI_NOMBRE := 'comboAceptacion';
  V_TFI_CAMPO_1 := 'TFI_VALIDACION';
  V_TFI_CAMPO_2 := 'TFI_ERROR_VALIDACION';
  V_TFI_VALOR_1 := 'false';
  V_TFI_VALOR_2 := 'Debe indicar si acepta/rechaza';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
             SET '||V_TFI_CAMPO_1||'='''||V_TFI_VALOR_1||''', '||V_TFI_CAMPO_2||'='''||V_TFI_VALOR_2||''' 
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
