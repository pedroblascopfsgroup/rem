--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190827
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.16.0
--## INCIDENCIA_LINK=HREOS-7272
--## PRODUCTO=NO
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
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
	SET 
  TAP_SCRIPT_VALIDACION_JBPM = ''existeAdjuntoUGCarteraValidacion("36", "E", "01") == null ? valores[''''T013_DefinicionOferta''''][''''comboConflicto''''] == DDSiNo.SI || valores[''''T013_DefinicionOferta''''][''''comboRiesgo''''] == DDSiNo.SI  ?  ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' : comprobarComiteLiberbankPlantillaPropuesta() ? existeAdjuntoUGCarteraValidacion("36", "E", "08") : isValidateOfertasDependientes() ? definicionOfertaT013(valores[''''T013_DefinicionOferta''''][''''comiteSuperior'''']) : ''''Una o varias ofertas dependientes tienen errores'''' : existeAdjuntoUGCarteraValidacion("36", "E", "01")'' ,
	USUARIOMODIFICAR = ''HREOS-7272'', 
	FECHAMODIFICAR = SYSDATE 
	WHERE TAP_CODIGO = ''T013_DefinicionOferta''';

  EXECUTE IMMEDIATE V_MSQL;

  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
  SET 
  TAP_SCRIPT_VALIDACION_JBPM = ''valores[''''T013_ResolucionComite''''][''''comboResolucion''''] != DDResolucionComite.CODIGO_APRUEBA ? (valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_CONTRAOFERTA ? checkBankia() || checkLiberbank() || checkGiants() ? null : existeAdjuntoUGValidacion("22","E") : null) : isValidateOfertasDependientes() ? resolucionComiteT013() : ''''Una o varias ofertas dependientes tienen errores'''' '' ,
  USUARIOMODIFICAR = ''HREOS-7272'', 
  FECHAMODIFICAR = SYSDATE 
  WHERE TAP_CODIGO = ''T013_ResolucionComite''';

	EXECUTE IMMEDIATE V_MSQL;
    
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
   			

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
