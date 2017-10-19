--/*
--##########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20171017
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
    
BEGIN	
	
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (
		SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_DefinicionOferta''
    )
    '
    ;
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	--COMPROBAMOS SI EXISTE EL CODIGO DE LA TAP
	IF V_NUM_TABLAS > 0 THEN	
	
		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS WHERE TAP_ID = (
		SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T013_DefinicionOferta''
		)
		AND TFI_NOMBRE = ''comiteSuperior''
		'
		;
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
		--COMPROBAMOS QUE LOS NUEVOS CAMPOS NO EXISTAN PREVIAMENTE
		IF V_NUM_TABLAS > 0 THEN
		
			DBMS_OUTPUT.PUT_LINE('[INFO] Uno de los campos o ambos ya existen en la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS para la tarea seleccionada. No se realiza ningun cambio.');
			
		ELSE
		
			V_MSQL := '
			  INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
			  SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL AS TFI_ID,
			  TAP.TAP_ID AS TAP_ID,
			  5 AS TFI_ORDEN,
			  ''comboinied'' AS TFI_TIPO,
			  ''comiteSuperior'' AS TFI_NOMBRE,
			  ''Comité sancionador superior'' AS TFI_LABEL,
			  0 AS VERSION,
			  ''HREOS-3018'' AS USUARIOCREAR,
			  SYSDATE AS FECHACREAR,
			  0 AS BORRADO
			  FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
			  WHERE TAP_CODIGO = ''T013_DefinicionOferta''
			  '
			  ;
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Se ha insertado correctamente el registro ''deuda_jud'' en la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS');
			
			
			V_MSQL := '
			  UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS TFI
			  SET 
				TFI_ORDEN = 6,
				USUARIOMODIFICAR = ''HREOS-3018'',
				FECHAMODIFICAR = SYSDATE
			  WHERE TFI_ORDEN = 5
				AND TFI.TFI_NOMBRE = ''observaciones''
				AND EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP_CODIGO = ''T013_DefinicionOferta''
				AND TFI.TAP_ID = TAP.TAP_ID)
			  '
			  ;
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado correctamente el orden del registro ''observaciones'' en la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS');

			COMMIT;
			
			DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de insercion/actualizacion de la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS a finalizado correctamente');
		
		END IF;
	
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe la tarea T013_DefinicionOferta en la tabla '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO. No se realiza ningun cambio.');
		
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
