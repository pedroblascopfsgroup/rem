--/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20160609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0.7
--## INCIDENCIA_LINK=HREOS-502
--## PRODUCTO=NO
--##
--## Finalidad: INSERTA filas de TFI_TAREAS_FORM_ITEMS - Enlaces a Pestanyas
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
    				--TAP_CODIGO 							--TFI_TIPO 			--TFI_NOMBRE 	--TFI_LABEL
		T_TFI(   'T001_CheckingDocumentacionAdmision',   	'elcactivo',   		'CHECKINFO',   	'ACTIVO > Checking informaci&oacuten'   			),
		T_TFI(   'T001_CheckingDocumentacionGestion',   	'elcactivo',   		'CHECKINFO',   	'ACTIVO > Checking informaci&oacuten'   			),
		T_TFI(   'T001_CheckingInformacion',   				'elcactivo',   		'CHECKINFO',   	'ACTIVO > Checking informaci&oacuten'   			),
		T_TFI(   'T001_VerificarEstadoPosesorio',   		'elcactivo',   		'POSESORIA',	'ACTIVO > Situaci&oacuten posesoria y llaves'   	),
		T_TFI(   'T004_AnalisisPeticion',   				'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T004_CierreEconomico',   					'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T004_ResultadoTarificada',   				'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T004_SolicitudPresupuestoComplementario',	'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T004_EleccionPresupuesto',   				'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T004_EleccionProveedorYTarifa',   		'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T006_AnalisisPeticion',   				'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T006_CierreEconomico',   					'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T002_AnalisisPeticion',   				'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T002_CierreEconomico',   					'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T008_CierreEconomico',   					'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T003_AnalisisPeticion',   				'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T003_CierreEconomico',   					'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T005_AnalisisPeticion',   				'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T005_CierreEconomico',   					'elctrabajo',   	'GESECO',   	'TRABAJO > Gesti&oacuten econ&oacutemica'   		),
		T_TFI(   'T002_ObtencionLPOGestorInterno',   		'elctrabajo',   	'DOCU',   		'TRABAJO > Documentos adjuntos'   					),
		T_TFI(   'T002_ObtencionDocumentoGestoria',   		'elctrabajo',   	'DOCU',   		'TRABAJO > Documentos adjuntos'   					),
		T_TFI(   'T002_ValidacionActuacion',   				'elctrabajo',   	'DOCU',   		'TRABAJO > Documentos adjuntos'   					),
		T_TFI(   'T008_ObtencionDocumento',   				'elctrabajo',   	'DOCU',   		'TRABAJO > Documentos adjuntos'   					),
		T_TFI(   'T003_ObtencionEtiqueta',   				'elctrabajo',   	'DOCU',   		'TRABAJO > Documentos adjuntos'   					),
		T_TFI(   'T003_EmisionCertificado',   				'elctrabajo',   	'DOCU',   		'TRABAJO > Documentos adjuntos'   					),
		T_TFI(   'T006_EmisionInforme',   					'elctrabajo',   	'DOCU',   		'TRABAJO > Documentos adjuntos'   					),
		T_TFI(   'T006_ValidacionInforme',   				'elctrabajo',   	'DOCU',   		'TRABAJO > Documentos adjuntos'   					),
		T_TFI(   'T005_EmisionTasacion',   					'elctrabajo',   	'DOCU',   		'TRABAJO > Documentos adjuntos'   					),
		T_TFI(   'T004_ResultadoNoTarificada',   			'elctrabajo',   	'FOTOS',  		'TRABAJO > Fotos'   								),
		T_TFI(   'T004_ValidacionTrabajo',   				'elctrabajo',   	'FOTOS',   		'TRABAJO > Fotos'   								)

		);
    V_TMP_T_TFI T_TFI;
    
    
    
 -- ## FIN DATOS
 -- ########################################################################################
  


BEGIN

	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Insertando datos de TFI_TAREAS_FORM_ITEMS - Enlaces a pestañas para las tareas');

	V_SQL := '
		SELECT COUNT(1) FROM '||V_ESQUEMA||'.tfi_tareas_form_items WHERE tfi_tipo IN (''elcactivo'',''elctrabajo'')
	';
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_ENLACES;


	IF (V_NUM_ENLACES > 0) THEN
		V_MSQL := 'DELETE '||V_ESQUEMA||'.tfi_tareas_form_items WHERE tfi_tipo IN (''elcactivo'',''elctrabajo'')';
		DBMS_OUTPUT.PUT_LINE('[DELETE] Se han encontrado '||V_NUM_ENLACES||' antiguos enlaces en TFI. Se eliminan todos antes de insertar los nuevos.'); 
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
					  ' (tfi_id, tap_id, tfi_orden, tfi_tipo, tfi_nombre, tfi_label, usuariocrear, fechacrear ) '||
					  ' VALUES (
					  		s_tfi_tareas_form_items.nextval,
					  		(SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '||''''||V_TMP_T_TFI(1)||''''||'),
					  		'||''||V_NUM_NORDEN||''||',
					  		'||''''||V_TMP_T_TFI(2)||''''||',
					  		'||''''||V_TMP_T_TFI(3)||''''||',
					  		'||''''||V_TMP_T_TFI(4)||''''||',
					  		''HREOS-502'',
					  		SYSDATE
					  		) ';
		DBMS_OUTPUT.PUT_LINE('[INSERT] INSERTANDO ENLACE - '''||V_TMP_T_TFI(1)||''' para pestaña '''||V_TMP_T_TFI(4)||''''); 
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