--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20221011
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12505
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
        T_TIPO_DATA('T017_ResolucionCES', ' checkBankia() ? checkExpedienteBloqueadoPorFuncion() == true ? '''' El expediente est&aacute; bloqueado '''' : null : checkReservaInformada() == false ? ''''En la reserva del expediente se debe marcar si es necesaria o no para poder avanzar.'''' : checkImporteParticipacion()  ? (checkCompradores() ? (checkVendido()  ? ''''El activo est&aacute; vendido''''  : (checkComercializable() ? (checkPoliticaCorporativa()  ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.''''): ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' '),
        T_TIPO_DATA('T017_ConfirmarFechaEscritura', '(checkBankia() && valores[''''T017_ConfirmarFechaEscritura''''][''''cambioRiesgo''''] == DDSiNo.SI) ? null :  (checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true)  ? '''' El expediente est&aacute; bloqueado '''' : (checkBankia() == true && (checkAprobadoRechazadoBCPosicionamiento() == false && userHasPermisoParaAvanzarTareas() == false )) ? ''''El estado de Validaci&oacute;n BC de la fecha arras tiene que ser Aceptado o Rechazado'''' : null')
                    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
	  	EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ' INTO V_COUNT;
	
	    IF V_COUNT = 1 THEN
		  
	        DBMS_OUTPUT.PUT_LINE(' LA FILA  YA EXISTE EN [TAP_TAREA_PROCEDIMIENTO] ACTUALIZARLA');
	        EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
		    		SET TAP_SCRIPT_VALIDACION =  '''||V_TMP_TIPO_DATA(2)||''' 
					,USUARIOMODIFICAR = ''REMVIP-12505''                    
		            ,FECHAMODIFICAR = SYSDATE
		            WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ';
	    END IF;
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');
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

EXIT;