--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160427
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-299
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza las validaciones de doc. adjunto en varios trámites
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

    --REGISTRO TAP ELEGIDO
    V_TAP_TAP_CODIGOS VARCHAR2(4000 CHAR) := ' ''T002_ObtencionLPOGestorInterno'' ';

    --CAMPO TAP PARA ACTUALIZAR
    V_TAP_CAMPO VARCHAR2(100 CHAR)  := 'TAP_SCRIPT_VALIDACION_JBPM';
    V_TAP_VALOR VARCHAR2(1000 CHAR) := 'valores[''''T002_ObtencionLPOGestorInterno''''][''''comboObtencion''''] == DDSiNo.NO ? (valores[''''T002_ObtencionLPOGestorInterno''''][''''motivoNoObtencion''''] == '''''''' ? ''''Si declina la obtenci&oacute;n del documento, debe indicar un motivo de no obtenci&oacute;n'''' : null) : existeAdjuntoUGValidacion("","T")';

  
BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] Actualización de validaciones de doc. adjunto obligatorio para que sean <POST> en la tarea');


--T002_ObtencionLPOGestorInterno--------------------------------------------

  --TRAMITE OBTENCION DOCUMENTAL, HACE LA VALIDACION DE DOC ADJUNTO AL GUARDAR LA TAREA SOLO SI SE INDICA QUE SE HA OBTENIDO
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

  -- SE QUITA LA VALIDACION <PRE> DE DOC ADJUNTO
  V_TAP_CAMPO := 'TAP_SCRIPT_VALIDACION';
  V_TAP_VALOR := '';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


--T002_ObtencionDocumentoGestoria--------------------------------------------

  V_TAP_TAP_CODIGOS := ' ''T002_ObtencionDocumentoGestoria'' ';

  --CAMPO TAP PARA ACTUALIZAR
  V_TAP_CAMPO := 'TAP_SCRIPT_VALIDACION_JBPM';
  V_TAP_VALOR := 'valores[''''T002_ObtencionDocumentoGestoria''''][''''comboObtencion''''] == DDSiNo.NO ? (valores[''''T002_ObtencionDocumentoGestoria''''][''''motivoNoObtencion''''] == '''''''' ? ''''Si declina la obtenci&oacute;n del documento, debe indicar un motivo de no obtenci&oacute;n'''' : null) : existeAdjuntoUGValidacion("","T")';

  --TRAMITE OBTENCION DOCUMENTAL, HACE LA VALIDACION DE DOC ADJUNTO AL GUARDAR LA TAREA SOLO SI SE INDICA QUE SE HA OBTENIDO
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
           SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
           WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
           ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

  -- SE QUITA LA VALIDACION <PRE> DE DOC ADJUNTO
  V_TAP_CAMPO := 'TAP_SCRIPT_VALIDACION';
  V_TAP_VALOR := '';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


--T008_ObtencionDocumento--------------------------------------------

  V_TAP_TAP_CODIGOS := ' ''T008_ObtencionDocumento'' ';

  --CAMPO TAP PARA ACTUALIZAR
  V_TAP_CAMPO := 'TAP_SCRIPT_VALIDACION_JBPM';
  V_TAP_VALOR := 'valores[''''T008_ObtencionDocumento''''][''''comboObtencion''''] == DDSiNo.NO ? (valores[''''T008_ObtencionDocumento''''][''''motivoNoObtencion''''] == '''''''' ? ''''Si declina la obtenci&oacute;n del documento, debe indicar un motivo de no obtenci&oacute;n'''' : null) : existeAdjuntoUGValidacion("","T")';

  --TRAMITE OBTENCION DOCUMENTAL, HACE LA VALIDACION DE DOC ADJUNTO AL GUARDAR LA TAREA SOLO SI SE INDICA QUE SE HA OBTENIDO
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
           SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
           WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
           ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

  -- SE QUITA LA VALIDACION <PRE> DE DOC ADJUNTO
  V_TAP_CAMPO := 'TAP_SCRIPT_VALIDACION';
  V_TAP_VALOR := '';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
             SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
             WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;


--T006_ValidacionInforme--------------------------------------------

  V_TAP_TAP_CODIGOS := ' ''T006_ValidacionInforme'' ';

  --CAMPO TAP PARA ACTUALIZAR
  V_TAP_CAMPO := 'TAP_SCRIPT_VALIDACION_JBPM';
  V_TAP_VALOR := 'valores[''''T006_ValidacionInforme''''][''''comboCorreccion''''] == DDSiNo.NO ? (valores[''''T006_ValidacionInforme''''][''''motivoIncorreccion''''] == '''''''' ? ''''Si declina la obtenci&oacute;n del informe, debe indicar un motivo de incorrecci&oacute;n'''' : null) : (valores[''''T006_ValidacionInforme''''][''''comboValoracion''''] == '''''''' ? ''''Debe indicar la valoraci&oacute;n del proveedor'''' : existeAdjuntoUGValidacion("01","T"))';

  --TRAMITE OBTENCION DOCUMENTAL, HACE LA VALIDACION DE DOC ADJUNTO AL GUARDAR LA TAREA SOLO SI SE INDICA QUE SE HA OBTENIDO
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
           SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
           WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
           ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;

  -- SE QUITA LA VALIDACION <PRE> DE DOC ADJUNTO
  V_TAP_CAMPO := 'TAP_SCRIPT_VALIDACION';
  V_TAP_VALOR := '';

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
