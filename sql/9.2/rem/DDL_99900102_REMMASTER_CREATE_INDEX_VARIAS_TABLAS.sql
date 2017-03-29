--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20170328
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS
--## PRODUCTO=NO
--## Finalidad: Indices necesarios para optimizar las búsquedas
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_INDEX NUMBER(3); -- Vble. auxiliar para la numeración de índices
    V_TABLA VARCHAR2(50 CHAR); -- Vble. auxiliar para almacenar el nombres de tablas
    V_INDICE VARCHAR2(50 CHAR); -- Vble. auxiliar para almacenar el nombre del índice
    V_NUM_COLS_INDEX NUMBER(2);--  Vble. auxiliar que indica el numero de columnas a los que apunta el ínidce

 
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(256);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- EN la columna 2 (COLUMNAS) no se ponen espacios.
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	-- 			TABLA							COLUMNAS																NOMBRE_INDICE
		T_TIPO_DATA('DD_TVI_TIPO_VIA' 				,'DD_TVI_ID,DD_TVI_CODIGO'												,'DD_TVI_IDX'	),
		T_TIPO_DATA('DD_UPO_UNID_POBLACIONAL' 		,'DD_UPO_ID,DD_UPO_CODIGO'												,'DD_UPO_IDX'   ),
		T_TIPO_DATA('DD_PRV_PROVINCIA' 				,'DD_PRV_ID,DD_PRV_CODIGO'												,'DD_PRV_IDX'   ),
		T_TIPO_DATA('USU_USUARIOS' 					,'USU_ID,USU_NOMBRE,USU_APELLIDO1,USU_APELLIDO2,USU_TELEFONO,USU_MAIL'	,'USU_USUARIOS_IDX'   )
		
	);
    V_TMP_TIPO_DATA T_TIPO_DATA;
	
BEGIN
	
	 -- LOOP para AÑADIR LAS COLUMNAS DE V_TIPO_DATA-----------------------------------------------------------------
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
			-- Creamos indice V_TMP_TIPO_DATA(2) para las columnas V_TMP_TIPO_DATA(2)
			V_NUM_INDEX := 1;
			WHILE V_NUM_INDEX > 0 
			LOOP
				-- Comprobamos que no haya ningún índice con el mismo nombre
				V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = '''||TRIM(V_TMP_TIPO_DATA(3))||''||TO_CHAR(V_NUM_INDEX)||''' ';
				EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
				IF V_NUM_TABLAS = 0 THEN
					
					--Comprobamos si ya existe un indice para las columnas de la tabla
					V_MSQL := '
						SELECT COUNT(1) 
							FROM( SELECT index_name, listagg(column_name,'','') within group (order by column_position) columnas
							FROM ALL_IND_COLUMNS
							WHERE table_name = '''||TRIM(V_TMP_TIPO_DATA(1))||'''
							AND index_owner='''||V_ESQUEMA_M||'''
							GROUP BY index_name
							) sqli
							WHERE sqli.columnas = UPPER('''||TRIM(V_TMP_TIPO_DATA(2))||''')
					';
					EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
					
					IF V_NUM_TABLAS = 0 THEN
						V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA_M||'.'||TRIM(V_TMP_TIPO_DATA(3))||''||TO_CHAR(V_NUM_INDEX)||' ON '||V_ESQUEMA_M||'.'||TRIM(V_TMP_TIPO_DATA(1))||' ('||UPPER(TRIM(V_TMP_TIPO_DATA(2)))||') TABLESPACE '||V_TABLESPACE_IDX;		
						EXECUTE IMMEDIATE V_MSQL;
						DBMS_OUTPUT.PUT_LINE('[INFO] Indice '||TRIM(V_TMP_TIPO_DATA(3))||''||TO_CHAR(V_NUM_INDEX)||' - ('||TRIM(V_TMP_TIPO_DATA(2))||')  - creado.');
					ELSE
						DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe un indice en '||TRIM(V_TMP_TIPO_DATA(1))||' para las columnas '''||TRIM(V_TMP_TIPO_DATA(2))||'''');
					END IF;
					
					V_NUM_INDEX := 0;
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO] Indice '||TRIM(V_TMP_TIPO_DATA(3))||''||TO_CHAR(V_NUM_INDEX)||' - Ya existe índice con este nombre - probamos con nombre con la numeración siguiente');
					V_NUM_INDEX := V_NUM_INDEX + 1;
				END IF;
			END LOOP;
	  END LOOP;	
	
	COMMIT;



EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
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