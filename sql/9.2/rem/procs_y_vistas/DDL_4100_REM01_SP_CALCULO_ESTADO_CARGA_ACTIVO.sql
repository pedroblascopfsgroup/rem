--/*
--##########################################
--## AUTOR=Carles
--## FECHA_CREACION=20191230
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6109
--## PRODUCTO=NO
--## Finalidad: Procedimiento almacenado que calcula el DD_ECA_ID de la tabla ACT_CRG_CARGAS.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial HREOS-7859
--##        0.2 Añadir opción sin carga HREOS-8527
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE SP_CALCULO_ESTADO_CARGA_ACTIVO (
    P_ACT_ID        IN NUMBER DEFAULT NULL,
    V_USUARIO       VARCHAR2 DEFAULT 'SP_CALCULO_ESTADO_CARGA_ACTIVO') AS
--v0.2

    V_ESQUEMA VARCHAR2(15 CHAR) := 'REM01';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
    V_MSQL VARCHAR2(4000 CHAR);
    V_NUM NUMBER(16);
    V_ACT_ID VARCHAR2(50 CHAR) := NULL;
    ERR_NUM NUMBER(25);
	ERR_MSG VARCHAR2(1024 CHAR);
BEGIN

    IF P_ACT_ID IS NOT NULL THEN --SI SE PASA UN ACTIVO, SE HARÁ ÚNICAMENTE PARA EL MISMO
        V_ACT_ID := ' AND AUX_ACT.ACT_ID = '||P_ACT_ID;
    END IF;

    --------------------------------------------------------------------
    ----------- 1-Vigente - impiden venta. ----------------------------
    --------------------------------------------------------------------
    
        V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                   USING (
                            SELECT
                            AUX_ACT.ACT_ID,
                            (SELECT ECA.DD_ECA_ID FROM '|| V_ESQUEMA ||'.DD_ECA_ESTADO_CARGA_ACTIVOS ECA WHERE ECA.DD_ECA_CODIGO = ''01'') AS DD_ECA_ID
                            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO AUX_ACT
                            WHERE AUX_ACT.ACT_ID IN (
                            SELECT SQLI.ACT_ID
                            FROM '|| V_ESQUEMA ||'.ACT_CRG_CARGAS SQLI
                            WHERE SQLI.BORRADO = 0 AND SQLI.DD_ECG_ID = (SELECT ECG.DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_CARGA ECG WHERE ECG.DD_ECG_CODIGO = ''01'') AND SQLI.CRG_IMPIDE_VENTA = 
								(SELECT DD_SIN_ID FROM '|| V_ESQUEMA_MASTER ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO =  ''01'')
                            GROUP BY SQLI.ACT_ID)
                            AND AUX_ACT.BORRADO = 0'||V_ACT_ID||
                          ') AUX
                   ON (ACT.ACT_ID = AUX.ACT_ID)
                   WHEN MATCHED THEN 
                   UPDATE SET
                    ACT.DD_ECA_ID = AUX.DD_ECA_ID
                    ,ACT.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,ACT.FECHAMODIFICAR = SYSDATE';

        EXECUTE IMMEDIATE V_MSQL;

    --------------------------------------------------------------------
    ----------- 2-No impide venta - con gestión. ----------------------
    --------------------------------------------------------------------
    
        V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                   USING (
                            SELECT
                            AUX_ACT.ACT_ID,
                            (SELECT ECA.DD_ECA_ID FROM '|| V_ESQUEMA ||'.DD_ECA_ESTADO_CARGA_ACTIVOS ECA WHERE ECA.DD_ECA_CODIGO = ''02'') AS DD_ECA_ID
                            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO AUX_ACT
                            WHERE AUX_ACT.ACT_ID IN (
                            SELECT SQLI.ACT_ID
                            FROM '|| V_ESQUEMA ||'.ACT_CRG_CARGAS SQLI
                            WHERE SQLI.BORRADO = 0 AND SQLI.DD_ECG_ID = (SELECT ECG.DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_CARGA ECG WHERE ECG.DD_ECG_CODIGO = ''01'') AND SQLI.CRG_IMPIDE_VENTA = 
								(SELECT DD_SIN_ID FROM '|| V_ESQUEMA_MASTER ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO =  ''02'')
                            GROUP BY SQLI.ACT_ID)
                            AND AUX_ACT.ACT_ID NOT IN (
                            SELECT SQLI.ACT_ID
                            FROM '|| V_ESQUEMA ||'.ACT_CRG_CARGAS SQLI
                            WHERE SQLI.BORRADO = 0 AND SQLI.DD_ECG_ID = (SELECT ECG.DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_CARGA ECG WHERE ECG.DD_ECG_CODIGO = ''01'') AND SQLI.CRG_IMPIDE_VENTA = 
								(SELECT DD_SIN_ID FROM '|| V_ESQUEMA_MASTER ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO =  ''01'')
                            GROUP BY SQLI.ACT_ID)
                            AND AUX_ACT.BORRADO = 0'||V_ACT_ID||
                          ') AUX
                   ON (ACT.ACT_ID = AUX.ACT_ID)
                   WHEN MATCHED THEN 
                   UPDATE SET
                    ACT.DD_ECA_ID = AUX.DD_ECA_ID
                    ,ACT.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,ACT.FECHAMODIFICAR = SYSDATE
				   WHERE ACT.DD_ECA_ID <> AUX.DD_ECA_ID';

        EXECUTE IMMEDIATE V_MSQL;

    --------------------------------------------------------------------
    ----------- 3-No impide venta - sin gestión. ----------------------
    --------------------------------------------------------------------
    
        V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                   USING (
                            SELECT
                            AUX_ACT.ACT_ID,
                            (SELECT ECA.DD_ECA_ID FROM '|| V_ESQUEMA ||'.DD_ECA_ESTADO_CARGA_ACTIVOS ECA WHERE ECA.DD_ECA_CODIGO = ''03'') AS DD_ECA_ID
                            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO AUX_ACT
                            WHERE AUX_ACT.ACT_ID IN (
                            SELECT SQLI.ACT_ID
                            FROM '|| V_ESQUEMA ||'.ACT_CRG_CARGAS SQLI
                            WHERE SQLI.BORRADO = 0 AND SQLI.DD_ECG_ID = (SELECT ECG.DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_CARGA ECG WHERE ECG.DD_ECG_CODIGO = ''02'') 
                            GROUP BY SQLI.ACT_ID)
                            AND AUX_ACT.ACT_ID NOT IN (
                            SELECT SQLI.ACT_ID
                            FROM '|| V_ESQUEMA ||'.ACT_CRG_CARGAS SQLI
                            WHERE SQLI.BORRADO = 0 AND SQLI.DD_ECG_ID = (SELECT ECG.DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_CARGA ECG WHERE ECG.DD_ECG_CODIGO = ''01'')
                            GROUP BY SQLI.ACT_ID)
                            AND AUX_ACT.BORRADO = 0'||V_ACT_ID||
                          ') AUX
                   ON (ACT.ACT_ID = AUX.ACT_ID)
                   WHEN MATCHED THEN 
                   UPDATE SET
                    ACT.DD_ECA_ID = AUX.DD_ECA_ID
                    ,ACT.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,ACT.FECHAMODIFICAR = SYSDATE
				   WHERE ACT.DD_ECA_ID <> AUX.DD_ECA_ID';

        EXECUTE IMMEDIATE V_MSQL;

    --------------------------------------------------------------------
    ----------- 4-Caducada. --------------------------------------------
    --------------------------------------------------------------------
    
        V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                   USING (
                            SELECT
                            AUX_ACT.ACT_ID,
                            (SELECT ECA.DD_ECA_ID FROM '|| V_ESQUEMA ||'.DD_ECA_ESTADO_CARGA_ACTIVOS ECA WHERE ECA.DD_ECA_CODIGO = ''04'') AS DD_ECA_ID
                            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO AUX_ACT
                            WHERE AUX_ACT.ACT_ID IN (
                            SELECT SQLI.ACT_ID
                            FROM '|| V_ESQUEMA ||'.ACT_CRG_CARGAS SQLI
                            WHERE SQLI.BORRADO = 0 AND SQLI.DD_ECG_ID = (SELECT ECG.DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_CARGA ECG WHERE ECG.DD_ECG_CODIGO = ''04'')
                            GROUP BY SQLI.ACT_ID)
                            AND AUX_ACT.ACT_ID NOT IN (
                            SELECT SQLI.ACT_ID
                            FROM '|| V_ESQUEMA ||'.ACT_CRG_CARGAS SQLI
                            WHERE SQLI.BORRADO = 0 AND (SQLI.DD_ECG_ID = (SELECT ECG.DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_CARGA ECG WHERE ECG.DD_ECG_CODIGO = ''01'') OR SQLI.DD_ECG_ID = (SELECT ECG.DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_CARGA ECG WHERE ECG.DD_ECG_CODIGO = ''02''))
                            GROUP BY SQLI.ACT_ID)
                            AND AUX_ACT.BORRADO = 0'||V_ACT_ID||
                          ') AUX
                   ON (ACT.ACT_ID = AUX.ACT_ID)
                   WHEN MATCHED THEN 
                   UPDATE SET
                    ACT.DD_ECA_ID = AUX.DD_ECA_ID
                    ,ACT.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,ACT.FECHAMODIFICAR = SYSDATE
				   WHERE ACT.DD_ECA_ID <> AUX.DD_ECA_ID';

        EXECUTE IMMEDIATE V_MSQL;

    --------------------------------------------------------------------
    ----------- 5-Cancelada. -------------------------------------------
    --------------------------------------------------------------------
    
        V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                   USING (
                            SELECT
                            AUX_ACT.ACT_ID,
                            (SELECT ECA.DD_ECA_ID FROM '|| V_ESQUEMA ||'.DD_ECA_ESTADO_CARGA_ACTIVOS ECA WHERE ECA.DD_ECA_CODIGO = ''05'') AS DD_ECA_ID
                            FROM '|| V_ESQUEMA ||'.ACT_ACTIVO AUX_ACT
                            WHERE AUX_ACT.ACT_ID IN (
                            SELECT SQLI.ACT_ID
                            FROM '|| V_ESQUEMA ||'.ACT_CRG_CARGAS SQLI
                            WHERE SQLI.BORRADO = 0 AND SQLI.DD_ECG_ID = (SELECT ECG.DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_CARGA ECG WHERE ECG.DD_ECG_CODIGO = ''03'')
                            GROUP BY SQLI.ACT_ID)
                            AND AUX_ACT.ACT_ID NOT IN (
                            SELECT SQLI.ACT_ID
                            FROM '|| V_ESQUEMA ||'.ACT_CRG_CARGAS SQLI
                            WHERE SQLI.BORRADO = 0 AND (SQLI.DD_ECG_ID = (SELECT ECG.DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_CARGA ECG WHERE ECG.DD_ECG_CODIGO = ''01'') 
                            OR SQLI.DD_ECG_ID = (SELECT ECG.DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_CARGA ECG WHERE ECG.DD_ECG_CODIGO = ''02'')
                            OR SQLI.DD_ECG_ID = (SELECT ECG.DD_ECG_ID FROM '|| V_ESQUEMA ||'.DD_ECG_ESTADO_CARGA ECG WHERE ECG.DD_ECG_CODIGO = ''04''))
                            GROUP BY SQLI.ACT_ID)
                            AND AUX_ACT.BORRADO = 0'||V_ACT_ID||
                          ') AUX
                   ON (ACT.ACT_ID = AUX.ACT_ID)
                   WHEN MATCHED THEN 
                   UPDATE SET
                    ACT.DD_ECA_ID = AUX.DD_ECA_ID
                    ,ACT.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    ,ACT.FECHAMODIFICAR = SYSDATE
				   WHERE ACT.DD_ECA_ID <> AUX.DD_ECA_ID';

        EXECUTE IMMEDIATE V_MSQL;

    --------------------------------------------------------------------
    ----------- Si no hay cargas. --------------------------------------
    --------------------------------------------------------------------

        V_MSQL := 'MERGE INTO ACT_ACTIVO ACT
                   USING (
                        SELECT AUX_ACT.ACT_ID FROM '|| V_ESQUEMA ||'.ACT_ACTIVO AUX_ACT
                        LEFT JOIN '|| V_ESQUEMA ||'.ACT_CRG_CARGAS CRG ON AUX_ACT.ACT_ID = CRG.ACT_ID AND CRG.BORRADO = 0
                        WHERE CRG.CRG_ID IS NULL AND AUX_ACT.BORRADO=0'||V_ACT_ID||
                        ') AUX
                   ON (ACT.ACT_ID = AUX.ACT_ID)
                   WHEN MATCHED THEN
                   UPDATE SET
                    ACT.DD_ECA_ID = NULL
                    , ACT.USUARIOMODIFICAR = '''||V_USUARIO||'''
                    , ACT.FECHAMODIFICAR = SYSDATE
				   WHERE ACT.DD_ECA_ID IS NOT NULL';

        EXECUTE IMMEDIATE V_MSQL;
        
        REM01.OPERACION_DDL.DDL_TABLE('ANALYZE','ACT_CRG_CARGAS');

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
    	ERR_NUM := SQLCODE;
	    ERR_MSG := SQLERRM;
        ROLLBACK;
        RAISE;
END SP_CALCULO_ESTADO_CARGA_ACTIVO;
/
EXIT;
