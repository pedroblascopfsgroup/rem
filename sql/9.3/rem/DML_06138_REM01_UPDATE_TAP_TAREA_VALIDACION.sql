--/*
--##########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=20220919
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-18654
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza los datos del array en TAP_TAREA_PROCEDIMIENTO
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
	
    V_ID NUMBER(16);
    V_TABLA VARCHAR2(50 CHAR):= 'TAP_TAREA_PROCEDIMIENTO';
    V_CHARS VARCHAR2(3 CHAR):= 'TAP';
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-18654';
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(32000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                          -- CODIGO  			                  VALIDACION
T_TIPO_DATA('T018_FirmaContrato','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_RespuestaReagendacionBC','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T015_AprobacionClienteClausulas','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T015_RespuestaBcReagendacion','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T015_EntregaFianzas','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T015_NegociacionClausulasAlquiler','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T015_AprobacionOfertaAlquilerComercial','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_FirmaRescisionContrato','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_ProponerRescisionCliente','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_AltaContratoAlquilerAdenda','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_FirmaAdenda','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_AgendarFirmaAdenda','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_AprobacionContrato','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_AltaContratoAlquiler','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_ComunicarSubrogacion','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_AprobacionOferta','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_EntregaFianzas','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_RespuestaContraofertaBC','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_AprobacionAlquilerSocial','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_CalculoRiesgo','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T015_CalculoRiesgo','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T018_DatosPBC','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T015_DatosPBC','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null'),
T_TIPO_DATA('T017_FirmaPropietario','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''''),
T_TIPO_DATA('T018_CierreContrato','(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? ''''El expediente est&aacute; bloqueado'''' : null')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
   
BEGIN	
	

	 
    -- LOOP para insertar los valores -----------------------------------------------------------------

    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP

      V_TMP_TIPO_DATA := V_TIPO_DATA(I);
    	
      --Comprobamos el dato a insertar
      V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE '||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
      EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
      
      --Si existe lo modificamos
      IF V_NUM_TABLAS > 0 THEN				
        
        DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
        V_MSQL := '
          UPDATE '|| V_ESQUEMA ||'.'||V_TABLA||' 
          SET 
            '||V_CHARS||'_SCRIPT_VALIDACION = '''||TRIM(V_TMP_TIPO_DATA(2))||''',
	    USUARIOMODIFICAR = '''||V_USUARIO||''',
            FECHAMODIFICAR = SYSDATE
			    WHERE '||V_CHARS||'_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND '||V_CHARS||'_SCRIPT_VALIDACION IS NULL';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
      
      END IF;

    END LOOP;
  COMMIT;
   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line(V_MSQL);
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
