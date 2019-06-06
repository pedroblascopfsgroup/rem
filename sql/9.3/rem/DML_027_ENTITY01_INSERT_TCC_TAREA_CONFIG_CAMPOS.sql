--/*
--##########################################
--## AUTOR=JOSE LUIS BARBA
--## FECHA_CREACION=20190604
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6586
--## PRODUCTO=NO
--##
--## Finalidad: Script para Insertar Registros de validación para el WS en la tabla TCC_TAREA_CONFIG_CAMPOS
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
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
		V_USU_CREAR VARCHAR2(30 CHAR) := '''HREOS-6586'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

		TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;

	  TYPE T_TIPO_TAREA IS TABLE OF VARCHAR2(250);
    TYPE T_ARRAY_TAREA IS TABLE OF T_TIPO_TAREA;

		-- Vbles. auxiliares para tratar las validaciones.
		V_TAREA_T013 VARCHAR2(4000 CHAR);
		V_NUM_TAREA_T013 NUMBER(16);
		V_TAREA_T004 VARCHAR2(4000 CHAR);
		V_NUM_TAREA_T004 NUMBER(16);
		V_TAREA VARCHAR(4000 CHAR);
		V_TAP_ID NUMBER(16);
		V_CAMPO VARCHAR2(4000 CHAR);
		V_TFI_ID NUMBER(16);

		V_TIPO_TAREA T_ARRAY_TAREA := T_ARRAY_TAREA
    (
			T_TIPO_TAREA('T013_PosicionamientoYFirma', 'T004_ResultadoNoTarificada')
		);

		V_TMP_TIPO_TAREA T_TIPO_TAREA;




		V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA
    (
																				-- **** T013_PosicionamientoYFirma ****
		-- ComboFirma = 01 y asistenciaPBC = 01
		--			 					TAREA												INSTANCIA					CAMPO						 VALOR	 							ACCION			
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'1'	,				'comboFirma',				'DD_SIN_SINO', 			'IN'),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'1'	,				'comboFirma',				'01', 							'='),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'1'	,				'fechaFirma',				 '', 								'NOT NULL'),			
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'1'	,				'numProtocolo',			 '', 								'NOT NULL'),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'1'	,				'comboCondiciones',	 '',	 							'NOT NULL'),		
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'1'	,				'condiciones',			 '', 								'NOT NULL'),		
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'1'	,				'motivoNoFirma',		 '',	 							'NULL'),

		T_TIPO_DATA('T013_PosicionamientoYFirma',					'1'	,				'asistenciaPBC',		 'DD_SIN_SINO',	 		'IN'),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'1'	,				'asistenciaPBC',		 '01',					 		'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'1'	,				'obsAsisPBC',		 		 '',	 							'NULL'),
		
		-- ComboFirma = 01 y asistenciaPBC = 02
		--			 					TAREA												INSTANCIA					CAMPO						 VALOR	 							ACCION			
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'2'	,				'comboFirma',				'DD_SIN_SINO', 			'IN'),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'2'	,				'comboFirma',				'01', 							'='),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'2'	,				'fechaFirma',				 '', 								'NOT NULL'),			
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'2'	,				'numProtocolo',			 '', 								'NOT NULL'),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'2'	,				'comboCondiciones',	 '',	 							'NOT NULL'),		
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'2'	,				'condiciones',			 '', 								'NOT NULL'),		
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'2'	,				'motivoNoFirma',		 '',	 							'NULL'),

		T_TIPO_DATA('T013_PosicionamientoYFirma',					'2'	,				'asistenciaPBC',		 'DD_SIN_SINO',	 		'IN'),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'2'	,				'asistenciaPBC',		 '02',					 		'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'2'	,				'obsAsisPBC',		 		 '',	 							'NOT NULL'),
		
		-- ComboFirma = 02   tieneReserva = 01   y   asistenciaPBC = 01
		--			 					TAREA												INSTANCIA					CAMPO						 VALOR	 							ACCION			
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'3'	,				'comboFirma',				'DD_SIN_SINO', 			'IN'),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'3'	,				'comboFirma',				'02', 							'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'3'	,				'tieneReserva',			'DD_SIN_SINO', 			'IN'),		
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'3'	,				'tieneReserva',			'01',	 							'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'3'	,				'motivoNoFirma',		 '',		 						'NULL'),

		T_TIPO_DATA('T013_PosicionamientoYFirma',					'3'	,				'fechaFirma',				 '', 								'NULL'),			
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'3'	,				'numProtocolo',			 '', 								'NULL'),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'3'	,				'comboCondiciones',	 '',	 							'NULL'),		
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'3'	,				'condiciones',			 '', 								'NULL'),		

		T_TIPO_DATA('T013_PosicionamientoYFirma',					'3'	,				'asistenciaPBC',		 'DD_SIN_SINO',	 		'IN'),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'3'	,				'asistenciaPBC',		 '01',					 		'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'3'	,				'obsAsisPBC',		 		 '',	 							'NULL'),

		-- ComboFirma = 02   tieneReserva = 01   y   asistenciaPBC = 02
		--			 					TAREA												INSTANCIA					CAMPO						 VALOR	 							ACCION			
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'4'	,				'comboFirma',				'DD_SIN_SINO', 			'IN'),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'4'	,				'comboFirma',				'02', 							'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'4'	,				'tieneReserva',			'DD_SIN_SINO', 			'IN'),		
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'4'	,				'tieneReserva',			'01',	 							'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'4'	,				'motivoNoFirma',		 '',		 						'NULL'),

		T_TIPO_DATA('T013_PosicionamientoYFirma',					'4'	,				'fechaFirma',				 '', 								'NULL'),			
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'4'	,				'numProtocolo',			 '', 								'NULL'),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'4'	,				'comboCondiciones',	 '',	 							'NULL'),		
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'4'	,				'condiciones',			 '', 								'NULL'),

		T_TIPO_DATA('T013_PosicionamientoYFirma',					'4'	,				'asistenciaPBC',		 'DD_SIN_SINO',	 		'IN'),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'4'	,				'asistenciaPBC',		 '02',					 		'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'4'	,				'obsAsisPBC',		 		 '',	 							'NOT NULL'),

		-- ComboFirma = 02   tieneReserva = 02   y   asistenciaPBC = 01
		--			 					TAREA												INSTANCIA					CAMPO						 VALOR	 							ACCION			
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'5'	,				'comboFirma',				'DD_SIN_SINO', 			'IN'),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'5'	,				'comboFirma',				'02', 							'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'5'	,				'tieneReserva',			'DD_SIN_SINO', 			'IN'),		
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'5'	,				'tieneReserva',			'02',	 							'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'5'	,				'motivoNoFirma',		 '',		 						'NOT NULL'),

		T_TIPO_DATA('T013_PosicionamientoYFirma',					'5'	,				'fechaFirma',				 '', 								'NULL'),			
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'5'	,				'numProtocolo',			 '', 								'NULL'),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'5'	,				'comboCondiciones',	 '',	 							'NULL'),		
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'5'	,				'condiciones',			 '', 								'NULL'),

		T_TIPO_DATA('T013_PosicionamientoYFirma',					'5'	,				'asistenciaPBC',		 'DD_SIN_SINO',	 		'IN'),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'5'	,				'asistenciaPBC',		 '01',					 		'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'5'	,				'obsAsisPBC',		 		 '',	 							'NULL'),

		-- ComboFirma = 02   tieneReserva = 02   y   asistenciaPBC = 02
		--			 					TAREA												INSTANCIA					CAMPO						 VALOR	 							ACCION			
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'6'	,				'comboFirma',				'DD_SIN_SINO', 			'IN'),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'6'	,				'comboFirma',				'02', 							'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'6'	,				'tieneReserva',			'DD_SIN_SINO', 			'IN'),		
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'6'	,				'tieneReserva',			'02',	 							'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'6'	,				'motivoNoFirma',		 '',	 							'NOT NULL'),

		T_TIPO_DATA('T013_PosicionamientoYFirma',					'6'	,				'fechaFirma',				 '', 								'NULL'),			
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'6'	,				'numProtocolo',			 '', 								'NULL'),					
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'6'	,				'comboCondiciones',	 '',	 							'NULL'),		
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'6'	,				'condiciones',			 '', 								'NULL'),		

		T_TIPO_DATA('T013_PosicionamientoYFirma',					'6'	,				'asistenciaPBC',		 'DD_SIN_SINO',	 		'IN'),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'6'	,				'asistenciaPBC',		 '02',					 		'='),
		T_TIPO_DATA('T013_PosicionamientoYFirma',					'6'	,				'obsAsisPBC',		 		 '',	 							'NOT NULL'),

																		-- ****  T004_ResultadoNoTarificada ****
	-- comboModificacion = 01
		--			 					TAREA												INSTANCIA					CAMPO											VALOR	 					ACCION
		T_TIPO_DATA('T004_ResultadoNoTarificada',					'7'	,				'comboModificacion',				'DD_SIN_SINO', 	'IN'),					
		T_TIPO_DATA('T004_ResultadoNoTarificada',					'7'	,				'comboModificacion',				'01',		 				'='),					
		T_TIPO_DATA('T004_ResultadoNoTarificada',					'7'	,				'fechaFinalizacion',				'', 						'NULL'),			
	-- comboModificacion = 02
		T_TIPO_DATA('T004_ResultadoNoTarificada',					'8'	,				'comboModificacion',				'DD_SIN_SINO',	'IN'),		
		T_TIPO_DATA('T004_ResultadoNoTarificada',					'8'	,				'comboModificacion',				'02',	 					'='),
		T_TIPO_DATA('T004_ResultadoNoTarificada',					'8'	,				'fechaFinalizacion',				'',  						'NOT NULL')

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
							V_TAREA_T013 := 'SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAREA(1))||''' AND BORRADO = 0';
							EXECUTE IMMEDIATE V_TAREA_T013 INTO V_NUM_TAREA_T013;
							-- Recuperar TAP_ID de T004_ResultadoNoTarificada
							V_TAREA_T004 := 'SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_TAREA(2))||''' AND BORRADO = 0';
							EXECUTE IMMEDIATE V_TAREA_T004 INTO V_NUM_TAREA_T004;
							
    					 V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TCC_TAREA_CONFIG_CAMPOS WHERE  TAP_ID = '''||V_NUM_TAREA_T013||''' OR TAP_ID = '''||V_NUM_TAREA_T004||'''';
							 EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

							IF V_NUM_TABLAS > 0  THEN			
								EXECUTE IMMEDIATE 'DELETE FROM '||V_ESQUEMA||'.TCC_TAREA_CONFIG_CAMPOS WHERE  TAP_ID = '''||V_NUM_TAREA_T013||''' OR TAP_ID = '''||V_NUM_TAREA_T004||'''';

										DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS ELIMINADOS CON ÉXITO. '); 										
								END IF;
						
						END LOOP;

					-- LOOP para insertar los valores --
					FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
						LOOP
							V_TMP_TIPO_DATA := V_TIPO_DATA(I);

							-- Recuperar TAP_ID del T_ARRAY -> T013_PosicionamientoYFirma y T004_ResultadoNoTarificada
							V_TAREA := 'SELECT TAP_ID FROM TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||''' AND BORRADO = 0';
							EXECUTE IMMEDIATE V_TAREA INTO V_TAP_ID;
							-- Recuperar el TFI_ID del T_ARRAY
							V_CAMPO := 'SELECT TFI_ID FROM TFI_TAREAS_FORM_ITEMS WHERE TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(3))||''' AND TAP_ID = '''||V_TAP_ID||'''';
							EXECUTE IMMEDIATE V_CAMPO INTO V_TFI_ID;		

							EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.TCC_TAREA_CONFIG_CAMPOS (TCC_ID, TAP_ID, TFI_ID, TCC_INSTANCIA, TCC_VALOR, TCC_ACCION, USUARIOCREAR, FECHACREAR) 
							VALUES ('||V_ESQUEMA||'.S_TCP_TAREA_CONFIG_PETICION.NEXTVAL,'||V_TAP_ID||',' ||V_TFI_ID||','''||V_TMP_TIPO_DATA(2)||''','''||V_TMP_TIPO_DATA(4)||''','''||V_TMP_TIPO_DATA(5)||''','||V_USU_CREAR||', SYSDATE )'; 
															
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