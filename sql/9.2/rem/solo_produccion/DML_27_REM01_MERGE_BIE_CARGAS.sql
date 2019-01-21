--/*
--#########################################
--## AUTOR=Javier Pons
--## FECHA_CREACION=20190121
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-2968
--## PRODUCTO=NO
--## 
--## Finalidad: Merge de cargas
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
V_SQL VARCHAR2(10000 CHAR);
TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
V_TABLA VARCHAR2(40 CHAR) := 'AUX_JPR_CARGAS';

BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
										
	 V_SQL := 'MERGE INTO '||V_ESQUEMA||'.BIE_CAR_CARGAS T1
        USING (
                    SELECT  ACT.BIE_ID,
                            AUX.IMPORTE_REGISTRAL,
                            SIC.DD_SIC_ID,
                            AUX.TITULAR_CARGA
            FROM '||V_ESQUEMA||'.AUX_JPR_CARGAS AUX
            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.NUM_HAYA
            JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA SIC ON SIC.DD_SIC_DESCRIPCION = AUX.ESTADO_REGISTRAL                      
        ) T2 
        ON (T1.BIE_ID = T2.BIE_ID)
        WHEN NOT MATCHED THEN
        INSERT(
            T1.BIE_ID,
            T1.BIE_CAR_ID,
            T1.BIE_CAR_TITULAR,
            T1.BIE_CAR_IMPORTE_REGISTRAL,
            T1.DD_SIC_ID,
            T1.DD_TPC_ID,
            T1.USUARIOCREAR,
            T1.FECHACREAR
        )
        VALUES(
            T2.BIE_ID,
            '||V_ESQUEMA||'.S_BIE_CAR_CARGAS.NEXTVAL,
            T2.TITULAR_CARGA,
            TO_NUMBER(T2.IMPORTE_REGISTRAL),
            T2.DD_SIC_ID,
            03,
            ''REMVIP-2968'',
            SYSDATE
        )
	';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' Activos a los que actualizamos el numero de finca.');  

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
		DBMS_OUTPUT.PUT_LINE(V_SQL);
        ROLLBACK;
        RAISE;
END;

/

EXIT
