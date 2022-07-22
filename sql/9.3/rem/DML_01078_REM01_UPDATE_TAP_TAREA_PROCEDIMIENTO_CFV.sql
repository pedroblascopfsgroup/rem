--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20220718
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12022
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
        T_TIPO_DATA('T013_DefinicionOferta', 'esOfertaPrincipalSinDependientes() ? existeAdjuntoUGCarteraValidacion("36", "E", "01") == null ? valores[''''T013_DefinicionOferta''''][''''comboConflicto''''] == DDSiNo.SI || valores[''''T013_DefinicionOferta''''][''''comboRiesgo''''] == DDSiNo.SI  ?  ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' : definicionOfertaT013(valores[''''T013_DefinicionOferta''''][''''comite'''']) : existeAdjuntoUGCarteraValidacion("36", "E", "01") : ''''No se puede avanzar una oferta principal sin dependientes.'''''),
        T_TIPO_DATA('T013_RatificacionComite', 'ratificacionComiteT013()'),
        T_TIPO_DATA('T013_ResolucionComite', 'valores[''''T013_ResolucionComite''''][''''comboResolucion''''] != DDResolucionComite.CODIGO_APRUEBA ? valores[''''T013_ResolucionComite''''][''''comboResolucion''''] == DDResolucionComite.CODIGO_CONTRAOFERTA ? checkLiberbank() || checkGiants() ? null : existeAdjuntoUGValidacion("22","E") : null : resolucionComiteT013()'),
        T_TIPO_DATA('T013_RespuestaOfertante', 'valores[''''T013_RespuestaOfertante''''][''''comboRespuesta''''] != DDRespuestaOfertante.CODIGO_RECHAZA ? respuestaOfertanteT013(valores[''''T013_RespuestaOfertante''''][''''importeOfertante'''']) : null'),
        T_TIPO_DATA('T013_ResultadoPBC', 'null'),
        T_TIPO_DATA('T017_PBCVenta', 'valores[''''T017_PBCVenta''''][''''comboRespuesta''''] == DDSiNo.SI  ? checkBankia()  ? checkEstadoBC() ? checkFechaContabilizacionArras() ? null : ''''El expediente tiene arras y no tiene fecha de contabilizaci&oacute;n de arras.'''' : ''''No se puede avanzar porque est&aacute; pendiente de BC'''' : null : null'),
        T_TIPO_DATA('T017_RatificacionComiteCES', 'null'),
        T_TIPO_DATA('T017_ResolucionCES', 'null'),
        T_TIPO_DATA('T017_RespuestaOfertanteCES', 'valores[''''T017_RespuestaOfertanteCES''''][''''comboRespuesta''''] != DDRespuestaOfertante.CODIGO_ACEPTA ? valores[''''T017_RespuestaOfertanteCES''''][''''comboRespuesta''''] == DDRespuestaOfertante.CODIGO_CONTRAOFERTA ? respuestaOfertanteT013(valores[''''T017_RespuestaOfertanteCES''''][''''importeOfertante'''']) : null : null')
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
	        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
		    		SET TAP_SCRIPT_VALIDACION_JBPM =  '''||V_TMP_TIPO_DATA(2)||''' 
					,USUARIOMODIFICAR = ''REMVIP-12022''                    
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