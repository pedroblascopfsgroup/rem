--/*
--######################################### 
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20200130
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6307
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
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master 
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_COE_SECUENCIA NUMBER (16);
	
BEGIN
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'SELECT REM01.S_COE_CONDICIONANTES_EXP.NEXTVAL FROM DUAL';
    
    EXECUTE IMMEDIATE V_MSQL INTO V_COE_SECUENCIA;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE T1
				USING (
				    SELECT DISTINCT ECO.ECO_ID, COE.COE_SOLICITA_RESERVA, COE.DD_TCC_ID, OFR.OFR_IMPORTE, COE.COE_IMPORTE_RESERVA
				        ,COE.COE_PLAZO_FIRMA_RESERVA, ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY 1) + '||V_COE_SECUENCIA||' AS RN
				        ,OFR.OFR_IMPORTE * (3.00/100) AS IMPORTE_RESERVA
				    FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
				    JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ECO.OFR_ID
				    JOIN '||V_ESQUEMA||'.ACT_OFR AO ON AO.OFR_ID = ECO.OFR_ID
				    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AO.ACT_ID
				    LEFT JOIN '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE COE ON COE.ECO_ID = ECO.ECO_ID
				    WHERE ACT.DD_CRA_ID = 1
				    AND OFR.FECHACREAR > TRUNC(TO_DATE(''23/01/2020'', ''DD/MM/YYYY''))
				    AND COE.COE_ID IS NULL
				) T2
				ON (T1.ECO_ID = T2.ECO_ID)
				WHEN NOT MATCHED THEN INSERT (
				    T1.COE_ID,
				    T1.COE_SOLICITA_RESERVA,
				    T1.DD_TCC_ID,
				    T1.COE_PORCENTAJE_RESERVA,
				    T1.COE_IMPORTE_RESERVA,
				    T1.COE_PLAZO_FIRMA_RESERVA,
				    T1.USUARIOCREAR,
				    T1.FECHACREAR,
				    T1.BORRADO,
				    T1.ECO_ID,
				    T1.VERSION
				)
				VALUES(
				    T2.RN,
				    1,
				    1,
				    3.00,
				    T2.IMPORTE_RESERVA,
				    5,
				    ''REMVIP-6307'',
				    SYSDATE,
				    0,
				    T2.ECO_ID,
				    0
				)';

	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han actualizado '||SQL%ROWCOUNT||' expedientes');

    COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');
  
EXCEPTION
	WHEN OTHERS THEN 
	    DBMS_OUTPUT.PUT_LINE('KO!');
	    ERR_NUM := SQLCODE;
	    ERR_MSG := SQLERRM;
	    
	    DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
	    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
	    DBMS_OUTPUT.PUT_LINE(err_msg);
	    
	    ROLLBACK;
	    RAISE;          

END;
/
EXIT;