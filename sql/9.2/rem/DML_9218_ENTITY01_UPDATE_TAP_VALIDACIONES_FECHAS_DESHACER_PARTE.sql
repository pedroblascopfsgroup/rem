--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160512
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0.3
--## INCIDENCIA_LINK=HREOS-319
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


BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO VALIDACIONES');


  --ACTUALIZACION DE VALIDACIONE POST 
  V_TAP_CAMPO := 'TAP_SCRIPT_VALIDACION_JBPM';

  -- OBTENCION DOC - VALIDACION ACTUACION  F.APROBACION > FECHA > HOY() ----------------------------------
  V_TAP_TAP_CODIGOS := ' ''T002_ValidacionActuacion'' ';
  V_TAP_VALOR := '(valores[''''T002_ValidacionActuacion''''][''''comboCorreccion''''] == DDSiNo.NO && valores[''''T002_ValidacionActuacion''''][''''motivoIncorreccion''''] == '''''''' ) ? ''''Si el documento no corresponde con la petici&oacute;n, debe indicar un motivo de incorrecci&oacute;n'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;



  -- OBTENCION INFORME - VALIDACION INFORME F.APROBACION > FECHA > HOY() ----------------------------------
  V_TAP_TAP_CODIGOS := ' ''T006_ValidacionInforme'' ';
  V_TAP_VALOR := '(valores[''''T006_ValidacionInforme''''][''''comboCorreccion''''] == DDSiNo.NO ? (valores[''''T006_ValidacionInforme''''][''''motivoIncorreccion''''] == '''''''' ? ''''Si declina la obtenci&oacute;n del informe, debe indicar un motivo de incorrecci&oacute;n'''' : null) : (valores[''''T006_ValidacionInforme''''][''''comboValoracion''''] == '''''''' ? ''''Debe indicar la valoraci&oacute;n del proveedor'''' : existeAdjuntoUGValidacion("01","T")) )';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;



  -- ACTUACION TECNICA - VALIDACION TRABAJO F.APROBACION > FECHA > HOY() ----------------------------------
  V_TAP_TAP_CODIGOS := ' ''T004_ValidacionTrabajo'' ';
  V_TAP_VALOR := '(valores[''''T004_ValidacionTrabajo''''][''''comboEjecutado''''] == DDSiNo.NO ? (valores[''''T004_ValidacionTrabajo''''][''''motivoIncorreccion''''] == '''''''' ? ''''Si el trabajo no se ha ejecutado de forma correcta, debe indicar el motivo'''' : null) : (valores[''''T004_ValidacionTrabajo''''][''''comboValoracion''''] == '''''''' ? ''''Debe indicar la valoraci&oacute;n del proveedor'''' : null) )';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;



  -- TODOS - CIERRE ECONOMICO  F.VALIDACION > FECHA > HOY() ----------------------------------
  V_TAP_TAP_CODIGOS := ' ''T002_CierreEconomico'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T002_CierreEconomico''''][''''fechaCierre''''], fechaValidacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

  V_TAP_TAP_CODIGOS := ' ''T003_CierreEconomico'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T003_CierreEconomico''''][''''fechaCierre''''], fechaValidacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

  V_TAP_TAP_CODIGOS := ' ''T004_CierreEconomico'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T004_CierreEconomico''''][''''fechaCierre''''], fechaValidacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

  V_TAP_TAP_CODIGOS := ' ''T005_CierreEconomico'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T005_CierreEconomico''''][''''fechaCierre''''], fechaValidacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

  V_TAP_TAP_CODIGOS := ' ''T006_CierreEconomico'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T006_CierreEconomico''''][''''fechaCierre''''], fechaValidacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n'''' : null';
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

  V_TAP_TAP_CODIGOS := ' ''T008_CierreEconomico'' ';
  V_TAP_VALOR := 'esFechaMenor(valores[''''T002_CierreEconomico''''][''''fechaCierre''''], fechaValidacionTrabajo()) ? ''''Fecha cierre debe ser posterior o igual a fecha de validaci&oacute;n'''' : null';
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
