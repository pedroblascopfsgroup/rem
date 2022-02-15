--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17168
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: Agregar nueva columna a la tabla ACT_CAT_CATASTRO
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-17168'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLA VARCHAR2(2400 CHAR) := 'ACT_CAT_CATASTRO'; 		-- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('CAT_ORIGEN_DATOS_CATASTRALES', 'VARCHAR2(2 CHAR)','', 'Origen de los datos catastrales'),
        T_TIPO_DATA('CAT_CLASE_USO_CATASTRAL', 'VARCHAR2(2 CHAR)','', 'Clase de uso catastral'),
        T_TIPO_DATA('CAT_VIGENTE','NUMBER(1,0)','DEFAULT 0', 'Idica si el catrasto está vigente'),
        T_TIPO_DATA('CAT_VALOR_CATASTRAL', 'NUMBER(16,2)','', 'Indica el valor catastral'),
        T_TIPO_DATA('CAT_MONEDA', 'VARCHAR2(5 CHAR)','', 'Tipo de moneda')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
		V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TMP_TIPO_DATA(1)||''' 
														 and TABLE_NAME = '''||V_TABLA||''' 
														 and OWNER = '''||V_ESQUEMA||'''';
		
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		
		IF V_NUM_TABLAS = 0 THEN
		
			V_MSQL := 'ALTER TABLE '||V_TABLA|| ' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||' '||V_TMP_TIPO_DATA(3)||')';		   
			EXECUTE IMMEDIATE V_MSQL;

            V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(4)||'''';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] AGREGADA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2));
		
		ELSE 
		
			DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA '||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||' YA EXISTE');
		
		END IF;
		
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZADA ACT_CAT_CATASTRO');
	
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
