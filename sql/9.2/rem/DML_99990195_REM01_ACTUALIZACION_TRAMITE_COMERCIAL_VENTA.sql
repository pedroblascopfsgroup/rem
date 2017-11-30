--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20171129
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3328
--## PRODUCTO=NO
--## Finalidad: Realiza las modificaciones necesarias para el trámite de sanción de ofertas.
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE.
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-3328'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    V_ENTIDAD_ID NUMBER(16);

    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    --		   TAP_CODIGO						TFI_ORDEN	TFI_TIPO		TFI_NOMBRE					TFI_LABEL				TFI_ERROR_VALIDACION	TFI_VALIDACION		TFI_BUSINESS_OPERATION
		T_TFI('T013_DocumentosPostVenta'		,'2'		,'checkbox'		,'checkboxVentaDirecta'		,'Venta directa'		,''						,'false'			,''	)
	);
    V_TMP_T_TFI T_TFI;

BEGIN

    FOR I IN V_TFI.FIRST .. V_TFI.LAST
	      LOOP
	      	  V_TMP_T_TFI := V_TFI(I);

			  V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') AND TFI_NOMBRE = '''||V_TMP_T_TFI(4)||''' ';
			  EXECUTE IMMEDIATE V_SQL INTO table_count;

			  IF table_count = 0 THEN
			  	  DBMS_OUTPUT.PUT('[INFO] Insertar registro nuevo...');
		          V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL FROM DUAL';
		          EXECUTE IMMEDIATE V_MSQL INTO V_ENTIDAD_ID;

		          V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS (' ||
		          			  'TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_ERROR_VALIDACION, TFI_VALIDACION, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) '||
		          			  'VALUES ('||V_ENTIDAD_ID||', (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||'''),'||
		          			  ''''||V_TMP_T_TFI(2)||''','''||V_TMP_T_TFI(3)||''','''||V_TMP_T_TFI(4)||''','''||V_TMP_T_TFI(5)||''', '''||V_TMP_T_TFI(6)||''', '''||V_TMP_T_TFI(7)||''', '||
		          			  ''''||V_TMP_T_TFI(8)||''',1, '||V_USU_MODIFICAR||', SYSDATE, 0)';
		          EXECUTE IMMEDIATE V_MSQL;

		          DBMS_OUTPUT.PUT_LINE('OK');
		      ELSE
		      	  DBMS_OUTPUT.PUT('[INFO] Actualizar registro existente...');
		      	  V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS TFI
							  SET 
								TFI_ORDEN = '''||V_TMP_T_TFI(2)||''',
								TFI_TIPO = '''||V_TMP_T_TFI(3)||''',
								TFI_LABEL = '''||V_TMP_T_TFI(5)||''',
								TFI_ERROR_VALIDACION = '''||V_TMP_T_TFI(6)||''',
								TFI_VALIDACION = '''||V_TMP_T_TFI(7)||''',
								TFI_BUSINESS_OPERATION = '''||V_TMP_T_TFI(8)||''',
								USUARIOMODIFICAR = '||V_USU_MODIFICAR||',
								FECHAMODIFICAR = SYSDATE
							  WHERE TFI.TFI_NOMBRE = '''||V_TMP_T_TFI(4)||'''
								AND EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||'''
								AND TFI.TAP_ID = TAP.TAP_ID)';
				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('OK');
		      END IF;
	      END LOOP;

	      -- Actualizar orden de los campos desplazados.
	 DBMS_OUTPUT.PUT('[INFO] Actualizar el orden de los elementos desplazados...');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS' ||
	          			' SET TFI_ORDEN = ''3'' '||
	          			', USUARIOMODIFICAR = '||V_USU_MODIFICAR||' '||
	          			', FECHAMODIFICAR = SYSDATE '||
	          			' WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_DocumentosPostVenta'') '||
			  			' AND TFI_NOMBRE = ''observaciones'' ';
	EXECUTE IMMEDIATE V_MSQL;

	DBMS_OUTPUT.PUT_LINE('OK');

    COMMIT;

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