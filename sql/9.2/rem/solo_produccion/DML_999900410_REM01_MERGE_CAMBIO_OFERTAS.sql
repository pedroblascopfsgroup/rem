--/*
--#########################################
--## AUTOR=Vicente Martinez Cifre
--## FECHA_CREACION=20181116
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-2497
--## PRODUCTO=NO
--## 
--## Finalidad: Anular ofertas no  tramitadas
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
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]'); 

	EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.OFR_OFERTAS T1
    USING (SELECT OFR.OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
    LEFT JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON OFR.OFR_ID = ECO.OFR_ID
    JOIN '||V_ESQUEMA||'.ACT_OFR AOFR ON OFR.OFR_ID = AOFR.OFR_ID
    JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AOFR.ACT_ID = ACT.ACT_ID AND ACT.ACT_NUM_ACTIVO = ''6876155''
    JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND DD_EOF_CODIGO = ''04'') T2
      ON (T1.OFR_ID = T2.OFR_ID)
    WHEN MATCHED THEN UPDATE SET
      DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''02''),
      USUARIOMODIFICAR = ''REMVIP-2497'',
      FECHAMODIFICAR = SYSDATE
	';

	DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' expedientes anulados.');  

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;

/

EXIT
