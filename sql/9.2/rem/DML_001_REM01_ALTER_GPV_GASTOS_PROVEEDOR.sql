--/*
--#########################################
--## AUTOR=Sergio Gimenez Mota
--## FECHA_CREACION=20190708
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

BEGIN

V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD GPV_FECHA_REC_PROP TIMESTAMP(6)';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' columna añadida');
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.GPV_FECHA_REC_PROP IS ''Fecha recepción del gasto por parte de la propiedad''';

V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD GPV_FECHA_REC_GEST TIMESTAMP(6)';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' columna añadida');
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.GPV_FECHA_REC_GEST IS ''Fecha recepción del gasto por parte de la gestoría/proveedor''';

V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD GPV_FECHA_REC_HAYA TIMESTAMP(6)';
EXECUTE IMMEDIATE V_MSQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' columna añadida');
EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.GPV_FECHA_REC_HAYA IS ''Fecha recepción del gasto por parte de Haya''';

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
