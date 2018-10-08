--/*
--##########################################
--## AUTOR=Marco Muñoz
--## FECHA_CREACION=20181005
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1956
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
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_TABLA VARCHAR2(50 CHAR) := '';
    V_USUARIO VARCHAR2(30 CHAR) := 'REMVIP-1956';
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error	


BEGIN	
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
----------------------------------------------------------------------------------------------------------------------------------
--MERGES--------------------------------------------------------------------------------------------------------------------------
--3 MERGES PARA CADA CARTERA (PATRIMONIO, ACTIVO, SITUACION_POSESORIA)
----------------------------------------------------------------------------------------------------------------------------------
--MERGES CAJAMAR
MERGE INTO REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA
USING 
(
    SELECT ACT.ACT_ID, 
           PTA2.ACT_PTA_ID,
           CASE WHEN AUX.ALQUILADO = 'S' THEN 1 ELSE 0 END AS CHECK_PERIMETRO,
           CASE WHEN AUX.ESTADO_ADECUACION IN ('S','SI') THEN '01'
                WHEN AUX.ESTADO_ADECUACION IN ('N','NO') THEN '02'
                WHEN AUX.ESTADO_ADECUACION IN ('NO APLICA') THEN '03'
                ELSE '04' END AS ADECUACION_ALQUILER
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO_PRINEX||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID 
    LEFT JOIN REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA2
      ON PTA2.ACT_ID = ACT.ACT_ID
    WHERE CARTERA = 'CAJAMAR'
      AND CRA.DD_CRA_CODIGO = '01' 
      AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (PTA.ACT_PTA_ID = T2.ACT_PTA_ID)
WHEN MATCHED THEN
UPDATE SET
        PTA.CHECK_HPM = T2.CHECK_PERIMETRO,
        PTA.DD_ADA_ID = (SELECT DD_ADA_ID FROM REM01.DD_ADA_ADECUACION_ALQUILER WHERE DD_ADA_CODIGO = T2.ADECUACION_ALQUILER),
        PTA.USUARIOMODIFICAR = 'REMVIP-1956',
        PTA.FECHAMODIFICAR = SYSDATE,
        PTA.BORRADO = 0
WHEN NOT MATCHED THEN
INSERT (ACT_PTA_ID, ACT_ID, CHECK_HPM, DD_ADA_ID, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (REM01.S_ACT_PTA_PATRIMONIO_ACTIVO.NEXTVAL, 
        T2.ACT_ID,
        T2.CHECK_PERIMETRO,
        (SELECT DD_ADA_ID FROM REM01.DD_ADA_ADECUACION_ALQUILER WHERE DD_ADA_CODIGO = T2.ADECUACION_ALQUILER),
       'REMVIP-1956',
        SYSDATE,
        0
);	
MERGE INTO REM01.ACT_ACTIVO ACT
USING 
(
    SELECT ACT.ACT_ID,
           CASE WHEN AUX.TIPO_CONTRATO_ALQUILER = 'Ordinario' THEN '01'
                WHEN AUX.TIPO_CONTRATO_ALQUILER LIKE '%a compra%' THEN '02'
                WHEN AUX.TIPO_CONTRATO_ALQUILER = 'FSV' THEN '03'
                WHEN AUX.TIPO_CONTRATO_ALQUILER = 'Especial' THEN '04'
           END AS TIPO_ALQUILER,
           CASE WHEN AUX.DESTINO_COMERCIAL = 'Alquiler' THEN '03'
                WHEN AUX.DESTINO_COMERCIAL = 'Alquiler y venta' THEN '02'
           END AS DESTINO_COMERCIAL
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO_PRINEX||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    WHERE CARTERA = 'CAJAMAR'
    AND CRA.DD_CRA_CODIGO = '01'  
    AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (ACT.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN
UPDATE SET
        ACT.DD_TAL_ID = (SELECT DD_TAL_ID FROM REM01.DD_TAL_TIPO_ALQUILER WHERE DD_TAL_CODIGO = T2.TIPO_ALQUILER),
        ACT.DD_TCO_ID =  CASE WHEN T2.ACT_ID IN (
                                                    SELECT DISTINCT act.ACT_ID
                                                    FROM REM01.ACT_ACTIVO  ACT
                                                    JOIN REM01.DD_CRA_CARTERA CRA
                                                      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                                                    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL    SCM 
                                                      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID 
                                                    JOIN REM01.ACT_OFR     AOF
                                                      ON ACT.ACT_ID = AOF.ACT_ID
                                                    JOIN REM01.OFR_OFERTAS OFR
                                                      ON OFR.OFR_ID = AOF.OFR_ID
                                                    JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF
                                                      ON EOF.DD_EOF_ID = OFR.DD_EOF_ID 
                                                    JOIN REM01.Dd_Tof_Tipos_Oferta TOF
                                                      ON TOF.DD_TOF_ID = OFR.DD_TOF_ID
                                                    LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                    ON ECO.OFR_ID = OFR.OFR_ID 
                                                    LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC
                                                    ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                    WHERE EOF.DD_EOF_CODIGO IN ('01','04')
                                                      AND ACT.BORRADO = 0
                                                      AND OFR.BORRADO = 0 
                                                      AND SCM.DD_SCM_CODIGO <> '05'
                                                )
                                                AND  T2.DESTINO_COMERCIAL = '03' 
                                                AND  ACT.DD_TCO_ID IN (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO IN ('01','02'))  
                                                THEN ACT.DD_TCO_ID
                                                ELSE (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = T2.DESTINO_COMERCIAL) 
                                                END,
        ACT.USUARIOMODIFICAR = 'REMVIP-1956',
        ACT.FECHAMODIFICAR = SYSDATE;	
MERGE INTO REM01.ACT_SPS_SIT_POSESORIA SPS
USING 
(
    SELECT ACT.ACT_ID,
           SPS.SPS_ID,
           AUX.ALQUILADO,
           SPS.SPS_OCUPADO,
           SPS.SPS_CON_TITULO
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO_PRINEX||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    JOIN REM01.ACT_SPS_SIT_POSESORIA          SPS
      ON SPS.ACT_ID = ACT.ACT_ID
    WHERE CARTERA = 'CAJAMAR'
    AND CRA.DD_CRA_CODIGO = '01'
    AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (SPS.SPS_ID = T2.SPS_ID)
WHEN MATCHED THEN
UPDATE SET
        SPS.SPS_OCUPADO = CASE WHEN T2.ALQUILADO = 'S' THEN 1 WHEN T2.ALQUILADO = 'N' AND T2.SPS_OCUPADO = 1 AND T2.SPS_CON_TITULO = 1 THEN 0 ELSE SPS.SPS_OCUPADO END,
        SPS.SPS_CON_TITULO = CASE WHEN T2.ALQUILADO = 'S' THEN 1 ELSE SPS.SPS_CON_TITULO END,
        SPS.USUARIOMODIFICAR = 'REMVIP-1956',
        SPS.FECHAMODIFICAR = SYSDATE;  	
--MERGES OTRAS CARTERAS        
MERGE INTO REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA
USING 
(
    SELECT ACT.ACT_ID, 
           PTA2.ACT_PTA_ID,
           CASE WHEN AUX.ALQUILADO = 'S' THEN 1 ELSE 0 END AS CHECK_PERIMETRO,
           CASE WHEN AUX.ESTADO_ADECUACION IN ('S','SI') THEN '01'
                WHEN AUX.ESTADO_ADECUACION IN ('N','NO') THEN '02'
                WHEN AUX.ESTADO_ADECUACION IN ('NO APLICA') THEN '03'
                ELSE '04' END AS ADECUACION_ALQUILER
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    LEFT JOIN REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA2
      ON PTA2.ACT_ID = ACT.ACT_ID
    WHERE CARTERA = 'OTRAS' 
      AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (PTA.ACT_PTA_ID = T2.ACT_PTA_ID)
WHEN MATCHED THEN
UPDATE SET
        PTA.CHECK_HPM = T2.CHECK_PERIMETRO,
        PTA.DD_ADA_ID = (SELECT DD_ADA_ID FROM REM01.DD_ADA_ADECUACION_ALQUILER WHERE DD_ADA_CODIGO = T2.ADECUACION_ALQUILER),
        PTA.USUARIOMODIFICAR = 'REMVIP-1956',
        PTA.FECHAMODIFICAR = SYSDATE,
        PTA.BORRADO = 0
WHEN NOT MATCHED THEN
INSERT (ACT_PTA_ID, ACT_ID, CHECK_HPM, DD_ADA_ID, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (REM01.S_ACT_PTA_PATRIMONIO_ACTIVO.NEXTVAL, 
        T2.ACT_ID,
        T2.CHECK_PERIMETRO,
        (SELECT DD_ADA_ID FROM REM01.DD_ADA_ADECUACION_ALQUILER WHERE DD_ADA_CODIGO = T2.ADECUACION_ALQUILER),
       'REMVIP-1956',
        SYSDATE,
        0
);  

MERGE INTO REM01.ACT_ACTIVO ACT
USING 
(
    SELECT ACT.ACT_ID,
           CASE WHEN AUX.TIPO_CONTRATO_ALQUILER = 'Ordinario' THEN '01'
                WHEN AUX.TIPO_CONTRATO_ALQUILER LIKE '%a compra%' THEN '02'
                WHEN AUX.TIPO_CONTRATO_ALQUILER = 'FSV' THEN '03'
                WHEN AUX.TIPO_CONTRATO_ALQUILER = 'Especial' THEN '04'
           END AS TIPO_ALQUILER,
           CASE WHEN AUX.DESTINO_COMERCIAL = 'Alquiler' THEN '03'
                WHEN AUX.DESTINO_COMERCIAL = 'Alquiler y venta' THEN '02'
           END AS DESTINO_COMERCIAL
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    WHERE CARTERA = 'OTRAS'
      AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (ACT.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN
UPDATE SET
        ACT.DD_TAL_ID = (SELECT DD_TAL_ID FROM REM01.DD_TAL_TIPO_ALQUILER WHERE DD_TAL_CODIGO = T2.TIPO_ALQUILER),
        ACT.DD_TCO_ID =  CASE WHEN T2.ACT_ID IN (
                                                    SELECT DISTINCT act.ACT_ID
                                                    FROM REM01.ACT_ACTIVO  ACT
                                                    JOIN REM01.DD_CRA_CARTERA CRA
                                                      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                                                    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL    SCM 
                                                      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID 
                                                    JOIN REM01.ACT_OFR     AOF
                                                      ON ACT.ACT_ID = AOF.ACT_ID
                                                    JOIN REM01.OFR_OFERTAS OFR
                                                      ON OFR.OFR_ID = AOF.OFR_ID
                                                    JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF
                                                      ON EOF.DD_EOF_ID = OFR.DD_EOF_ID 
                                                    JOIN REM01.Dd_Tof_Tipos_Oferta TOF
                                                      ON TOF.DD_TOF_ID = OFR.DD_TOF_ID
                                                    LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                    ON ECO.OFR_ID = OFR.OFR_ID 
                                                    LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC
                                                    ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                    WHERE EOF.DD_EOF_CODIGO IN ('01','04')
                                                      AND ACT.BORRADO = 0
                                                      AND OFR.BORRADO = 0 
                                                      AND SCM.DD_SCM_CODIGO <> '05'
                                                )
                                                AND  T2.DESTINO_COMERCIAL = '03' 
                                                AND  ACT.DD_TCO_ID IN (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO IN ('01','02'))  
                                                THEN ACT.DD_TCO_ID
                                                ELSE (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = T2.DESTINO_COMERCIAL) 
                                                END,
        ACT.USUARIOMODIFICAR = 'REMVIP-1956',
        ACT.FECHAMODIFICAR = SYSDATE;
        
MERGE INTO REM01.ACT_SPS_SIT_POSESORIA SPS
USING 
(
      
SELECT ACT.ACT_ID,
           SPS.SPS_ID,
           AUX.ALQUILADO,
           SPS.SPS_OCUPADO,
           SPS.SPS_CON_TITULO
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    JOIN REM01.ACT_SPS_SIT_POSESORIA          SPS
      ON SPS.ACT_ID = ACT.ACT_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    WHERE CARTERA = 'OTRAS'  
      AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (SPS.SPS_ID = T2.SPS_ID)
WHEN MATCHED THEN
UPDATE SET
        SPS.SPS_OCUPADO = CASE WHEN T2.ALQUILADO = 'S' THEN 1 WHEN T2.ALQUILADO = 'N' AND T2.SPS_OCUPADO = 1 AND T2.SPS_CON_TITULO = 1 THEN 0 ELSE SPS.SPS_OCUPADO END,
        SPS.SPS_CON_TITULO = CASE WHEN T2.ALQUILADO = 'S' THEN 1 ELSE SPS.SPS_CON_TITULO END,
        SPS.USUARIOMODIFICAR = 'REMVIP-1956',
        SPS.FECHAMODIFICAR = SYSDATE; 

--MERGES BANKIA --> 6079 (ENCUENTRA 6078 ACTIVOS)  
MERGE INTO REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA
USING 
(
    SELECT ACT.ACT_ID, 
           PTA2.ACT_PTA_ID,
           CASE WHEN AUX.ALQUILADO = 'S' THEN 1 ELSE 0 END AS CHECK_PERIMETRO,
           CASE WHEN AUX.ESTADO_ADECUACION IN ('S','SI') THEN '01'
                WHEN AUX.ESTADO_ADECUACION IN ('N','NO') THEN '02'
                WHEN AUX.ESTADO_ADECUACION IN ('NO APLICA') THEN '03'
                ELSE '04' END AS ADECUACION_ALQUILER
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    LEFT JOIN REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA2
      ON PTA2.ACT_ID = ACT.ACT_ID
    WHERE CARTERA = 'BANKIA'
    AND CRA.DD_CRA_CODIGO = '03'  
    AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (PTA.ACT_PTA_ID = T2.ACT_PTA_ID)
WHEN MATCHED THEN
UPDATE SET
        PTA.CHECK_HPM = T2.CHECK_PERIMETRO,
        PTA.DD_ADA_ID = (SELECT DD_ADA_ID FROM REM01.DD_ADA_ADECUACION_ALQUILER WHERE DD_ADA_CODIGO = T2.ADECUACION_ALQUILER),
        PTA.USUARIOMODIFICAR = 'REMVIP-1956',
        PTA.FECHAMODIFICAR = SYSDATE,
        PTA.BORRADO = 0
WHEN NOT MATCHED THEN
INSERT (ACT_PTA_ID, ACT_ID, CHECK_HPM, DD_ADA_ID, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (REM01.S_ACT_PTA_PATRIMONIO_ACTIVO.NEXTVAL, 
        T2.ACT_ID,
        T2.CHECK_PERIMETRO,
        (SELECT DD_ADA_ID FROM REM01.DD_ADA_ADECUACION_ALQUILER WHERE DD_ADA_CODIGO = T2.ADECUACION_ALQUILER),
       'REMVIP-1956',
        SYSDATE,
        0
);

MERGE INTO REM01.ACT_ACTIVO ACT
USING 
(
    SELECT ACT.ACT_ID,
           CASE WHEN AUX.TIPO_CONTRATO_ALQUILER = 'Ordinario' THEN '01'
                WHEN AUX.TIPO_CONTRATO_ALQUILER LIKE '%a compra%' THEN '02'
                WHEN AUX.TIPO_CONTRATO_ALQUILER = 'FSV' THEN '03'
                WHEN AUX.TIPO_CONTRATO_ALQUILER = 'Especial' THEN '04'
           END AS TIPO_ALQUILER,
           CASE WHEN AUX.DESTINO_COMERCIAL = 'Alquiler' THEN '03'
                WHEN AUX.DESTINO_COMERCIAL = 'Alquiler y venta' THEN '02'
           END AS DESTINO_COMERCIAL
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    WHERE CARTERA = 'BANKIA'
    AND CRA.DD_CRA_CODIGO = '03'  
    AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (ACT.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN
UPDATE SET
        ACT.DD_TAL_ID = (SELECT DD_TAL_ID FROM REM01.DD_TAL_TIPO_ALQUILER WHERE DD_TAL_CODIGO = T2.TIPO_ALQUILER),
        ACT.DD_TCO_ID =  CASE WHEN T2.ACT_ID IN (
                                                    SELECT DISTINCT act.ACT_ID
                                                    FROM REM01.ACT_ACTIVO  ACT
                                                    JOIN REM01.DD_CRA_CARTERA CRA
                                                      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                                                    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL    SCM 
                                                      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID 
                                                    JOIN REM01.ACT_OFR     AOF
                                                      ON ACT.ACT_ID = AOF.ACT_ID
                                                    JOIN REM01.OFR_OFERTAS OFR
                                                      ON OFR.OFR_ID = AOF.OFR_ID
                                                    JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF
                                                      ON EOF.DD_EOF_ID = OFR.DD_EOF_ID 
                                                    JOIN REM01.Dd_Tof_Tipos_Oferta TOF
                                                      ON TOF.DD_TOF_ID = OFR.DD_TOF_ID
                                                    LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                    ON ECO.OFR_ID = OFR.OFR_ID 
                                                    LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC
                                                    ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                    WHERE EOF.DD_EOF_CODIGO IN ('01','04')
                                                      AND ACT.BORRADO = 0
                                                      AND OFR.BORRADO = 0 
                                                      AND SCM.DD_SCM_CODIGO <> '05'
                                                )
                                                AND  T2.DESTINO_COMERCIAL = '03' 
                                                AND  ACT.DD_TCO_ID IN (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO IN ('01','02'))  
                                                THEN ACT.DD_TCO_ID
                                                ELSE (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = T2.DESTINO_COMERCIAL) 
                                                END,
        ACT.USUARIOMODIFICAR = 'REMVIP-1956',
        ACT.FECHAMODIFICAR = SYSDATE;
        
        
MERGE INTO REM01.ACT_SPS_SIT_POSESORIA SPS
USING 
(
    SELECT ACT.ACT_ID,
           SPS.SPS_ID,
           AUX.ALQUILADO,
           SPS.SPS_OCUPADO,
           SPS.SPS_CON_TITULO
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    JOIN REM01.ACT_SPS_SIT_POSESORIA          SPS
      ON SPS.ACT_ID = ACT.ACT_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    WHERE CARTERA = 'BANKIA'
    AND CRA.DD_CRA_CODIGO = '03'  
    AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (SPS.SPS_ID = T2.SPS_ID)
WHEN MATCHED THEN
UPDATE SET
        SPS.SPS_OCUPADO = CASE WHEN T2.ALQUILADO = 'S' THEN 1 WHEN T2.ALQUILADO = 'N' AND T2.SPS_OCUPADO = 1 AND T2.SPS_CON_TITULO = 1 THEN 0 ELSE SPS.SPS_OCUPADO END,
        SPS.SPS_CON_TITULO = CASE WHEN T2.ALQUILADO = 'S' THEN 1 ELSE SPS.SPS_CON_TITULO END,
        SPS.USUARIOMODIFICAR = 'REMVIP-1956',
        SPS.FECHAMODIFICAR = SYSDATE;        

--MERGES SAREB --> 2765 (ENCUENTRA 2764 ACTIVOS)  
MERGE INTO REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA
USING 
(
    SELECT ACT.ACT_ID, 
           PTA2.ACT_PTA_ID,
           CASE WHEN AUX.ALQUILADO = 'S' THEN 1 ELSE 0 END AS CHECK_PERIMETRO,
           CASE WHEN AUX.ESTADO_ADECUACION IN ('S','SI') THEN '01'
                WHEN AUX.ESTADO_ADECUACION IN ('N','NO') THEN '02'
                WHEN AUX.ESTADO_ADECUACION IN ('NO APLICA') THEN '03'
                ELSE '04' END AS ADECUACION_ALQUILER
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    LEFT JOIN REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA2
      ON PTA2.ACT_ID = ACT.ACT_ID
    WHERE CARTERA = 'SAREB'
    AND CRA.DD_CRA_CODIGO = '02' 
    AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (PTA.ACT_PTA_ID = T2.ACT_PTA_ID)
WHEN MATCHED THEN
UPDATE SET
        PTA.CHECK_HPM = T2.CHECK_PERIMETRO,
        PTA.DD_ADA_ID = (SELECT DD_ADA_ID FROM REM01.DD_ADA_ADECUACION_ALQUILER WHERE DD_ADA_CODIGO = T2.ADECUACION_ALQUILER),
        PTA.USUARIOMODIFICAR = 'REMVIP-1956',
        PTA.FECHAMODIFICAR = SYSDATE,
        PTA.BORRADO = 0
WHEN NOT MATCHED THEN
INSERT (ACT_PTA_ID, ACT_ID, CHECK_HPM, DD_ADA_ID, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (REM01.S_ACT_PTA_PATRIMONIO_ACTIVO.NEXTVAL, 
        T2.ACT_ID,
        T2.CHECK_PERIMETRO,
        (SELECT DD_ADA_ID FROM REM01.DD_ADA_ADECUACION_ALQUILER WHERE DD_ADA_CODIGO = T2.ADECUACION_ALQUILER),
       'REMVIP-1956',
        SYSDATE,
        0
);

MERGE INTO REM01.ACT_ACTIVO ACT
USING 
(
    SELECT ACT.ACT_ID,
           CASE WHEN AUX.TIPO_CONTRATO_ALQUILER = 'Ordinario' THEN '01'
                WHEN AUX.TIPO_CONTRATO_ALQUILER LIKE '%a compra%' THEN '02'
                WHEN AUX.TIPO_CONTRATO_ALQUILER = 'FSV' THEN '03'
                WHEN AUX.TIPO_CONTRATO_ALQUILER = 'Especial' THEN '04'
           END AS TIPO_ALQUILER,
           CASE WHEN AUX.DESTINO_COMERCIAL = 'Alquiler' THEN '03'
                WHEN AUX.DESTINO_COMERCIAL = 'Alquiler y venta' THEN '02'
           END AS DESTINO_COMERCIAL
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    WHERE CARTERA = 'SAREB'
    AND CRA.DD_CRA_CODIGO = '02' 
    AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (ACT.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN
UPDATE SET
        ACT.DD_TAL_ID = (SELECT DD_TAL_ID FROM REM01.DD_TAL_TIPO_ALQUILER WHERE DD_TAL_CODIGO = T2.TIPO_ALQUILER),
        ACT.DD_TCO_ID =  CASE WHEN T2.ACT_ID IN (
                                                    SELECT DISTINCT act.ACT_ID
                                                    FROM REM01.ACT_ACTIVO  ACT
                                                    JOIN REM01.DD_CRA_CARTERA CRA
                                                      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                                                    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL    SCM 
                                                      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID 
                                                    JOIN REM01.ACT_OFR     AOF
                                                      ON ACT.ACT_ID = AOF.ACT_ID
                                                    JOIN REM01.OFR_OFERTAS OFR
                                                      ON OFR.OFR_ID = AOF.OFR_ID
                                                    JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF
                                                      ON EOF.DD_EOF_ID = OFR.DD_EOF_ID 
                                                    JOIN REM01.Dd_Tof_Tipos_Oferta TOF
                                                      ON TOF.DD_TOF_ID = OFR.DD_TOF_ID
                                                    LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                    ON ECO.OFR_ID = OFR.OFR_ID 
                                                    LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC
                                                    ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                    WHERE EOF.DD_EOF_CODIGO IN ('01','04')
                                                      AND ACT.BORRADO = 0
                                                      AND OFR.BORRADO = 0 
                                                      AND SCM.DD_SCM_CODIGO <> '05'
                                                )
                                                AND  T2.DESTINO_COMERCIAL = '03' 
                                                AND  ACT.DD_TCO_ID IN (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO IN ('01','02'))  
                                                THEN ACT.DD_TCO_ID
                                                ELSE (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = T2.DESTINO_COMERCIAL) 
                                                END,
        ACT.USUARIOMODIFICAR = 'REMVIP-1956',
        ACT.FECHAMODIFICAR = SYSDATE;
        

MERGE INTO REM01.ACT_SPS_SIT_POSESORIA SPS
USING 
(
    SELECT ACT.ACT_ID,
           SPS.SPS_ID,
           AUX.ALQUILADO,
           SPS.SPS_OCUPADO,
           SPS.SPS_CON_TITULO
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    JOIN REM01.ACT_SPS_SIT_POSESORIA          SPS
      ON SPS.ACT_ID = ACT.ACT_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    WHERE CARTERA = 'SAREB'
    AND CRA.DD_CRA_CODIGO = '02' 
    AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (SPS.SPS_ID = T2.SPS_ID)
WHEN MATCHED THEN
UPDATE SET
        SPS.SPS_OCUPADO = CASE WHEN T2.ALQUILADO = 'S' THEN 1 WHEN T2.ALQUILADO = 'N' AND T2.SPS_OCUPADO = 1 AND T2.SPS_CON_TITULO = 1 THEN 0 ELSE SPS.SPS_OCUPADO END,
        SPS.SPS_CON_TITULO = CASE WHEN T2.ALQUILADO = 'S' THEN 1 ELSE SPS.SPS_CON_TITULO END,
        SPS.USUARIOMODIFICAR = 'REMVIP-1956',
        SPS.FECHAMODIFICAR = SYSDATE;        
 
 
--MERGES LIBERBANK --> 9012 (ENCUENTRA 7403 ACTIVOS)
MERGE INTO REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA
USING 
(
    SELECT ACT.ACT_ID, 
           PTA2.ACT_PTA_ID,
           CASE WHEN AUX.ALQUILADO = 'S' THEN 1 ELSE 0 END AS CHECK_PERIMETRO,
           CASE WHEN AUX.ESTADO_ADECUACION IN ('S','SI') THEN '01'
                WHEN AUX.ESTADO_ADECUACION IN ('N','NO') THEN '02'
                WHEN AUX.ESTADO_ADECUACION IN ('NO APLICA') THEN '03'
                ELSE '04' END AS ADECUACION_ALQUILER
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO_PRINEX||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    LEFT JOIN REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA2
      ON PTA2.ACT_ID = ACT.ACT_ID
    WHERE CARTERA = 'LIBERBANK'
    AND CRA.DD_CRA_CODIGO = '08' 
    AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (PTA.ACT_PTA_ID = T2.ACT_PTA_ID)
WHEN MATCHED THEN
UPDATE SET
        PTA.CHECK_HPM = T2.CHECK_PERIMETRO,
        PTA.DD_ADA_ID = (SELECT DD_ADA_ID FROM REM01.DD_ADA_ADECUACION_ALQUILER WHERE DD_ADA_CODIGO = T2.ADECUACION_ALQUILER),
        PTA.USUARIOMODIFICAR = 'REMVIP-1956',
        PTA.FECHAMODIFICAR = SYSDATE,
        PTA.BORRADO = 0
WHEN NOT MATCHED THEN
INSERT (ACT_PTA_ID, ACT_ID, CHECK_HPM, DD_ADA_ID, USUARIOCREAR, FECHACREAR, BORRADO)
VALUES (REM01.S_ACT_PTA_PATRIMONIO_ACTIVO.NEXTVAL, 
        T2.ACT_ID,
        T2.CHECK_PERIMETRO,
        (SELECT DD_ADA_ID FROM REM01.DD_ADA_ADECUACION_ALQUILER WHERE DD_ADA_CODIGO = T2.ADECUACION_ALQUILER),
       'REMVIP-1956',
        SYSDATE,
        0
);


MERGE INTO REM01.ACT_ACTIVO ACT
USING 
(
    SELECT ACT.ACT_ID,
           CASE WHEN AUX.TIPO_CONTRATO_ALQUILER = 'Ordinario' THEN '01'
                WHEN AUX.TIPO_CONTRATO_ALQUILER LIKE '%a compra%' THEN '02'
                WHEN AUX.TIPO_CONTRATO_ALQUILER = 'FSV' THEN '03'
                WHEN AUX.TIPO_CONTRATO_ALQUILER = 'Especial' THEN '04'
           END AS TIPO_ALQUILER,
           CASE WHEN AUX.DESTINO_COMERCIAL = 'Alquiler' THEN '03'
                WHEN AUX.DESTINO_COMERCIAL = 'Alquiler y venta' THEN '02'
           END AS DESTINO_COMERCIAL
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO_PRINEX||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    WHERE CARTERA = 'LIBERBANK'
    AND CRA.DD_CRA_CODIGO = '08'
    AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (ACT.ACT_ID = T2.ACT_ID)
WHEN MATCHED THEN
UPDATE SET
        ACT.DD_TAL_ID = (SELECT DD_TAL_ID FROM REM01.DD_TAL_TIPO_ALQUILER WHERE DD_TAL_CODIGO = T2.TIPO_ALQUILER),
        ACT.DD_TCO_ID =  CASE WHEN T2.ACT_ID IN (
                                                    SELECT DISTINCT act.ACT_ID
                                                    FROM REM01.ACT_ACTIVO  ACT
                                                    JOIN REM01.DD_CRA_CARTERA CRA
                                                      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                                                    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL    SCM 
                                                      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID 
                                                    JOIN REM01.ACT_OFR     AOF
                                                      ON ACT.ACT_ID = AOF.ACT_ID
                                                    JOIN REM01.OFR_OFERTAS OFR
                                                      ON OFR.OFR_ID = AOF.OFR_ID
                                                    JOIN REM01.DD_EOF_ESTADOS_OFERTA EOF
                                                      ON EOF.DD_EOF_ID = OFR.DD_EOF_ID 
                                                    JOIN REM01.Dd_Tof_Tipos_Oferta TOF
                                                      ON TOF.DD_TOF_ID = OFR.DD_TOF_ID
                                                    LEFT JOIN REM01.ECO_EXPEDIENTE_COMERCIAL ECO
                                                    ON ECO.OFR_ID = OFR.OFR_ID 
                                                    LEFT JOIN REM01.DD_EEC_EST_EXP_COMERCIAL EEC
                                                    ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                                                    WHERE EOF.DD_EOF_CODIGO IN ('01','04')
                                                      AND ACT.BORRADO = 0
                                                      AND OFR.BORRADO = 0 
                                                      AND SCM.DD_SCM_CODIGO <> '05'
                                                )
                                                AND  T2.DESTINO_COMERCIAL = '03' 
                                                AND  ACT.DD_TCO_ID IN (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO IN ('01','02'))  
                                                THEN ACT.DD_TCO_ID
                                                ELSE (SELECT DD_TCO_ID FROM REM01.DD_TCO_TIPO_COMERCIALIZACION WHERE DD_TCO_CODIGO = T2.DESTINO_COMERCIAL) 
                                                END,
        ACT.USUARIOMODIFICAR = 'REMVIP-1956',
        ACT.FECHAMODIFICAR = SYSDATE;
        
        
MERGE INTO REM01.ACT_SPS_SIT_POSESORIA SPS
USING 
(
    SELECT ACT.ACT_ID,
           SPS.SPS_ID,
           AUX.ALQUILADO,
           SPS.SPS_OCUPADO,
           SPS.SPS_CON_TITULO
    FROM REM01.AUX_MMC_PERIMETRO_ALQUILABLE   AUX
    JOIN REM01.ACT_ACTIVO                     ACT
      ON ACT.ACT_NUM_ACTIVO_PRINEX||'' = AUX.ID_HAYA
    JOIN REM01.DD_CRA_CARTERA                 CRA
      ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
    JOIN REM01.ACT_SPS_SIT_POSESORIA          SPS
      ON SPS.ACT_ID = ACT.ACT_ID
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL      SCM 
      ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
    WHERE CARTERA = 'LIBERBANK'
    AND CRA.DD_CRA_CODIGO = '08'  
    AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (SPS.SPS_ID = T2.SPS_ID)
WHEN MATCHED THEN
UPDATE SET
        SPS.SPS_OCUPADO = CASE WHEN T2.ALQUILADO = 'S' THEN 1 WHEN T2.ALQUILADO = 'N' AND T2.SPS_OCUPADO = 1 AND T2.SPS_CON_TITULO = 1 THEN 0 ELSE SPS.SPS_OCUPADO END,
        SPS.SPS_CON_TITULO = CASE WHEN T2.ALQUILADO = 'S' THEN 1 ELSE SPS.SPS_CON_TITULO END,
        SPS.USUARIOMODIFICAR = 'REMVIP-1956',
        SPS.FECHAMODIFICAR = SYSDATE;        
        
--------------------------------------------------------------------------------------------------------------
--UPDATE DEL TIPO DE ALQUILER PRA 211 ACTIVOS A FSV
--------------------------------------------------------------------------------------------------------------
UPDATE REM01.ACT_ACTIVO ACT SET
   ACT.DD_TAL_ID = (SELECT DD_TAL_ID FROM REM01.DD_TAL_TIPO_ALQUILER WHERE DD_TAL_CODIGO = '03'),
   ACT.USUARIOMODIFICAR = 'REMVIP-1956',
   ACT.FECHAMODIFICAR = SYSDATE
WHERE ACT.ACT_NUM_ACTIVO IN (
5935567,
5955409,
5952808,
5963763,
5936634,
5944195,
5933331,
5953874,
5931899,
5930961,
5932465,
5941800,
5943830,
5956073,
5937534,
5927703,
5948750,
5959675,
5927009,
5969922,
5929074,
5960351,
5952167,
5938056,
5936452,
5929021,
5955422,
5966026,
5955556,
5943663,
5964115,
5936320,
5944883,
5934729,
5934361,
5947340,
5949134,
5928892,
5945482,
5959632,
5929134,
5926416,
5934142,
5931984,
5929580,
5953477,
5937225,
5966219,
5946561,
5932900,
5927417,
5949103,
5949856,
5948735,
5966882,
5954078,
5948883,
5941370,
5933061,
5936748,
5933192,
5931408,
5946322,
5926658,
5949339,
5949965,
5944349,
5948021,
5931050,
5970015,
5943634,
5926794,
5951060,
5966173,
5963717,
5938784,
5970091,
5929824,
5948001,
5940411,
5932108,
5926039,
5952658,
5960417,
5951965,
5929981,
5943234,
5957451,
5956564,
5936181,
5950051,
5950672,
5961277,
5942574,
5960066,
5938450,
5944717,
5925177,
5940212,
5952731,
5959449,
5943958,
5924913,
5942171,
5958624,
5938873,
5947437,
5948499,
5938424,
5935689,
5966096,
5934635,
5956527,
5933633,
5952291,
5946156,
5965145,
5940718,
5927057,
5936447,
5933330,
5927956,
5956615,
5963469,
5934632,
5968385,
5968496,
5953197,
5942395,
5941709,
5960509,
5955963,
5929085,
5952337,
5927082,
5956680,
5967703,
5938045,
5964556,
5947756,
5959060,
5966732,
5951061,
5935585,
5968709,
5963818,
5948924,
5970485,
5961042,
5967123,
5935684,
5966337,
5962027,
5961445,
5951992,
5963722,
5938540,
5950990,
5932662,
5961747,
5962486,
5964286,
5966194,
5938533,
5962521,
5927269,
5925253,
5956206,
5965026,
5965754,
5959680,
5940312,
5940586,
5966996,
5944878,
5953152,
6049376,
5938922,
5932131,
5933336,
5966491,
5935308,
5955655,
5953634,
5958309,
5966603,
5955565,
5956638,
5954166,
5944584,
5928575,
5954777,
5962573,
5943217,
5961969,
5967187,
5934961,
5925705,
5934590,
5948960,
5953967,
5924933,
5964909,
5948252,
5928844,
5952087,
5940541,
6064582,
6706117,
5934125,
5953931);



---------------------------------------------------------------------------------------------------------------
 --MERGE FINAL PARA ACTIVOS CON TITULO Y OCUPADOS QUE NO ESTÉN VENDIDOS Y NO ESTÉN EN LA EXCEL
 --HAY QUE PONER QUE NO ESTEN VENDIDOS (SALDRAN 1164 ACTIVOS EN TEORIA)
---------------------------------------------------------------------------------------------------------------
 --MERGE FINAL PARA ACTIVOS CON TITULO Y OCUPADOS QUE NO ESTÉN VENDIDOS Y NO ESTÉN EN LA EXCEL
 --HAY QUE PONER QUE NO ESTEN VENDIDOS (SALDRAN 1164 ACTIVOS EN TEORIA)
MERGE INTO REM01.ACT_SPS_SIT_POSESORIA SPS
USING 
(
    SELECT DISTINCT ACT.ACT_ID, SPS.SPS_ID
    FROM REM01.ACT_ACTIVO                         ACT 
    JOIN REM01.DD_CRA_CARTERA                     CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID 
    JOIN REM01.ACT_SPS_SIT_POSESORIA              SPS ON SPS.ACT_ID = ACT.ACT_ID 
    LEFT JOIN REM01.ACT_PTA_PATRIMONIO_ACTIVO     AUX ON AUX.ACT_ID = ACT.ACT_ID 
    LEFT JOIN REM01.DD_SCM_SITUACION_COMERCIAL    SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID 
    LEFT JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION  TCO ON TCO.DD_TCO_ID = ACT.DD_TCO_ID 
    LEFT JOIN REM01.DD_EAC_ESTADO_ACTIVO          EAC ON EAC.DD_EAC_ID = ACT.DD_EAC_ID     
    WHERE AUX.ACT_PTA_ID IS NULL       
        AND SPS.SPS_CON_TITULO = 1       
        AND SPS.SPS_OCUPADO = 1   
        AND ACT.BORRADO = 0     
        AND SCM.DD_SCM_CODIGO <> '05'
) T2
ON (SPS.SPS_ID = T2.SPS_ID)
WHEN MATCHED THEN
UPDATE SET
        SPS.SPS_OCUPADO = 0,
        SPS.USUARIOMODIFICAR = 'REMVIP-1956',
        SPS.FECHAMODIFICAR = SYSDATE
;

---------------------------------------------------------------------------------------------------------
--MERGE FINAL PARA EL CHECK QUE ESTABA MAL CALCULADO
--AHORA: poner el check Perimetro de alquiler a todos los que tengan en ACT.DD_TCO_ID <> Venta
---------------------------------------------------------------------------------------------------------      
UPDATE REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA
SET PTA.CHECK_HPM = 1,
    PTA.USUARIOMODIFICAR = 'REMVIP-1956',
    PTA.FECHAMODIFICAR = SYSDATE
WHERE PTA.ACT_PTA_ID IN 
(
    SELECT ACT_PTA_ID
    FROM REM01.ACT_ACTIVO ACT
    JOIN REM01.ACT_PTA_PATRIMONIO_ACTIVO PTA
    ON PTA.ACT_ID = ACT.ACT_ID
    LEFT JOIN REM01.DD_TCO_TIPO_COMERCIALIZACION TCO
    ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
    WHERE PTA.USUARIOCREAR = 'REMVIP-1956' AND TCO.DD_TCO_CODIGO <> '01'
);
	

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
         DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
  	
