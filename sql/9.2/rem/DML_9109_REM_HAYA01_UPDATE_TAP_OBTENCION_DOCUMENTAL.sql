--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160413
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
    V_TAP_TAP_CODIGOS VARCHAR2(4000 CHAR) := ' ''T002_ObtencionDocumentoGestoria''
                                              ,''T002_ObtencionLPOGestorInterno''
                                              ,''T003_EmisionCertificado''
                                              ,''T003_ObtencionEtiqueta''
                                              ,''T008_ObtencionDocumento'' ';

    --CAMPO TFI PARA ACTUALIZAR
    V_TAP_CAMPO VARCHAR2(100 CHAR)  := 'TAP_SCRIPT_VALIDACION';
    V_TAP_VALOR VARCHAR2(1000 CHAR) := 'existeAdjuntoUGValidacion("","T")';

  
BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO CAMPO '||V_TAP_CAMPO||' DE TABLA TAP PARA OBTENCION DOCUMENTAL');

  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||')' ;
  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
  
  IF V_NUM_TABLAS = 0 THEN
  
    DBMS_OUTPUT.PUT_LINE('[WARN] ' ||V_ESQUEMA|| '.TAP_TAREAS_PROCEDIMIENTO - NO EXISTE EL REGISTRO CON TAP_CODIGO =  '||V_TAP_TAP_CODIGOS||'.');
    DBMS_OUTPUT.PUT_LINE('[WARN] ' ||V_ESQUEMA|| '.TAP_TAREAS_PROCEDIMIENTO - SE ABORTA ESTE SCRIPT.');

    DBMS_OUTPUT.PUT_LINE('[FIN] SCRIPT EJECUTADO CON PROBLEMAS ');

  ELSE


    --TRAMITE OBTENCION DOCUMENTAL, HACE LA VALIDACION POR MAPEO TIPODOC/SUBTIPO TRABAJO
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
               SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
               WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
               ';

    DBMS_OUTPUT.PUT_LINE('[SQL] '||V_TAP_TAP_CODIGOS);
    EXECUTE IMMEDIATE V_MSQL;


    --PARA RESTO DE TRAMITES (NO HAY MAPEO), REQUERIMOS DOCUMENTOS POR CODIGO - LOS QUE CORRESPONDEN POR TRAMITE/TAREA
    V_TAP_VALOR := 'existeAdjuntoUGValidacion("07","T")';
    V_TAP_TAP_CODIGOS := ' ''T005_EmisionTasacion'' ';

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
               SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
               WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
               ';

    DBMS_OUTPUT.PUT_LINE('[SQL] '||V_TAP_TAP_CODIGOS);
    EXECUTE IMMEDIATE V_MSQL;
                                              

    V_TAP_VALOR := 'existeAdjuntoUGValidacion("01","T")';
    V_TAP_TAP_CODIGOS := ' ''T006_ValidacionInforme'' ';

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO
               SET '||V_TAP_CAMPO||'='''||V_TAP_VALOR||''' 
               WHERE TAP_CODIGO IN ('||V_TAP_TAP_CODIGOS||') 
               ';

    DBMS_OUTPUT.PUT_LINE('[SQL] '||V_TAP_TAP_CODIGOS);
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
