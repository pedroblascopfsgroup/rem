--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220514
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11680
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
V_USUARIO VARCHAR2(20 CHAR) := 'REMVIP-11680';
PL_OUTPUT VARCHAR2(32000 CHAR);
V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN 
 

	DBMS_OUTPUT.PUT_LINE('[INICIO]');
 
	V_MSQL := 'MERGE INTO REM01.OFR_OFERTAS T1 USING(
					SELECT DISTINCT OFR.OFR_ID
                        FROM REM01.OFR_OFERTAS OFR
                        JOIN REM01.ACT_OFR AO ON AO.OFR_ID = OFR.OFR_ID
                        JOIN REM01.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID
                        JOIN REM01.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''03''
                        JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID AND EOF.DD_EOF_CODIGO = ''03'') T2 
				ON (T1.OFR_ID = T2.OFR_ID)
				WHEN MATCHED THEN UPDATE SET
				T1.DD_EOF_ID = (SELECT DD_EOF_ID FROM REM01.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''02''),
				T1.FECHAMODIFICAR = SYSDATE,
				T1.USUARIOMODIFICAR = '''||V_USUARIO||'''';
	EXECUTE IMMEDIATE V_MSQL;
  
  	DBMS_OUTPUT.PUT_LINE('[INFO] - INFORMADO ESTADO DE OFERTA MODIFICADO A ANULADA EN '||SQL%ROWCOUNT||' OFERTAS.');
  
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
