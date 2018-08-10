--/*
--##########################################
--## AUTOR=JIN LI, HU
--## FECHA_CREACION=20180801
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4376
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_TABLA VARCHAR2(30 CHAR) := 'GPL_GASTOS_PRINEX_LBK';  -- Tabla a modificar
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_GPL_GASTOS_PRINEX_LBK';  -- Tabla a modificar    
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_USR VARCHAR2(30 CHAR) := 'HREOS-4376'; -- USUARIOCREAR/USUARIOMODIFICAR
       
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('GPL_PROYECTO', 'NUMBER(4, 0)'),
        T_TIPO_DATA('GPL_TIPO_INMUEBLE', 'VARCHAR2(2 CHAR)'),
        T_TIPO_DATA('GPL_CLAVE_1', 'VARCHAR2(3 CHAR)'),
        T_TIPO_DATA('GPL_CLAVE_2', 'VARCHAR2(3 CHAR)'),
        T_TIPO_DATA('GPL_CLAVE_3', 'VARCHAR2(3 CHAR)'),
        T_TIPO_DATA('GPL_CLAVE_4', 'VARCHAR2(3 CHAR)'),
        T_TIPO_DATA('ACT_ID', 'NUMBER(16, 0)'),
        T_TIPO_DATA('GPL_IMPORTE_GASTO', 'NUMBER(13, 2)')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    -- LOOP para insertar las nuevas columnas en GPL_GASTOS_PRINEX_LBK -----------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE('[INFO]: ADICIÓN EN GPL_GASTOS_PRINEX_LBK] ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
    
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

    	-- Comprobamos si ya existe la columna
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= '''||V_TMP_TIPO_DATA(1)||''' and TABLE_NAME= '''||V_TABLA||''' and OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;    
    		
    	IF V_NUM_TABLAS = 0 THEN      
    		--Añadir columnas
    		DBMS_OUTPUT.PUT_LINE('[INFO]: AÑADIENDO LA COLUMNA '''||V_TMP_TIPO_DATA(1)||'''');   			  
            EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD ('||V_TMP_TIPO_DATA(1)||' '||V_TMP_TIPO_DATA(2)||')';
    		DBMS_OUTPUT.PUT_LINE('[INFO]: COLUMNA '||V_TMP_TIPO_DATA(1)||' AÑADIDA CORRECTAMENTE');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO]: LA COLUMNA '||V_TMP_TIPO_DATA(1)||' YA EXISTE...');
    	END IF;

      END LOOP;

    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA GPL_GASTOS_PRINEX_LBK ACTUALIZADA CORRECTAMENTE ');


    ---------------------------
    ---     SECUENCIA       ---
    ---------------------------
     EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME =''S_'||V_TABLA||''' AND SEQUENCE_OWNER='''||V_ESQUEMA||''''
        INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('[CREAMOS S_'||V_TABLA||']');
        V_SQL:= 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[S_'||V_TABLA||' CREADA]');
    END IF;


    -- MODIFICAR LA COLUMNA PK --------------------------------------------------------------------------------------------------

    DBMS_OUTPUT.PUT_LINE('[INFO]: MODIFICACION DE LA COLUMNA CLAVE PRIMARIA');
    -- Comprobamos si ya existe la columna
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''GPL_ID'' and TABLE_NAME= '''||V_TABLA||''' and OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN
        --Renombrar la columna PK 
        DBMS_OUTPUT.PUT_LINE('[INFO]: RENOMBRANDO LA COLUMNA PK');
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' RENAME COLUMN GPV_ID TO GPL_ID';
        DBMS_OUTPUT.PUT_LINE('[INFO]: RENOMBRANDO LA COLUMNA PK CORRECTAMENTE');

        --Quitar el comentario que no corresponde
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.GPL_ID IS ''(null)''';
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO]: LA COLUMNA PK YA SE HABÍA RENOMBRADO');
    END IF;

    -- ADICIÓN DE LA COLUMNA GPV_ID (QUE NO ES LA PK DE LA TABLA) ---------------------------------------------------------------

    -- Comprobamos si ya existe la columna
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''GPV_ID'' and TABLE_NAME= '''||V_TABLA||''' and OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;    
            
    IF V_NUM_TABLAS = 0 THEN      
        --Añadir la nueva columna 
        DBMS_OUTPUT.PUT_LINE('[INFO]: AÑADIENDO LA COLUMNA GPV_ID');               
        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (GPV_ID NUMBER(16,0))';
        DBMS_OUTPUT.PUT_LINE('[INFO]: COLUMNA GPV_ID AÑADIDA CORRECTAMENTE');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO]: LA COLUMNA GPV_ID YA EXISTE...');
    END IF;


EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
