--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20220110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10895
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
    
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10895';
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3500);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- TAP_CODIGO  TAP_DESCRIPCION   TAP_SCRIPT_VALIDACION   TAP_SCRIPT_VALIDACION_JBPM   TAP_SCRIPT_DECISION
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        
		T_TIPO_DATA('T017_FirmaPropietario', 'Firma propietario', 'checkImporteParticipacion() ? (checkCompradores() ? (checkVendido() ? ''''El activo est&aacute; vendido'''' : (checkComercializable() ? (checkPoliticaCorporativa() ?  null : ''''El estado de la pol&iacute;tica corporativa no es el correcto para poder avanzar.'''') : ''''El activo debe ser comercializable'''') ) : ''''Los compradores deben sumar el 100%'''') : ''''El sumatorio de importes de participaci&oacute;n de los activos ha de ser el mismo que el importe total del expediente''''', 'valores[''''T017_FirmaPropietario''''][''''comboFirma''''] == DDSiNo.NO ? (valores[''''T017_FirmaPropietario''''][''''motivoAnulacion''''] ==  '''''''' ? ''''Si no se firma el motivo de anulaci&oacute;n es obligatorio rellenarlo'''' : null ) : null', 'valores[''''T017_FirmaPropietario''''][''''comboFirma''''] == DDSiNo.SI ? ''''Si'''' : ''''No''''')
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
		            ,'''||V_USUARIO||'''
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
					,USUARIOMODIFICAR = '''||V_USUARIO||'''
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
		                    , null , null  , null , null  , 0, '''||V_USUARIO||''', SYSDATE , null, null, null , null  , 0)';
		    EXECUTE IMMEDIATE V_MSQL;
	    
        	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	            VALUES (
	                '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
	                ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	                ,  1, ''combobox'', ''comboResultado'' , ''Resultado negativo'' , ''Debe indicar si el resultado es Negativo o No'' , ''false'' 
	                , null , ''DDSiNo''  , 0, '''||V_USUARIO||''', SYSDATE , null, null, null , null  , 0
	            )';
			EXECUTE IMMEDIATE V_MSQL;
		
				
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
	                ,'''||V_USUARIO||'''
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
