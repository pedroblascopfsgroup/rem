--/*
--#########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20211115
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.11
--## INCIDENCIA_LINK=REMVIP-10763
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

V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
V_SENTENCIA VARCHAR2(2000 CHAR);
V_NUM_TABLAS NUMBER(16);
V_MSQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN 
 

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZACIÓN NUMERO DE EXPEDIENTES.');
 
         V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.OFR_OFERTAS OFR USING(
			SELECT DISTINCT OFR.OFR_ID 
			FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
			JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
			JOIN '||V_ESQUEMA||'.ACT_OFR ACO ON ACO.OFR_ID = OFR.OFR_ID
			JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = ACO.ACT_ID
			JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
			WHERE CRA.DD_CRA_CODIGO = ''03'' AND EOF.DD_EOF_CODIGO IN (''04'', ''03'') AND OFR.FECHACREAR <= TO_DATE(''15/11/2021'', ''DD/MM/YYYY'')
			) AUX ON (AUX.OFR_ID = OFR.OFR_ID)
			WHEN MATCHED THEN UPDATE SET
			OFR.DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''02''),
			OFR.USUARIOMODIFICAR = ''MIG_CAIXA_ANULA'',
			OFR.FECHAMODIFICAR = SYSDATE';
   	  	EXECUTE IMMEDIATE V_MSQL;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||' Actualizadas '||SQL%ROWCOUNT||' Filas.');
  
  
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
