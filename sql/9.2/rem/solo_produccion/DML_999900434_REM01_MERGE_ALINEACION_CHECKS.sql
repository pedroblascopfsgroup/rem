--/*
--#########################################
--## AUTOR=Javier Pons
--## FECHA_CREACION=20181210
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.20
--## INCIDENCIA_LINK=REMVIP-2724
--## PRODUCTO=NO
--## 
--## Finalidad:Alineacion agrupaciones restringidas
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

	EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T1
                                USING (
                                WITH AGRUPACIONES_MAL AS (
                                        SELECT DISTINCT AGR_ID, COUNT(*) FROM (
                                        SELECT AGR.AGR_ID, /*ACT.ACT_ID,*/ PAC.PAC_CHECK_COMERCIALIZAR, PAC.PAC_CHECK_PUBLICAR, PAC.PAC_CHECK_GESTIONAR, PAC.PAC_CHECK_FORMALIZAR, COUNT(*) AS NUM_ACTIVOS
                                        FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION        AGR
                                        JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION    TAG
                                        ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                                        JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA
                                        ON AGR.AGR_ID = AGA.AGR_ID
                                        JOIN '||V_ESQUEMA||'.ACT_ACTIVO                ACT
                                        ON ACT.ACT_ID = AGA.ACT_ID
                                        JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO  PAC
                                        ON PAC.ACT_ID = ACT.ACT_ID
                                        WHERE TAG.DD_TAG_CODIGO IN (''02'')
                                        GROUP BY AGR.AGR_ID, /*ACT.ACT_ID,*/ PAC.PAC_CHECK_COMERCIALIZAR, PAC.PAC_CHECK_PUBLICAR, PAC.PAC_CHECK_GESTIONAR, PAC.PAC_CHECK_FORMALIZAR
                                        ORDER BY 1
                                        )
                                        GROUP BY AGR_ID
                                        HAVING COUNT(*) > 1
                                        ORDER BY 2 DESC
                                )
                                SELECT DISTINCT T2.AGR_ID, T2.AGR_ACT_PRINCIPAL, PAC2.PAC_ID, PAC.PAC_CHECK_COMERCIALIZAR, PAC.PAC_CHECK_PUBLICAR, PAC.PAC_CHECK_GESTIONAR, PAC.PAC_CHECK_FORMALIZAR
                                FROM AGRUPACIONES_MAL                   T1
                                JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION           T2
                                ON T1.AGR_ID = T2.AGR_ID
                                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO    T3
                                ON T3.AGR_ID = T2.AGR_ID
                                JOIN '||V_ESQUEMA||'.ACT_ACTIVO                   T4
                                ON T4.ACT_ID = T3.ACT_ID
                                JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO  PAC
                                ON PAC.ACT_ID = T2.AGR_ACT_PRINCIPAL
                                JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO  PAC2
                                ON T4.ACT_ID = PAC2.ACT_ID
                                WHERE T2.AGR_ID NOT IN (19312)
                                ) T2
                                ON (T1.PAC_ID = T2.PAC_ID)
                                WHEN MATCHED THEN UPDATE SET
                                T1.PAC_CHECK_COMERCIALIZAR = T2.PAC_CHECK_COMERCIALIZAR,
                                T1.PAC_CHECK_PUBLICAR = T2.PAC_CHECK_PUBLICAR,
                                T1.PAC_CHECK_GESTIONAR = T2.PAC_CHECK_GESTIONAR,
                                T1.PAC_CHECK_FORMALIZAR = T2.PAC_CHECK_FORMALIZAR,
                                T1.USUARIOMODIFICAR = ''REMVIP-2724'',
                                T1.FECHAMODIFICAR = SYSDATE
                            ';

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
