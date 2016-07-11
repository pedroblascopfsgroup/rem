--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160523
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0.5
--## INCIDENCIA_LINK=HREOS-480
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza las validaciones de trámites
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
    V_TAP_TAP_CODIGOS VARCHAR2(4000 CHAR) := '';

    --CAMPO TFI PARA ACTUALIZAR
    V_TAP_CAMPO VARCHAR2(100 CHAR)  := '';
    V_TAP_VALOR VARCHAR2(1000 CHAR) := '';


/* VALIDACIONES POST ANTIGUAS:
TAP_CODIGO  TAP_SCRIPT_VALIDACION TAP_SCRIPT_VALIDACION_JBPM
T008_CierreEconomico    esFechaMenor(valores['T002_CierreEconomico']['fechaCierre'], fechaValidacionTrabajo()) ? 'Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n' : null

*/

BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO VALIDACIONES - TRAMITE CEDULA: validaciones de fechas y documentos requeridos');

  --ACTUALIZACION DE VALIDACIONE POST 
  V_TAP_CAMPO := 'TAP_SCRIPT_VALIDACION_JBPM';

-- CEDULA - CIERRE ECONOMICO - Validación POST fecha mayora a validación Trabajo ----
  V_TAP_TAP_CODIGOS := ' ''T008_CierreEconomico'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T008_CierreEconomico''''][''''fechaCierre''''], fechaAprobacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de aprobaci&oacute;n del trabajo'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADO CORRECTAMENTE ');


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
