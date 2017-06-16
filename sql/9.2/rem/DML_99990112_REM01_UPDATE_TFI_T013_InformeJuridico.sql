--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE	
--## FECHA_CREACION=20170613
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2128
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar todos los campos de la tarea excepto el título y las observaciones.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    V_SQL_NORDEN VARCHAR2(4000 CHAR); -- Vble. para consulta del siguente ORDEN TFI para una tarea.
    V_NUM_NORDEN NUMBER(16); -- Vble. para indicar el siguiente orden en TFI para una tarea.
    V_NUM_ENLACES NUMBER(16); -- Vble. para indicar no. de enlaces en TFI
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TEXT_TABLA VARCHAR2(27 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS VARCHAR2(3 CHAR) := 'TAP'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_TEXT_TABLA2 VARCHAR2(27 CHAR) := 'TFI_TAREAS_FORM_ITEMS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CHARS2 VARCHAR2(3 CHAR) := 'TFI'; -- Vble. auxiliar para almacenar las 3 letras orientativas de la tabla de ref.
    V_USU_BORRAR VARCHAR2(30 CHAR) := '''HREOS-2128'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    
    /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;

    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    			 --TAP_CODIGO 							--TFI_NOMBRE 		--TFI_VALIDACION
		T_TFI(   'T013_InformeJuridico',   				'comboResultado',	  	'' ),
		T_TFI(   'T013_InformeJuridico',   				'fechaEmision',	  		'' )
		);
      V_TMP_T_TFI T_TFI;

    
 -- ## FIN DATOS
 -- ########################################################################################

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Borrar datos de '||V_TEXT_TABLA2);

	-- Bucle INSERT tfi_tareas_form_items
	FOR I IN V_TFI.FIRST .. V_TFI.LAST
	LOOP

		V_TMP_T_TFI := V_TFI(I);
		
		--Comprobar el dato a insertar.
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' '||V_TEXT_CHARS||' 
		JOIN '||V_ESQUEMA||'.'||V_TEXT_TABLA2||' '||V_TEXT_CHARS2||' ON '||V_TEXT_CHARS||'.'||V_TEXT_CHARS||'_ID = '||V_TEXT_CHARS2||'.'||V_TEXT_CHARS||'_ID 
		WHERE '||V_TEXT_CHARS||'.'||V_TEXT_CHARS||'_CODIGO = '''||TRIM(V_TMP_T_TFI(1))||''' AND '||
			' '||V_TEXT_CHARS2||'.'||V_TEXT_CHARS2||'_NOMBRE = '''||TRIM(V_TMP_T_TFI(2))||''' AND '||
			' '||V_TEXT_CHARS||'.BORRADO = 0 AND '||V_TEXT_CHARS2||'.BORRADO = 0';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
		IF V_NUM_TABLAS > 0 THEN				
			-- Si existe se modifica.
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TEXT_TABLA2||' '||
	        ' SET BORRADO = 1 '||
	        ' ,USUARIOBORRAR = '||V_USU_BORRAR||' '||
	        ' ,FECHABORRAR = SYSDATE '||
	        ' WHERE '||V_TEXT_CHARS||'_ID = (SELECT '||V_TEXT_CHARS||'_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' WHERE '||V_TEXT_CHARS||'_CODIGO = '''||V_TMP_T_TFI(1)||''') ' ||
	        '   AND '||V_TEXT_CHARS2||'_NOMBRE = '''||V_TMP_T_TFI(2)||''' ';
		    EXECUTE IMMEDIATE V_MSQL;
	
		    DBMS_OUTPUT.PUT_LINE('[INFO] El campo '||V_TMP_T_TFI(2)||' de la tarea '||V_TMP_T_TFI(1)||' se ha borrado.');
		    
		END IF;
	END LOOP;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Filas TFI borradas correctamente.');

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