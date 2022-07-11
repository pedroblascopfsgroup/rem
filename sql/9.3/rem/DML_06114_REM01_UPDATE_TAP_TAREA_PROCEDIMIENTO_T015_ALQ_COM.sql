--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220707
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18264
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3500);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        
		    T_TIPO_DATA('T015_CalculoRiesgo', '', 'checkBankia() ? valores[''''T015_CalculoRiesgo''''][''''comboRiesgo''''] == DDRiesgoOperacion.CODIGO_ROP_MEDIO || valores[''''T015_CalculoRiesgo''''][''''comboRiesgo''''] == DDRiesgoOperacion.CODIGO_ROP_BAJO  ? ''''RiesgoMedioBajo''''  :  valores[''''T015_CalculoRiesgo''''][''''comboRiesgo''''] == DDRiesgoOperacion.CODIGO_ROP_NO_APLICA ? ''''NoAplica'''' : ''''RiesgoAlto'''' : valores[''''T015_CalculoRiesgo''''][''''comboRiesgo''''] == DDRiesgoOperacion.CODIGO_ROP_NO_APLICA ? ''''NoAplica''''  : ''''RiesgoAltoMedioBajo'''''),
        T_TIPO_DATA('T015_PBC', '', 'checkBankia() ? valores[''''T015_PBC''''][''''comboResultado''''] == DDSiNo.SI ? ''''Aprueba'''' : ''''Anular'''' : valores[''''T015_PBC''''][''''comboResultado''''] == DDSiNo.SI ? ''''OK'''' : ''''Anular'''''),
        T_TIPO_DATA('T015_AprobacionOfertaAlquilerComercial', 'checkBankia() ? valores[''''T015_AprobacionOfertaAlquilerComercial''''][''''comboCodiciones''''] == DDSiNo.SI && valores[''''T015_AprobacionOfertaAlquilerComercial''''][''''comboAprobApi''''] == DDSiNo.SI && valores[''''T015_AprobacionOfertaAlquilerComercial''''][''''comboBorradorContratoApi''''] == DDSiNo.SI? null  : ''''Se deben rellenar los campos Condiciones pactadas aprobadas, Aprobaci&oacute;n comunicada a API y Borrador de contrato enviado a API de la tarea a ''''Si'''' para poder avanzar''''  :  null', 'checkBankia() ? valores[''''T015_AprobacionOfertaAlquilerComercial''''][''''comboResultado''''] == ''''01'''' ? ''''OK''''  : ''''Anulada'''' : null'),
        T_TIPO_DATA('T015_NegociacionClausulasAlquiler', '', 'checkBankia() ? valores[''''T015_NegociacionClausulasAlquiler''''][''''comboResultado''''] == DDSiNo.SI ? ''''Acepta''''  : ''''NoAcepta''''  : null'),
        T_TIPO_DATA('T015_RespuestaBcReagendacion', '', 'checkBankia() ? valores[''''T015_RespuestaBcReagendacion''''][''''comboReagendacion''''] == ''''01'''' ? ''''OK''''  : ''''Anulada'''' : null'),
        T_TIPO_DATA('T015_AprobacionClienteClausulas', '', 'checkBankia() ? valores[''''T015_AprobacionClienteClausulas''''][''''comboClienteAceptaBor''''] == DDSiNo.SI ? ''''Acepta''''  : valores[''''T015_AprobacionClienteClausulas''''][''''comboClienteAceptaBor''''] == DDSiNo.NO && valores[''''T015_AprobacionClienteClausulas''''][''''comboBcRenegocia''''] == DDSiNo.SI ? ''''AceptaNeg''''  : ''''Anula'''' : null'),
        T_TIPO_DATA('T015_AgendarFechaFirma', 'checkBankia() && valores[''''T015_AgendarFechaFirma''''][''''ibanDev''''] != null  ? checkIBANValido(valores[''''T015_AgendarFechaFirma''''][''''ibanDev''''])  ? null  : ''''El formato del IBAN no es v&aacute;lido'''' : null', 'checkBankia() ? valores[''''T015_AgendarFechaFirma''''][''''comboFianza''''] == DDSiNo.SI ? ''''AceptaFirma''''  : valores[''''T015_AgendarFechaFirma''''][''''comboFianza''''] == DDSiNo.NO ? ''''AceptaFianza''''  : null  : valores[''''T015_AgendarFechaFirma''''][''''comboResultado''''] == ''''01'''' ? ''''OK''''  : ''''Anulada'''''),
        T_TIPO_DATA('T015_Firma', '', 'checkBankia() ? valores[''''T015_Firma''''][''''comboFirma''''] == DDSiNo.SI ? ''''Firmado'''' : ''''Anulada'''' : null'),
        T_TIPO_DATA('T015_EntregaFianzas', '', 'checkBankia() ? valores[''''T015_EntregaFianzas''''][''''comboFianza''''] == DDSiNo.SI ? ''''FianzaOK''''  : getValorFianzaExonerada() == false && getFianzaExoneradaAndHistReagendacion().equals("EsMayorA3") ? ''''ExoneradaMayor''''  : getValorFianzaExonerada() == false && getFianzaExoneradaAndHistReagendacion().equals("EsMenorA3") ? ''''ExoneradaMenor''''  : null : null')

    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
--INSERT TAP_TAREA_PROCEDIMIENTO ----------------------------
 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
	  	EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ' INTO V_COUNT;
	
	    IF V_COUNT = 1 THEN
		  
	        DBMS_OUTPUT.PUT_LINE(' LA FILA  YA EXISTE EN [TAP_TAREA_PROCEDIMIENTO] ACTUALIZARLA');
	        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
          SET TAP_SCRIPT_VALIDACION_JBPM =  '''||V_TMP_TIPO_DATA(2)||''',
		    		  TAP_SCRIPT_DECISION =  '''||V_TMP_TIPO_DATA(3)||''' 
					,USUARIOMODIFICAR = ''HREOS-18264''
		            ,FECHAMODIFICAR = SYSDATE
		            WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' 
		        ';
			EXECUTE IMMEDIATE V_MSQL;
	    END IF;
	
	
	
	
	    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
	END LOOP;
	COMMIT;
	
DBMS_OUTPUT.PUT_LINE('[FIN] ');
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
