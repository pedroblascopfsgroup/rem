--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180913
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=REMVIP-1852
--## PRODUCTO=NO
--## 
--## Finalidad: Truncamos la histórica. Insertamos en la histórica lo que hay en la vista.
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
V_TABLA VARCHAR2(40 CHAR) := 'BIE_LOCALIZACION';
V_SQL VARCHAR2(12000 CHAR);
V_SENTENCIA VARCHAR2(32000 CHAR);
PL_OUTPUT VARCHAR2(32000 CHAR);
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-1852';

BEGIN
	
	PL_OUTPUT := '[INICIO]'||CHR(10);
	
	EXECUTE IMMEDIATE('TRUNCATE TABLE '||V_ESQUEMA||'.SWH_STOCK_ACT_WEBCOM_HIST');
	
	V_SQL := '  INSERT INTO  REM01.SWH_STOCK_ACT_WEBCOM_HIST
				SELECT * FROM REM01.VI_STOCK_ACTIVOS_WEBCOM
	';
	EXECUTE IMMEDIATE V_SQL;		

    COMMIT;

	PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);
	DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

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
