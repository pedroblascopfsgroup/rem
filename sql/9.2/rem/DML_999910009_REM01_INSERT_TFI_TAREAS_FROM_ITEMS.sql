--/*
--##########################################
--## AUTOR=JINLI HU
--## FECHA_CREACION=20190210
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5452
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES: Relanzable
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_MAX_ID NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    TYPE T_TIPO_DATA_2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_2 IS TABLE OF T_TIPO_DATA_2;
    V_TIPO_DATA_2 T_ARRAY_DATA_2 := T_ARRAY_DATA_2(
	T_TIPO_DATA_2('4', 'datefield', 'fechaReunionComite', 'Fecha reunión comité', ''),
	T_TIPO_DATA_2('5', 'combobox', 'comiteInternoSancionador', 'Comité interno sancionador', 'DDCisComiteInternoSancionador')
	); 
    V_TMP_TIPO_DATA_2 T_TIPO_DATA_2;
    
BEGIN	
	
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (
		SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T015_ResolucionExpediente''
    )';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	--COMPROBAMOS SI EXISTE EL CODIGO DE LA TAP
	IF V_NUM_TABLAS > 0 THEN	
		-- LOOP-----------------------------------------------------------------
		DBMS_OUTPUT.PUT_LINE('[INFO] Empieza la inserción en la tabla TFI_TAREAS_FORM_ITEMS');
		FOR I IN V_TIPO_DATA_2.FIRST .. V_TIPO_DATA_2.LAST
		LOOP
			V_TMP_TIPO_DATA_2 := V_TIPO_DATA_2(I);
			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (
			SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T015_ResolucionExpediente''
			)
			AND TFI_NOMBRE = '''||V_TMP_TIPO_DATA_2(3)||'''
			';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
			--COMPROBAMOS QUE LOS NUEVOS CAMPOS NO EXISTAN PREVIAMENTE
			IF V_NUM_TABLAS > 0 THEN
		
				DBMS_OUTPUT.PUT_LINE('[INFO] El campo '||V_TMP_TIPO_DATA_2(3)||' ya existe.');

			ELSE
		
				V_MSQL := '
					INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
					SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL AS TFI_ID,
					TAP.TAP_ID AS TAP_ID,
					'||V_TMP_TIPO_DATA_2(1)||' AS TFI_ORDEN,
					'''||V_TMP_TIPO_DATA_2(2)||''' AS TFI_TIPO,
					'''||V_TMP_TIPO_DATA_2(3)||''' AS TFI_NOMBRE,
					'''||V_TMP_TIPO_DATA_2(4)||''' AS TFI_LABEL,
					'''||V_TMP_TIPO_DATA_2(5)||''' AS TFI_BUSINESS_OPERATION,
					0 AS VERSION,
					''HREOS-5452'' AS USUARIOCREAR,
					SYSDATE AS FECHACREAR,
					0 AS BORRADO
					FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
					WHERE TAP_CODIGO = ''T015_ResolucionExpediente''
					';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Se ha insertado correctamente el registro '||V_TMP_TIPO_DATA_2(3)||' en la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS');
			
			END IF;
			
		END LOOP;
		
		COMMIT;
		
		DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de insercion/actualizacion de la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS a finalizado correctamente');
	
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe la tarea T013_ResolucionComite en la tabla '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO. No se realiza ningun cambio.');
		
	END IF;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;
