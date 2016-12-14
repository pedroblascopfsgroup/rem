--/*
--##########################################
--## AUTOR=Fran G
--## FECHA_CREACION=20161115
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=HREOS-1156
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar los campos de auditoria USU_USERNAME, USUARIOCREAR, USUARIOMODIFICAR y USUARIOBORRAR a VARCHAR2(50 CHAR)
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial 
--##        0.2 Cambio en la estructura en la captura de excepciones para que si una tabla falla, continue con la siguiente
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
   	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
   	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_NUM_MOD NUMBER(10) := 0; --Vble. que almacena el numero de campos modificados
    V_NUM_ERR NUMBER(10) := 0; --Vble. que almacena el numero de campos que han dado error

    CURSOR  TABLES_CURSOR IS
        SELECT 'ALTER TABLE '||V_ESQUEMA||'.'||tab.TABLE_NAME||' MODIFY '||tab.COLUMN_NAME|| ' VARCHAR2(50 CHAR)'
        FROM ALL_TAB_COLUMNS tab 
        WHERE tab.COLUMN_NAME IN ('USU_USERNAME', 'USUARIOCREAR', 'USUARIOMODIFICAR', 'USUARIOBORRAR') AND (tab.CHAR_LENGTH <> 50 OR tab.DATA_TYPE <> 'VARCHAR2')
        AND EXISTS (SELECT 1 FROM ALL_OBJECTS a WHERE a.OBJECT_TYPE = 'TABLE' and tab.TABLE_NAME = a.OBJECT_NAME and a.owner = 'REM01')
	AND tab.OWNER = 'REM01'
        ORDER BY tab.TABLE_NAME;
        
BEGIN

    OPEN TABLES_CURSOR;  
    
    DBMS_OUTPUT.PUT_LINE('[INFO] COMENZANDO EL PROCESO...');
    
    LOOP
        FETCH TABLES_CURSOR INTO V_MSQL;
        EXIT WHEN TABLES_CURSOR%NOTFOUND;        
            
            BEGIN
                DBMS_OUTPUT.PUT_LINE('[INFO] SENTENCIA -> ' ||V_MSQL);
                EXECUTE IMMEDIATE V_MSQL;  
                V_NUM_MOD := V_NUM_MOD + 1;
            EXCEPTION
                WHEN OTHERS THEN
                  DBMS_OUTPUT.PUT_LINE('[ERROR] NO SE HA EJECUTAR');
                  DBMS_OUTPUT.PUT_LINE('[ERROR] '||SQLERRM);                  
                  DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');                  
                  V_NUM_ERR := V_NUM_ERR + 1;
            END;
            
    END LOOP;
    CLOSE TABLES_CURSOR;    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] CAMPOS MODIFICADOS -> ('||V_NUM_MOD||')');
    DBMS_OUTPUT.PUT_LINE('[INFO] CAMPOS QUE HAN DADO ERROR -> ('||V_NUM_ERR||')');
    DBMS_OUTPUT.PUT_LINE('[INFO] EL PROCESO HA FINALIZADO CORRECTAMENTE');

    EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(ERR_MSG);
      RAISE;   

END;

/
 
EXIT;
