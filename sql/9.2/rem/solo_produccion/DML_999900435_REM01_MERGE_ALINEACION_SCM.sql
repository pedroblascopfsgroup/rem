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

	EXECUTE IMMEDIATE 'MERGE INTO REM01.ACT_ACTIVO T1
                            USING (
                            WITH AGRUPACIONES_MAL AS (
                                    SELECT AGR_ID, COUNT(*) FROM (
                                    SELECT AGR.AGR_ID, /*ACT.ACT_ID,*/ ACT.DD_SCM_ID, COUNT(*) AS NUM_ACTIVOS
                                    FROM REM01.ACT_AGR_AGRUPACION        AGR
                                    JOIN REM01.DD_TAG_TIPO_AGRUPACION    TAG
                                    ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                                    JOIN REM01.ACT_AGA_AGRUPACION_ACTIVO AGA
                                    ON AGR.AGR_ID = AGA.AGR_ID
                                    JOIN REM01.ACT_ACTIVO                ACT
                                    ON ACT.ACT_ID = AGA.ACT_ID
                                    WHERE TAG.DD_TAG_CODIGO IN (''02'')
                                    GROUP BY AGR.AGR_ID, /*ACT.ACT_ID,*/ ACT.DD_SCM_ID
                                    ORDER BY 1
                                    )
                                    GROUP BY AGR_ID 
                                    HAVING COUNT(*) > 1
                                    ORDER BY 2 DESC
                            )
                            SELECT DISTINCT T2.AGR_ID, 
                                        (SELECT DD_SCM_ID FROM REM01.ACT_ACTIVO WHERE ACT_ID = T2.AGR_ACT_PRINCIPAL) AS SITUACION_ACTIVO_PPAL, 
                                        T4.ACT_NUM_ACTIVO, 
                                        T4.ACT_ID AS ACTIVO,
                                        T4.DD_SCM_ID AS SITUACION_ACTIVO
                            FROM AGRUPACIONES_MAL                   T1
                            JOIN REM01.ACT_AGR_AGRUPACION           T2
                            ON T1.AGR_ID = T2.AGR_ID
                            JOIN REM01.ACT_AGA_AGRUPACION_ACTIVO    T3
                            ON T3.AGR_ID = T2.AGR_ID
                            JOIN REM01.ACT_ACTIVO                   T4
                            ON T4.ACT_ID =  T3.ACT_ID
                            JOIN REM01.DD_SCM_SITUACION_COMERCIAL   T5
                            ON T5.DD_SCM_ID = T4.DD_SCM_ID
                            WHERE T2.AGR_ID NOT IN (7856)
                            ) T2
                            ON (T1.ACT_ID = T2.ACTIVO)
                            WHEN MATCHED THEN UPDATE SET
                            T1.DD_SCM_ID = T2.SITUACION_ACTIVO_PPAL,
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
