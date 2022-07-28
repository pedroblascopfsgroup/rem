--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220725
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18270
--## PRODUCTO=SI
--##
--## Finalidad: 
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Añadir nuevos campos para la tarea HREOS-18270 Javier Esbri
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
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TFI_TAREAS_FORM_ITEMS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TEXT_CHARS VARCHAR2(2400 CHAR) := 'TFI'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-18270';
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	V_TAP_ID NUMBER(16);
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3500);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- TAP_CODIGO  TAP_DESCRIPCION   TAP_SCRIPT_VALIDACION   TAP_SCRIPT_VALIDACION_JBPM   TAP_SCRIPT_DECISION
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        
		T_TIPO_DATA('T018_AprobacionAlquilerSocial', 'Aprobacion alquiler social', '', '', '')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

	TYPE T_TIPO_DATA2 IS TABLE OF VARCHAR2(3500);
    TYPE T_ARRAY_DATA2 IS TABLE OF T_TIPO_DATA2;
    -- TAP_CODIGO  TAP_DESCRIPCION   TAP_SCRIPT_VALIDACION   TAP_SCRIPT_VALIDACION_JBPM   TAP_SCRIPT_DECISION
    V_TIPO_DATA2 T_ARRAY_DATA2 := T_ARRAY_DATA2(

		T_TIPO_DATA2('T018_AprobacionAlquilerSocial'	,'combobox', 	'1'		,'comboResultado'	        ,'Debe indicar si se Aprueba o No'    				,'false'   ,'DDSiNo'	    ,'Condiciones pactadas aprobadas'),
        T_TIPO_DATA2('T018_AprobacionAlquilerSocial'	,'combobox', 	'2'		,'comboAprobadoApi'	        ,'Debe indicar si se Aprueba o No'                  ,'false'   ,'DDSiNo'	    ,'Aprobación comunicada a API'),
        T_TIPO_DATA2('T018_AprobacionAlquilerSocial'	,'combobox', 	'3'		,'comboBorradorContratoApi'	,'Debe indicar si se Aprueba o No'                  ,'false'   ,'DDSiNo'	    ,'Borrador de contrato enviado a API'),
		T_TIPO_DATA2('T018_AprobacionAlquilerSocial'	,'combobox', 	'4'		,'comboClienteAcepBorr'	    ,'Debe indicar si se Aprueba o No'                  ,'false'   ,'DDSiNo'	    ,'Cliente acepta borrado'),
        T_TIPO_DATA2('T018_AprobacionAlquilerSocial'	,'datefield', 	'5'		,'fecha'		        	,''                                                 ,'false'   ,null          	,'Fecha'),
		T_TIPO_DATA2('T018_AprobacionAlquilerSocial'	,'textarea', 	'6'		,'justificacion'	        ,''                                                 ,null      ,null		    ,'Justificación'),
    	T_TIPO_DATA2('T018_AprobacionAlquilerSocial'	,'textarea', 	'7'		,'observaciones'	        ,''                                                 ,null      ,null		    ,'Observaciones')
    ); 
    V_TMP_TIPO_DATA2 T_TIPO_DATA2;
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
		            ,(SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO LIKE ''%T018%'') 
		            ,'''||V_TMP_TIPO_DATA(1)||''' 
		            ,null 
		            ,'''||V_TMP_TIPO_DATA(3)||''' 
					,'''||V_TMP_TIPO_DATA(4)||''' 
					,'''||V_TMP_TIPO_DATA(5)||''' 
		            ,null  
		            ,0  
		            ,'''||V_TMP_TIPO_DATA(2)||''' 
		            ,0
		            ,''HREOS-18268''
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
					,USUARIOMODIFICAR = ''HREOS-18268''
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
		                    , null , null  , null , null  , 0, ''HREOS-18268'', SYSDATE , null, null, null , null  , 0)';
		    EXECUTE IMMEDIATE V_MSQL;
	    
        	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	            VALUES (
	                '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
	                ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	                ,  1, ''combobox'', ''comboResultado'' , ''Resultado negativo'' , ''Debe indicar si el resultado es Negativo o No'' , ''false'' 
	                , null , ''DDSiNo''  , 0, ''HREOS-18268'', SYSDATE , null, null, null , null  , 0
	            )';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
	                VALUES (
	                    '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL
	                    ,(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||''')
	                    ,  2, ''textarea'', ''observaciones'' , ''Observaciones'' , null , null 
	                    , null , null  , 0, ''HREOS-18268'', SYSDATE , null, null, null , null  , 0
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
	                ,''HREOS-18268''
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

	-- Bucle que COMPRUEBA/CREA los elementos de la tarea
	FOR I IN V_TIPO_DATA2.FIRST .. V_TIPO_DATA2.LAST
	LOOP

		V_TMP_TIPO_DATA2 := V_TIPO_DATA2(I);	

		-- Verificar si la FILA existe, si no existe se crea.	
		V_SQL := 'SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA2(1))||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_TAP_ID;

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' 
				WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA2(1))||''')
				AND TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA2(4))||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL CAMPO '''|| TRIM(V_TMP_TIPO_DATA2(3)) ||''' DE '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||'''');
			V_MSQL := 'SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL INTO V_ID;
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (' ||
						''||V_TEXT_CHARS||'_ID,
						TAP_ID,
						'||V_TEXT_CHARS||'_ORDEN,
						'||V_TEXT_CHARS||'_TIPO,
						'||V_TEXT_CHARS||'_NOMBRE,
						'||V_TEXT_CHARS||'_LABEL,
						'||V_TEXT_CHARS||'_ERROR_VALIDACION,
						'||V_TEXT_CHARS||'_VALIDACION,
						'||V_TEXT_CHARS||'_BUSINESS_OPERATION,
						VERSION,
						USUARIOCREAR,
						FECHACREAR,
						BORRADO) ' ||
						'SELECT 
						'|| V_ID || ',
						'||V_TAP_ID||',
						'''||V_TMP_TIPO_DATA2(3)||''',
						'''||TRIM(V_TMP_TIPO_DATA2(2))||''',
						'''||TRIM(V_TMP_TIPO_DATA2(4))||''',
						'''||TRIM(V_TMP_TIPO_DATA2(8))||''',
						'''||TRIM(V_TMP_TIPO_DATA2(5))||''',
						'''||TRIM(V_TMP_TIPO_DATA2(6))||''', 
						'''||TRIM(V_TMP_TIPO_DATA2(7))||''',
						0, '''||V_USUARIO||''',SYSDATE,0 '||
						' FROM DUAL';
			DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
		ELSE
			--Si la FILA existe se modifica.
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL CAMPO '''|| TRIM(V_TMP_TIPO_DATA2(3)) ||''' DE '''|| TRIM(V_TMP_TIPO_DATA2(1)) ||'''');
			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||' '||
						'SET '||V_TEXT_CHARS||'_TIPO = '''||TRIM(V_TMP_TIPO_DATA2(2))||''''|| 
						', '||V_TEXT_CHARS||'_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA2(4))||''''||
						', '||V_TEXT_CHARS||'_LABEL = '''||TRIM(V_TMP_TIPO_DATA2(8))||''''||
						', '||V_TEXT_CHARS||'_ORDEN = '''||TRIM(V_TMP_TIPO_DATA2(3))||''''||
						', '||V_TEXT_CHARS||'_ERROR_VALIDACION = '''||TRIM(V_TMP_TIPO_DATA2(5))||''''||
						', '||V_TEXT_CHARS||'_VALIDACION = '''||TRIM(V_TMP_TIPO_DATA2(6))||''''||
						', '||V_TEXT_CHARS||'_BUSINESS_OPERATION = '''||TRIM(V_TMP_TIPO_DATA2(7))||''''||
						', USUARIOMODIFICAR = '''||V_USUARIO||''' , FECHAMODIFICAR = SYSDATE, BORRADO = 0 '||
						'WHERE '||V_TEXT_CHARS||'_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA2(4))||''' AND TAP_ID = '||V_TAP_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
         	DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
		END IF;
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
