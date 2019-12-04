--/*
--##########################################
--## AUTOR=Vicente Martinez
--## FECHA_CREACION=20191203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8520
--## PRODUCTO=NO
--##
--## Finalidad:	Cambiar instrucciones de las tareas contenidas en el array
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
	V_ID NUMBER(16); -- Vble. auxiliar para almacenar temporalmente el numero de la sequencia.
	
	V_TFI_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TEXT_TABLA_ACT VARCHAR2(2400 CHAR) := 'TFI_TAREAS_FORM_ITEMS'; -- Vble. auxiliar para almacenar el nombre de la tabla a actualizar.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-8520';
	
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(3200 CHAR);
	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('T013_DefinicionOferta', 'titulo', '<p style="margin-bottom: 10px">
  Ha aceptado una oferta y se ha creado un expediente comercial asociado a la misma.
  A continuación  debería rellenar todos los campos necesarios para definir la oferta, pudiendo darse la siguiente casuística para finalizar la tarea
  </p>
  <p style="margin-bottom: 10px">A) Si tiene atribuciones para sancionar la oferta:<br />
  i) Si el activo está dentro del perímetro de formalización al pulsar el botón Aceptar finalizará esta tarea y se le lanzará a la gestoría de  formalización una nueva tarea para la realización del "Informe jurídico".<br />
  ii) Si el activo no se encuentra dentro del perímetro de formalización, la siguiente tarea que se lanzará es "Firma por el propietario".<br />
  *) Si el trámite es de la subcartera "Omega - Inmobiliario", al pulsar el botón Aceptar, pasará a PBC Reserva o PBC Venta, dependiendo de si tiene o no reserva. </p>
  <p style="margin-bottom: 10px"> B) Si no tiene atribuciones para sancionar la oferta, deberá preparar la propuesta y remitirla al comité sancionador, indicando  abajo la fecha de envío.</p>
  <p style="margin-bottom: 10px"> C) El presente expediente tiene origen en el ejercicio del derecho de tanteo y retracto administrativo, por lo que la oferta ya fue aprobada en su momento.
  De ser así, marque el check dispuesto al efecto, identificando el nº de expediente origen, para que el trámite vaya directamente a la tarea de "Posicionamiento y firma".
  </p>
  <p style="margin-bottom: 10px">
  En cualquier caso, para poder finalizar la tarea, tiene que reflejar si existe riesgo reputacional y/o conflicto de intereses en la Ficha del expediente.
  </p>
  <p style="margin-bottom: 10px">
  En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite
  </p>'),
		T_TIPO_DATA('T013_PBCReserva', 'titulo', '<p style="margin-bottom: 10px">En la presente tarea deberá reflejar si se ha aprobado el proceso de PBC de la reserva.</p> <p style="margin-bottom: 10px">Si no se ha aprobado, el expediente quedará anulado, finalizándose el trámite</p> <p style="margin-bottom: 10px"> Si se ha aprobado, se lanzará al gestor la tarea de "PBC Venta"</p> <p style="margin-bottom: 10px"> En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite</p>'),
		T_TIPO_DATA('T013_ResultadoPBC', 'titulo', '<p style="margin-bottom: 10px">
  En la presente tarea deberá reflejar si se ha aprobado el proceso de PBC.</p>
  <p style="margin-bottom: 10px">Si no se ha aprobado, el expediente quedará anulado, finalizándose el trámite</p>
  <p style="margin-bottom: 10px"> Si se ha aprobado, se lanzará a la gestoría de formalización la tarea de "Posicionamiento y firma"</p> <p style="margin-bottom: 10px"> Si se ha aprobado y el trámite es de la subcartera "Omega - Inmobiliario", se lanzará la tarea de "Firma Propietario"</p> <p style="margin-bottom: 10px"> En el campo "observaciones" puede hacer constar cualquier aspecto relevante que considere que debe quedar reflejado en este punto del trámite</p>')
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZACION EN '||V_TEXT_TABLA_ACT);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		--Comprobar el dato a insertar.
		V_SQL := 'SELECT TFI.TFI_ID
					FROM '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS TFI
					JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TFI.TAP_ID = TAP.TAP_ID
					AND TAP_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
					WHERE TFI.TFI_NOMBRE = '''||TRIM(V_TMP_TIPO_DATA(2))||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_TFI_ID;
		
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_ACT||' WHERE 
			TFI_ID = '''||V_TFI_ID||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
		IF V_NUM_TABLAS > 0 THEN				
			-- Si existe se modifica.
			DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICAR EL CAMPO '''|| TRIM(V_TMP_TIPO_DATA(3)) ||''' DE '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.'||V_TEXT_TABLA_ACT||' SET 
				TFI_LABEL = '''||TRIM(V_TMP_TIPO_DATA(3))||''',
				USUARIOMODIFICAR = '''||V_USUARIO||''' , 
				FECHAMODIFICAR = SYSDATE, 
				BORRADO = 0 
				WHERE TFI_ID = '''||V_TFI_ID||'''';
			EXECUTE IMMEDIATE V_MSQL;
         
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');
		END IF;
	END LOOP;
    
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA_ACT||' ACTUALIZADO CORRECTAMENTE ');

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