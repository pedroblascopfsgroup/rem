--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20181115
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-449
--## PRODUCTO=NO
--##
--## Finalidad: Script de salvación o no.
--## VERSIONES:
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

BEGIN	
	
DBMS_OUTPUT.PUT_LINE('DESTINO COMERCIAL VENTA y ALQUILER Y VENTA');
MERGE INTO #ESQUEMA#.ACT_APU_ACTIVO_PUBLICACION T1
USING (
    WITH HEP AS (
        SELECT HEP_ID, ACT_ID, HEP_FECHA_DESDE, HEP_FECHA_HASTA, DD_POR_ID, DD_TPU_ID
            , DD_EPU_ID, HEP_MOTIVO, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR
            , FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO
        FROM (
            SELECT HEP_ID, ACT_ID, HEP_FECHA_DESDE, HEP_FECHA_HASTA, DD_POR_ID, DD_TPU_ID
                , DD_EPU_ID, HEP_MOTIVO, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR
                , FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO
                , ROW_NUMBER() OVER(PARTITION BY ACT_ID ORDER BY HEP_FECHA_HASTA DESC NULLS FIRST, HEP_ID DESC) RN
            FROM #ESQUEMA#.ACT_HEP_HIST_EST_PUBLICACION
            WHERE BORRADO = 0)
        WHERE RN = 1)
    , COMERCIAL AS (
        SELECT ACT.ACT_ID, TCO.DD_TCO_ID, TCO.DD_TCO_CODIGO, TCO.DD_TCO_DESCRIPCION
            , SCM.DD_SCM_ID, SCM.DD_SCM_CODIGO, SCM.DD_SCM_DESCRIPCION
            , TAL.DD_TAL_ID, TAL.DD_TAL_CODIGO, TAL.DD_TAL_DESCRIPCION
            , TPA.DD_TPA_ID, TPA.DD_TPA_CODIGO, TPA.DD_TPA_DESCRIPCION
            , CRA.DD_CRA_ID, CRA.DD_CRA_CODIGO, CRA.DD_CRA_DESCRIPCION
        FROM #ESQUEMA#.ACT_ACTIVO ACT
        JOIN #ESQUEMA#.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
        LEFT JOIN #ESQUEMA#.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
        LEFT JOIN #ESQUEMA#.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
        LEFT JOIN #ESQUEMA#.DD_TAL_TIPO_ALQUILER TAL ON TAL.DD_TAL_ID = ACT.DD_TAL_ID
        LEFT JOIN #ESQUEMA#.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
        WHERE ACT.BORRADO = 0)
    , RESERVA AS (
        SELECT ACT_ID, DD_EEC_CODIGO
        FROM (
            SELECT ACT.ACT_ID, EEC.DD_EEC_CODIGO, ROW_NUMBER() OVER(PARTITION BY ACT.ACT_ID ORDER BY DECODE(EEC.DD_EEC_CODIGO,'06',0,1)) RN
            FROM #ESQUEMA#.ACT_ACTIVO ACT
            JOIN #ESQUEMA#.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
            JOIN #ESQUEMA#.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = AO.OFR_ID
            JOIN #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID)
        WHERE RN = 1)
    SELECT APU.APU_ID, HEP.ACT_ID
        , CASE
            WHEN EPU.DD_EPU_CODIGO IN ('01','04') THEN (SELECT DD_TPU_ID FROM #ESQUEMA#.DD_TPU_TIPO_PUBLICACION WHERE DD_TPU_CODIGO = '01')
            WHEN EPU.DD_EPU_CODIGO IN ('02','07') THEN (SELECT DD_TPU_ID FROM #ESQUEMA#.DD_TPU_TIPO_PUBLICACION WHERE DD_TPU_CODIGO = '02')
            WHEN EPU.DD_EPU_CODIGO = '06' THEN NULL
            ELSE HEP.DD_TPU_ID
            END DD_TPU_ID
        , CASE 
            WHEN EPU.DD_EPU_CODIGO IN ('01','02','04','07') AND (CO.DD_TAL_CODIGO IS NULL OR CO.DD_TAL_CODIGO = '01') THEN (SELECT DD_EPV_ID FROM #ESQUEMA#.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = '03') 
            WHEN EPU.DD_EPU_CODIGO IN ('01','02','04','07') AND CO.DD_TAL_CODIGO IN ('02','03','04') THEN (SELECT DD_EPV_ID FROM #ESQUEMA#.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = '04')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') THEN (SELECT DD_EPV_ID FROM #ESQUEMA#.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = '04')  
            WHEN EPU.DD_EPU_CODIGO = '06' THEN (SELECT DD_EPV_ID FROM #ESQUEMA#.DD_EPV_ESTADO_PUB_VENTA WHERE DD_EPV_CODIGO = '01')  
            END DD_EPV_ID
        , CASE
            WHEN CO.DD_TCO_CODIGO = '01' THEN EPA.DD_EPA_ID
            WHEN CO.DD_TCO_CODIGO = '02' THEN 1
            END DD_EPA_ID, CO.DD_TCO_ID
        , CASE
            WHEN EPU.DD_EPU_CODIGO IN ('01','02','04','07') AND CO.DD_TAL_CODIGO IN ('02','03','04') THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '03')
            WHEN EPU.DD_EPU_CODIGO = '06' THEN NULL
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') AND CO.DD_SCM_CODIGO = '05' THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '13')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') AND PAC.PAC_INCLUIDO = 0 THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '08')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') AND CO.DD_SCM_CODIGO = '01' THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '02')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') AND NVL(RES.DD_EEC_CODIGO,'00') = '06' THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '07')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') AND CO.DD_TAL_CODIGO IN ('02','03','04') THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '03')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '12')
            END DD_MTO_V_ID
        , CASE
            WHEN EPU.DD_EPU_CODIGO = '06' THEN 0 
            ELSE 1 
            END APU_CHECK_PUBLICAR_V
        , CASE
            WHEN (EPU.DD_EPU_CODIGO IN ('01','02','04','07') AND (CO.DD_TAL_CODIGO IS NULL OR CO.DD_TAL_CODIGO = '01')) OR EPU.DD_EPU_CODIGO = '06' THEN 0
            ELSE 1
            END APU_CHECK_OCULTAR_V
        , CASE
            WHEN EPU.DD_EPU_CODIGO IN ('04','07') THEN 1
            ELSE 0
            END APU_CHECK_OCULTAR_PRECIO_V
        , CASE
            WHEN CO.DD_CRA_CODIGO = '02' AND NVL(CO.DD_TPA_CODIGO,'00') = '01' THEN 1
            ELSE 0
            END APU_CHECK_PUB_SIN_PRECIO_V, 'MIGRACION_PUBLICACIONES' USUARIO, SYSDATE FECHA
    FROM HEP
    JOIN #ESQUEMA#.ACT_ACTIVO ACT ON ACT.ACT_ID = HEP.ACT_ID
    JOIN COMERCIAL CO ON CO.ACT_ID = HEP.ACT_ID
    JOIN #ESQUEMA#.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_CODIGO = '01'
    JOIN #ESQUEMA#.DD_EPU_ESTADO_PUBLICACION EPU ON EPU.DD_EPU_ID = HEP.DD_EPU_ID
    JOIN #ESQUEMA#.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = HEP.ACT_ID
    LEFT JOIN #ESQUEMA#.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = HEP.ACT_ID
    LEFT JOIN RESERVA RES ON RES.ACT_ID = HEP.ACT_ID
    WHERE CO.DD_TCO_CODIGO IN ('01','02')) T2
ON (T1.APU_ID = T2.APU_ID)
WHEN MATCHED THEN UPDATE SET
    T1.DD_TPU_ID = T2.DD_TPU_ID, T1.DD_EPV_ID = T2.DD_EPV_ID, T1.DD_EPA_ID = T2.DD_EPA_ID, T1.DD_TCO_ID = T2.DD_TCO_ID
    , T1.DD_MTO_V_ID = T2.DD_MTO_V_ID, T1.APU_CHECK_PUBLICAR_V = T2.APU_CHECK_PUBLICAR_V, T1.APU_CHECK_OCULTAR_V = T2.APU_CHECK_OCULTAR_V
    , T1.APU_CHECK_OCULTAR_PRECIO_V = T2.APU_CHECK_OCULTAR_PRECIO_V, T1.APU_CHECK_PUB_SIN_PRECIO_V = T2.APU_CHECK_PUB_SIN_PRECIO_V
    , T1.USUARIOMODIFICAR = T2.USUARIO, T1.FECHAMODIFICAR = T2.FECHA;

DBMS_OUTPUT.PUT_LINE('DESTINO COMERCIAL ALQUILER');
MERGE INTO #ESQUEMA#.ACT_APU_ACTIVO_PUBLICACION T1
USING (
    WITH HEP AS (
        SELECT HEP_ID, ACT_ID, HEP_FECHA_DESDE, HEP_FECHA_HASTA, DD_POR_ID, DD_TPU_ID
            , DD_EPU_ID, HEP_MOTIVO, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR
            , FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO
        FROM (
            SELECT HEP_ID, ACT_ID, HEP_FECHA_DESDE, HEP_FECHA_HASTA, DD_POR_ID, DD_TPU_ID
                , DD_EPU_ID, HEP_MOTIVO, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR
                , FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO
                , ROW_NUMBER() OVER(PARTITION BY ACT_ID ORDER BY HEP_FECHA_HASTA DESC NULLS FIRST, HEP_ID DESC) RN
            FROM #ESQUEMA#.ACT_HEP_HIST_EST_PUBLICACION
            WHERE BORRADO = 0)
        WHERE RN = 1)
    , COMERCIAL AS (
        SELECT ACT.ACT_ID, TCO.DD_TCO_ID, TCO.DD_TCO_CODIGO, TCO.DD_TCO_DESCRIPCION
            , SCM.DD_SCM_ID, SCM.DD_SCM_CODIGO, SCM.DD_SCM_DESCRIPCION
            , TAL.DD_TAL_ID, TAL.DD_TAL_CODIGO, TAL.DD_TAL_DESCRIPCION
            , TPA.DD_TPA_ID, TPA.DD_TPA_CODIGO, TPA.DD_TPA_DESCRIPCION
            , CRA.DD_CRA_ID, CRA.DD_CRA_CODIGO, CRA.DD_CRA_DESCRIPCION
        FROM #ESQUEMA#.ACT_ACTIVO ACT
        JOIN #ESQUEMA#.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
        LEFT JOIN #ESQUEMA#.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
        LEFT JOIN #ESQUEMA#.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
        LEFT JOIN #ESQUEMA#.DD_TAL_TIPO_ALQUILER TAL ON TAL.DD_TAL_ID = ACT.DD_TAL_ID
        LEFT JOIN #ESQUEMA#.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID
        WHERE ACT.BORRADO = 0)
    , RESERVA AS (
        SELECT ACT_ID, DD_EEC_CODIGO
        FROM (
            SELECT ACT.ACT_ID, EEC.DD_EEC_CODIGO, ROW_NUMBER() OVER(PARTITION BY ACT.ACT_ID ORDER BY DECODE(EEC.DD_EEC_CODIGO,'06',0,1)) RN
            FROM #ESQUEMA#.ACT_ACTIVO ACT
            JOIN #ESQUEMA#.ACT_OFR AO ON AO.ACT_ID = ACT.ACT_ID
            JOIN #ESQUEMA#.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = AO.OFR_ID
            JOIN #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID)
        WHERE RN = 1)
    SELECT APU.APU_ID, HEP.ACT_ID
        , CASE
            WHEN EPU.DD_EPU_CODIGO IN ('01','04') THEN (SELECT DD_TPU_ID FROM #ESQUEMA#.DD_TPU_TIPO_PUBLICACION WHERE DD_TPU_CODIGO = '01')
            WHEN EPU.DD_EPU_CODIGO IN ('02','07') THEN (SELECT DD_TPU_ID FROM #ESQUEMA#.DD_TPU_TIPO_PUBLICACION WHERE DD_TPU_CODIGO = '02')
            WHEN EPU.DD_EPU_CODIGO = '06' THEN NULL
            ELSE HEP.DD_TPU_ID
            END DD_TPU_ID
        , CASE
            WHEN CO.DD_TCO_CODIGO = '02' THEN APU.DD_EPV_ID
            ELSE EPV.DD_EPV_ID
            END DD_EPV_ID
        , CASE
            WHEN EPU.DD_EPU_CODIGO IN ('01','02','04','07') AND CO.DD_TAL_CODIGO IS NULL THEN (SELECT DD_EPA_ID FROM #ESQUEMA#.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = '03') 
            WHEN EPU.DD_EPU_CODIGO IN ('01','02','04','07') AND CO.DD_TAL_CODIGO IS NOT NULL THEN (SELECT DD_EPA_ID FROM #ESQUEMA#.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = '04')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') THEN (SELECT DD_EPA_ID FROM #ESQUEMA#.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = '04')  
            WHEN EPU.DD_EPU_CODIGO = '06' THEN (SELECT DD_EPA_ID FROM #ESQUEMA#.DD_EPA_ESTADO_PUB_ALQUILER WHERE DD_EPA_CODIGO = '01')  
            END DD_EPA_ID
        , CO.DD_TCO_ID
        , CASE
            WHEN EPU.DD_EPU_CODIGO IN ('01','02','04','07') AND CO.DD_TAL_CODIGO IN ('01','02','03','04') THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '03')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') AND CO.DD_SCM_CODIGO = '05' THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '13')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') AND PAC.PAC_INCLUIDO = 0 THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '08')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') AND CO.DD_SCM_CODIGO = '01' THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '02')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') AND NVL(RES.DD_EEC_CODIGO,'00') = '06' THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '07')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') AND CO.DD_TAL_CODIGO IN ('02','03','04') THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '03')
            WHEN EPU.DD_EPU_CODIGO IN ('03','05') THEN (SELECT DD_MTO_ID FROM #ESQUEMA#.DD_MTO_MOTIVOS_OCULTACION WHERE DD_MTO_CODIGO = '12')
            WHEN EPU.DD_EPU_CODIGO = '06' THEN NULL
            END DD_MTO_A_ID
        , CASE
            WHEN EPU.DD_EPU_CODIGO = '06' THEN 0 
            ELSE 1 
            END APU_CHECK_PUBLICAR_A
        , CASE
            WHEN (EPU.DD_EPU_CODIGO IN ('01','02','04','07') AND (CO.DD_TAL_CODIGO IS NOT NULL)) OR EPU.DD_EPU_CODIGO IN ('03','05') THEN 1
            ELSE 0
            END APU_CHECK_OCULTAR_A
        , CASE
            WHEN EPU.DD_EPU_CODIGO IN ('04','07') THEN 1
            ELSE 0
            END APU_CHECK_OCULTAR_PRECIO_A
        , 0 APU_CHECK_PUB_SIN_PRECIO_A, 'MIGRACION_PUBLICACIONES' USUARIO, SYSDATE FECHA
    FROM HEP
    JOIN COMERCIAL CO ON CO.ACT_ID = HEP.ACT_ID
    JOIN #ESQUEMA#.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_CODIGO = '01'
    JOIN #ESQUEMA#.DD_EPU_ESTADO_PUBLICACION EPU ON EPU.DD_EPU_ID = HEP.DD_EPU_ID
    JOIN #ESQUEMA#.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = HEP.ACT_ID
    LEFT JOIN #ESQUEMA#.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = HEP.ACT_ID
    LEFT JOIN RESERVA RES ON RES.ACT_ID = HEP.ACT_ID
    WHERE CO.DD_TCO_CODIGO IN ('02','03','04')) T2
ON (T1.APU_ID = T2.APU_ID)
WHEN MATCHED THEN UPDATE SET
    T1.DD_TPU_ID = T2.DD_TPU_ID, T1.DD_EPV_ID = T2.DD_EPV_ID, T1.DD_EPA_ID = T2.DD_EPA_ID, T1.DD_TCO_ID = T2.DD_TCO_ID
    , T1.DD_MTO_A_ID = T2.DD_MTO_A_ID, T1.APU_CHECK_PUBLICAR_A = T2.APU_CHECK_PUBLICAR_A, T1.APU_CHECK_OCULTAR_A = T2.APU_CHECK_OCULTAR_A
    , T1.APU_CHECK_OCULTAR_PRECIO_A = T2.APU_CHECK_OCULTAR_PRECIO_A, T1.APU_CHECK_PUB_SIN_PRECIO_A = T2.APU_CHECK_PUB_SIN_PRECIO_A
    , T1.USUARIOMODIFICAR = T2.USUARIO, T1.FECHAMODIFICAR = T2.FECHA;

DBMS_OUTPUT.PUT_LINE('[FIN]');
	   	
COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(SQLERRM);
    ROLLBACK;
    RAISE;          
END;
/
EXIT
