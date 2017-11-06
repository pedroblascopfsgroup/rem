--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171026
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.7
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Añadir dos índices
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

    V_MSQL VARCHAR2(32000 CHAR); --Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE VARCHAR2(25 CHAR) := '#TABLESPACE_INDEX#';
    V_EXISTS_COLUMN NUMBER(16); -- Vble. para validar la existencia de una columna.
    V_EXISTS_INDEX NUMBER(16); -- Vble. para validar la existencia de un índice.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_COLUMN VARCHAR2(30 CHAR) := 'PRG_NUM_PROVISION';
    V_TABLE VARCHAR2(30 CHAR) := 'PRG_PROVISION_GASTOS';
    V_NOMBRE_IDX VARCHAR2(30 CHAR) := 'IDX_PRG_NUM_PROVISION';--Nombre índice.
    V_COUNT VARCHAR2(1000 CHAR);
    
BEGIN
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] Se añaden índices sobre tabla '||V_TABLE);
    
    --Índice sobre GPV_NUM_GASTO_HAYA de GPV_GASTOS_PROVEEDOR
    V_MSQL := 'SELECT T1.INDEX_NAME
        FROM ALL_IND_COLUMNS T1
        JOIN ALL_INDEXES T2 ON T1.INDEX_NAME = T2.INDEX_NAME
        JOIN ALL_CONS_COLUMNS T3 ON T3.COLUMN_NAME = T1.COLUMN_NAME AND T3.TABLE_NAME = T1.TABLE_NAME AND T3.POSITION IS NULL AND T3.OWNER = '''||V_ESQUEMA||'''
        WHERE T1.COLUMN_NAME = '''||V_COLUMN||''' AND T1.TABLE_NAME = '''||V_TABLE||''' 
            AND T1.INDEX_OWNER = '''||V_ESQUEMA||''' AND T1.COLUMN_POSITION = 1';
    V_COUNT := 'SELECT COUNT(1) FROM ('||V_MSQL||')';
    EXECUTE IMMEDIATE V_COUNT INTO V_EXISTS_INDEX;
    IF V_EXISTS_INDEX = 1 THEN
        EXECUTE IMMEDIATE V_MSQL INTO V_NOMBRE_IDX;
        V_MSQL := 'DROP INDEX '||V_NOMBRE_IDX;
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Índice eliminado');
        V_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||V_NOMBRE_IDX||' ON '||V_ESQUEMA||'.'||V_TABLE||' ('||V_COLUMN||') 
          PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
          STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
          PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
          BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
          TABLESPACE '||V_TABLESPACE;
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Índice '||V_NOMBRE_IDX||' creado');
    ELSE
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_COLUMN||''' AND TABLE_NAME = '''||V_TABLE||''' AND OWNER = '''||V_ESQUEMA||''' ';
        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS_COLUMN;
        IF V_EXISTS_COLUMN = 1 THEN
            DBMS_OUTPUT.PUT_LINE('[INFO] Existe el campo '||V_TABLE||'.'||V_COLUMN);
            V_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||V_NOMBRE_IDX||' ON '||V_ESQUEMA||'.'||V_TABLE||' ('||V_COLUMN||') 
              PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
              STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
              PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
              BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
              TABLESPACE '||V_TABLESPACE;
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Índice '||V_NOMBRE_IDX||' creado');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] No existe '||V_TABLE||'.'||V_COLUMN||' y por lo tanto no se le puede crear un índice');
        END IF;
    END IF;
    
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] Índices añadidos.');

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