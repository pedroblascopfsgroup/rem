--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=201600510
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2336
--## PRODUCTO=SI
--## 
--## Finalidad: CREA INDICE EN CIR_CIRBE
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla o indice 
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN
    
    ---------------------
    --  CIR_CIRBE   --
    --------------------- 
    
    --** Comprobamos si existe la tabla   
    V_SQL := 'SELECT count(1) FROM (
            SELECT index_name, To_Char(WM_CONCAT(column_name))  columnas
            FROM ALL_IND_COLUMNS 
            WHERE table_name = ''CIR_CIRBE'' and index_owner=''' || V_ESQUEMA || '''
            GROUP BY index_name
        ) sqli
        WHERE sqli.columnas = ''PER_ID,CIR_FECHA_EXTRACCION''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS = 0 THEN 
        --**Guardamos en una tabla temporal los valores del campo ven_id
        V_MSQL := 'CREATE INDEX '||v_esquema||'.INX_CIR_CIRBE_DEL ON
                   CIR_CIRBE (PER_ID,CIR_FECHA_EXTRACCION)';        
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.INX_CIR_CIRBE_DEL INDICE CREADO');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.INX_CIR_CIRBE_DEL (o equivalente) YA EXISTIA....');
	END IF;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.CIR_CIRBE... FIN CREACION INDICE');


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
