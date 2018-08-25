--/*
--##########################################
--## AUTOR=Jose Navarro
--## FECHA_CREACION=20180826
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4443
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza el trámite T015 Trámite comercial alquiler.
--## INSTRUCCIONES:
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
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU_MODIFICAR VARCHAR2(30 CHAR) := '''HREOS-4443'''; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.
    
	-- T015_VerificarScoring
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		----- TFI_NOMBRE		--TFI_ORDEN
    	T_TIPO_DATA('deposito', 		'1'),
	T_TIPO_DATA('nMeses', 			'3'),
	T_TIPO_DATA('importeDeposito', 		'4'),
	T_TIPO_DATA('fiadorSolidario', 		'6'),
	T_TIPO_DATA('nombreFS', 		'7'),
	T_TIPO_DATA('documento', 		'8'),
	T_TIPO_DATA('resultadoScoring', 	'9'),
	T_TIPO_DATA('fechaSancScoring', 	'10'),
	T_TIPO_DATA('motivoRechazo', 		'11'),
	T_TIPO_DATA('nExpediente', 		'12'),
	T_TIPO_DATA('nMesesFianza', 		'13'),
	T_TIPO_DATA('importeFianza', 		'14'),
	T_TIPO_DATA('tipoImpuesto', 		'15'),
	T_TIPO_DATA('porcentajeImpuesto', 	'16'),
	T_TIPO_DATA('observaciones', 		'17')
    );
    V_TMP_TIPO_DATA T_TIPO_DATA;

	-- T015_VerificarSeguroRentas
    TYPE T_TIPO_DATA2 IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_DATA2 IS TABLE OF T_TIPO_DATA2;
    V_TIPO_DATA2 T_ARRAY_DATA2 := T_ARRAY_DATA2(
		----- TFI_NOMBRE		--TFI_ORDEN
    	T_TIPO_DATA2('deposito', 		'1'),
	T_TIPO_DATA2('nMeses', 			'3'),
	T_TIPO_DATA2('importeDeposito', 	'4'),
	T_TIPO_DATA2('fiadorSolidario', 	'6'),
	T_TIPO_DATA2('nombreFS', 		'7'),
	T_TIPO_DATA2('documento', 		'8'),
	T_TIPO_DATA2('resultadoRentas', 	'9'),
	T_TIPO_DATA2('fechaSancRentas', 	'10'),
	T_TIPO_DATA2('motivoRechazo', 		'11'),
	T_TIPO_DATA2('nMesesFianza', 		'12'),
	T_TIPO_DATA2('importeFianza', 		'13'),
	T_TIPO_DATA2('tipoImpuesto', 		'14'),
	T_TIPO_DATA2('porcentajeImpuesto', 	'15'),
	T_TIPO_DATA2('aseguradora', 		'16'),
	T_TIPO_DATA2('envioEmail', 		'17'),
	T_TIPO_DATA2('observaciones', 		'18')
    );
    V_TMP_TIPO_DATA2 T_TIPO_DATA2;

	-- T015_DefinicionOferta
    TYPE T_TIPO_DATA3 IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_DATA3 IS TABLE OF T_TIPO_DATA3;
    V_TIPO_DATA3 T_ARRAY_DATA3 := T_ARRAY_DATA3(
		----- TFI_NOMBRE		--TFI_ORDEN
    	T_TIPO_DATA3('deposito', 		'1'),
	T_TIPO_DATA3('nMeses', 			'3'),
	T_TIPO_DATA3('importeDeposito', 	'4'),
	T_TIPO_DATA3('fiadorSolidario', 	'6'),
	T_TIPO_DATA3('nombreFS', 		'7'),
	T_TIPO_DATA3('documento', 		'8'),
	T_TIPO_DATA3('tipoTratamiento', 	'9'),
	T_TIPO_DATA3('fechaTratamiento', 	'10'),
	T_TIPO_DATA3('tipoInquilino', 		'11'),
	T_TIPO_DATA3('nMesesFianza', 		'12'),
	T_TIPO_DATA3('importeFianza', 		'13'),
	T_TIPO_DATA3('tipoImpuesto', 		'14'),
	T_TIPO_DATA3('porcentajeImpuesto', 	'15'),
	T_TIPO_DATA3('observaciones', 		'16')
    );
    V_TMP_TIPO_DATA3 T_TIPO_DATA3;
	
	-- emptyfield
    TYPE T_TIPO_DATA4 IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_DATA4 IS TABLE OF T_TIPO_DATA4;
    V_TIPO_DATA4 T_ARRAY_DATA4 := T_ARRAY_DATA4(
		----- TAP_CODIGO					--TFI_ORDEN
    	T_TIPO_DATA4('T015_Firma', 					'2'),
    	T_TIPO_DATA4('T015_ResolucionPBC', 				'2'),
    	T_TIPO_DATA4('T015_DefinicionOferta', 				'2'),
    	T_TIPO_DATA4('T015_DefinicionOferta', 				'5'),
    	T_TIPO_DATA4('T015_VerificarSeguroRentas', 			'2'),
    	T_TIPO_DATA4('T015_VerificarSeguroRentas', 			'5'),
    	T_TIPO_DATA4('T015_VerificarScoring', 				'2'),
    	T_TIPO_DATA4('T015_VerificarScoring', 				'5')
    );
    V_TMP_TIPO_DATA4 T_TIPO_DATA4;
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('COMENZANDO EL PROCESO DE ACTUALIZACIÓN TABLA ''TFI_TAREAS_FORM_ITEMS''');

	--Modificación del campo nMeses de la tarea T015_VerificarScoring
	DBMS_OUTPUT.PUT_LINE('Modificando campo nMeses de la tarea T015_VerificarScoring');

	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
		   SET TFI_TIPO = ''number'',
		   USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''',
		   FECHAMODIFICAR = SYSDATE
		   WHERE TAP_ID = (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T015_VerificarScoring'') 
			AND TFI_NOMBRE = ''nMeses'''; 
    EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('Modificación completada');

	--Modificación del orden de la tarea T015_VerificarScoring
	DBMS_OUTPUT.PUT_LINE('Modificando orden campos de la tarea T015_VerificarScoring');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
        
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
		   SET TFI_ORDEN = '||TRIM(V_TMP_TIPO_DATA(2))||',
		   USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''',
		   FECHAMODIFICAR = SYSDATE
		   WHERE TAP_ID = (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T015_VerificarScoring'') 
			AND TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(1))||''''; 
    EXECUTE IMMEDIATE V_MSQL;

      END LOOP;
	DBMS_OUTPUT.PUT_LINE('Modificación completada');

	--Modificación del orden de la tarea T015_VerificarSeguroRentas
	DBMS_OUTPUT.PUT_LINE('Modificando orden campos de la tarea T015_VerificarSeguroRentas');
    FOR I IN V_TIPO_DATA2.FIRST .. V_TIPO_DATA2.LAST
      LOOP
        V_TMP_TIPO_DATA2 := V_TIPO_DATA2(I);
        
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
		   SET TFI_ORDEN = '||TRIM(V_TMP_TIPO_DATA2(2))||',
		   USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''',
		   FECHAMODIFICAR = SYSDATE
		   WHERE TAP_ID = (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T015_VerificarSeguroRentas'') 
			AND TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA2(1))||''''; 
    EXECUTE IMMEDIATE V_MSQL;

      END LOOP;
	DBMS_OUTPUT.PUT_LINE('Modificación completada');

	--Modificación del orden de la tarea T015_DefinicionOferta
	DBMS_OUTPUT.PUT_LINE('Modificando orden campos de la tarea T015_DefinicionOferta');
    FOR I IN V_TIPO_DATA3.FIRST .. V_TIPO_DATA3.LAST
      LOOP
        V_TMP_TIPO_DATA3 := V_TIPO_DATA3(I);
        
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS
		   SET TFI_ORDEN = '||TRIM(V_TMP_TIPO_DATA3(2))||',
		   USUARIOMODIFICAR = '''||V_USU_MODIFICAR||''',
		   FECHAMODIFICAR = SYSDATE
		   WHERE TAP_ID = (SELECT TAP.TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP WHERE TAP.TAP_CODIGO = ''T015_DefinicionOferta'') 
			AND TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA3(1))||''''; 
    EXECUTE IMMEDIATE V_MSQL;

      END LOOP;
	DBMS_OUTPUT.PUT_LINE('Modificación completada');

	--Insercion de elementos emptyfield para solucionar algunos fallos de visualizacion
	DBMS_OUTPUT.PUT_LINE('Insertando emptyfield en tareas');

	 FOR I IN V_TIPO_DATA4.FIRST .. V_TIPO_DATA4.LAST
      LOOP
        V_TMP_TIPO_DATA4 := V_TIPO_DATA4(I);

	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS 
		(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
		SELECT
			S_TFI_TAREAS_FORM_ITEMS.NEXTVAL,
			TAP.TAP_ID, 
			'||TRIM(V_TMP_TIPO_DATA4(2))||', 
			''emptyField'', 
			''hueco'', 
			'', 
			0, 
			'''||V_USU_MODIFICAR||''', 
			SYSDATE, 
			0
		FROM
			'||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
		WHERE
			TAP.TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA4(1))||''''; 
    EXECUTE IMMEDIATE V_MSQL;

      END LOOP;

	DBMS_OUTPUT.PUT_LINE('Inserción completada');

	COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA ''TFI_TAREAS_FORM_ITEMS'' ACTUALIZADA CORRECTAMENTE ');
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
