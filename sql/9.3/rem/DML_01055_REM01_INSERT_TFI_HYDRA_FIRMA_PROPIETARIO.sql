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
    
    V_TAP_CODIGO VARCHAR2(50 CHAR) := 'T017_FirmaPropietario';
	V_TAP_ID NUMBER(16);
	V_TFI_ID NUMBER(16);
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10895';
    
    TYPE T_TIPO_DATA_TFI IS TABLE OF VARCHAR2(3500);
    TYPE T_ARRAY_DATA_TFI IS TABLE OF T_TIPO_DATA_TFI;
    -- TAP_CODIGO  TAP_DESCRIPCION   TAP_SCRIPT_VALIDACION   TAP_SCRIPT_VALIDACION_JBPM   TAP_SCRIPT_DECISION
    V_TIPO_DATA_TFI T_ARRAY_DATA_TFI := T_ARRAY_DATA_TFI(
        
			T_TIPO_DATA_TFI('1', 'combobox',		'comboFirma'		, '¿Se ha firmado la escritura?', 			'', 		'DDSiNo'),
			T_TIPO_DATA_TFI('2', 'datefield',		'fechaFirma'		, 'Fecha efectiva de firma', 			'', 		''),
			T_TIPO_DATA_TFI('3', 'textfield',		'notario'		, 'Notario', 			'', 		''),
			T_TIPO_DATA_TFI('4', 'numberfield',		'numProtocolo'		, 'Nº protocolo', 			'', 		''),
			T_TIPO_DATA_TFI('5', 'numberfield',		'precioEscrituracion'		, 'Precio escrituración', 			'', 		''),
			T_TIPO_DATA_TFI('6', 'combobox',		'motivoAnulacion'		, 'Motivo anulación	', 			'', 		'DDMotivoAnulacionExpediente'),
			T_TIPO_DATA_TFI('7', 'textarea',		'observaciones'		, 'observaciones', 			'', 		'')
	    ); 
    V_TMP_TIPO_DATA_TFI T_TIPO_DATA_TFI;
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	--  Insercion de los TFI
	
	FOR I IN V_TIPO_DATA_TFI.FIRST .. V_TIPO_DATA_TFI.LAST
	LOOP
		V_TMP_TIPO_DATA_TFI := V_TIPO_DATA_TFI(I);

		--Comprobar el dato a insertar.
		V_SQL := 'SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TAP_CODIGO)||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_TAP_ID;
			    DBMS_OUTPUT.PUT_LINE('HOLA HOLA HOLA');

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE 
			TAP_ID = '''||V_TAP_ID||'''
			AND TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA_TFI(3))||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
		IF V_NUM_TABLAS > 0 THEN				
			-- Si existe se modifica.
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL CAMPO '''|| TRIM(V_TMP_TIPO_DATA_TFI(3)) ||''' DE '''|| TRIM(V_TAP_CODIGO) ||'''');
			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TFI_TAREAS_FORM_ITEMS SET 
				TFI_ORDEN = '''||TRIM(V_TMP_TIPO_DATA_TFI(1))||''',
				TFI_TIPO = '''||TRIM(V_TMP_TIPO_DATA_TFI(2))||''',  
				TFI_LABEL = '''||TRIM(V_TMP_TIPO_DATA_TFI(4))||''', 
				TFI_ERROR_VALIDACION = '''||TRIM(V_TMP_TIPO_DATA_TFI(5))||''',
				TFI_BUSINESS_OPERATION = '''||TRIM(V_TMP_TIPO_DATA_TFI(6))||''',
				USUARIOMODIFICAR = '''||V_USUARIO||''' , 
				FECHAMODIFICAR = SYSDATE, 
				BORRADO = 0 
				WHERE TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA_TFI(3))||''' AND TAP_ID = '||V_TAP_ID||'';
			EXECUTE IMMEDIATE V_MSQL;
         
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

		ELSE
			-- Si no existe se inserta.
			DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAR EL CAMPO '''|| TRIM(V_TMP_TIPO_DATA_TFI(3)) ||''' DE '''|| TRIM(V_TAP_CODIGO) ||'''');

			V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL FROM DUAL';
			EXECUTE IMMEDIATE V_MSQL INTO V_TFI_ID;

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
				 (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
				SELECT '
					||V_TFI_ID|| ', '
					||V_TAP_ID|| ', '
					||TRIM(V_TMP_TIPO_DATA_TFI(1))||','''
					||TRIM(V_TMP_TIPO_DATA_TFI(2))||''','''
					||TRIM(V_TMP_TIPO_DATA_TFI(3))||''','''
					||TRIM(V_TMP_TIPO_DATA_TFI(4))||''','''
					||TRIM(V_TMP_TIPO_DATA_TFI(5))||''',''' 
					||TRIM(V_TMP_TIPO_DATA_TFI(6))||''',
					0, '''
					||V_USUARIO||''', 
					SYSDATE, 
					0 
					FROM DUAL';
			--DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
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
