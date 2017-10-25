--/*
--##########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20171023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3018
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

    V_TAREA VARCHAR(50 CHAR);
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
    			-- tap_codigo,			orden,	tipo,			nombre,				label,				validacion,	valor_inicial, business_op
	  T_FUNCION('T013_RatificacionComite', '2', 'comboinied', 'comboRatificacion', '¿Aprueba Ratificación?', '', '', 'DDResolucionComite' )

    ); 
    V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	
	FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
      
		V_TMP_FUNCION := V_FUNCION(I);
		
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (
			SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_FUNCION(1)||'''
	    )
	    '
	    ;
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
		--COMPROBAMOS SI EXISTE EL CODIGO DE LA TAP
		IF V_NUM_TABLAS > 0 THEN	
		
			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (
			SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_FUNCION(1)||'''
			)
			AND TFI_NOMBRE = '''||V_TMP_FUNCION(4)||'''
			'
			;
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
			--COMPROBAMOS QUE LOS NUEVOS CAMPOS NO EXISTAN PREVIAMENTE
			IF V_NUM_TABLAS > 0 THEN
			
				DBMS_OUTPUT.PUT_LINE('[INFO] Uno de los campos o ambos ya existen en la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS para la tarea seleccionada. Se modifican sus campos.');
				V_MSQL := '
				  UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS TFI
				  SET 
					TFI_ORDEN = '''||V_TMP_FUNCION(2)||''',
					TFI_TIPO = '''||V_TMP_FUNCION(3)||''',
					TFI_LABEL = '''||V_TMP_FUNCION(5)||''',
					TFI_VALIDACION = '''||V_TMP_FUNCION(6)||''',
					TFI_VALOR_INICIAL = '''||V_TMP_FUNCION(7)||''',
					TFI_BUSINESS_OPERATION = '''||V_TMP_FUNCION(8)||''',
					VERSION = 1,
					USUARIOMODIFICAR = ''HREOS-3018'',
					FECHAMODIFICAR = SYSDATE
				  WHERE TFI.TFI_NOMBRE = '''||V_TMP_FUNCION(4)||'''
					AND EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = '''||V_TMP_FUNCION(1)||'''
					AND TFI.TAP_ID = TAP.TAP_ID)
				  '
				  ;
				EXECUTE IMMEDIATE V_MSQL;
			ELSE
			
				V_MSQL := '
				  INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALIDACION, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
				  SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL AS TFI_ID,
				  TAP.TAP_ID AS TAP_ID,
				  '''||V_TMP_FUNCION(2)||''' AS TFI_ORDEN,
				  '''||V_TMP_FUNCION(3)||''' AS TFI_TIPO,
				  '''||V_TMP_FUNCION(4)||''' AS TFI_NOMBRE,
				  '''||V_TMP_FUNCION(5)||''' AS TFI_LABEL,
				  '''||V_TMP_FUNCION(6)||''' AS TFI_VALIDACION,
				  '''||V_TMP_FUNCION(7)||''' AS TFI_VALOR_INICIAL,
				  '''||V_TMP_FUNCION(8)||''' AS TFI_BUSINESS_OPERATION,
				  0 AS VERSION,
				  ''HREOS-3018'' AS USUARIOCREAR,
				  SYSDATE AS FECHACREAR,
				  0 AS BORRADO
				  FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
				  WHERE TAP_CODIGO = '''||V_TMP_FUNCION(1)||'''
				  '
				  ;
				EXECUTE IMMEDIATE V_MSQL;
				
				COMMIT;
				
				DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de insercion/actualizacion de la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS a finalizado correctamente');
			
			END IF;
		
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe la tarea '''||V_TMP_FUNCION(1)||''' en la tabla '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO. No se realiza ningun cambio.');
			
		END IF;
	END LOOP;
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
