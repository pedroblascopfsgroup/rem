--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180514
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-751
--## PRODUCTO=NO
--## 
--## Finalidad: 
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

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_UPG_USER_PERFIL_GESTOR (
    V_USUARIO IN VARCHAR2
    , V_USU_USER IN VARCHAR2
    , V_USU_MAIL IN VARCHAR2
    , V_USU_GRUP IN VARCHAR2
    , V_DES_DESP IN VARCHAR2
    , V_COD_TDES IN VARCHAR2
    , V_TDE_DESC IN VARCHAR2
    , V_COD_PERF IN VARCHAR2
    , V_PEF_DESC IN VARCHAR2
    , V_COD_GEST IN VARCHAR2
    , V_GES_DESC IN VARCHAR2
    , V_COD_CART IN VARCHAR2
    , V_CNF_GEST IN NUMBER
    , PL_OUTPUT OUT VARCHAR2
) AS

    V_ESQUEMA       VARCHAR2(25 CHAR) := 'REM01'; --'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M     VARCHAR2(25 CHAR) := 'REMMASTER'; --'REMMASTER'; -- Configuracion Esquema Master
    V_USU_NOMBRE    VARCHAR2(100 CHAR);
    V_CAR_DESC      VARCHAR2(100 CHAR);
    V_ZON_COD       VARCHAR2(50 CHAR) := '01545465454';
    SP_OUTPUT       VARCHAR2(32000 CHAR);
    V_MSQL          VARCHAR2(4000 CHAR);
    V_PASS          VARCHAR2(10 CHAR);
    
    FUNCTION DAME_PASSWORD RETURN VARCHAR2 AS 
        VV_RANVALUE VARCHAR(11);
    BEGIN
        VV_RANVALUE := SUBSTR(CAST(DBMS_RANDOM.VALUE(1,10) AS VARCHAR),1,10);
        VV_RANVALUE := SUBSTR(DBMS_OBFUSCATION_TOOLKIT.MD5 (INPUT => UTL_RAW.CAST_TO_RAW(VV_RANVALUE)),1,10);
        RETURN VV_RANVALUE;
    END DAME_PASSWORD;

BEGIN

    V_USU_NOMBRE := INITCAP(REPLACE(REPLACE(REPLACE(''||V_USU_USER||'', '.', ' '), '_', ' '), '-', ' '));

    PL_OUTPUT := '[INICIO]' || CHR(10);
    
    V_PASS := DAME_PASSWORD();

    V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.USU_USUARIOS (USU_ID, ENTIDAD_ID, USU_USERNAME, USU_MAIL ,USU_NOMBRE, USU_PASSWORD
            , USU_GRUPO
    		, USUARIOCREAR, FECHACREAR, USU_FECHA_VIGENCIA_PASS)
        SELECT '||V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL, 1, '''||V_USU_USER||''', '''||V_USU_MAIL||''', '''||V_USU_NOMBRE||''', '''||V_PASS||'''
            , CASE 
                WHEN NVL('''||V_USU_GRUP||''',''0'') = '''||V_USU_USER||''' THEN 1
                ELSE 0
                END
        	, '''||V_USUARIO||''', SYSDATE, SYSDATE + 3650
        FROM DUAL
        WHERE NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA_M||'.USU_USUARIOS
            WHERE USU_USERNAME = '''||V_USU_USER||'''
            )';
    EXECUTE IMMEDIATE V_MSQL;
    
    IF SQL%ROWCOUNT = 0 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] No se ha creado el usuario ' || V_USU_USER || ' porque ya existe ' || CHR(10);
    ELSIF SQL%ROWCOUNT = 1 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] Usuario ' || V_USU_USER || ' creado con contraseña ' || V_PASS || CHR(10);
    END IF;
    
    V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS (GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO
    		, USUARIOCREAR, FECHACREAR)
        SELECT '||V_ESQUEMA_M||'.S_GRU_GRUPOS_USUARIOS.NEXTVAL, USU_GRU.USU_ID, USU_USU.USU_ID
        	, '''||V_USUARIO||''', SYSDATE
        FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU_GRU
        JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU_USU ON USU_USU.USU_USERNAME = '''||V_USU_USER||'''
        WHERE USU_GRU.USU_USERNAME = '''||V_USU_GRUP||''' AND USU_GRU.USU_GRUPO = 1
            AND NOT EXISTS (
                SELECT 1
                FROM '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS GRU
                WHERE GRU.USU_ID_GRUPO = USU_GRU.USU_ID AND GRU.USU_ID_USUARIO = USU_USU.USU_ID
            )';
    EXECUTE IMMEDIATE V_MSQL;
    
    IF SQL%ROWCOUNT = 0 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] No se crea registro de grupo porque ya existe o el usuario no es de grupo ' || CHR(10);
    ELSIF SQL%ROWCOUNT = 1 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] Usuario ' || V_USU_USER || ' añadido al grupo ' || V_USU_GRUP || CHR(10);
    END IF;
    
    IF V_COD_TDES IS NOT NULL THEN 
        V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO (DD_TDE_ID, DD_TDE_CODIGO, DD_TDE_DESCRIPCION, DD_TDE_DESCRIPCION_LARGA
                , USUARIOCREAR, FECHACREAR)
            SELECT '||V_ESQUEMA_M||'.S_DD_TDE_TIPO_DESPACHO.NEXTVAL, '''||V_COD_TDES||''', '''||V_TDE_DESC||''', '''||V_TDE_DESC||'''
                , '''||V_USUARIO||''', SYSDATE
            FROM DUAL
            WHERE NOT EXISTS (
                SELECT 1
                FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO
                WHERE DD_TDE_CODIGO = '''||V_COD_TDES||'''
                )';
        EXECUTE IMMEDIATE V_MSQL;
        
        IF SQL%ROWCOUNT = 0 THEN
            PL_OUTPUT := PL_OUTPUT || '   [INFO] Ya existe el tipo de despacho ' || V_TDE_DESC || CHR(10);
        ELSIF SQL%ROWCOUNT = 1 THEN
            PL_OUTPUT := PL_OUTPUT || '   [INFO] Tipo de despacho ' || V_TDE_DESC || ' creado ' || CHR(10);
        END IF;
    END IF;
    
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO (DES_ID, DES_DESPACHO, ZON_ID, DD_TDE_ID, USUARIOCREAR, FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_DES_DESPACHO_EXTERNO.NEXTVAL, '''||V_DES_DESP||''', ZON.ZON_ID, TDE.DD_TDE_ID, '''||V_USUARIO||''', SYSDATE
        FROM '||V_ESQUEMA||'.ZON_ZONIFICACION ZON
        JOIN '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO TDE ON TDE.DD_TDE_CODIGO = '''||V_COD_TDES||'''
        WHERE ZON.ZON_COD = '''||V_ZON_COD||''' AND NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES
            WHERE DES.ZON_ID = ZON.ZON_ID AND TDE.DD_TDE_ID = DES.DD_TDE_ID
            )';
    EXECUTE IMMEDIATE V_MSQL;
    
    IF SQL%ROWCOUNT = 0 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] Ya existe el despacho para esa zona y tipo' || CHR(10);
    ELSIF SQL%ROWCOUNT = 1 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] Creado/actualizado el despacho ' || V_DES_DESP || CHR(10);
    END IF;
    
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL, USU.USU_ID, DES.DES_ID, 0, 0, '''||V_USUARIO||''', SYSDATE
        FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES
        JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = '''||V_USU_USER||'''
        LEFT JOIN '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS USD ON USD.USU_ID = USU.USU_ID AND USD.DES_ID = DES.DES_ID
        WHERE USD.USD_ID IS NULL AND DES.DES_DESPACHO = '''||V_DES_DESP||'''';
    EXECUTE IMMEDIATE V_MSQL;
    
    IF SQL%ROWCOUNT = 0 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] No se ha asignado despacho al usuario ' || V_USU_USER || CHR(10);
    ELSIF SQL%ROWCOUNT = 1 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] Despachado el usuario ' || V_USU_USER || ' en ' || V_DES_DESP || CHR(10);
    END IF;
    
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES (PEF_ID, PEF_CODIGO, PEF_DESCRIPCION, PEF_DESCRIPCION_LARGA
            , USUARIOCREAR, FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL, '''||V_COD_PERF||''', '''||V_PEF_DESC||''', '''||V_PEF_DESC||'''
            , '''||V_USUARIO||''', SYSDATE
        FROM DUAL
        WHERE NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA||'.PEF_PERFILES
            WHERE PEF_CODIGO = '''||V_COD_PERF||'''
            )';
    EXECUTE IMMEDIATE V_MSQL;
    
    IF SQL%ROWCOUNT = 0 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] Ya existe el perfil ' || V_COD_PERF || CHR(10);
    ELSIF SQL%ROWCOUNT = 1 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] Perfil ' || V_COD_PERF || ' creado ' || CHR(10);
    END IF;

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (ZON_ID, PEF_ID, USU_ID, ZPU_ID, USUARIOCREAR, FECHACREAR)
        SELECT ZON.ZON_ID, PEF.PEF_ID, USU.USU_ID, '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL, '''||V_USUARIO||''', SYSDATE
        FROM '||V_ESQUEMA||'.ZON_ZONIFICACION ZON
        JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON PEF.PEF_CODIGO = '''||V_COD_PERF||'''
        JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = '''||V_USU_USER||'''
        LEFT JOIN '||V_ESQUEMA||'.ZON_PEF_USU ZPU ON ZPU.PEF_ID = PEF.PEF_ID 
            AND ZPU.USU_ID = USU.USU_ID AND ZPU.ZON_ID = ZON.ZON_ID
        WHERE ZON.ZON_COD = '''||V_ZON_COD||''' AND ZPU.ZPU_ID IS NULL';
    EXECUTE IMMEDIATE V_MSQL;
    
    IF SQL%ROWCOUNT = 0 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] No se ha perfilado el usuario ' || V_USU_USER || CHR(10);
    ELSIF SQL%ROWCOUNT = 1 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] Perfilado el usuario ' || V_USU_USER || ' con ' || V_COD_PERF || CHR(10);
    END IF;
    
    IF V_COD_CART IS NOT NULL THEN
        V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.UCA_USUARIO_CARTERA (UCA_ID, USU_ID, DD_CRA_ID)
            SELECT '||V_ESQUEMA||'.S_UCA_USUARIO_CARTERA.NEXTVAL, USU.USU_ID, CRA.DD_CRA_ID
            FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_CODIGO = '''||V_COD_CART||'''
            LEFT JOIN '||V_ESQUEMA||'.UCA_USUARIO_CARTERA UCA ON UCA.USU_ID = USU.USU_ID AND UCA.DD_CRA_ID = CRA.DD_CRA_ID
            WHERE USU.USU_USERNAME = '''||V_USU_USER||''' AND UCA.UCA_ID IS NULL';
        EXECUTE IMMEDIATE V_MSQL;
        
        IF SQL%ROWCOUNT = 0 THEN
            V_MSQL := 'SELECT DD_CRA_DESCRIPCION FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_COD_CART||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_CAR_DESC;
            PL_OUTPUT := PL_OUTPUT || '   [INFO] Usuario ' || V_USU_USER || ' ya carterizado para la cartera ' || V_CAR_DESC || CHR(10);
        ELSIF SQL%ROWCOUNT = 1 THEN
            V_MSQL := 'SELECT DD_CRA_DESCRIPCION FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_COD_CART||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_CAR_DESC;
            PL_OUTPUT := PL_OUTPUT || '   [INFO] ' || V_USU_USER || ' carterizado para ' || V_CAR_DESC || CHR(10);
        END IF;
    END IF;
    
    IF V_COD_GEST IS NOT NULL THEN 
        V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR (DD_TGE_ID, DD_TGE_CODIGO, DD_TGE_DESCRIPCION, DD_TGE_DESCRIPCION_LARGA
                , DD_TGE_EDITABLE_WEB, USUARIOCREAR, FECHACREAR)
            SELECT '||V_ESQUEMA_M||'.S_DD_TGE_TIPO_GESTOR.NEXTVAL, '''||V_COD_GEST||''', '''||V_GES_DESC||''', '''||V_GES_DESC||'''
                , 1, '''||V_USUARIO||''', SYSDATE
            FROM DUAL
            WHERE NOT EXISTS (
                SELECT 1
                FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR
                WHERE DD_TGE_CODIGO = '''||V_COD_GEST||'''
                )';
        EXECUTE IMMEDIATE V_MSQL;
        
        IF SQL%ROWCOUNT = 0 THEN
            PL_OUTPUT := PL_OUTPUT || '   [INFO] Ya existe el tipo de gestor ' || V_GES_DESC || CHR(10);
        ELSIF SQL%ROWCOUNT = 1 THEN
            PL_OUTPUT := PL_OUTPUT || '   [INFO] Tipo de gestor ' || V_GES_DESC || ' creado ' || CHR(10);
        END IF;
    END IF;
    
    IF NVL(V_CNF_GEST,0) = 1 THEN
        V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES T1
            USING (
                SELECT TGE.DD_TGE_CODIGO, CRA.DD_CRA_CODIGO, USU.USU_USERNAME, USU.USU_NOMBRE
                FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
                JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = '''||V_COD_GEST||'''
                JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_CODIGO = '''||V_COD_CART||'''
                WHERE USU.USU_USERNAME = '''||V_USU_USER||'''
                ) T2
            ON (T1.TIPO_GESTOR = T2.DD_TGE_CODIGO AND T1.COD_CARTERA = TO_NUMBER(T2.DD_CRA_CODIGO))
            WHEN MATCHED THEN UPDATE SET
                T1.USERNAME = T2.USU_USERNAME, T1.NOMBRE_USUARIO = T2.USU_NOMBRE
                , T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
            WHEN NOT MATCHED THEN INSERT (T1.ID, T1.TIPO_GESTOR, T1.COD_CARTERA, T1.USERNAME
                , T1.NOMBRE_USUARIO, T1.USUARIOCREAR, T1.FECHACREAR)
            VALUES ('||V_ESQUEMA||'.S_ACT_GES_DIST_GESTORES.NEXTVAL, T2.DD_TGE_CODIGO, T2.DD_CRA_CODIGO, T2.USU_USERNAME
                , T2.USU_NOMBRE, '''||V_USUARIO||''', SYSDATE)';
        EXECUTE IMMEDIATE V_MSQL;
        PL_OUTPUT := PL_OUTPUT || '   [INFO] ' || SQL%ROWCOUNT || ' registro/s en configuración de gestores fusionado/s' || CHR(10);
    END IF;
    
    PL_OUTPUT := PL_OUTPUT || '[FIN]';
    
EXCEPTION
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || '[ERROR] Se ha producido un error en la ejecución: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        PL_OUTPUT := PL_OUTPUT || V_MSQL;
        ROLLBACK;
        RAISE;
END SP_UPG_USER_PERFIL_GESTOR;
/
EXIT;