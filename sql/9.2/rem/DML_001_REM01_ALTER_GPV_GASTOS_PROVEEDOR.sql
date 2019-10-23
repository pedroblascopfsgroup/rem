--/*
--#########################################
--## AUTOR=Sergio Gimenez Mota
--## FECHA_CREACION=20190713
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.9.0
--## INCIDENCIA_LINK=NO
--## PRODUCTO=NO
--## 
--## Finalidad: Modificación de tabla 'GPV_GASTOS_PROVEEDOR'
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

V_MSQL VARCHAR2(32000 CHAR);
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_ESQUEMA_M VARCHAR2(20 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'GPV_GASTOS_PROVEEDOR';
V_NUM_COLS NUMBER(16);

BEGIN

V_MSQL := 'SELECT COUNT(*)
FROM USER_TAB_COLS
WHERE COLUMN_NAME = ''GPV_FECHA_REC_PROP''
AND TABLE_NAME = ''GPV_GASTOS_PROVEEDOR''
';
EXECUTE IMMEDIATE V_MSQL INTO V_NUM_COLS;

IF V_NUM_COLS > 0 THEN
    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' DROP COLUMN GPV_FECHA_REC_PROP';		
    EXECUTE IMMEDIATE V_MSQL;		
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.GPV_FECHA_REC_PROP YA EXISTE, BORRANDO...');
END IF;

V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD GPV_FECHA_REC_PROP DATE';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' columna añadida');
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.GPV_FECHA_REC_PROP IS ''Fecha recepción del gasto por parte de la propiedad: es la fecha recepción del documento por parte de Haya, rellenable por la gestoría.''';

IF V_NUM_COLS > 0 THEN
    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' DROP COLUMN GPV_FECHA_REC_GEST';		
    EXECUTE IMMEDIATE V_MSQL;		
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.GPV_FECHA_REC_GEST YA EXISTE, BORRANDO...');
END IF;

V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD GPV_FECHA_REC_GEST DATE';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' columna añadida');
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.GPV_FECHA_REC_GEST IS ''Fecha recepción del gasto por parte de la gestoría/proveedor: Fecha recepción del documento por parte de la gestoría, rellenable por la gestoría.''';

IF V_NUM_COLS > 0 THEN
    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' DROP COLUMN GPV_FECHA_REC_HAYA';		
    EXECUTE IMMEDIATE V_MSQL;		
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'.GPV_FECHA_REC_HAYA YA EXISTE, BORRANDO...');
END IF;

V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD GPV_FECHA_REC_HAYA DATE';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' columna añadida');
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.GPV_FECHA_REC_HAYA IS ''Fecha recepción del gasto por parte de Haya: Fecha recepción del documento por parte Haya, rellenable por la gestoría.''';

COMMIT;

EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE;

END;
/

EXIT;
