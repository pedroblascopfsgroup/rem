--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-286
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el Trámite de Admisión
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
    V_TAP_TAP_CODIGOS VARCHAR2(4000 CHAR) := ' ''T001_CheckingDocumentacionAdmision''
                                            , ''T001_CheckingDocumentacionGestion''
                                            , ''T001_VerificarEstadoPosesorio'' ';

    --CAMPO TFI PARA ACTUALIZAR
    V_PTP_CAMPO VARCHAR2(100 CHAR)  := 'DD_PTP_PLAZO_SCRIPT';
    V_PTP_VALOR VARCHAR2(1000 CHAR) := '15*24*60*60*1000L';

  
BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO CAMPO '||V_PTP_CAMPO||' DE TABLA DD_PTP_PLAZOS_TAREAS_PLAZAS PARA T. ADMISIÓN - PLAZOS');



  --TODOS menos T001_CheckingInformacion - 15 Días -------------------------------------------------------
  V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS
             SET '||V_PTP_CAMPO||'='''||V_PTP_VALOR||''' 
             WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||'))
             ';

  DBMS_OUTPUT.PUT_LINE('[SQL] '||V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;



  --T001_CheckingInformacion - 30 Días ------------------------------------

  V_TAP_TAP_CODIGOS :=' ''T001_CheckingInformacion'' ';
  V_PTP_VALOR := '30*24*60*60*1000L';

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS
             SET '||V_PTP_CAMPO||'='''||V_PTP_VALOR||''' 
             WHERE TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||'))
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
