--/*
--##########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20171031
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3137
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
    
BEGIN	
	
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (
		SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_RatificacionComite''
    )
    '
    ;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	--COMPROBAMOS SI EXISTE EL CODIGO DE LA TAP
	IF V_NUM_TABLAS > 0 THEN	
	
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (
		SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_RatificacionComite''
		)
		AND TFI_NOMBRE = ''importeContraoferta''
		'
		;
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
		--COMPROBAMOS QUE LOS NUEVOS CAMPOS NO EXISTAN PREVIAMENTE
		IF V_NUM_TABLAS > 0 THEN
		
			DBMS_OUTPUT.PUT_LINE('[INFO] Uno de los campos o ambos ya existen en la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS para la tarea seleccionada. No se realiza ningun cambio.');
			V_MSQL := '
			  UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS TFI
			  SET 
				TFI_TIPO = ''textinf'',
				TFI_ORDEN = 3,
				TFI_LABEL = ''Importe contraoferta'',
				TFI_VALOR_INICIAL = '''',
				TFI_BUSINESS_OPERATION = '''',
				VERSION = 1,
				USUARIOMODIFICAR = ''HREOS-3137'',
				FECHAMODIFICAR = SYSDATE
			  WHERE TFI.TFI_NOMBRE = ''importeContraoferta''
				AND EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = ''T013_RatificacionComite''
				AND TFI.TAP_ID = TAP.TAP_ID)
			  '
			  ;
			EXECUTE IMMEDIATE V_MSQL;
		ELSE
		
			V_MSQL := '
			  INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_VALOR_INICIAL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
			  SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL AS TFI_ID,
			  TAP.TAP_ID AS TAP_ID,
			  3 AS TFI_ORDEN,
			  ''textinf'' AS TFI_TIPO,
			  ''importeContraoferta'' AS TFI_NOMBRE,
			  ''Importe contraoferta'' AS TFI_LABEL,
			  '''' AS TFI_VALOR_INICIAL,
			  '''' AS TFI_BUSINESS_OPERATION,
			  0 AS VERSION,
			  ''HREOS-3137'' AS USUARIOCREAR,
			  SYSDATE AS FECHACREAR,
			  0 AS BORRADO
			  FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
			  WHERE TAP_CODIGO = ''T013_RatificacionComite''
			  '
			  ;
			EXECUTE IMMEDIATE V_MSQL;
						
			
			V_MSQL := '
			  UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS TFI
			  SET 
				TFI_ORDEN = 4,
				USUARIOMODIFICAR = ''HREOS-3137'',
				FECHAMODIFICAR = SYSDATE
			  WHERE TFI.TFI_NOMBRE = ''observaciones''
				AND EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = ''T013_RatificacionComite''
				AND TFI.TAP_ID = TAP.TAP_ID)
			  '
			  ;
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado correctamente el orden del registro ''observaciones'' en la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS');

			COMMIT;
			
			DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de insercion/actualizacion de la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS a finalizado correctamente');
		
		END IF;
	
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe la tarea T013_RatificacionComite en la tabla '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO. No se realiza ningun cambio.');
		
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
