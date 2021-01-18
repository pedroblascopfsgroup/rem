--/*
--##########################################
--## AUTOR=Sergio Salt
--## FECHA_CREACION=20201027
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11734
--## PRODUCTO=No
--## Finalidad: Cambiar el tipo del campo de TBJ_ID_TAREA
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

	-- Se van a insertar los roles creados en DML_143_ENTITY01_INSERT_ROLES_VER_TABS.sql
	-- a todos los perfiles existentes. 

    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    DATA_TYPE VARCHAR2(100 CHAR); -- Vble. para consulta que valida el tipo de la columna.
  	AUX_COLUMN VARCHAR2(100 CHAR):= 'AUX_ID_TAREA_COLUMN';
    TYPE COL_ARRAY IS VARRAY(9) OF VARCHAR2(128);
    V_COLUMNA COL_ARRAY := COL_ARRAY(
     	'TBJ_ID_TAREA'
    );
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('******** ACT_TBJ_TRABAJO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_TBJ_TRABAJO... Comprobaciones previas'); 

    FOR I IN V_COLUMNA.FIRST .. V_COLUMNA.LAST
      LOOP
		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''ACT_TBJ_TRABAJO'' and owner = '''||V_ESQUEMA||''' and column_name = '''||TRIM(V_COLUMNA(I))||'''';

	    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	    -- Si existe los valores
	    IF V_NUM_TABLAS = 0 THEN	  
			DBMS_OUTPUT.PUT_LINE('[INFO] No existe la columna '||TRIM(V_COLUMNA(I))||' en la tabla '||V_ESQUEMA||'.ACT_TBJ_TRABAJO...no se modifica nada.');
		ELSE
            V_MSQL := 'SELECT DATA_TYPE FROM all_tab_columns WHERE TABLE_NAME = ''ACT_TBJ_TRABAJO'' and owner = '''||V_ESQUEMA||''' and column_name = '''||TRIM(V_COLUMNA(I))||'''';
            EXECUTE IMMEDIATE V_SQL INTO DATA_TYPE;
            IF DATA_TYPE = 'VARCHAR2' THEN
                DBMS_OUTPUT.PUT_LINE('[INFO] La columa '||TRIM(V_COLUMNA(I))||' en la tabla '||V_ESQUEMA||'.ACT_TBJ_TRABAJO ya posee el tipo VARCHAR2...no se modifica nada.');
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] Se procede a cambiar el tipo de la columna');

                V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO ADD ' || AUX_COLUMN || ' NUMBER';

                EXECUTE IMMEDIATE V_MSQL;


                DBMS_OUTPUT.PUT_LINE('[INFO] SE HA CREADO TABLA AUX');
                V_MSQL := 'UPDATE (
                            SELECT tbj_1.'||TRIM(V_COLUMNA(I))||' AS ID_TAREA , tbj_2.'||AUX_COLUMN||' AS AUX 
                            FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO tbj_1, '||V_ESQUEMA||'.ACT_TBJ_TRABAJO tbj_2 
                            WHERE tbj_1.TBJ_ID =  tbj_2.TBJ_ID
                        ) SET AUX = ID_TAREA';

                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN VOLCADO LOS DATOS EN LA COLUMNA AUX');


                V_MSQL := 'ALTER TABLE ACT_TBJ_TRABAJO DROP COLUMN ' || TRIM(V_COLUMNA(I));
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] SE HA BORRADO LA COLUMNA ' ||  TRIM(V_COLUMNA(I)));


                V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.ACT_TBJ_TRABAJO ADD ' || TRIM(V_COLUMNA(I)) || ' VARCHAR2(50 CHAR)';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] SE HA CREADO LA COLUMNA ' ||  TRIM(V_COLUMNA(I)) || ' CON EL NUEVO TIPO DE DATO');

                V_MSQL := 'UPDATE (
                                SELECT tbj_1.'||TRIM(V_COLUMNA(I))||' AS ID_TAREA , tbj_2.'||AUX_COLUMN||' AS AUX 
                                FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO tbj_1, '||V_ESQUEMA||'.ACT_TBJ_TRABAJO tbj_2 
                                WHERE tbj_1.TBJ_ID =  tbj_2.TBJ_ID
                            ) SET ID_TAREA = TO_CHAR(AUX)';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN VOLCADO LOS DATOS EN LA COLUMNA' || TRIM(V_COLUMNA(I)));



                V_MSQL:= 'SELECT COUNT(1) FROM ' ||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE ' ||TRIM(V_COLUMNA(I)) || ' IS NOT NULL' ;
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;



                IF V_NUM_TABLAS > 0 THEN
                    V_MSQL := 'ALTER TABLE ACT_TBJ_TRABAJO DROP COLUMN ' || AUX_COLUMN;
                    EXECUTE IMMEDIATE V_MSQL;
                    DBMS_OUTPUT.PUT_LINE('[INFO] SE HA BORRADO LA COLUMNA  AUXILIAR');
                    DBMS_OUTPUT.PUT_LINE('[INFO] TODO OK');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO] NO SE HA BORRADO LA COLUMNA  AUXILIAR');
                    DBMS_OUTPUT.PUT_LINE('[INFO] ¡¡¡¡¡¡¡¡¡FAIL!!!!!!!!!!');
                END IF;



	    	END IF;
	    END IF;	
     END LOOP;
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