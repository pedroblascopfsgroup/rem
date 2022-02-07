--/*
--#########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20211207
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10812
--## PRODUCTO=NO
--## 
--## Finalidad: 
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

V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_M VARCHAR2(10 CHAR) := '#ESQUEMA_MASTER#';
V_USUARIO VARCHAR2(20 CHAR) := 'REMVIP-10812';
PL_OUTPUT VARCHAR2(32000 CHAR);
V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN 
 

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
 
	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.OFR_OFERTAS T1 USING(
					SELECT OFR.OFR_ID, CAST(OFR.FECHACREAR AS DATE) AS OFR_FECHA_ALTA
						FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
						WHERE OFR.BORRADO = 0 AND OFR.OFR_FECHA_ALTA IS NULL) T2 
				ON (T1.OFR_ID = T2.OFR_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.OFR_FECHA_ALTA = T2.OFR_FECHA_ALTA,
				T1.FECHAMODIFICAR = SYSDATE,
				T1.USUARIOMODIFICAR = '''||V_USUARIO||'''';
	EXECUTE IMMEDIATE V_MSQL;
  
  	DBMS_OUTPUT.PUT_LINE('[INFO] - INFORMADO OFR_FECHA_ALTA = FECHACREAR EN '||SQL%ROWCOUNT||' OFERTAS.');
  
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
