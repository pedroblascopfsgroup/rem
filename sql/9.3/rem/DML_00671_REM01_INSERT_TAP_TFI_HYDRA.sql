--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20210517
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13991
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
    -- TAP_CODIGO  TAP_DESCRIPCION   TAP_SCRIPT_VALIDACION   TAP_SCRIPT_VALIDACION_JBPM   TAP_SCRIPT_DECISION
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('T017_PBC_CN', 'PBC CN', '', '', 'valores[''''T017_PBC_CN''''][''''comboResultado''''] == DDSiNo.NO ? ''''resultadoPositivo'''' : ''''resultadoNegativo'''''),
        T_TIPO_DATA('T017_AgendarFechaFirmaArras', 'Agendar fecha firma arras', '', '', ''),
        T_TIPO_DATA('T017_ConfirmarFechaFirmaArras', 'Confirmación fecha firma arras', '', '', 'valores[''''T017_ConfirmarFechaFirmaArras''''][''''comboConfirmado''''] == DDSiNo.SI ? ''''Confirmado'''' : ''''noConfirmado'''''),
        T_TIPO_DATA('T017_AgendarPosicionamiento', 'Agendar posicionamiento', '', '', ''),
        T_TIPO_DATA('T017_ConfirmarFechaEscritura', 'Confirmación fecha firma contrato', '!tieneTramiteGENCATVigenteByIdActivo() ? checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' : ''''El activo tiene un tr&aacute;mite GENCAT en curso.''''', 
    				'checkExpedienteBloqueado() ? (valores[''''T017_ConfirmarFechaEscritura''''][''''comboConfirmado''''] == DDSiNo.SI ? (checkPosicionamiento() ? null : ''''El expediente debe tener alg&uacute;n posicionamiento'''') : null) : ''''El expediente no est&aacute; bloqueado''''', 
        			'valores[''''T017_ConfirmarFechaEscritura''''][''''comboConfirmado''''] == DDSiNo.SI ? ''''Confirmado'''' : ''''noConfirmado'''''),
        T_TIPO_DATA('T017_FirmaContrato', 'Firma contrato', '!tieneTramiteGENCATVigenteByIdActivo() ? checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' : ''''El activo tiene un tr&aacute;mite GENCAT en curso.''''', 
			        'checkExpedienteBloqueado() ? (valores[''''T017_FirmaContrato''''][''''comboFirma''''] == DDSiNo.SI ? (checkPosicionamiento() ? null : ''''El expediente debe tener alg&uacute;n posicionamiento'''') : null) : ''''El expediente no est&aacute; bloqueado''''', 
			        'valores[''''T017_FirmaContrato''''][''''comboFirma''''] == DDSiNo.SI ? ''''Firmado'''' : ''''NoFirmado'''''),
        T_TIPO_DATA('T017_DefinicionOferta', 'Definición oferta', 'checkReservaInformada() ? checkImporteParticipacion() ? checkCamposComprador() ? checkCompradores() ? checkVendido() ? ''''El activo est&aacute; vendido'''' : checkComercializable() ? null : ''''El activo debe ser comercializable'''' : ''''Los compradores deben sumar el 100%'''' : ''''Es necesario cumplimentar todos los campos obligatorios de los compradores para avanzar la tarea.'''' : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente'''' : ''''En la reserva del expediente se debe marcar si es necesaria o no para poder avanzar.''''', 
        			'checkReservaInformada() ? checkTipoImpuesto() ? checkDepositoDespublicacionSubido() ? checkDepositoRelleno() ? existeAdjuntoUGCarteraValidacion("36", "E", "01") == null ? valores[''''T017_DefinicionOferta''''][''''comboConflicto''''] == DDSiNo.SI || valores[''''T017_DefinicionOferta''''][''''comboRiesgo''''] == DDSiNo.SI ? ''''El estado de la responsabilidad corporativa no es el correcto para poder avanzar.'''' : definicionOfertaT013(valores[''''T017_DefinicionOferta''''][''''comiteSuperior'''']) : existeAdjuntoUGCarteraValidacion("36", "E", "01") : ''''Es necesario rellenar el campo Dep&oacute;sito en la pesta&ntilde;a Condiciones.'''' : ''''Es necesario adjuntar sobre el Expediente Comercial, el documento Dep&oacute;sito para la despublicaci&oacute;n del activo.'''' : ''''En las condiciones del expediente, el tipo de impuesto debe estar informado para poder avanzar.'''' : ''''En la reserva del expediente se debe marcar si es necesaria o no para poder avanzar.''''', 
        			'checkBankia() ? esMayorista() ? ''''Mayorista'''' : ''''noMayorista'''' : null'),
		T_TIPO_DATA('T017_PBCReserva', 'PBC Reserva', '', '', 'valores[''''T017_PBCReserva''''][''''comboRespuesta''''] == DDApruebaDeniega.CODIGO_APRUEBA ? checkBankia() ? ''''ApruebaBC'''' : ''''Aprueba'''' : ''''Deniega'''''),
		T_TIPO_DATA('T017_PBCVenta', 'PBC Venta', '!tieneTramiteGENCATVigenteByIdActivo() ? null : ''''El activo tiene un tr&aacute;mite GENCAT en curso.''''', 
					'', 
					'valores[''''T017_PBCVenta''''][''''comboRespuesta''''] == DDApruebaDeniega.CODIGO_APRUEBA ? checkBankia() ? ''''ApruebaBC'''' : ''''Aprueba'''' : ''''Deniega''''')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
--INSERT TAP_TAREA_PROCEDIMIENTO ----------------------------
 FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
	  	EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ' INTO V_COUNT;
	
	    IF V_COUNT = 0 THEN
		   	DBMS_OUTPUT.PUT_LINE(' INSERTANDO EN [TAP_TAREA_PROCEDIMIENTO] ');
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
		    VALUES(
		            '||V_ESQUEMA||'.S_TAP_TAREA_PROCEDIMIENTO.NEXTVAL 
		            ,(SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO LIKE ''%T017%'') 
		            ,'''||V_TMP_TIPO_DATA(1)||''' 
		            ,null 
		            ,'''||V_TMP_TIPO_DATA(3)||''' 
					,'''||V_TMP_TIPO_DATA(4)||''' 
					,'''||V_TMP_TIPO_DATA(5)||''' 
		            ,null  
		            ,0  
		            ,'''||V_TMP_TIPO_DATA(2)||''' 
		            ,0
		            ,''HREOS-13991''
		            ,SYSDATE
		            ,null 
		            ,null 
		            ,null 
		            ,null 
		            ,0 
		            , null 
		            , null
		            , null
		            , 0 
		            ,''EXTTareaProcedimiento'' 
		            ,3
		            , (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GCOM'') 
		            , (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''811'') 
		            ,null
		            ,null
		            ,null
		        )';
			EXECUTE IMMEDIATE V_MSQL;
	        DBMS_OUTPUT.PUT_LINE('INSERCION EN [TAP_TAREA_PROCEDIMIENTO] CORRECTA');
	    ELSE
	        DBMS_OUTPUT.PUT_LINE(' LA FILA  YA EXISTE EN [TAP_TAREA_PROCEDIMIENTO] ACTUALIZARLA');
	        V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO 
		    		SET TAP_DESCRIPCION = '''||V_TMP_TIPO_DATA(2)||''' 
		            ,TAP_SCRIPT_VALIDACION =  '''||V_TMP_TIPO_DATA(3)||''' 
		            ,TAP_SCRIPT_VALIDACION_JBPM = '''||V_TMP_TIPO_DATA(4)||''' 
					,TAP_SCRIPT_DECISION = '''||V_TMP_TIPO_DATA(5)||''' 
					,USUARIOMODIFICAR = ''HREOS-13991''
		            ,FECHAMODIFICAR = SYSDATE
		            WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' 
		        ';
			EXECUTE IMMEDIATE V_MSQL;
	    END IF;
	
	--INSERT TFI_TAREA_FORMS_ITEMS ----------------------------
	 
	   DBMS_OUTPUT.PUT_LINE(' INSERTANDO EN [TFI_TAREAS_FORM_ITEMS] ');
	    EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''' ) ' INTO V_COUNT;
	
	    IF V_COUNT = 0 THEN
			V_MSQL := ' INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
		            VALUES (
		                    '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
		                    ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
		                    , 0
		                    , ''label''  , ''titulo'', ''<p style="margin-bottom:10px">Instrucciones por defecto de la tarea '''''||V_TMP_TIPO_DATA(2)||''''' </p>''
		                    , null , null  , null , null  , 0, ''HREOS-13991'', SYSDATE , null, null, null , null  , 0)';
		    EXECUTE IMMEDIATE V_MSQL;
	    
	       	
	
			IF V_TMP_TIPO_DATA(1) = 'T017_PBC_CN' THEN
	        	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	                VALUES (
	                    '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
	                    ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	                    ,  1, ''combobox'', ''comboResultado'' , ''Resultado negativo'' , ''Debe indicar si el resultado es Negativo o No'' , ''false'' 
	                    , null , ''DDSiNo''  , 0, ''HREOS-13991'', SYSDATE , null, null, null , null  , 0
	                )';
				EXECUTE IMMEDIATE V_MSQL;
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	                VALUES (
	                    '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
	                    ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	                    ,  2, ''textarea'', ''observaciones'' , ''Observaciones'' , null , null 
	                    , null , null  , 0, ''HREOS-13991'', SYSDATE , null, null, null , null  , 0
	                )';
				EXECUTE IMMEDIATE V_MSQL;
				
			ELSIF V_TMP_TIPO_DATA(1) = 'T017_ConfirmarFechaFirmaArras' THEN
				--V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	              --  VALUES (
	                --    '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
	                  --  ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	                   -- ,  1, ''combobox'', ''comboConfirmado'' , ''Confirmar fecha firma arras'' , ''Debe indicar si la fecha firma arras está confirmada o no'' , ''false'' 
	                   -- , null , ''DDSiNo''  , 0, ''HREOS-13991'', SYSDATE , null, null, null , null  , 0
	               -- )';
				--EXECUTE IMMEDIATE V_MSQL;
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	                VALUES (
	                    '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
	                    ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	                    ,  2, ''textarea'', ''observaciones'' , ''Observaciones'' , null , null 
	                    , null , null  , 0, ''HREOS-13991'', SYSDATE , null, null, null , null  , 0
	                )';
				EXECUTE IMMEDIATE V_MSQL;
				
			ELSIF V_TMP_TIPO_DATA(1) = 'T017_ConfirmarFechaEscritura' THEN
				--V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	           --     VALUES (
	              --      '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
	             --       ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	             --       ,  1, ''combobox'', ''comboConfirmado'' , ''Confirmar fecha firma arras'' , ''Debe indicar si la fecha firma escritura está confirmada o no'' , ''false'' 
	             --      , null , ''DDSiNo''  , 0, ''HREOS-13991'', SYSDATE , null, null, null , null  , 0
	            --    )';
			--	EXECUTE IMMEDIATE V_MSQL;
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	                VALUES (
	                    '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
	                    ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	                    ,  2, ''textarea'', ''observaciones'' , ''Observaciones'' , null , null 
	                    , null , null  , 0, ''HREOS-13991'', SYSDATE , null, null, null , null  , 0
	                )';
				EXECUTE IMMEDIATE V_MSQL;
				
			ELSIF V_TMP_TIPO_DATA(1) = 'T017_FirmaContrato' THEN
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	                VALUES (
	                    '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
	                    ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	                    ,  1, ''combobox'', ''comboFirma'' , ''Reserva firmada'' , ''Debe indicar si la reserva está firmada o no'' , ''false'' 
	                    , null , ''DDSiNo''  , 0, ''HREOS-13991'', SYSDATE , null, null, null , null  , 0
	                )';
				EXECUTE IMMEDIATE V_MSQL;
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	                VALUES (
	                    '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
	                    ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	                    ,  2, ''textarea'', ''observaciones'' , ''Observaciones'' , null , null 
	                    , null , null  , 0, ''HREOS-13991'', SYSDATE , null, null, null , null  , 0
	                )';
				EXECUTE IMMEDIATE V_MSQL;
				
			ELSE
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	                VALUES (
	                    '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
	                    ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	                    ,  1, ''textarea'', ''observaciones'' , ''Observaciones'' , null , null 
	                    , null , null  , 0, ''HREOS-13991'', SYSDATE , null, null, null , null  , 0
	                )';
				EXECUTE IMMEDIATE V_MSQL;
	        END IF;
	    	DBMS_OUTPUT.PUT_LINE('INSERCION EN [TFI_TAREAS_FORM_ITEMS] CORRECTA');
	    ELSE
	        DBMS_OUTPUT.PUT_LINE(' LA FILA  YA EXISTE EN [TFI_TAREAS_FORM_ITEMS]');
	    END IF;
	
	--INSERT DD_PTP_PLAZOS_TAREAS_PLAZAS  ----------------------------
	    DBMS_OUTPUT.PUT_LINE(' INSERTANDO EN [DD_PTP_PLAZOS_TAREAS_PLAZAS] ');
	    EXECUTE IMMEDIATE 'SELECT count(1) FROM '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''') ' INTO V_COUNT;
	
	    IF V_COUNT = 0 THEN
	        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_PTP_PLAZOS_TAREAS_PLAZAS
	            VALUES (
	                '||V_ESQUEMA||'.S_DD_PTP_PLAZOS_TAREAS_PLAZAS.NEXTVAL
	                ,null ,null
	                ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	                ,''5*24*60*60*1000L''
	                ,0
	                ,''HREOS-13991''
	                ,SYSDATE
	                , null,null,null,null
	                ,0
	                ,0
	                ,null
	            )';
	        EXECUTE IMMEDIATE V_MSQL;
	        
	        DBMS_OUTPUT.PUT_LINE(' INSERCION EN [DD_PTP_PLAZOS_TAREAS_PLAZAS] CORRECTA');
	    ELSE
	        DBMS_OUTPUT.PUT_LINE(' LA FILA YA EXISE EN [DD_PTP_PLAZOS_TAREAS_PLAZAS]');
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
