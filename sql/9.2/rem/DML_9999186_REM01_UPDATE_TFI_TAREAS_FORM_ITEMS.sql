--/*
--##########################################
--## AUTOR=Sergio Nieto
--## FECHA_CREACION=20181208
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4967
--## PRODUCTO=NO
--##
--## Finalidad: Script que actualiza los trámites T015 Definición de Oferta, T015 Verificar Scoring y T015 Verificar Seguro de Rentas.
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_USU VARCHAR2(30 CHAR) := 'HREOS-4719'; -- Vble. auxiliar para almacenar el nombre de usuario que modifica los registros.

    /* Reordenar TFI_TAREAS_FOR_ITEMS */
    TYPE T_TFI IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_TFI IS TABLE OF T_TFI;
    V_TFI T_ARRAY_TFI := T_ARRAY_TFI(
    		 	--TAP_CODIGO					  --TFI_NOMBRE            --TFI_ORDEN
		T_TFI('T015_DefinicionOferta',			'nMesesFianza'				,  '3'),
		T_TFI('T015_DefinicionOferta',			'importeFianza'				,  '4'),
        T_TFI('T015_DefinicionOferta',			'tipoInquilino'				,  '5'),
		T_TFI('T015_DefinicionOferta',			'tipoImpuesto'				,  '7'),
		T_TFI('T015_DefinicionOferta',			'porcentajeImpuesto'		,  '8'),
        T_TFI('T015_DefinicionOferta',			'deposito'					,  '9'),
        T_TFI('T015_DefinicionOferta',			'nMeses'					,  '11'),
        T_TFI('T015_DefinicionOferta',			'importeDeposito'			,  '12'),
        T_TFI('T015_DefinicionOferta',			'fiadorSolidario'			,  '13'),
        T_TFI('T015_DefinicionOferta',			'nombreFS'					,  '15'),
        T_TFI('T015_DefinicionOferta',			'documento'					,  '16'),
        T_TFI('T015_DefinicionOferta',			'observaciones'				,  '17'),
        
        
        T_TFI('T015_VerificarScoring',			'tipoImpuesto'				,  '7'),
        T_TFI('T015_VerificarScoring',			'porcentajeImpuesto'		,  '8'),
        T_TFI('T015_VerificarScoring',			'deposito'					,  '9'),
        T_TFI('T015_VerificarScoring',			'nMeses'					,  '11'),
        T_TFI('T015_VerificarScoring',			'importeDeposito'			,  '12'),
        T_TFI('T015_VerificarScoring',			'fiadorSolidario'			,  '13'),
        T_TFI('T015_VerificarScoring',			'nombreFS'					,  '15'),
        T_TFI('T015_VerificarScoring',			'documento'					,  '16'),
        T_TFI('T015_VerificarScoring',			'observaciones'				,  '17'),
        
        
        T_TFI('T015_VerificarSeguroRentas',		'tipoImpuesto'				,  '5'),
        T_TFI('T015_VerificarSeguroRentas',		'porcentajeImpuesto'		,  '6'),
        T_TFI('T015_VerificarSeguroRentas',		'aseguradora'				,  '7'),
        T_TFI('T015_VerificarSeguroRentas',		'envioEmail'				,  '8'),
        T_TFI('T015_VerificarSeguroRentas',		'deposito'					,  '9'),
        T_TFI('T015_VerificarSeguroRentas',		'nMeses'					,  '11'),
        T_TFI('T015_VerificarSeguroRentas',		'importeDeposito'			,  '12'),
        T_TFI('T015_VerificarSeguroRentas',		'fiadorSolidario'			,  '13'),
        T_TFI('T015_VerificarSeguroRentas',		'nombreFS'					,  '15'),
        T_TFI('T015_VerificarSeguroRentas',		'documento'					,  '16'),
        T_TFI('T015_VerificarSeguroRentas',		'observaciones'				,  '17')
    );
    V_TMP_T_TFI T_TFI;
    
    -- Insertar huecoo en blanco
    TYPE T_VACIO IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY_VACIO IS TABLE OF T_VACIO;
    V_T_VACIO T_ARRAY_VACIO := T_ARRAY_VACIO(
    		 	  --TAP_CODIGO					 --TFI_ORDEN
    	T_VACIO('T015_DefinicionOferta', 			'6'),
    	T_VACIO('T015_DefinicionOferta', 			'10'),
    	T_VACIO('T015_DefinicionOferta', 			'14'),
    	T_VACIO('T015_VerificarScoring', 			'10'),
    	T_VACIO('T015_VerificarScoring',			'14'),
    	T_VACIO('T015_VerificarSeguroRentas',		'10'),
    	T_VACIO('T015_VerificarSeguroRentas',		'14')
    );
    V_TMP_T_VACIO T_VACIO;

BEGIN

        DBMS_OUTPUT.PUT_LINE('[INFO] REORDENANDO TFI_TAREAS_FORM_ITEMS');

        FOR I IN V_TFI.FIRST .. V_TFI.LAST
        LOOP

            V_TMP_T_TFI := V_TFI(I);

            --Comprobar el dato a insertar.
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||TRIM(V_TMP_T_TFI(1))||''' AND BORRADO = 0';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

            DBMS_OUTPUT.PUT_LINE('[INFO] ORDENANDO ''' || TRIM(V_TMP_T_TFI(1)));

            IF V_NUM_TABLAS > 0 THEN				
                -- Si existe se modifica.
                V_MSQL := 'UPDATE '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS '||
                ' SET TFI_ORDEN = '||V_TMP_T_TFI(3)||' '||
                ' ,USUARIOMODIFICAR = ''' || V_USU || ''' ,FECHAMODIFICAR = SYSDATE '||
                ' WHERE TFI_NOMBRE = '''||V_TMP_T_TFI(2)||''' AND TAP_ID = (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = '''||V_TMP_T_TFI(1)||''') ';
                
                DBMS_OUTPUT.PUT_LINE('[INFO] ORDENANDO SQL: ''' || V_MSQL);
                EXECUTE IMMEDIATE V_MSQL;

                DBMS_OUTPUT.PUT_LINE('[INFO] El campo TAP_SCRIPT_VALIDACION_JBPM de la tarea '||V_TMP_T_TFI(1)||' se ha actualizado.');
                
            END IF;
        END LOOP;
        
	    --Insercion de elementos emptyfield para solucionar algunos fallos de visualizacion
		DBMS_OUTPUT.PUT_LINE('Insertando emptyfield en tareas');
	
		 FOR I IN V_T_VACIO.FIRST .. V_T_VACIO.LAST
	      LOOP
	        V_TMP_T_VACIO := V_T_VACIO(I);
		
		V_SQL := 'SELECT COUNT(1) 
			FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS TFI 
			JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TFI.TAP_ID AND TAP.TAP_CODIGO = '''||TRIM(V_TMP_T_VACIO(1))||'''
			WHERE TFI.TFI_ORDEN = '||TRIM(V_TMP_T_VACIO(2))||' AND TFI.TFI_TIPO = ''emptyField'' AND TFI.BORRADO = 0';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
		IF V_NUM_TABLAS = 0 THEN
	
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS 
				(TFI_ID, TAP_ID, TFI_ORDEN, TFI_TIPO, TFI_NOMBRE, TFI_LABEL, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
				SELECT
					S_TFI_TAREAS_FORM_ITEMS.NEXTVAL,
					TAP.TAP_ID, 
					'||TRIM(V_TMP_T_VACIO(2))||', 
					''label'', 
					''hueco'', 
					'''', 
					0, 
					''' || V_USU || ''', 
					SYSDATE, 
					0
				FROM
					'||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP
				WHERE
					TAP.TAP_CODIGO = '''||TRIM(V_TMP_T_VACIO(1))||''''; 
		    EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('Insertado elemento ''emptyField'' en la posicion '||TRIM(V_TMP_T_VACIO(2)));	
		ELSE
			DBMS_OUTPUT.PUT_LINE('Ya existe un elemento ''emptyField'' en la posicion '||TRIM(V_TMP_T_VACIO(2)));
		END IF;
	
	      END LOOP;
	
		DBMS_OUTPUT.PUT_LINE('Inserción completada');
	
    COMMIT;
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
