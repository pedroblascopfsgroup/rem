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
										
	 V_SQL := '    MERGE INTO '||V_ESQUEMA||'.ACT_CRG_CARGAS T1
                        USING (
                        SELECT ACT.BIE_ID,
                                ACT.ACT_ID,
                                BIE.BIE_CAR_ID,
                                AUX.TIPO_CARGA,
                                AUX.SUBTIPO_CARGA,
                                AUX.CARGAS_PROPIAS,
                                BIE.USUARIOCREAR
                            FROM '||V_ESQUEMA||'.BIE_CAR_CARGAS BIE
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT on ACT.bie_id = BIE.bie_id
                            JOIN '||V_ESQUEMA||'.AUX_JPR_CARGAS aux on BIE.BIE_CAR_IMPORTE_REGISTRAL = AUX.IMPORTE_REGISTRAL and AUX.NUM_HAYA = ACT.act_num_activo
                            where BIE.USUARIOCREAR = ''REMVIP-2968''              
                        ) T2 
                        ON (T1.ACT_ID = T2.ACT_ID)
                        WHEN NOT MATCHED THEN
                        INSERT(
                            T1.CRG_ID,
                            T1.ACT_ID,
                            T1.BIE_CAR_ID,
                            T1.DD_TCA_ID,
                            T1.DD_STC_ID,
                            T1.CRG_CARGAS_PROPIAS,
                            T1.USUARIOCREAR,
                            T1.FECHACREAR
                        )
                        VALUES(
                            '||V_ESQUEMA||'.S_ACT_CRG_CARGAS.NEXTVAL,
                            T2.ACT_ID,
                            T2.BIE_CAR_ID,
                            T2.TIPO_CARGA,
                            T2.SUBTIPO_CARGA,
                            TO_NUMBER(T2.CARGAS_PROPIAS),
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
