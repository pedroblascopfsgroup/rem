--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20170403
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.0-X
--## INCIDENCIA_LINK=HREOS-1859
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el Tramite sancion oferta venta
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versi&oacute;n inicial
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
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
 	table_count number(3); -- Vble. para validar la existencia de las Tablas.
  
    /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(	
    --		   TAP_CODIGO						TFI_ORDEN	TFI_TIPO		TFI_NOMBRE				TFI_LABEL					TFI_ERROR_VALIDACION					TFI_VALIDACION		TFI_BUSINESS_OPERATION																																																																													TFI_ERROR_VALIDACION											TFI_VALIDACION									TFI_BUSINESS_OPERATION																																																																															,''																,''												,''					),
    	T_TFI('T013_PosicionamientoYFirma'		,'9'		,'textfield'	,'tieneReserva'			,'Tiene reserva'			,''										,'false',			''								),
    	T_TFI('T013_PosicionamientoYFirma'		,'7'		,'combo'		,'motivoNoFirma'		,'Motivo de no firma'		,'Debe indicar un motivo de no firma'	,'false',			'DDMotivoAnulacionExpediente'	)				
    );
    V_TMP_T_TFI T_TFI;

  
BEGIN	
	
  	DBMS_OUTPUT.PUT_LINE('[INICIO] INSERTANDO CAMPO EN TABLA TFI PARA T. SANCION OFERTA VENTA');


	-- Insertamos en la tabla tfi_tareas_form_items
	FOR I IN V_TFI.FIRST .. V_TFI.LAST
	  LOOP
	      V_TMP_T_TFI := V_TFI(I);
	      
	      
		  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') AND TFI_NOMBRE = '''||V_TMP_T_TFI(4)||''' ';
		  EXECUTE IMMEDIATE V_SQL INTO table_count;
					   
		  IF table_count = 1 THEN
			  DBMS_OUTPUT.PUT_LINE('[INFO] Actualizamos el campo'''||V_TMP_T_TFI(4)||'''');
		  	  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
          			' SET TFI_ORDEN = '''||V_TMP_T_TFI(2)||''', TFI_TIPO = '''||V_TMP_T_TFI(3)||''', TFI_LABEL = '''||V_TMP_T_TFI(5)||''' '||
          			', TFI_ERROR_VALIDACION = '''||V_TMP_T_TFI(6)||''', TFI_VALIDACION = '''||V_TMP_T_TFI(7)||''' '||
          			', TFI_BUSINESS_OPERATION = '''||V_TMP_T_TFI(8)||''', USUARIOMODIFICAR = ''HREOS-1859'', FECHAMODIFICAR = SYSDATE '||
          			' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') '||
		  			' AND TFI_NOMBRE = '''||V_TMP_T_TFI(4)||''' ';
	          DBMS_OUTPUT.PUT_LINE('Actualizado Campo '''||V_TMP_T_TFI(4)||''' de '''||V_TMP_T_TFI(1)||''''); 
	          DBMS_OUTPUT.PUT_LINE(V_MSQL);
	          EXECUTE IMMEDIATE V_MSQL;
	          DBMS_OUTPUT.PUT_LINE('ACTUALIZADO'); 
		     
			  
		  ELSE  
		  
		   	  V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL FROM DUAL';
			  EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;
			  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS (' ||
			  			  'TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, USUARIOCREAR, FECHACREAR, BORRADO) '||
			  			  'VALUES ('||V_ENTIDAD_ID||', (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||'''),'||
			  			  ''''||V_TMP_T_TFI(2)||''','''||V_TMP_T_TFI(3)||''','''||V_TMP_T_TFI(4)||''','''||V_TMP_T_TFI(5)||''', '''||V_TMP_T_TFI(6)||''', '''||V_TMP_T_TFI(7)||''', '''||V_TMP_T_TFI(8)||''', ''HREOS-1859'', SYSDATE, 0)';
			  DBMS_OUTPUT.PUT_LINE('INSERTANDO: Campo '''||V_TMP_T_TFI(4)||''' de '''||V_TMP_T_TFI(1)||''''); 
			  DBMS_OUTPUT.PUT_LINE(V_MSQL);
			  EXECUTE IMMEDIATE V_MSQL;
			  DBMS_OUTPUT.PUT_LINE('INSERTADO');  
		  END IF;
		  
	  END LOOP;
	 

	  COMMIT;
	  DBMS_OUTPUT.PUT_LINE('[FIN] TFI ACTUALIZADO CORRECTAMENTE ');

  
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
