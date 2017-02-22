--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1601
--## PRODUCTO=NO
--## Finalidad: Añadir check en columa de la tabla DD_OPM_VALIDACION_FORMATO
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_OPM_OPERACION_MASIVA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
    V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
	  T_FUNCION('CPPA_01', 	's,s,s,s,s,s,s,s*'),
	  T_FUNCION('CPPA_02', 	's,s*'),
	  T_FUNCION('CPPA_03', 	's,s,s,s*'),
	  T_FUNCION('CPPA', 	's,s,s,s,s*')
    ); 
    V_TMP_FUNCION T_FUNCION;
    V_MSQL_1 VARCHAR2(4000 CHAR);

BEGIN
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas *************************************************');

	 -- LOOP para actualizar los valores en DD_OPM_OPERACION_MASIVA -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN DD_OPM_OPERACION_MASIVA] ');
     FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
      LOOP
            V_TMP_FUNCION := V_FUNCION(I);
			
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_OPM_OPERACION_MASIVA WHERE DD_OPM_CODIGO = '''||V_TMP_FUNCION(1)||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FUNCION
			IF V_NUM_TABLAS > 0 THEN	  
				V_MSQL_1 := 'UPDATE '||V_ESQUEMA||'.DD_OPM_OPERACION_MASIVA' ||
							' SET DD_OPM_VALIDACION_FORMATO ='''||TRIM(V_TMP_FUNCION(2))||''''||
							' WHERE DD_OPM_CODIGO ='''||TRIM(V_TMP_FUNCION(1))||'''';
		    	
				EXECUTE IMMEDIATE V_MSQL_1;
				DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.DD_OPM_OPERACION_MASIVA actualizados correctamente.');
				
		    END IF;	
      END LOOP;
	
	
	-- Verificar si la columna ya existe. Si ya existe la columna, no se hace nada con esta (no tiene en cuenta si al existir los tipos coinciden)
	V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME = ''CHK1_DD_OPM_OPERACION_MASIVA'' and TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		--No existe la CONSTRAINT y la creamos
		DBMS_OUTPUT.PUT_LINE('[INFO] Cambios en ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'] -------------------------------------------');
		V_MSQL := 'ALTER TABLE '||V_TEXT_TABLA||' ' ||
					' ADD CONSTRAINT CHK1_DD_OPM_OPERACION_MASIVA CHECK ' ||
					' (instr(dd_opm_validacion_formato,''*'')>0)' ||
					' ENABLE';

		EXECUTE IMMEDIATE V_MSQL;
		--DBMS_OUTPUT.PUT_LINE('[1] '||V_MSQL);
		DBMS_OUTPUT.PUT_LINE('[INFO] ... CHK1_DD_OPM_OPERACION_MASIVA CONSTRAINT INSERTADA en tabla ');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] ... CHK1_DD_OPM_OPERACION_MASIVA CONSTRAINT YA	EXISTE, no hace nada. ');
	END IF;
	
	
EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT