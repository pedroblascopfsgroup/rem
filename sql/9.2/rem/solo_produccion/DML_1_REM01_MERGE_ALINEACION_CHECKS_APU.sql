--/*
--#########################################
--## AUTOR=Javier Pons
--## FECHA_CREACION=20181211
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

	EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION T1
USING (
WITH AGRUPACIONES_MAL AS (
         SELECT AGR_ID, COUNT(*) FROM (
                 SELECT AGR.AGR_ID,                 
                        EPV.DD_EPV_ID,
                        TCO.DD_TCO_ID,
                        APU.DD_MTO_V_ID,
                        APU.APU_MOT_OCULTACION_MANUAL_V,
                        APU.APU_CHECK_PUBLICAR_V,
                        APU.APU_CHECK_OCULTAR_V,
                        APU.APU_CHECK_OCULTAR_PRECIO_V,
                        APU.APU_CHECK_PUB_SIN_PRECIO_V,
                        APU.APU_MOT_OCULTACION_MANUAL_A,
                        APU.DD_TPU_V_ID,
                        APU.APU_MOTIVO_PUBLICACION, COUNT(*) AS NUM_ACTIVOS
                 FROM '||V_ESQUEMA||'.ACT_AGR_AGRUPACION      AGR
                 JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION      TAG
                 ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                 JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO       AGA
                 ON AGR.AGR_ID = AGA.AGR_ID
                 JOIN '||V_ESQUEMA||'.ACT_ACTIVO                ACT
                 ON ACT.ACT_ID = AGA.ACT_ID
                 JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION      APU
                 ON APU.ACT_ID = ACT.ACT_ID
                 JOIN '||V_ESQUEMA||'.DD_TPU_TIPO_PUBLICACION     TPU
                 ON TPU.DD_TPU_ID = APU.DD_TPU_V_ID
                 JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA     EPV
                 ON EPV.DD_EPV_ID = APU.DD_EPV_ID
                 JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION     TCO
                 ON TCO.DD_TCO_ID = APU.DD_TCO_ID
                 JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION       MTO
                 ON MTO.DD_MTO_ID = APU.DD_MTO_V_ID
                 WHERE TAG.DD_TAG_CODIGO IN (''02'')
                 GROUP BY AGR.AGR_ID,
                        EPV.DD_EPV_ID,
                        TCO.DD_TCO_ID,
                        APU.DD_MTO_V_ID,
                        APU.APU_MOT_OCULTACION_MANUAL_V,
                        APU.APU_CHECK_PUBLICAR_V,
                        APU.APU_CHECK_OCULTAR_V,
                        APU.APU_CHECK_OCULTAR_PRECIO_V,
                        APU.APU_CHECK_PUB_SIN_PRECIO_V,
                        APU.APU_MOT_OCULTACION_MANUAL_A,
                        APU.DD_TPU_V_ID,
                        APU.APU_MOTIVO_PUBLICACION
                 ORDER BY 1
         )
         GROUP BY AGR_ID 
         HAVING COUNT(*) > 1
         ORDER BY 2 DESC
)
SELECT DISTINCT T2.AGR_ID,
                T4.ACT_NUM_ACTIVO, 
                T4.ACT_ID AS ACTIVO_,               
                pp.act_id,
                ppp.DD_EPV_ID,
                ppp.DD_TCO_ID,
                ppp.DD_MTO_V_ID,
                ppp.DD_TPU_V_ID,
                ppp.APU_MOT_OCULTACION_MANUAL_V,
                ppp.APU_CHECK_PUBLICAR_V,
                ppp.APU_CHECK_OCULTAR_V,
                ppp.APU_CHECK_OCULTAR_PRECIO_V,
                ppp.APU_CHECK_PUB_SIN_PRECIO_V,
                ppp.APU_MOT_OCULTACION_MANUAL_A,
                ppp.APU_MOTIVO_PUBLICACION
                    FROM AGRUPACIONES_MAL                   T1
                    JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION           T2
                    ON T1.AGR_ID = T2.AGR_ID
                    JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO    T3
                    ON T3.AGR_ID = T2.AGR_ID
                    JOIN '||V_ESQUEMA||'.ACT_ACTIVO                   T4
                    ON T4.ACT_ID =  T3.ACT_ID
                    JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION      APU
                    ON APU.ACT_ID = T4.ACT_ID
                    JOIN '||V_ESQUEMA||'.DD_TPU_TIPO_PUBLICACION     TPU
                    ON TPU.DD_TPU_ID = APU.DD_TPU_V_ID
                    JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA     EPV
                    ON EPV.DD_EPV_ID = APU.DD_EPV_ID
                    JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION     TCO
                    ON TCO.DD_TCO_ID = APU.DD_TCO_ID
                    JOIN '||V_ESQUEMA||'.DD_MTO_MOTIVOS_OCULTACION       MTO
                    ON MTO.DD_MTO_ID = APU.DD_MTO_V_ID
                    left join '||V_ESQUEMA||'.ACT_ACTIVO pp
                    on pp.act_id = t2.AGR_ACT_PRINCIPAL
                    left join '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION      ppp
                    on ppp.act_id = pp.act_id
                    WHERE T2.AGR_ID NOT IN (19836,15796,32490)
                    ) T2
                    ON (T1.ACT_ID = T2.ACTIVO_)
                    WHEN MATCHED THEN UPDATE SET
                        T1.DD_EPV_ID = T2.DD_EPV_ID,
                        T1.DD_TCO_ID = T2.DD_TCO_ID,
                        T1.DD_MTO_V_ID = T2.DD_MTO_V_ID,
                        T1.DD_TPU_V_ID = T2.DD_TPU_V_ID,
                        T1.APU_MOT_OCULTACION_MANUAL_V = T2.APU_MOT_OCULTACION_MANUAL_V,
                        T1.APU_CHECK_PUBLICAR_V = T2.APU_CHECK_PUBLICAR_V,
                        T1.APU_CHECK_OCULTAR_V =  T2.APU_CHECK_OCULTAR_V,
                        T1.APU_CHECK_OCULTAR_PRECIO_V = T2.APU_CHECK_OCULTAR_PRECIO_V,
                        T1.APU_CHECK_PUB_SIN_PRECIO_V = T2.APU_CHECK_PUB_SIN_PRECIO_V,
                        T1.APU_MOT_OCULTACION_MANUAL_A =  T2.APU_MOT_OCULTACION_MANUAL_A,
                        T1.APU_MOTIVO_PUBLICACION = T2.APU_MOTIVO_PUBLICACION,
                        T1.USUARIOMODIFICAR = ''REMVIP-2724'',
                        T1.FECHAMODIFICAR = SYSDATE
                            ';

	COMMIT;

    DBMS_OUTPUT.PUT_LINE('	[INFO] '||SQL%ROWCOUNT||' Activos a los que actualizamos la APU.');  
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
