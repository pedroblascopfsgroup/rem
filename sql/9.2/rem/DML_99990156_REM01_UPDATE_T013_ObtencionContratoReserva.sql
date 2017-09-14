--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20170914
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2822
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el Obtención contrato reserva
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
    --		   TAP_CODIGO							TFI_NOMBRE					TFI_VALIDACION																																																																													TFI_ERROR_VALIDACION											TFI_VALIDACION									TFI_BUSINESS_OPERATION																																																																															,''																,''												,''					),
    	T_TFI('T013_ObtencionContratoReserva',		'fechaFirma',		'false')
    );
    V_TMP_T_TFI T_TFI;

  
BEGIN	
	
  	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZANDO CAMPO EN TABLA TFI PARA T. COMERCIAL DE VENTA');


	-- Insertamos en la tabla tfi_tareas_form_items
	FOR I IN V_TFI.FIRST .. V_TFI.LAST
	  LOOP
	      V_TMP_T_TFI := V_TFI(I);
	      	      
		  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') AND TFI_NOMBRE = '''||V_TMP_T_TFI(2)||''' ';
		  EXECUTE IMMEDIATE V_SQL INTO table_count;
					   
		  IF table_count = 1 THEN
			  DBMS_OUTPUT.PUT_LINE('[INFO] Actualizamos el campo'''||V_TMP_T_TFI(2)||'''');
		  	  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
          			' SET TFI_VALIDACION = '''||V_TMP_T_TFI(3)||''' '||
          			', USUARIOMODIFICAR = ''HREOS-2822'', FECHAMODIFICAR = SYSDATE '||
          			' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') '||
		  			' AND TFI_NOMBRE = '''||V_TMP_T_TFI(2)||''' ';
	          
		  	DBMS_OUTPUT.PUT_LINE('Actualizado Campo '''||V_TMP_T_TFI(2)||''' de '''||V_TMP_T_TFI(1)||''''); 
	          EXECUTE IMMEDIATE V_MSQL;		     
			  
		  ELSE  
			  DBMS_OUTPUT.PUT_LINE('No existe el campo '''||V_TMP_T_TFI(2)||''' de '''||V_TMP_T_TFI(1)||'''');   
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
