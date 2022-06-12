--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20220526
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-XXXXX
--## PRODUCTO=NO
--##
--## Finalidad: Crear objetos para SP_REENVIA_GASTOS
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(2400 CHAR) := 'TMP_REENVIO_GASTOS'; 		-- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_ALTER VARCHAR2(2400 CHAR) := 'H_REENVIO_GASTOS';
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('GGE_CLIENTE_PAGADOR','NUMBER (16)'),
		T_TIPO_DATA('GGE_CLIENTE_INFORMADOR','NUMBER (16)'),
		T_TIPO_DATA('GGE_FECHA_EAH','DATE') , 
		T_TIPO_DATA('GGE_FECHA_EAP','DATE') ,
		T_TIPO_DATA('GGE_FECHA_ENVIO_PRPTRIO','DATE') ,
		T_TIPO_DATA('GGE_FECHA_ENVIO_INFORMATIVA','DATE')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 1 THEN
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' PURGE';
		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||'... Dropeada');
	END IF;

	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
			GPV_ID NUMBER(16) NOT NULL
		)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||'... Creada');

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		-- Comprobamos si existe columna    
		V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TMP_TIPO_DATA(1)||''' and TABLE_NAME = '''||V_TABLA_ALTER||''' and OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
			--Si no existe la columna, la creamos y establecemos la FK
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA_ALTER|| ' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||')';		   
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_ESQUEMA||'.'||V_TABLA_ALTER||'.'||V_TMP_TIPO_DATA(1)||'... Creada');
		
		ELSE 
        
            DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA '||V_ESQUEMA||'.'||V_TABLA_ALTER||'.'||V_TMP_TIPO_DATA(1)||' YA EXISTE');

		END IF;
		
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] ALTERADA '||V_TABLA_ALTER||'');
	
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;