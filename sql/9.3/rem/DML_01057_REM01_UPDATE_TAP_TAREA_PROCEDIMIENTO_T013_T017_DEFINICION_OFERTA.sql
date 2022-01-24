--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20220124
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11089
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
        T_TIPO_DATA('T013_DefinicionOferta', 'checkCamposComprador() ? esOmega() ? checkReservaInformada()  ? null : ''''En la reserva del expediente se debe marcar si es necesaria o no para poder avanzar.''''  : checkImporteParticipacion()  ? checkCompradores()  ? checkVendido()  ? ''''El activo est&aacute; vendido''''  : checkComercializable()  ? checkBankia() ? checkImpuestos()  ? null  : ''''Debe indicar el tipo de impuesto y tipo aplicable.''''  : compruebaEstadoNoSolicitadoPendiente() ? ''''No se ha realizado el contraste de lista sobre todos los compradores.'''' : compruebaEstadoPositivoRealDenegado() ? ''''Hay compradores con un estado positivo real denegado en el contraste de listas.'''' : isOfertaDependiente() ? ''''Para sancionar esta oferta, hay que acceder a su Oferta Agrupada (Principal)''''  : null : ''''El activo debe ser comercializable''''  : ''''Los compradores deben sumar el 100%'''' : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' : ''''Es necesario cumplimentar todos los campos obligatorios de los compradores para avanzar la tarea.''''  '),
        T_TIPO_DATA('T017_DefinicionOferta', '(checkBankia() == true && checkExpedienteBloqueadoPorFuncion() == true) ? '''' El expediente est&aacute; bloqueado '''' : (checkBankia() == true  || checkReservaInformada() == true) ? checkImporteParticipacion() ? checkCamposComprador()  ? checkCompradores()  ? checkVendido() ? ''''El activo est&aacute; vendido'''' : checkComercializable() ? compruebaEstadoNoSolicitadoPendiente() ? '''' Hay compradores en los que no se ha realizado el contraste de listas'''' : compruebaEstadoPositivoRealDenegado() ?  ''''Hay compradores con un estado positivo real denegado en el contraste de listas'''' : null : ''''El activo debe ser comercializable''''  : ''''Los compradores deben sumar el 100%''''  : ''''Es necesario cumplimentar todos los campos obligatorios de los compradores para avanzar la tarea.''''  : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''  : ''''En la reserva del expediente se debe marcar si es necesaria o no para poder avanzar.'''' ')
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
		    		SET TAP_SCRIPT_VALIDACION =  '''||V_TMP_TIPO_DATA(2)||''' 
					,USUARIOMODIFICAR = ''REMVIP-11089''                    
		            ,FECHAMODIFICAR = SYSDATE
		            WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ';
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

EXIT;