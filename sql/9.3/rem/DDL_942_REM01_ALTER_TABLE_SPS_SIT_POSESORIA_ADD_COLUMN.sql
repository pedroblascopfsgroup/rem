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
    V_TABLE_NAME VARCHAR2(50 CHAR) := 'ACT_SPS_SIT_POSESORIA'; -- Vble. que almacena el nombre de la tabla.
    V_COMMENT_COLUMN VARCHAR2(100 CHAR); --Vble. para almacenar el comentario de la columna.
    V_FLAG NUMBER(1,0); --Vble flag para acceder al comentario relacionado.

    TYPE T_COLUMNS IS TABLE OF VARCHAR2(100 CHAR);
    T_ARRAY_COLUMNS_TO_ADD T_COLUMNS := T_COLUMNS(
        'SPS_USUARIOMODIFICAR_OCUPADO',
        'SPS_FECHAMODIFICAR_OCUPADO',
        'SPS_USUARIOMODIFICAR_CON_TITULO',
        'SPS_FECHAMODIFICAR_CON_TITULO'
    );

    TYPE T_DATATYPES IS TABLE OF VARCHAR2(100 CHAR);
    T_ARRAY_DATATYPES T_DATATYPES := T_DATATYPES(
        'VARCHAR2(50 CHAR)',
        'TIMESTAMP(6)'
    );

    TYPE T_COMMENTS IS TABLE OF VARCHAR2(100 CHAR);
    T_ARRAY_OF_COMMENTS T_COMMENTS := T_COMMENTS(
        'Indica el usuario que modificó el registro.',
        'Indica la fecha en la que se modificó el registro.'
    );
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	FOR I IN T_ARRAY_COLUMNS_TO_ADD.FIRST .. T_ARRAY_COLUMNS_TO_ADD.LAST 
    LOOP

        V_SQL := 'SELECT COUNT(1) 
                  FROM ALL_TAB_COLUMNS  
                  WHERE COLUMN_NAME = '''||T_ARRAY_COLUMNS_TO_ADD(I)||'''
                   AND TABLE_NAME = '''||V_TABLE_NAME||'''
                    AND OWNER = '''||V_ESQUEMA ||'''';
        
        EXECUTE IMMEDIATE V_SQL INTO V_EXIST;

        IF V_EXIST = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA COLUMNA ' || T_ARRAY_COLUMNS_TO_ADD(I) || ' EN LA TABLA ' || V_TABLE_NAME || ' SE PROCEDE A SU CREACION');

            IF MOD(I,2) = 0 THEN V_FLAG := 2;
                            ELSE V_FLAG := 1;
            END IF;

            V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || '
                      ADD ' || T_ARRAY_COLUMNS_TO_ADD(I) || ' ' || T_ARRAY_DATATYPES(V_FLAG);
            EXECUTE IMMEDIATE V_SQL;


            V_SQL := 'COMMENT ON COLUMN ' || V_TABLE_NAME ||'.'||T_ARRAY_COLUMNS_TO_ADD(I)|| ' IS '''|| T_ARRAY_OF_COMMENTS(V_FLAG) || '''';
            EXECUTE IMMEDIATE V_SQL;

        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] LA COLUMNA ' || T_ARRAY_COLUMNS_TO_ADD(I) || ' EN LA TABLA ' || V_TABLE_NAME || ' YA EXISTE ');
        END IF;
		
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] SE HA ALTERADO CORRECTAMENTE LA TABLA ' || V_TABLE_NAME);
	
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
