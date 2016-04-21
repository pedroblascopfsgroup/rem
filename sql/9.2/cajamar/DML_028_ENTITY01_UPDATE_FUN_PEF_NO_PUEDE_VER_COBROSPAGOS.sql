--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160421
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=CMREC-3186
--## PRODUCTO=SI
--##
--## Finalidad: DML que actualiza la tabla FUN_PEF el campo borrado a 1 para los permisos de 'ROLE_TAB_COBROS_PAGOS'.
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de registros en una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLE_NAME VARCHAR2(50 CHAR):= 'FUN_PEF';
    
BEGIN
	
    -- ******** Update de la tabla ACU_CAMPOS_TIPO_ACUERDO *******
    DBMS_OUTPUT.PUT_LINE('******** Update de la tabla FUN_PEF *******'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLE_NAME||'... Comprobaciones previas'); 
    
    -- Comprobamos si existen registros en la tabla.   
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLE_NAME||' WHERE FUN_ID IN (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ROLE_TAB_COBROS_PAGOS'') AND BORRADO = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
    -- Si NO existen registros no hacemos nada.
    IF V_NUM_REG = 0 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] La tabla '||V_ESQUEMA||'.'||V_TABLE_NAME||' NO contiene registros con los filtros especificados. Tal vez ya este acutalizada.');    
    ELSE
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLE_NAME||' SET BORRADO = 1 WHERE FUN_ID IN (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ROLE_TAB_COBROS_PAGOS'')';
   		       EXECUTE IMMEDIATE V_MSQL;
            COMMIT;	
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLE_NAME||' Se han actualizado los valores. Se finaliza el script.');
	END IF;	

    
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
