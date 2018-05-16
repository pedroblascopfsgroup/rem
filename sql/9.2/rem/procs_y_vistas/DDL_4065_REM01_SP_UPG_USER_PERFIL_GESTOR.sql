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

CREATE OR REPLACE PROCEDURE REM01.SP_UPG_USER_PERFIL_GESTOR (V_USUARIO IN VARCHAR2, V_USERNAME IN VARCHAR2, V_PERFILES IN VARCHAR2, V_TIPOS_GESTOR IN VARCHAR2, V_DESPACHOS IN VARCHAR2, V_CARTERA IN VARCHAR2, PL_OUTPUT OUT VARCHAR2) AS
    
    V_ESQUEMA       VARCHAR2(25 CHAR) := 'REM01'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M     VARCHAR2(25 CHAR) := 'REMMASTER'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_PERFIL        VARCHAR2(4000 CHAR);
    V_TIPO_GESTOR   VARCHAR2(4000 CHAR);
    V_DESPACHO      VARCHAR2(4000 CHAR);
    V_CARTERA_DESC  VARCHAR2(100 CHAR);
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

    V_PERFIL := REPLACE(REPLACE(''''||V_PERFILES||'''', ',', ''','''), ' ', '');
    V_TIPO_GESTOR := REPLACE(REPLACE(''''||V_TIPOS_GESTOR||'''', ',', ''','''), ' ', '');
    V_DESPACHO := REPLACE(REPLACE(''''||V_DESPACHOS||'''', ',', ''','''), ' ', '');

    PL_OUTPUT := '[INICIO]' || CHR(10);
    
    V_PASS := DAME_PASSWORD();

    V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.USU_USUARIOS (USU_ID, ENTIDAD_ID, USU_USERNAME, USU_NOMBRE, USU_PASSWORD, USUARIOCREAR
            , FECHACREAR, USU_FECHA_VIGENCIA_PASS)
        SELECT '||V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL, 1, '''||V_USERNAME||''', '''||V_USERNAME||''', '''||V_PASS||''', '''||V_USUARIO||'''
            , SYSDATE, SYSDATE + 720
        FROM DUAL
        WHERE NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA_M||'.USU_USUARIOS
            WHERE USU_USERNAME = '''||V_USERNAME||'''
            )';
    EXECUTE IMMEDIATE V_MSQL;
    
    IF SQL%ROWCOUNT = 0 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] No se ha creado el usuario ' || V_USERNAME || ' porque ya existe ' || CHR(10);
    ELSIF SQL%ROWCOUNT = 1 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] Usuario ' || V_USERNAME || ' creado con contraseña ' || V_PASS || CHR(10);
    END IF;
    
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS (USD_ID, USU_ID, DES_ID, USD_GESTOR_DEFECTO, USD_SUPERVISOR, USUARIOCREAR, FECHACREAR)
        SELECT '||V_ESQUEMA||'.S_USD_USUARIOS_DESPACHOS.NEXTVAL, USU.USU_ID, DES.DES_ID, 0, 0, '''||V_USUARIO||''', SYSDATE
        FROM '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES
        JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = '''||V_USERNAME||'''
        LEFT JOIN '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS USD ON USD.USU_ID = USU.USU_ID AND USD.DES_ID = DES.DES_ID
        WHERE USD.USD_ID IS NULL AND DES.DES_DESPACHO IN ('||V_DESPACHO||')';
    EXECUTE IMMEDIATE V_MSQL;
    
    IF SQL%ROWCOUNT = 0 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] No se ha asignado despacho al usuario ' || V_USERNAME || CHR(10);
    ELSIF SQL%ROWCOUNT = 1 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] Despachado el usuario ' || V_USERNAME || ' en ' || V_DESPACHO || CHR(10);
    END IF;

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (ZON_ID, PEF_ID, USU_ID, ZPU_ID, USUARIOCREAR, FECHACREAR)
        SELECT ZON.ZON_ID, PEF.PEF_ID, USU.USU_ID, '||V_ESQUEMA||'.S_ZON_PEF_USU.NEXTVAL, '''||V_USUARIO||''', SYSDATE
        FROM '||V_ESQUEMA||'.ZON_ZONIFICACION ZON
        JOIN '||V_ESQUEMA||'.PEF_PERFILES PEF ON PEF.PEF_CODIGO IN ('||V_PERFIL||')
        JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON USU.USU_USERNAME = '''||V_USERNAME||'''
        LEFT JOIN '||V_ESQUEMA||'.ZON_PEF_USU ZPU ON ZPU.PEF_ID = PEF.PEF_ID 
            AND ZPU.USU_ID = USU.USU_ID AND ZPU.ZON_ID = ZON.ZON_ID
        WHERE ZON.ZON_COD = ''01545465454'' AND ZPU.ZPU_ID IS NULL';
    EXECUTE IMMEDIATE V_MSQL;
    
    IF SQL%ROWCOUNT = 0 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] No se ha perfilado el usuario ' || V_USERNAME || CHR(10);
    ELSIF SQL%ROWCOUNT = 1 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] Perfilado el usuario ' || V_USERNAME || ' con ' || V_PERFIL || CHR(10);
    END IF;
    
    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.UCA_USUARIO_CARTERA (UCA_ID, USU_ID, DD_CRA_ID)
        SELECT '||V_ESQUEMA||'.S_UCA_USUARIO_CARTERA.NEXTVAL, USU.USU_ID, CRA.DD_CRA_ID
        FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
        JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_CODIGO = '''||V_CARTERA||'''
        LEFT JOIN '||V_ESQUEMA||'.UCA_USUARIO_CARTERA UCA ON UCA.USU_ID = USU.USU_ID AND UCA.DD_CRA_ID = CRA.DD_CRA_ID
        WHERE USU.USU_USERNAME = '''||V_USERNAME||''' AND UCA.UCA_ID IS NULL';
    EXECUTE IMMEDIATE V_MSQL;
    
    IF SQL%ROWCOUNT = 0 THEN
        PL_OUTPUT := PL_OUTPUT || '   [INFO] No se ha carterizado el usuario ' || V_USERNAME || CHR(10);
    ELSIF SQL%ROWCOUNT = 1 THEN
        V_MSQL := 'SELECT DD_CRA_DESCRIPCION FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||V_CARTERA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_CARTERA_DESC;
        PL_OUTPUT := PL_OUTPUT || '   [INFO] Carterizado el usuario ' || V_USERNAME || ' para ' || V_CARTERA_DESC || CHR(10);
    END IF;
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_GES_DIST_GESTORES T1
        USING (
            SELECT TGE.DD_TGE_CODIGO, CRA.DD_CRA_CODIGO, USU.USU_USERNAME, USU.USU_NOMBRE
            FROM '||V_ESQUEMA_M||'.USU_USUARIOS USU
            JOIN '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO IN ('||V_TIPO_GESTOR||')
            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_CODIGO = '''||V_CARTERA||'''
            WHERE USU.USU_USERNAME = '''||V_USERNAME||'''
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

    REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3 ('SP_AGA_V4', SP_OUTPUT, NULL, NULL, '02');
    PL_OUTPUT := PL_OUTPUT || SP_OUTPUT || CHR(10);

    REM01.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3 ('SP_AGA_V4', SP_OUTPUT, NULL, NULL, '01');
    PL_OUTPUT := PL_OUTPUT || SP_OUTPUT || CHR(10);
    
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