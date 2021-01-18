--/*
--##########################################
--## AUTOR=SERGIO SALT
--## FECHA_CREACION=20210107
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12584
--## PRODUCTO=NO
--##
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_EXIST NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'HREOS-12584'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_TABLE_NAME VARCHAR2(50 CHAR) := 'ACT_BBVA_ACTIVOS'; -- Vble. que almacena el nombre de la tabla.
    V_OLD_DATATYPE VARCHAR(100 CHAR):= 'NUMBER';
    V_NEW_DATATYPE VARCHAR2(100 CHAR) := 'VARCHAR2(255 CHAR)'; --Vble. que alamacena el nuevo tipo de datatype.
    V_TMP_COLUMN_NAME VARCHAR2(100 CHAR); --Vble. para almacenar un nombre de columna temporal.
    V_COMMENT_COLUMN VARCHAR2(100 CHAR); --Vble. para almacenar el comentario de la columna.
    
    TYPE T_COLUMNS IS TABLE OF VARCHAR2(100 CHAR);
    T_ARRAY_NOMBRE_COLUMNAS T_COLUMNS := T_COLUMNS(
        'BBVA_EMPRESA',
        'BBVA_OFICINA',
        'BBVA_CONTRAPARTIDA',
        'BBVA_FOLIO'
    );

    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	FOR I IN T_ARRAY_NOMBRE_COLUMNAS.FIRST .. T_ARRAY_NOMBRE_COLUMNAS.LAST 
    LOOP
        V_TMP_COLUMN_NAME := TRIM(T_ARRAY_NOMBRE_COLUMNAS(I))||'_TMP';
        V_SQL := 'SELECT COUNT(1) 
                  FROM ALL_TAB_COLUMNS 
                  WHERE COLUMN_NAME = '''||T_ARRAY_NOMBRE_COLUMNAS(I)||'''
                  AND TABLE_NAME = '''||V_TABLE_NAME||'''
                  AND OWNER = '''||V_ESQUEMA ||'''
                  AND DATA_TYPE = '''||V_OLD_DATATYPE||'''';
        
        EXECUTE IMMEDIATE V_SQL INTO V_EXIST;
        IF V_EXIST = 1 THEN 

            V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || '
                      ADD ' || V_TMP_COLUMN_NAME || ' ' || V_NEW_DATATYPE;
            EXECUTE IMMEDIATE V_SQL;

            V_SQL := 'SELECT COUNT(1) FROM ALL_COL_COMMENTS WHERE COLUMN_NAME = ''' || T_ARRAY_NOMBRE_COLUMNAS(I) || ''' AND COMMENTS IS NOT NULL';
            EXECUTE IMMEDIATE V_SQL INTO V_EXIST;
            IF V_EXIST = 1 THEN
                V_SQL := 'SELECT COMMENTS FROM ALL_COL_COMMENTS WHERE COLUMN_NAME = ''' || T_ARRAY_NOMBRE_COLUMNAS(I) || '''';
                EXECUTE IMMEDIATE V_SQL INTO V_COMMENT_COLUMN;

                V_SQL := 'COMMENT ON COLUMN ' || V_TABLE_NAME ||'.'||V_TMP_COLUMN_NAME|| ' IS '''|| V_COMMENT_COLUMN || '''';
                EXECUTE IMMEDIATE V_SQL;
            END IF;

            V_SQL := 'UPDATE ' || V_TABLE_NAME || '
                      SET ' || V_TMP_COLUMN_NAME || '=' || T_ARRAY_NOMBRE_COLUMNAS(I);
            EXECUTE IMMEDIATE V_SQL;

            V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || '
                      DROP COLUMN ' || T_ARRAY_NOMBRE_COLUMNAS(I);
            EXECUTE IMMEDIATE V_SQL;


            V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || '
                      RENAME COLUMN ' || V_TMP_COLUMN_NAME || ' TO ' || T_ARRAY_NOMBRE_COLUMNAS(I);
            EXECUTE IMMEDIATE V_SQL;


        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] NO SE HA ENCONTRADO LA COLUMNA ' || T_ARRAY_NOMBRE_COLUMNAS(I) || ' EN LA TABLA ' || V_TABLE_NAME || ' CON EL DATA TYPE ' || V_OLD_DATATYPE);
        END IF;
		
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] SE HA CAMBIADO CORRECTAMENTE EL TIPO DE DATO EN LA TABLA ' || V_TABLE_NAME);
	
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
