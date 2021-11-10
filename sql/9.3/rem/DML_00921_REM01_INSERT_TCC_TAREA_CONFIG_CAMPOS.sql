--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20211001
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15415
--## PRODUCTO=NO
--##
--## Finalidad: Script para Insertar Registros de validación para el WS en la tabla TCC_TAREA_CONFIG_CAMPOS
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - Cristian Montoya
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT_TABLA VARCHAR2(30):= 'TCC_TAREA_CONFIG_CAMPOS';
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
		V_SQL_DELETE VARCHAR2(4000 CHAR);
		V_NUM_DELETE NUMBER(16);
		V_USU_CREAR VARCHAR2(30 CHAR) := '''HREOS-15415'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

		TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

	  TYPE T_TIPO_TAREA IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_TAREA IS TABLE OF T_TIPO_TAREA;

		-- Vbles. auxiliares para tratar las validaciones.
		V_TAREA_ID NUMBER(16);
		V_TFI_ID NUMBER(16);

		V_TIPO_TAREA T_ARRAY_TAREA := T_ARRAY_TAREA
    	(
			T_TIPO_TAREA('T018_PbcAlquiler'),
			T_TIPO_TAREA('T015_PBC')
		);

		V_TMP_TIPO_TAREA T_TIPO_TAREA;




		V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
    																			-- **** T018_PbcAlquiler ****
		--			(TAREA, INSTANCIA, CAMPO, VALOR, ACCION)		
		T_TIPO_DATA('T018_PbcAlquiler', '1', 'comboResultado', 'SELECT DD_SIN_CODIGO FROM '||V_ESQUEMA_M||'.DD_SIN_SINO', 'IN'),
		T_TIPO_DATA('T018_PbcAlquiler', '1', 'comboResultado', '', 'IS NOT NULL'),
		T_TIPO_DATA('T018_PbcAlquiler', '1', 'fechaResolucion', '', 'IS NOT NULL'),

																				-- **** T015_PBC ****
		--			(TAREA, INSTANCIA, CAMPO, VALOR, ACCION)		
		T_TIPO_DATA('T015_PBC', '1', 'comboResultado', '', 'IS NOT NULL'),
		T_TIPO_DATA('T015_PBC', '1', 'comboResultado', 'SELECT DD_SIN_CODIGO FROM '||V_ESQUEMA_M||'.DD_SIN_SINO', 'IN')
 ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;


BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');		
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCIÓN EN '||V_TEXT_TABLA);

	DBMS_OUTPUT.PUT_LINE('[INFO] SE ELIMINAN LOS REGISTROS DE LA TAREAS DEL T_ARRAY ');
	
	-- LOOP para eliminar los valores de las Tareas del T_ARRAY 
	FOR I IN V_TIPO_TAREA.FIRST .. V_TIPO_TAREA.LAST
		LOOP
			V_TMP_TIPO_TAREA := V_TIPO_TAREA(I);

			-- Recuperar TAP_ID de T013_PosicionamientoYFirma 
			V_SQL := 'SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAREA(1))||''' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_TAREA_ID;
			
		 	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TCC_TAREA_CONFIG_CAMPOS WHERE  TAP_ID = '''||V_TAREA_ID||'''';
			 EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

			IF V_NUM_TABLAS > 0  THEN			
				EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.TCC_TAREA_CONFIG_CAMPOS WHERE  TAP_ID = '''||V_TAREA_ID||'''';

						DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ELIMINADOS CON ÉXITO. '); 										
				END IF;
		
		END LOOP;

	-- LOOP para insertar los valores --
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);

			-- Recuperar TAP_ID del T_ARRAY -> T013_PosicionamientoYFirma y T004_ResultadoNoTarificada
			V_SQL := 'SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
			EXECUTE IMMEDIATE V_SQL INTO V_TAREA_ID;
			-- Recuperar el TFI_ID del T_ARRAY
			V_SQL := 'SELECT TFI_ID FROM TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND TAP_ID = '''||V_TAREA_ID||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_TFI_ID;		

			EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.TCC_TAREA_CONFIG_CAMPOS (TCC_ID, TAP_ID, TFI_ID, TCC_INSTANCIA, TCC_VALOR, TCC_ACCION, USUARIOCREAR, FECHACREAR) 
			VALUES ('||V_ESQUEMA||'.S_TCP_TAREA_CONFIG_PETICION.NEXTVAL,'||V_TAREA_ID||',' ||V_TFI_ID||','''||V_TMP_TIPO_DATA(2)||''','''||V_TMP_TIPO_DATA(4)||''','''||V_TMP_TIPO_DATA(5)||''','||V_USU_CREAR||', SYSDATE )'; 
											
			DBMS_OUTPUT.PUT_LINE('[INFO] SE INSERTA EL REGISTRO DE LA TAREA '||TRIM(V_TMP_TIPO_DATA(1)));
		
		END LOOP;
	COMMIT; 				
	DBMS_OUTPUT.PUT_LINE('[INFO] FIN.');


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