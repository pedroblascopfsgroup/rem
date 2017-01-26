--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20170126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1337
--## PRODUCTO=NO
--##
--## Finalidad: INSERTA filas de TFI_TAREAS_FORM_ITEMS - Campos tarea T004_AutorizacionBankia del T. ACTUACION TECNICA
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    
    
    /* TABLA: TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    				--TAP_CODIGO 							--TFI_TIPO 			--TFI_NOMBRE 		--TFI_BUSINESS_OP					--tfi_label 								--TFI_ERROR_VALIDACION													--TFI_VALIDACION

		T_TFI(   'T004_AutorizacionBankia',   			'date',   				'fecha',  				'',						'Fecha',											'Debe indicar la fecha de autorizaci&oacute;n',							'false' ),
		T_TFI(   'T004_AutorizacionBankia',   			'combo',   				'comboAmpliacion',  	'DDSiNo',				'Ampliación del presupuesto',						'Debe indicar si autoriza el trabajo o el incremento de presupuesto',	'false' ),
		T_TFI(   'T004_AutorizacionBankia',   			'textarea',   			'observaciones',  		'',						'Observaciones',									'',																		'' ),
		T_TFI(   'T004_AutorizacionBankia',   			'elctrabajo',   		'GESECO',				'',						'TRABAJO > Gesti&oacuten econ&oacutemica',			'',																		'' )

		);
    V_TMP_T_TFI T_TFI;

/*
        T_TFI('T004_AutorizacionBankia'            ,'1'        ,'date'     ,'fecha'                ,'Fecha'                                                                                                                                                                                                                                                                                                        ,'Debe indicar la fecha de autorizaci&oacute;n'                 ,'false'                                        ,''                 ),
        T_TFI('T004_AutorizacionBankia'            ,'2'        ,'combo'    ,'comboAmpliacion'      ,'Ampliación del presupuesto'                                                                                                                                                                                                                                                                                   ,'Debe indicar si autoriza el incremento de presupuesto'        ,'false'                                        ,'DDSiNo'           ),
        T_TFI('T004_AutorizacionBankia'            ,'3'        ,'textinf'  ,'numIncremento'        ,'Importe del incremento'                                                                                                                                                                                                                                                                                       ,''                                                             ,''                                             ,''                 ),
        T_TFI('T004_AutorizacionBankia'            ,'4'        ,'textarea' ,'observaciones'        ,'Observaciones'                                                                                                                                                                                                                                                                                                ,''                                                             ,''                                             ,''                 )
*/
    
 -- ## FIN DATOS
 -- ########################################################################################
  


BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO] Insertando datos de TFI_TAREAS_FORM_ITEMS - remapeo de tarea T004_AutorizacionBankia en T. EMISION CEE');

	V_SQL := '
		SELECT COUNT(1) FROM '||V_ESQUEMA||'.tfi_tareas_form_items WHERE tfi_nombre <> ''titulo''  
			AND tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T004_AutorizacionBankia'' )
	';
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_ENLACES;


	IF (V_NUM_ENLACES > 0) THEN
		V_MSQL := 'DELETE '||V_ESQUEMA||'.tfi_tareas_form_items WHERE tfi_nombre <> ''titulo''  
			AND tap_id = (select tap_id from '||V_ESQUEMA||'.tap_tarea_procedimiento where tap_codigo = ''T004_AutorizacionBankia'' )
	';
		DBMS_OUTPUT.PUT_LINE('[DELETE] Se han encontrado '||V_NUM_ENLACES||' campos antiguos en TFI que necesitan borrarse para T004_AutorizacionBankia. Se eliminan todos antes de insertar los nuevos.'); 
		--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
	END IF;

	-- Bucle INSERT tfi_tareas_form_items
	FOR I IN V_TFI.FIRST .. V_TFI.LAST
	LOOP

		V_TMP_T_TFI := V_TFI(I);

		V_SQL_NORDEN := '
			SELECT max(tfi.tfi_orden) + 1 next_order
			FROM '||V_ESQUEMA||'.tfi_tareas_form_items tfi
			INNER JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap
			ON tfi.tap_id = tap.tap_id
			WHERE tap.tap_codigo = '||''''||V_TMP_T_TFI(1)||''''||'
			GROUP BY tap.tap_codigo
		';
		--DBMS_OUTPUT.PUT_LINE(V_SQL_NORDEN);
		EXECUTE IMMEDIATE V_SQL_NORDEN INTO V_NUM_NORDEN;


		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS ' ||
					  ' (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_business_operation, tfi_label, TFI_ERROR_VALIDACION, TFI_VALIDACION, usuariocrear, fechacrear ) '||
					  ' VALUES (
					  		s_tfi_tareas_form_items.nextval,
					  		(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '||''''||V_TMP_T_TFI(1)||''''||'),
					  		'||''||V_NUM_NORDEN||''||',
					  		'||''''||V_TMP_T_TFI(2)||''''||',
					  		'||''''||V_TMP_T_TFI(3)||''''||',
		  					'||''''||V_TMP_T_TFI(4)||''''||',
					  		'||''''||V_TMP_T_TFI(5)||''''||',
					  		'||''''||V_TMP_T_TFI(6)||''''||',
					  		'||''''||V_TMP_T_TFI(7)||''''||',
					  		''REM_F2'',
					  		SYSDATE
					  		) ';
		DBMS_OUTPUT.PUT_LINE('[INSERT] INSERTANDO CAMPO - '''||V_TMP_T_TFI(3)||''' para tarea '''||V_TMP_T_TFI(1)||''''); 
		-- DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[COMMIT] Commit realizado');
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[FIN] Filas TFI insertadas correctamente.');

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