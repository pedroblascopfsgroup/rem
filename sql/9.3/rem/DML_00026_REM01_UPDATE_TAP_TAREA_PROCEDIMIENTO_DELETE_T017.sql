--/*
--##########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20200225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8546
--## PRODUCTO=NO
--##
--## Finalidad:	Borrar tareas de manera lógica
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
	
	V_TAP_ID NUMBER(16);
	V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'TAP_TAREA_PROCEDIMIENTO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-8546';
	
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
	V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('T017_AnalisisPM'),
		T_TIPO_DATA('T017_RespuestaOfertantePM')
	); 
	V_TMP_TIPO_DATA T_TIPO_DATA;

BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	-- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
	LOOP
		V_TMP_TIPO_DATA := V_TIPO_DATA(I);
		
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE 
			TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
		IF V_NUM_TABLAS > 0 THEN				
			-- Si existe se modifica.
			DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO DEL CAMPO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||''' DE TAP_TAREA_PROCEDIMIENTO');
			V_MSQL := 'UPDATE '|| V_ESQUEMA ||'.TAP_TAREA_PROCEDIMIENTO SET
				USUARIOBORRAR = '''||V_USUARIO||''' , 
				FECHABORRAR = SYSDATE, 
				BORRADO = 1 
				WHERE TAP_CODIGO = '''||V_TMP_TIPO_DATA(1)||'''';
			EXECUTE IMMEDIATE V_MSQL;
         
			DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO MODIFICADO CORRECTAMENTE');

		END IF;
	END LOOP;
    
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: DICCIONARIO '||V_TEXT_TABLA||' ACTUALIZADO CORRECTAMENTE ');

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