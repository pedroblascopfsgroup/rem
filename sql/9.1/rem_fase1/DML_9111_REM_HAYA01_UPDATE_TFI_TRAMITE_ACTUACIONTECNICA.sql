--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-280
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el Trámite de Actuación Técnica
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
    V_TFI_TAP_CODIGO VARCHAR2(100 CHAR) := 'T004_FijacionPlazo';
    V_TFI_TFI_NOMBRE VARCHAR2(100 CHAR) := 'fechaConcreta';

    --CAMPO TFI PARA ACTUALIZAR
    V_TFI_CAMPO VARCHAR2(100 CHAR)  := 'tfi_tipo';
    V_TFI_VALOR VARCHAR2(1000 CHAR) := 'date';

  
BEGIN	
	
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO CAMPO '||V_TFI_CAMPO||' DE TABLA TFI PARA T. ACTUACION TECNICA');

  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS 
            WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
              AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||''' ';
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[WARN] ' ||V_ESQUEMA|| '.TFI_TAREAS_FORM_ITEMS - NO EXISTE EL REGISTRO CON TAP_CODIGO =  '||V_TFI_TAP_CODIGO||'Y CON TFI_NOMBRE = '||V_TFI_TFI_NOMBRE||'.');
    DBMS_OUTPUT.PUT_LINE('[WARN] ' ||V_ESQUEMA|| '.TFI_TAREAS_FORM_ITEMS - SE ABORTA ESTE SCRIPT.');

    DBMS_OUTPUT.PUT_LINE('[FIN] SCRIPT EJECUTADO CON PROBLEMAS ');

  ELSE


    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
               SET '||V_TFI_CAMPO||'='''||V_TFI_VALOR||''' 
               WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TFI_TAP_CODIGO||''') 
                 AND TFI_NOMBRE = '''||V_TFI_TFI_NOMBRE||'''
               ';

    EXECUTE IMMEDIATE V_MSQL;


    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADO CORRECTAMENTE ');

  END IF;


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
