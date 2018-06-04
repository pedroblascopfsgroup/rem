--/*
--##########################################
--## AUTOR=Ivan Castelló
--## FECHA_CREACION=20180531
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4109
--## PRODUCTO=NO
--## Finalidad: DDL para crear tabla AUX_AVANZAR_TAREA_AUTO.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 - Ivan Castelló - Versión inicial (20180516)
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA_MR VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- Configuracion Esquema Minirec
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):='#ESQUEMA_MASTER#'; --Configuracion Esquema Master
    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
    V_MSQL_DROP VARCHAR2(4000 CHAR);
    V_TABLA VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;
    EXISTE       NUMBER;

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_TABLA := 'AUX_AVANZAR_TAREA_AUTO';
	DBMS_OUTPUT.PUT_LINE('[INICIO] Inicio del proceso');
	DBMS_OUTPUT.PUT_LINE(' ');
	DBMS_OUTPUT.PUT_LINE('[INFO] crear Tabla: '||V_TABLA);
	--Comprobar si existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
		--DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL);
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

		
	V_MSQL := '
        CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'(
            ACT_ID      NUMBER(16,0), 
            DD_TTR_ID   NUMBER(16,0), 
            TBJ_ID      NUMBER(16,0),
            TRA_ID      NUMBER(16,0),
            TAR_ID      NUMBER(16,0),
            DD_EIN_ID   NUMBER(16,0),
            TEX_ID      NUMBER(16,0),
            TAP_ID      NUMBER(16,0),
            NUEVA_TAR_ID      NUMBER(16,0),
            USU_ID      NUMBER(16,0),
            SUP_ID      NUMBER(16,0)
        )';


	IF V_NUM_TABLAS = 0 THEN
		DBMS_OUTPUT.PUT_LINE('    [INFO] '||V_TABLA||' no existe');
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('    [INFO] TABLA '||V_TABLA||' creada');
	ELSE
		DBMS_OUTPUT.PUT_LINE('    [INFO] La tabla '||V_TABLA||' ya existe');
		V_MSQL_DROP := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA;    
		DBMS_OUTPUT.PUT_LINE('[QUERY] '||V_MSQL_DROP);
		EXECUTE IMMEDIATE V_MSQL_DROP;
		DBMS_OUTPUT.PUT_LINE('    [INFO] Borrada la tabla '||V_TABLA);

		EXECUTE IMMEDIATE V_MSQL;


		DBMS_OUTPUT.PUT_LINE('    [INFO] TABLA '||V_TABLA||' creada');
	END IF;



    V_MSQL := 'SELECT COUNT(1) FROM all_indexes WHERE index_name = ''IDX_'||V_TABLA||'_ACT'' and table_name='''||V_TABLA||''' and table_owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('    [INFO] Creamos index ''IDX_'||V_TABLA||'_ACT''');
        EXECUTE IMMEDIATE 'create index IDX_'||V_TABLA||'_ACT on '||V_TABLA||' (ACT_ID) nologging';
    ELSE
        DBMS_OUTPUT.PUT_LINE('    [INFO] El index ''IDX_'||V_TABLA||'_ACT'' ya existe');
    END IF;


    V_MSQL := 'SELECT COUNT(1) FROM all_indexes WHERE index_name = ''IDX_'||V_TABLA||'_TBJ'' and table_name='''||V_TABLA||''' and table_owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('    [INFO] Creamos index ''IDX_'||V_TABLA||'_TBJ''');
        EXECUTE IMMEDIATE 'create index IDX_'||V_TABLA||'_TBJ on '||V_TABLA||' (TBJ_ID) nologging';
    ELSE
        DBMS_OUTPUT.PUT_LINE('    [INFO] El index ''IDX_'||V_TABLA||'_TBJ'' ya existe');
    END IF;


    V_MSQL := 'SELECT COUNT(1) FROM all_indexes WHERE index_name = ''IDX_'||V_TABLA||'_TRA'' and table_name='''||V_TABLA||''' and table_owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('    [INFO] Creamos index ''IDX_'||V_TABLA||'_TRA''');
        EXECUTE IMMEDIATE 'create index IDX_'||V_TABLA||'_TRA on '||V_TABLA||' (TRA_ID) nologging';
    ELSE
        DBMS_OUTPUT.PUT_LINE('    [INFO] El index ''IDX_'||V_TABLA||'_TRA'' ya existe');
    END IF;


    V_MSQL := 'SELECT COUNT(1) FROM all_indexes WHERE index_name = ''IDX_'||V_TABLA||'_TEX'' and table_name='''||V_TABLA||''' and table_owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('    [INFO] Creamos index ''IDX_'||V_TABLA||'_TEX''');
        EXECUTE IMMEDIATE 'create index IDX_'||V_TABLA||'_TEX on '||V_TABLA||' (TEX_ID) nologging';
    ELSE
        DBMS_OUTPUT.PUT_LINE('    [INFO] El index ''IDX_'||V_TABLA||'_TEX'' ya existe');
    END IF;


    V_MSQL := 'SELECT COUNT(1) FROM all_indexes WHERE index_name = ''IDX_'||V_TABLA||'_TAP'' and table_name='''||V_TABLA||''' and table_owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

    IF V_NUM_TABLAS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('    [INFO] Creamos index ''IDX_'||V_TABLA||'_TAP''');
        EXECUTE IMMEDIATE 'create index IDX_'||V_TABLA||'_TAP on '||V_TABLA||' (TAP_ID) nologging';
    ELSE
        DBMS_OUTPUT.PUT_LINE('    [INFO] El index ''IDX_'||V_TABLA||'_TAP'' ya existe');
    END IF;



	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

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

