--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160419
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0
--## INCIDENCIA_LINK=PRODUCTO-954
--## PRODUCTO=SI
--## Finalidad: DDL para cambiar campo Observaciones a tipo CHAR(2000).
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
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    TABLE_COUNT number(3); -- Vble. para validar la existencia de las Tablas.
    COL_COUNT number(3); -- Vble. para validar la existencia de las Columnas.
    TABLE_NAME VARCHAR2(50 CHAR):= 'CCO_CONTABILIDAD_COBROS'; --Nombre de la tabla a usar.
    COLUMN_NAME VARCHAR2(50 CHAR):= 'CCO_OBSERVACIONES'; --Nombre de la columna a usar.
    
    
BEGIN
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||TABLE_NAME||'... Comprobaciones previas');
	-- Comprobar existencia de la tabla CCO_CONTABILIDAD_COBROS.
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||TABLE_NAME||'''';
	EXECUTE IMMEDIATE V_MSQL INTO TABLE_COUNT;
	
	IF TABLE_COUNT > 0 THEN
		-- Comprobamar existencia de la columna CCO_OBSERVACIONES dentro de la tabla.
		V_MSQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE table_name = '''||TABLE_NAME||''' and column_name = '''||COLUMN_NAME||'''';
		EXECUTE IMMEDIATE V_MSQL INTO COL_COUNT;
		
		IF COL_COUNT > 0 THEN
			V_MSQL :='ALTER TABLE '||TABLE_NAME||' MODIFY ('||COLUMN_NAME||' CHAR(2000))';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] La columna '||COLUMN_NAME||' de la tabla '||TABLE_NAME||' se ha actualizado correctamente.');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[ERROR] La columna '||COLUMN_NAME||' NO existe. No se puede continuar..');
		END IF;
	ELSE
		DBMS_OUTPUT.PUT_LINE('[ERROR] La tabla '||V_ESQUEMA||'.'||TABLE_NAME||' NO existe. No se puede continuar..');
	END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Código de error obtenido:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT