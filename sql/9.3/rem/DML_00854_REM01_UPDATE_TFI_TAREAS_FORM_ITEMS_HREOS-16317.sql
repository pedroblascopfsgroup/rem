--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20211110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16317
--## PRODUCTO=NO
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
     TYPE T_TIPO_DATA_2 IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA_2 IS TABLE OF T_TIPO_DATA_2;
    V_TIPO_DATA_2 T_ARRAY_DATA_2 := T_ARRAY_DATA_2
    (
		T_TIPO_DATA_2('1', 'comboboxinicial', 'comboResultado', 'Respuesta scoring BC', 'DDTipoAccionNoComercial')
	); 
	
    V_TMP_TIPO_DATA_2 T_TIPO_DATA_2;
    
BEGIN	
	
	FOR I IN V_TIPO_DATA_2.FIRST .. V_TIPO_DATA_2.LAST
		LOOP
			
			V_TMP_TIPO_DATA_2 := V_TIPO_DATA_2(I);
			
			V_MSQL :=  'SELECT COUNT(1) 
					    FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS 
						WHERE TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T018_ScoringBc'')
						AND TFI_NOMBRE = '''||V_TMP_TIPO_DATA_2(3)||'''
			';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
			--COMPROBAMOS QUE LOS NUEVOS CAMPOS NO EXISTAN PREVIAMENTE
			IF V_NUM_TABLAS > 0 THEN
		
				-- Si existe se modifica.
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '||
						  ' SET TFI_ORDEN = '||V_TMP_TIPO_DATA_2(1)||' '||
						  ' ,TFI_BUSINESS_OPERATION = '||V_TMP_TIPO_DATA_2(5)||' '||
						  ' ,USUARIOMODIFICAR = ''HREOS-16317'' ,FECHAMODIFICAR = SYSDATE '||
						  ' WHERE TFI_NOMBRE = '''||V_TMP_TIPO_DATA_2(3)||''' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''T018_ScoringBc'') 
		        ';
                EXECUTE IMMEDIATE V_MSQL;

			ELSE
		
				V_MSQL :=  'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS (TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, TFI_BUSINESS_OPERATION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
							SELECT '||V_ESQUEMA||'.S_TFI_TAREAS_FORM_ITEMS.NEXTVAL AS TFI_ID,
							TAP.TAP_ID 							AS TAP_ID,
							'||V_TMP_TIPO_DATA_2(1)||' 			AS TFI_ORDEN,
							'''||V_TMP_TIPO_DATA_2(2)||''' 		AS TFI_TIPO,
							'''||V_TMP_TIPO_DATA_2(3)||''' 		AS TFI_NOMBRE,
							'''||V_TMP_TIPO_DATA_2(4)||''' 		AS TFI_LABEL,
							'''||V_TMP_TIPO_DATA_2(5)||''' 		AS TFI_BUSINESS_OPERATION,
							0 									AS VERSION,
							''HREOS-16317'' 					AS USUARIOCREAR,
							SYSDATE 							AS FECHACREAR,
							0									AS BORRADO
							FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
							WHERE TAP_CODIGO = ''T018_ScoringBc''
				';
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Se ha insertado correctamente el registro '||V_TMP_TIPO_DATA_2(3)||' en la tabla '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS');
			
			END IF;
			
		END LOOP;
		
		COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA TAP_TAREA_PROCEDIMIENTO ACTUALIZADA CORRECTAMENTE ');

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