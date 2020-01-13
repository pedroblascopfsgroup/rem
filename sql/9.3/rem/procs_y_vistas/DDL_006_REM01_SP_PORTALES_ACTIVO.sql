--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9047
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE SP_PORTALES_ACTIVO (
    P_ACT_ID        IN REM01.ACT_ACTIVO.ACT_ID%TYPE,
    P_AGR_ID        IN REM01.ACT_AGR_AGRUPACION.AGR_ID%TYPE,
    V_USUARIO       VARCHAR2,
    PL_OUTPUT       OUT VARCHAR2) AS

    V_ESQUEMA VARCHAR2(15 CHAR) := 'REM01';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
    V_MSQL VARCHAR2(6000 CHAR);
    V_POR_V NUMBER(16);
    V_POR_A NUMBER(16);
-- 0.1
BEGIN
   PL_OUTPUT := PL_OUTPUT || '[INICIO]' || CHR(10);

	IF V_USUARIO IS NULL OR P_ACT_ID IS NOT NULL AND P_AGR_ID IS NOT NULL OR P_ACT_ID IS NULL AND P_AGR_ID IS NULL AND V_USUARIO IS NOT NULL THEN
		PL_OUTPUT := PL_OUTPUT || 'KO. No se ha podido completar la operativa' || CHR(10);
    ELSIF P_ACT_ID IS NOT NULL AND P_AGR_ID IS NULL THEN --ACTIVOS
        EXECUTE IMMEDIATE 'SELECT VPA.DD_POR_ID FROM '||V_ESQUEMA||'.V_PORTALES_ACTIVO VPA WHERE VPA.ACT_ID = '||P_ACT_ID INTO V_POR_V;
        EXECUTE IMMEDIATE 'SELECT APU.DD_POR_ID FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU WHERE APU.BORRADO = 0 AND APU.ACT_ID = '||P_ACT_ID INTO V_POR_A;
        IF V_POR_V IS NULL OR V_POR_V = V_POR_A THEN
            PL_OUTPUT := PL_OUTPUT || 'OK. Sin cambios que realizar' || CHR(10);
        ELSE 
             V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
                   USING (
                            SELECT
                                APU.APU_ID
                                , '||V_POR_V||' DD_POR_ID
                            FROM 
                                '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                            WHERE APU.BORRADO = 0 AND APU.ACT_ID = '||P_ACT_ID||
                          ') AUX
                   ON (APU.APU_ID = AUX.APU_ID)
                   WHEN MATCHED THEN
                   UPDATE SET
                    APU.DD_POR_ID = AUX.DD_POR_ID
                    ,APU.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,APU.FECHAMODIFICAR = SYSDATE';
            EXECUTE IMMEDIATE V_MSQL;
            
            PL_OUTPUT := PL_OUTPUT || 'Se ha cambiado el canal de publicación para ' ||SQL%ROWCOUNT|| ' activos' || CHR(10);
            
            PL_OUTPUT := PL_OUTPUT || 'OK. Se han realizado los cambios de portal' || CHR(10);
        END IF;
    ELSIF P_ACT_ID IS NULL AND P_AGR_ID IS NOT NULL THEN-- AGRUPACIONES
        EXECUTE IMMEDIATE 'SELECT VPA.DD_POR_ID FROM '||V_ESQUEMA||'.V_PORTALES_ACTIVO VPA
                           JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON VPA.ACT_ID = AGA.ACT_ID
                           WHERE AGA.BORRADO = 0 AND AGA.AGA_PRINCIPAL = 1 AND VPA.AGR_ID = '||P_AGR_ID INTO V_POR_V;
        EXECUTE IMMEDIATE 'SELECT APU.DD_POR_ID FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                           JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON APU.ACT_ID = AGA.ACT_ID
                           WHERE AGA.BORRADO = 0 AND AGA.AGA_PRINCIPAL = 1 AND AGA.AGR_ID = '||P_AGR_ID INTO V_POR_A;
        IF V_POR_V IS NULL OR V_POR_V = V_POR_A THEN
            PL_OUTPUT := PL_OUTPUT || 'OK. Sin cambios que realizar' || CHR(10);
        ELSE 
             V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
                   USING (
                            SELECT
                                APU.APU_ID
                                , '||V_POR_V||' DD_POR_ID
                            FROM 
                                '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON APU.ACT_ID = AGA.ACT_ID
                                LEFT JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID AND EPV.BORRADO = 0
                            WHERE APU.BORRADO = 0 AND EPV.DD_EPV_CODIGO IN (''03'',''04'') AND AGA.BORRADO = 0 AND AGA.AGR_ID = '||P_AGR_ID||
                          ') AUX
                   ON (APU.APU_ID = AUX.APU_ID)
                   WHEN MATCHED THEN
                   UPDATE SET
                    APU.DD_POR_ID = AUX.DD_POR_ID
                    ,APU.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,APU.FECHAMODIFICAR = SYSDATE';
            EXECUTE IMMEDIATE V_MSQL;
            
            PL_OUTPUT := PL_OUTPUT || 'Se ha cambiado el canal de publicación para ' ||SQL%ROWCOUNT|| ' activos' || CHR(10);
            PL_OUTPUT := PL_OUTPUT || 'OK. Se han realizado los cambios de portal' || CHR(10);
          END IF;  
    ELSIF P_ACT_ID IS NULL AND P_AGR_ID IS NULL AND UPPER(V_USUARIO) = 'PROC_CALCULO_PORTAL' THEN 
            
         V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION AHP
           USING (
                    SELECT
                        AHP.AHP_ID
                    FROM 
                        '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP
                        JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AHP.ACT_ID = AGA.ACT_ID
                        JOIN (SELECT VPA.DD_POR_ID, AGA.AGR_ID 
                            FROM '||V_ESQUEMA||'.V_PORTALES_ACTIVO VPA
                            JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON VPA.AGR_ID = AGA.AGR_ID AND VPA.ACT_ID = AGA.ACT_ID AND AGA.AGA_PRINCIPAL = 1 AND AGA.BORRADO = 0) PRN ON AGA.AGR_ID = PRN.AGR_ID
                        LEFT JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = AHP.DD_EPV_ID AND EPV.BORRADO = 0
                        JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON AHP.ACT_ID = APU.ACT_ID
                    WHERE AHP.BORRADO = 0 AND AGA.BORRADO = 0 AND (APU.DD_POR_ID IS NULL OR APU.DD_POR_ID <> PRN.DD_POR_ID) AND APU.BORRADO = 0 AND AHP.AHP_FECHA_FIN_VENTA IS NULL AND EPV.DD_EPV_CODIGO IN (''03'',''04'')) AUX
           ON (AHP.AHP_ID = AUX.AHP_ID)
           WHEN MATCHED THEN
           UPDATE SET
            AHP.AHP_FECHA_FIN_VENTA = SYSDATE
            ,AHP.USUARIOMODIFICAR = '''||V_USUARIO||'''
            ,AHP.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;
    
    
        V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION (
                                              AHP_ID
                                              , ACT_ID
                                              , DD_TPU_A_ID
                                              , DD_TPU_V_ID
                                              , DD_EPV_ID
                                              , DD_EPA_ID
                                              , DD_TCO_ID
                                              , DD_MTO_V_ID
                                              , AHP_MOT_OCULTACION_MANUAL_V
                                              , AHP_CHECK_PUBLICAR_V
                                              , AHP_CHECK_OCULTAR_V
                                              , AHP_CHECK_OCULTAR_PRECIO_V
                                              , AHP_CHECK_PUB_SIN_PRECIO_V
                                              , DD_MTO_A_ID
                                              , AHP_MOT_OCULTACION_MANUAL_A
                                              , AHP_CHECK_PUBLICAR_A
                                              , AHP_CHECK_OCULTAR_A
                                              , AHP_CHECK_OCULTAR_PRECIO_A
                                              , AHP_CHECK_PUB_SIN_PRECIO_A
                                              , AHP_FECHA_INI_VENTA
                                              , VERSION
                                              , USUARIOCREAR
                                              , FECHACREAR
                                              , BORRADO
                                              , ES_CONDICONADO_ANTERIOR
                                              , DD_POR_ID
                                              )
                SELECT  '|| V_ESQUEMA ||'.S_ACT_AHP_HIST_PUBLICACION.NEXTVAL
                                              , APU.ACT_ID
                                              , APU.DD_TPU_A_ID
                                              , APU.DD_TPU_V_ID
                                              , APU.DD_EPV_ID
                                              , APU.DD_EPA_ID
                                              , APU.DD_TCO_ID
                                              , APU.DD_MTO_V_ID
                                              , APU.APU_MOT_OCULTACION_MANUAL_V
                                              , APU.APU_CHECK_PUBLICAR_V
                                              , APU.APU_CHECK_OCULTAR_V
                                              , APU.APU_CHECK_OCULTAR_PRECIO_V
                                              , APU.APU_CHECK_PUB_SIN_PRECIO_V
                                              , APU.DD_MTO_A_ID
                                              , APU.APU_MOT_OCULTACION_MANUAL_A
                                              , APU.APU_CHECK_PUBLICAR_A
                                              , APU.APU_CHECK_OCULTAR_A
                                              , APU.APU_CHECK_OCULTAR_PRECIO_A
                                              , APU.APU_CHECK_PUB_SIN_PRECIO_A
                                              , SYSDATE
                                              , APU.VERSION
                                              , '''||V_USUARIO||''' USUARIOCREAR
                                              , SYSDATE FECHACREAR
                                              , 0 BORRADO
                                              , APU.ES_CONDICONADO_ANTERIOR
                                              , PRN.DD_POR_ID
                FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
                        JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON APU.ACT_ID = AGA.ACT_ID
                        JOIN (SELECT VPA.DD_POR_ID, AGA.AGR_ID 
                            FROM '||V_ESQUEMA||'.V_PORTALES_ACTIVO VPA
                            JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON VPA.AGR_ID = AGA.AGR_ID AND VPA.ACT_ID = AGA.ACT_ID AND AGA.AGA_PRINCIPAL = 1 AND AGA.BORRADO = 0) PRN ON AGA.AGR_ID = PRN.AGR_ID
                        LEFT JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID AND EPV.BORRADO = 0
                        WHERE APU.BORRADO = 0 AND AGA.BORRADO = 0 AND (APU.DD_POR_ID IS NULL OR APU.DD_POR_ID <> PRN.DD_POR_ID) AND EPV.DD_EPV_CODIGO IN (''03'',''04'')';
        EXECUTE IMMEDIATE V_MSQL;

        PL_OUTPUT := PL_OUTPUT || 'Se inserta un nuevo registro en el histórico de publicaciones para ' ||SQL%ROWCOUNT|| ' activos' || CHR(10);
     
        V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
               USING (
                        SELECT
                            APU.APU_ID
                            , PRN.DD_POR_ID
                        FROM 
                            '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                            JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON APU.ACT_ID = AGA.ACT_ID
                            JOIN (SELECT VPA.DD_POR_ID, AGA.AGR_ID 
                                FROM '||V_ESQUEMA||'.V_PORTALES_ACTIVO VPA
                                JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON VPA.AGR_ID = AGA.AGR_ID AND VPA.ACT_ID = AGA.ACT_ID AND AGA.AGA_PRINCIPAL = 1 AND AGA.BORRADO = 0) PRN ON AGA.AGR_ID = PRN.AGR_ID
                            LEFT JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID AND EPV.BORRADO = 0
                        WHERE APU.BORRADO = 0 AND EPV.DD_EPV_CODIGO IN (''03'',''04'') AND (APU.DD_POR_ID IS NULL OR APU.DD_POR_ID <> PRN.DD_POR_ID) AND AGA.BORRADO = 0) AUX
               ON (APU.APU_ID = AUX.APU_ID)
               WHEN MATCHED THEN
               UPDATE SET
                APU.DD_POR_ID = AUX.DD_POR_ID
                ,APU.USUARIOMODIFICAR = '''||V_USUARIO||'''
                ,APU.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_MSQL;
        
        PL_OUTPUT := PL_OUTPUT || 'Se ha cambiado el canal de publicación para ' ||SQL%ROWCOUNT|| ' activos' || CHR(10);
        
        PL_OUTPUT := PL_OUTPUT || 'OK. Se han realizado los cambios de portal' || CHR(10);    
    ELSE
	PL_OUTPUT := PL_OUTPUT || 'OK. Sin cambios que realizar' || CHR(10); 
    END IF;

    COMMIT;
	PL_OUTPUT := PL_OUTPUT || '[FIN]' || CHR(10);
EXCEPTION
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || 'KO. No se ha podido completar la operativa: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        PL_OUTPUT := PL_OUTPUT || V_MSQL || CHR(10);
        ROLLBACK;
        RAISE;
END SP_PORTALES_ACTIVO;
/
EXIT;
