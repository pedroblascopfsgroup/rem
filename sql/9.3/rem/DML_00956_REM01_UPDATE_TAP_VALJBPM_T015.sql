--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20211026
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15708
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualizaci&oacute;n de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    	T_TIPO_DATA('T015_AgendarFechaFirma', 'checkBankia() == true  ? valores[''''T015_AgendarFechaFirma''''][''''comboResultado''''] == DDSiNo.NO ? tieneRellenosCamposAnulacion() ? null  : ''''Se deben rellenar el motivo anulaci&oacute;n y el detalle anulaci&oacute;n''''  : checkContratoSubido() ? null : ''''Es necesario adjuntar sobre el Expediente Comercial, el documento Contrato.'''' : null'),
		T_TIPO_DATA('T015_AceptacionCliente', '(checkBankia() == true && valores[''''T015_AceptacionCliente''''][''''aceptacionContraoferta''''] == DDSiNo.NO) ? tieneRellenosCamposAnulacion() ? null : ''''Se deben rellenar el motivo anulaci&oacute;n y el detalle anulaci&oacute;n'''' : null'),
		T_TIPO_DATA('T015_SancionPatrimonio', '(checkBankia() == true && valores[''''T015_SancionPatrimonio''''][''''comboResultado''''] == DDSiNo.NO) ? tieneRellenosCamposAnulacion() ? null : ''''Se deben rellenar el motivo anulaci&oacute;n y el detalle anulaci&oacute;n'''' : null'),
		T_TIPO_DATA('T015_SancionBC',         '(checkBankia() == true && valores[''''T015_SancionBC''''][''''comboResolucion''''] == DDSiNo.NO) ? tieneRellenosCamposAnulacion() ? null : ''''Se deben rellenar el motivo anulaci&oacute;n y el detalle anulaci&oacute;n'''' : null'),
		T_TIPO_DATA('T015_ScoringBC',         '(checkBankia() == true && valores[''''T015_ScoringBC''''][''''comboResolucion''''] == DDSiNo.NO) ? tieneRellenosCamposAnulacion() ? null : ''''Se deben rellenar el motivo anulaci&oacute;n y el detalle anulaci&oacute;n'''' : null'),
		T_TIPO_DATA('T015_ElevarASancion',   '(checkBankia() == true && valores[''''T015_ElevarASancion''''][''''resolucionOferta''''] == DDRespuestaOfertante.CODIGO_RECHAZA) ? tieneRellenosCamposAnulacion() ? null : ''''Se deben rellenar el motivo anulaci&oacute;n y el detalle anulaci&oacute;n'''' : null'),
		T_TIPO_DATA('T015_SolicitarGarantiasAdicionales', 'checkBankia() == true ? (haPasadoScoringBC() && valores[''''T015_SolicitarGarantiasAdicionales''''][''''comboResultado''''] == DDSiNo.NO)  ? tieneRellenosCamposAnulacion()  ? null  : ''''Se deben rellenar el motivo anulaci&oacute;n y el detalle anulaci&oacute;n'''' : null : null'),
		T_TIPO_DATA('T015_VerificarScoring',  '(checkBankia() == true && valores[''''T015_VerificarScoring''''][''''resultadoScoring''''] == DDResultadoScoring.RESULTADO_RECHAZADO) ? tieneRellenosCamposAnulacion() ? null : ''''Se deben rellenar el motivo anulaci&oacute;n y el detalle anulaci&oacute;n'''' : null')
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
		    		SET TAP_SCRIPT_VALIDACION_JBPM =  '''||V_TMP_TIPO_DATA(2)||''' 
					,USUARIOMODIFICAR = ''HREOS-15708''                    
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