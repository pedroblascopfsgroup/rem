--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20191114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5765
--## PRODUCTO=NO
--## 
--## Finalidad: CREAR TRAMITE GENCAT
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(50 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_M VARCHAR2(50 CHAR) := '#ESQUEMA_MASTER#';
    V_EXISTS NUMBER(1);
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5765_V1'; -- USUARIOCREAR/USUARIOMODIFICAR
    V_ACTIVO NUMBER(16) := 5961278; 

BEGIN

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''AUX_MIGRA_GENCAT'' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    IF V_EXISTS = 1 THEN
        V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.AUX_MIGRA_GENCAT PURGE';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('Borrada tabla AUX_MIGRA_GENCAT');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe la tabla AUX_MIGRA_GENCAT');
    END IF;

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''AUX_MIGRA_TAR_ADECUA_GENCAT'' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    IF V_EXISTS = 1 THEN 
        V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.AUX_MIGRA_TAR_ADECUA_GENCAT PURGE';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('Borrada tabla AUX_MIGRA_TAR_ADECUA_GENCAT');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe la tabla AUX_MIGRA_TAR_ADECUA_GENCAT');
    END IF;
    
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''AUX_MIGRA_TAR_COM_GENCAT'' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    IF V_EXISTS = 1 THEN
        V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.AUX_MIGRA_TAR_COM_GENCAT PURGE';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('Borrada tabla AUX_MIGRA_TAR_COM_GENCAT');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe la tabla AUX_MIGRA_TAR_COM_GENCAT');
    END IF;
    
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_ADG_ADECUACION_GENCAT ADG 
        WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT CMG WHERE CMG.CMG_ID = ADG.CMG_ID AND CMG.USUARIOCREAR = '''||V_USR||''')';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' registros de adecuación de activos afectos a GENCAT');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT OFG
        WHERE EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT CMG WHERE CMG.CMG_ID = OFG.CMG_ID AND CMG.USUARIOCREAR = '''||V_USR||''')';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' registros de ofertas relacionadas con comunicaciones a GENCAT');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT WHERE USUARIOCREAR = '''||V_USR||'''';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' registros de comunicaciones a GENCAT');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR TEV
        WHERE EXISTS (SELECT 1 
            FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX 
            JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TEX.TAR_ID
            JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TAR_ID = TAR.TAR_ID
            JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID
            WHERE TEX.TEX_ID = TEV.TEX_ID AND TRA.USUARIOCREAR = '''||V_USR||''')';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' registros de datos de tareas de trámites GENCAT');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX  
        WHERE EXISTS (SELECT 1 
            FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
            JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TAR_ID = TAR.TAR_ID
            JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID
            WHERE TAR.TAR_ID = TEX.TAR_ID AND TRA.USUARIOCREAR = '''||V_USR||''')';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' registros de tipos de trámites GENCAT');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
        WHERE EXISTS (SELECT 1 
            FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA
            WHERE TRA.TRA_ID = TAC.TRA_ID AND TRA.USUARIOCREAR = '''||V_USR||''')';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' registros de relación de trámites GENCAT');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES WHERE USUARIOCREAR = '''||V_USR||'''';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' registros de tareas de trámites GENCAT');
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE WHERE USUARIOCREAR = '''||V_USR||'''';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' registros de trámites GENCAT');

    --ACTIVOS OFERTAS EN BLOQUEO ADMINISTRATIVO, RESERVADO O APROBADO SIN RESERVA
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.AUX_MIGRA_GENCAT AS
        WITH ADECUACION AS (
            SELECT ADO.ACT_ID
            FROM '||V_ESQUEMA||'.ACT_ADO_ADMISION_DOCUMENTO ADO
            JOIN '||V_ESQUEMA||'.ACT_CFD_CONFIG_DOCUMENTO CFD ON CFD.CFD_ID = ADO.CFD_ID AND CFD.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_TPD_TIPO_DOCUMENTO TPD ON TPD.DD_TPD_ID = CFD.DD_TPD_ID AND TPD.BORRADO = 0
                AND TPD.DD_TPD_CODIGO IN (''13'',''90'')
            JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = CFD.DD_TPA_ID AND TPA.BORRADO = 0
                AND TPA.DD_TPA_CODIGO = ''02''
            WHERE ADO.BORRADO = 0 
                AND NVL(ADO.ADO_FECHA_OBTENCION,TO_DATE(''31/12/2099'',''DD/MM/YYYY'')) < SYSDATE
                AND NVL(ADO.ADO_FECHA_CADUCIDAD,TO_DATE(''31/12/2099'',''DD/MM/YYYY'')) > SYSDATE
            )
        SELECT ACT_ID, OFR_ID, ACT_NUM_ACTIVO, ECO_NUM_EXPEDIENTE, DD_EEC_CODIGO
            , ACT_OFR_IMPORTE, ECO_FECHA_SANCION, COE_SOLICITA_RESERVA, RES_FECHA_FIRMA
            , ADECUACION, BIE_DREG_SUPERFICIE_CONSTRUIDA, DD_SIP_ID, DD_TPE_ID
        FROM (
            SELECT ACT.ACT_ID, OFR.OFR_ID, ACT.ACT_NUM_ACTIVO, ECO.ECO_NUM_EXPEDIENTE
                , EEC.DD_EEC_CODIGO, AOF.ACT_OFR_IMPORTE, ECO.ECO_FECHA_SANCION
                , COE.COE_SOLICITA_RESERVA, RES.RES_FECHA_FIRMA, NVL2(ADE.ACT_ID, 0, 1) ADECUACION
                , BDR.BIE_DREG_SUPERFICIE_CONSTRUIDA, COE.DD_SIP_ID, COM.DD_TPE_ID, ROW_NUMBER() OVER(PARTITION BY ACT.ACT_ID ORDER BY COM.CLC_ID NULLS LAST) RN
            FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
            JOIN '||V_ESQUEMA||'.VI_ACTIVOS_AFECTOS_GENCAT AFE ON AFE.ACT_ID = ACT.ACT_ID
            JOIN '||V_ESQUEMA||'.BIE_BIEN BIE ON BIE.BIE_ID = ACT.BIE_ID AND BIE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.BIE_DATOS_REGISTRALES BDR ON BDR.BIE_ID = BIE.BIE_ID AND BDR.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
            JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
                AND SCM.DD_SCM_CODIGO NOT IN (''01'',''05'',''06'')
            JOIN '||V_ESQUEMA||'.ACT_OFR AOF ON AOF.ACT_ID = ACT.ACT_ID
            JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR ON OFR.OFR_ID = AOF.OFR_ID AND OFR.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
                AND EOF.DD_EOF_CODIGO = ''01''
            JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID AND ECO.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
                AND EEC.DD_EEC_CODIGO IN (''05'',''06'',''11'')
            JOIN '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE COE ON COE.ECO_ID = ECO.ECO_ID AND COE.BORRADO = 0
            JOIN '||V_ESQUEMA||'.CEX_COMPRADOR_EXPEDIENTE CEX ON CEX.ECO_ID = ECO.ECO_ID AND CEX.BORRADO = 0
            JOIN '||V_ESQUEMA||'.COM_COMPRADOR COM ON COM.COM_ID = CEX.COM_ID AND COM.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON RES.ECO_ID = ECO.ECO_ID AND RES.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE ON ERE.DD_ERE_ID = RES.DD_ERE_ID
                AND ERE.DD_ERE_CODIGO = ''02''
            LEFT JOIN ADECUACION ADE ON ADE.ACT_ID = ACT.ACT_ID
            LEFT JOIN '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT CMG ON CMG.ACT_ID = ACT.ACT_ID
            WHERE CMG.CMG_ID IS NULL AND ACT.ACT_NUM_ACTIVO = '||V_ACTIVO||')
        WHERE RN = 1';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Creada tabla AUX_MIGRA_GENCAT');

    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.AUX_MIGRA_GENCAT
    WHERE COE_SOLICITA_RESERVA = 1 AND RES_FECHA_FIRMA IS NULL
        AND DD_EEC_CODIGO = ''11''';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Borrados '||SQL%ROWCOUNT||' registros de tabla AUX_MIGRA_GENCAT por estar corruptos.');

    --CREACION COMUNICACION
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT (CMG_ID, ACT_ID, CMG_FECHA_PREBLOQUEO
        , DD_ECG_ID, USUARIOCREAR, FECHACREAR)
    SELECT '||V_ESQUEMA||'.S_ACT_CMG_COMUNICACION_GENCAT.NEXTVAL CMG_ID, AUX.ACT_ID
        , CASE 
            WHEN AUX.DD_EEC_CODIGO = ''11'' THEN AUX.ECO_FECHA_SANCION
            ELSE AUX.RES_FECHA_FIRMA
            END CMG_FECHA_PREBLOQUEO
        , ECG.DD_ECG_ID, '''||V_USR||''', SYSDATE
    FROM '||V_ESQUEMA||'.AUX_MIGRA_GENCAT AUX
    JOIN '||V_ESQUEMA||'.DD_ECG_ESTADO_COM_GENCAT ECG ON ECG.DD_ECG_CODIGO = ''CREADO''';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Creadas '||SQL%ROWCOUNT||' comunicaciones GENCAT.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_OFG_OFERTA_GENCAT (OFG_ID, CMG_ID, OFR_ID, OFG_IMPORTE
        , DD_TPE_ID, DD_SIP_ID, USUARIOCREAR, FECHACREAR)
    SELECT '||V_ESQUEMA||'.S_ACT_OFG_OFERTA_GENCAT.NEXTVAL OFG_ID, CMG.CMG_ID, AUX.OFR_ID
        , AUX.ACT_OFR_IMPORTE OFG_IMPORTE, AUX.DD_TPE_ID, AUX.DD_SIP_ID, '''||V_USR||'''
        , SYSDATE
    FROM '||V_ESQUEMA||'.AUX_MIGRA_GENCAT AUX
    JOIN '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT CMG ON CMG.ACT_ID = AUX.ACT_ID';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' ofertas relacionadas con las comunicaciones GENCAT creadas.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_ADG_ADECUACION_GENCAT (ADG_ID, CMG_ID, ADG_REFORMA, ADG_IMPORTE
        , ADG_FECHA_REVISION, USUARIOCREAR, FECHACREAR)
    SELECT '||V_ESQUEMA||'.S_ACT_ADG_ADECUACION_GENCAT.NEXTVAL, CMG.CMG_ID
        , AUX.ADECUACION, CASE 
            WHEN AUX.ADECUACION = 0 
            THEN 0
            ELSE AUX.BIE_DREG_SUPERFICIE_CONSTRUIDA * 52.3
            END ADG_IMPORTE
        , SYSDATE, '''||V_USR||''', SYSDATE
    FROM '||V_ESQUEMA||'.AUX_MIGRA_GENCAT AUX
    JOIN '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT CMG ON CMG.ACT_ID = AUX.ACT_ID';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' registros de adecuación relacionados con las comunicaciones GENCAT creadas.');
    
    --CREACION TRAMITE
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.AUX_MIGRA_TAR_ADECUA_GENCAT AS
    WITH GESTOR AS (
        SELECT ACT_ID, USU_ID
        FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
        JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
        JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
            AND TGE.DD_TGE_CODIGO = ''GACT''
        WHERE GEE.BORRADO = 0
        )
    , SUPERVISOR AS (
        SELECT ACT_ID, USU_ID
        FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
        JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
        JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
            AND TGE.DD_TGE_CODIGO = ''SUPACT''
        WHERE GEE.BORRADO = 0
        )
    SELECT '||V_ESQUEMA||'.S_ACT_TRA_TRAMITE.NEXTVAL TRA_ID,
        '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL TAR_ID,
        '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL TEX_ID,
        AUX.ACT_ID,
        TAP.TAP_ID, 
        TAP.TAP_DESCRIPCION, 
        GES.USU_ID, 
        SUP.USU_ID SUP_ID,
        STA.DD_STA_ID
    FROM '||V_ESQUEMA||'.AUX_MIGRA_GENCAT AUX
    JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_CODIGO = ''T016_ProcesoAdecuacion''
    JOIN GESTOR GES ON GES.ACT_ID = AUX.ACT_ID
    LEFT JOIN SUPERVISOR SUP ON SUP.ACT_ID = AUX.ACT_ID
    LEFT JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE STA ON STA.DD_STA_ID = TAP.DD_STA_ID';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Creada tabla AUX_MIGRA_TAR_ADECUA_GENCAT');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_TRA_TRAMITE (TRA_ID, ACT_ID, DD_TPO_ID, DD_EPR_ID
        , TRA_FECHA_INICIO, USUARIOCREAR, FECHACREAR, DD_TAC_ID)
    SELECT AUX.TRA_ID, AUX.ACT_ID,
        (SELECT TPO.DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO TPO WHERE TPO.DD_TPO_CODIGO = ''T016''),
        (SELECT EPR.DD_EPR_ID FROM '||V_ESQUEMA_M||'.DD_EPR_ESTADO_PROCEDIMIENTO EPR WHERE EPR.DD_EPR_CODIGO = ''10''),
        SYSDATE,
        '''||V_USR||''',
        SYSDATE,
        (SELECT TAC.DD_TAC_ID FROM '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION TAC WHERE TAC.DD_TAC_CODIGO = ''GES'')
    FROM '||V_ESQUEMA||'.AUX_MIGRA_TAR_ADECUA_GENCAT AUX';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Creados '||SQL%ROWCOUNT||' trámites GENCAT.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID, DD_EIN_ID
        , DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, TAR_FECHA_INI
        , USUARIOCREAR, FECHACREAR, TAR_FECHA_VENC, DTYPE)
    SELECT 
        AUX.TAR_ID,
        (SELECT EIN.DD_EIN_ID FROM '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN WHERE EIN.DD_EIN_CODIGO = ''61''),
        AUX.DD_STA_ID,
        1,
        AUX.TAP_DESCRIPCION,
        AUX.TAP_DESCRIPCION,
        SYSDATE,
        '''||V_USR||''',
        SYSDATE,
        SYSDATE + 15 AS TAR_FECHA_VENC,
        ''EXTTareaNotificacion''
    FROM '||V_ESQUEMA||'.AUX_MIGRA_TAR_ADECUA_GENCAT AUX';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Creadas '||SQL%ROWCOUNT||' tareas de adecuación del trámite de GENCAT.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ETN_EXTAREAS_NOTIFICACIONES (TAR_ID, TAR_FECHA_VENC_REAL)
    SELECT AUX.TAR_ID,
        SYSDATE + 15 AS TAR_FECHA_VENC_REAL
    FROM '||V_ESQUEMA||'.AUX_MIGRA_TAR_ADECUA_GENCAT AUX';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Insertadas '||SQL%ROWCOUNT||' fechas de vencimiento de las tareas de adecuación de trámite de GENCAT.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TEX_TAREA_EXTERNA (TEX_ID, TAR_ID, TAP_ID, USUARIOCREAR
        , FECHACREAR, DTYPE, USUARIOBORRAR, FECHABORRAR, BORRADO)
    SELECT 
        AUX.TEX_ID,
        AUX.TAR_ID,
        AUX.TAP_ID,
        '''||V_USR||''',
        SYSDATE,
        ''EXTTareaExterna'',
        AUX.USU_ID,
        SYSDATE,
        1
    FROM '||V_ESQUEMA||'.AUX_MIGRA_TAR_ADECUA_GENCAT AUX';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Insertados '||SQL%ROWCOUNT||' registros de tipo de trámite de GENCAT para las tareas de adecuación.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS (TAR_ID, TRA_ID, ACT_ID, USU_ID, SUP_ID
        , USUARIOCREAR, FECHACREAR)
    SELECT 
        AUX.TAR_ID,
        AUX.TRA_ID,
        AUX.ACT_ID,
        AUX.USU_ID,
        AUX.SUP_ID,
        '''||V_USR||''',
        SYSDATE
    FROM '||V_ESQUEMA||'.AUX_MIGRA_TAR_ADECUA_GENCAT AUX';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' activos relacionados con las tareas de adecuación del trámite de GENCAT.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TEV_TAREA_EXTERNA_VALOR (TEV_ID, TEX_ID, TEV_NOMBRE, TEV_VALOR
        , USUARIOCREAR, FECHACREAR, DTYPE)
    SELECT '||V_ESQUEMA||'.S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL, AUX.TEX_ID, TFI.TFI_NOMBRE
        , CASE TFI.TFI_NOMBRE
            WHEN ''titulo'' THEN NULL
            WHEN ''observaciones'' THEN NULL
            WHEN ''fechaRevision'' THEN TO_CHAR(SYSDATE, ''YYYY-MM-DD'')
            WHEN ''necesitaReforma'' THEN DECODE(ADG.ADG_REFORMA, 0, ''02'', 1, ''01'')
            WHEN ''importeReforma'' THEN TO_CHAR(ADG.ADG_IMPORTE)
            END TEV_VALOR
        , '''||V_USR||''', SYSDATE, ''TareaExternaValor''
    FROM '||V_ESQUEMA||'.AUX_MIGRA_TAR_ADECUA_GENCAT AUX
    JOIN '||V_ESQUEMA||'.TFI_TAREAS_FORM_ITEMS TFI ON TFI.TAP_ID = AUX.TAP_ID
    JOIN '||V_ESQUEMA||'.AUX_MIGRA_GENCAT AUX2 ON AUX2.ACT_ID = AUX.ACT_ID
    JOIN '||V_ESQUEMA||'.ACT_CMG_COMUNICACION_GENCAT CMG ON CMG.ACT_ID = AUX2.ACT_ID
    JOIN '||V_ESQUEMA||'.ACT_ADG_ADECUACION_GENCAT ADG ON ADG.CMG_ID = CMG.CMG_ID';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Insertados '||SQL%ROWCOUNT||' de datos de la tarea de adecuación del trámite de GENCAT.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
    USING (SELECT TAR_ID, USU_ID
        FROM AUX_MIGRA_TAR_ADECUA_GENCAT AUX) T2
    ON (T1.TAR_ID = T2.TAR_ID)
    WHEN MATCHED THEN UPDATE SET
        T1.TAR_TAREA_FINALIZADA = 1, T1.TAR_FECHA_FIN = SYSDATE, T1.BORRADO = 1
        , T1.USUARIOBORRAR = T2.USU_ID, T1.FECHABORRAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' tareas de adecuación del trámite GENCAT completadas.');

    --CREACION TAREA COMUNICACION
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.AUX_MIGRA_TAR_COM_GENCAT AS
    WITH GESTOR AS (
        SELECT ACT_ID, USU_ID
        FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
        JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
        JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
            AND TGE.DD_TGE_CODIGO = ''GFORMADM''
        WHERE GEE.BORRADO = 0
        )
    , SUPERVISOR AS (
        SELECT ACT_ID, USU_ID
        FROM '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE
        JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.GEE_ID = GEE.GEE_ID
        JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
            AND TGE.DD_TGE_CODIGO = ''SFORMADM''
        WHERE GEE.BORRADO = 0
        )
    SELECT AUX.TRA_ID,
        '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL TAR_ID,
        '||V_ESQUEMA||'.S_TEX_TAREA_EXTERNA.NEXTVAL TEX_ID,
        AUX.ACT_ID,
        TAP.TAP_ID, 
        TAP.TAP_DESCRIPCION, 
        COALESCE(GES.USU_ID,USU.USU_ID) USU_ID, 
        SUP.USU_ID SUP_ID,
        STA.DD_STA_ID
    FROM '||V_ESQUEMA||'.AUX_MIGRA_TAR_ADECUA_GENCAT AUX
    JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_CODIGO = ''T016_ComunicarGENCAT''
    LEFT JOIN GESTOR GES ON GES.ACT_ID = AUX.ACT_ID
    LEFT JOIN '||V_ESQUEMA||'.V_GESTORES_ACTIVO VI ON VI.ACT_ID = AUX.ACT_ID AND VI.TIPO_GESTOR = ''GFORMADM''
    LEFT JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = VI.USERNAME AND USU.BORRADO = 0
    LEFT JOIN SUPERVISOR SUP ON SUP.ACT_ID = AUX.ACT_ID
    LEFT JOIN '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE STA ON STA.DD_STA_ID = TAP.DD_STA_ID';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Creada tabla AUX_MIGRA_TAR_COM_GENCAT.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES (TAR_ID, DD_EIN_ID
        , DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, TAR_FECHA_INI
        , USUARIOCREAR, FECHACREAR, TAR_FECHA_VENC, DTYPE)
    SELECT 
        AUX.TAR_ID,
        (SELECT EIN.DD_EIN_ID FROM '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION EIN WHERE EIN.DD_EIN_CODIGO = ''61''),
        AUX.DD_STA_ID,
        1,
        AUX.TAP_DESCRIPCION,
        AUX.TAP_DESCRIPCION,
        SYSDATE,
        '''||V_USR||''',
        SYSDATE,
        SYSDATE + 15 AS TAR_FECHA_VENC,
        ''EXTTareaNotificacion''
    FROM '||V_ESQUEMA||'.AUX_MIGRA_TAR_COM_GENCAT AUX';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Creadas '||SQL%ROWCOUNT||' tareas de comunicación del trámite de GENCAT.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ETN_EXTAREAS_NOTIFICACIONES (TAR_ID, TAR_FECHA_VENC_REAL)
    SELECT AUX.TAR_ID,
        SYSDATE + 15 AS TAR_FECHA_VENC_REAL
    FROM '||V_ESQUEMA||'.AUX_MIGRA_TAR_COM_GENCAT AUX';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Insertadas '||SQL%ROWCOUNT||' fechas de vencimiento de las tareas de comunicación de trámite de GENCAT.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TEX_TAREA_EXTERNA (TEX_ID, TAR_ID, TAP_ID, USUARIOCREAR
        , FECHACREAR, DTYPE)
    SELECT 
        AUX.TEX_ID,
        AUX.TAR_ID,
        AUX.TAP_ID,
        '''||V_USR||''',
        SYSDATE,
        ''EXTTareaExterna''
    FROM '||V_ESQUEMA||'.AUX_MIGRA_TAR_COM_GENCAT AUX';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Insertados '||SQL%ROWCOUNT||' registros de tipo de trámite de GENCAT para las tareas de comunicación.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS (TAR_ID, TRA_ID, ACT_ID, USU_ID, SUP_ID
        , USUARIOCREAR, FECHACREAR)
    SELECT 
        AUX.TAR_ID,
        AUX.TRA_ID,
        AUX.ACT_ID,
        AUX.USU_ID,
        AUX.SUP_ID,
        '''||V_USR||''',
        SYSDATE
    FROM '||V_ESQUEMA||'.AUX_MIGRA_TAR_COM_GENCAT AUX';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT||' activos relacionados con las tareas de comunicación del trámite de GENCAT.');
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
    USING (
        SELECT DISTINCT TAR.TAR_ID
        FROM '||V_ESQUEMA||'.AUX_MIGRA_GENCAT AUX
        JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = AUX.OFR_ID
        JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = ECO.TBJ_ID
        JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
        JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
        JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
        JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
            AND TAP.TAP_CODIGO = ''T013_ResolucionTanteo'') T2
    ON (T1.TAR_ID = T2.TAR_ID)
    WHEN MATCHED THEN UPDATE SET
        T1.TAR_TAREA_FINALIZADA = 1, T1.TAR_FECHA_FIN = SYSDATE, T1.BORRADO = 1
        , T1.USUARIOBORRAR = '''||V_USR||''', T1.FECHABORRAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Finalizadas '||SQL%ROWCOUNT||' tareas de resolución de tanteo del trámite comercial de venta para los activos a los que se les ha creado comunicación GENCAT.');
        
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TEX_TAREA_EXTERNA T1
    USING (
        SELECT DISTINCT TAR.TAR_ID
        FROM '||V_ESQUEMA||'.AUX_MIGRA_GENCAT AUX
        JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = AUX.OFR_ID
        JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TBJ_ID = ECO.TBJ_ID
        JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.TRA_ID = TRA.TRA_ID
        JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID
        JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID
        JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
            AND TAP.TAP_CODIGO = ''T013_ResolucionTanteo'') T2
    ON (T1.TAR_ID = T2.TAR_ID)
    WHEN MATCHED THEN UPDATE SET
        T1.BORRADO = 1, T1.USUARIOBORRAR = '''||V_USR||''', T1.FECHABORRAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('Finalizados '||SQL%ROWCOUNT||' registros de tipo de trámite comercial de venta para la tarea de resolución de tanteo para los activos a los que se les ha creado comunicación GENCAT.');

    REM01.ALTA_BPM_INSTANCES('SP_BPM',PL_OUTPUT);

    COMMIT;


EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(SQLERRM);
        DBMS_OUTPUT.put_line(V_MSQL);
        ROLLBACK;
        RAISE;   
END;
/
EXIT;
