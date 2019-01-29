--/*
--##########################################
--## AUTOR=Mariam Lliso
--## FECHA_CREACION=20190102
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5160
--## PRODUCTO=NO
--## Finalidad: Procedimiento almacenado que asigna Gestores de todos los tipos.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial Pau Serrano
--##		0.2 Añadidos gestor comercial backoffice liberbank SOG
--##		0.3 Modificación para que los grestores de la tabla ACT_GES_DIST_GESTORES que no tengan cartera también los asigne al activo
--##		0.4 Añadidos gestor de reserva para Cajamar - REMVIP-2129
--##		0.5 Añadidos los nuevos gestores comerciales de alquiler (gestor y supervisor) - HREOS-5064
--##		0.6 HREOS-5049 Carlos López: Optimización
--##		0.7 HREOS-5160 Mariam Lliso: modificada la asignación de gestores
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_AGA_ASIGNA_GESTOR_ACTIVO_V3 (
    V_USUARIO       VARCHAR2 DEFAULT 'SP_AGA_V4',
    PL_OUTPUT       OUT VARCHAR2,
    P_ACT_ID        IN #ESQUEMA#.act_activo.act_id%TYPE,
    P_ALL_ACTIVOS   IN NUMBER,
    P_CLASE_ACTIVO  IN VARCHAR2) AS
--v0.2

    V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
    V_MSQL VARCHAR2(4000 CHAR);
    V_NUM NUMBER(16);
    V_COUNT_1 NUMBER(16) := 0;
    V_COUNT_GES NUMBER(16) := 0;
    V_ACT_ID VARCHAR2(50 CHAR) := NULL;
    V_CLASE_ACTIVO VARCHAR (500 CHAR);
    V_CLASE_ACTIVO_NULL VARCHAR (500 CHAR);
    TYPE T_GESTOR IS TABLE OF VARCHAR2(250 CHAR);

    V_GESTOR_FINANCIERO T_GESTOR := T_GESTOR('GPUBL','SPUBL','GCOM','SCOM','FVDNEG','FVDBACKOFR','FVDBACKVNT','SUPFVD','SFORM','GCODI','GCOINM','GCOIN','GLIBINVINM','GLIBSINTER','GLIBRES','GESRES','SUPRES');
    V_GESTOR_INMOBILIAR T_GESTOR := T_GESTOR('GADM','SUPADM','GACT','SUPACT','GPREC','SPREC','GPUBL','SPUBL','GCOM','SCOM','FVDNEG','FVDBACKOFR','FVDBACKVNT','SUPFVD','SFORM','GGADM','GIAFORM','GTOCED','CERT','GIAADMT','PTEC', 'GTREE','GCODI','GCOINM','GCOIN','GLIBINVINM','GLIBSINTER','GLIBRES','HAYAGBOINM','SBACKOFFICEINMLIBER','GEDI', 'SUPEDI', 'GSUE', 'SUPSUE','GALQ','SUALQ', 'GESTCOMALQ', 'SUPCOMALQ','GFORMADM');
    V_GESTOR T_GESTOR;

BEGIN

    PL_OUTPUT := '[INICIO]'||CHR(10);
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME LIKE ''TMP_GEST_ACT'' AND OWNER LIKE '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM;

    IF V_NUM != 0 THEN
        --PL_OUTPUT := PL_OUTPUT || '   [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' TMP_GEST_ACT eliminada'||CHR(10);
        V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.TMP_GEST_ACT';
        EXECUTE IMMEDIATE V_MSQL;
    END IF;

    --PL_OUTPUT := PL_OUTPUT || '   [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' TMP_GEST_ACT creada'||CHR(10);
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_GEST_ACT (
        ACT_ID NUMBER(16,0)
        , USU_ID NUMBER(16,0)
        , GEE_ID NUMBER(16,0)
        , GEH_ID NUMBER(16,0)
        , TIPO_GESTOR VARCHAR2(20 CHAR))';
    EXECUTE IMMEDIATE V_MSQL;

    IF P_CLASE_ACTIVO = '01' THEN --ACTIVOS FINANCIEROS
        V_GESTOR := V_GESTOR_FINANCIERO;
        V_CLASE_ACTIVO :=  'JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
            JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND SCR.DD_SCR_ID = ACT.DD_SCR_ID
            WHERE SCR.DD_SCR_CODIGO = DECODE (CRA.DD_CRA_CODIGO, ''01'',''01'',''02'',''03'',''03'',''05'',''04'',''10'',''05'',''12'',''09'',''21'',''07'',''134'',''07'',''38'',''00'')';
        V_CLASE_ACTIVO_NULL :=  'LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
            LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND SCR.DD_SCR_ID = ACT.DD_SCR_ID
            WHERE SCR.DD_SCR_CODIGO IS NULL';
    ELSIF P_CLASE_ACTIVO = '02' THEN-- ACTIVOS INMOBILIAROS
        V_GESTOR := V_GESTOR_INMOBILIAR;
        V_CLASE_ACTIVO := 'JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
            JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND SCR.DD_SCR_ID = ACT.DD_SCR_ID
            WHERE SCR.DD_SCR_CODIGO <> DECODE (CRA.DD_CRA_CODIGO, ''01'',''01'',''02'',''03'',''03'',''05'',''04'',''10'',''05'',''12'',''09'',''21'',''07'',''134'',''07'',''38'',''00'')';
        V_CLASE_ACTIVO_NULL := 'LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
            LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND SCR.DD_SCR_ID = ACT.DD_SCR_ID
            WHERE SCR.DD_SCR_CODIGO IS NULL';
    END IF;
    
    IF P_ACT_ID IS NOT NULL THEN --SI SE PASA UN ACTIVO, SE HARÁ ÚNICAMENTE PARA EL MISMO
        V_ACT_ID := 'AND ACT.ACT_ID = '||P_ACT_ID;
    END IF;

    --------------------------------------------------------------------
    ----------- ASIGNAMOS GESTORES ---------------------------
    --------------------------------------------------------------------
    FOR I IN V_GESTOR.FIRST .. V_GESTOR.LAST
    LOOP
        
        
        V_MSQL := 'SELECT COUNT(1)
            FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
            JOIN '||V_ESQUEMA||'.V_GESTORES_ACTIVO GEST ON ACT.ACT_ID = GEST.ACT_ID AND GEST.TIPO_GESTOR = '''||V_GESTOR(I)||'''
            JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEST.USERNAME
            '||V_CLASE_ACTIVO_NULL||'
                AND ACT.BORRADO = 0
                AND NOT EXISTS (
                    SELECT 1
                    FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
                    JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC        ON GAC.ACT_ID    = GAH.ACT_ID
                    JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH      ON GEH.GEH_ID    = GAH.GEH_ID
                    JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE           ON GEE.GEE_ID    = GAC.GEE_ID
                    JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE    ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_ID = GEH.DD_TGE_ID
                        AND TGE.DD_TGE_CODIGO = '''||V_GESTOR(I)||'''
                    WHERE GEE.BORRADO = 0 AND GEH.BORRADO = 0
                        AND ACT.ACT_ID = GAH.ACT_ID)
                '||V_ACT_ID;
        
        EXECUTE IMMEDIATE V_MSQL INTO V_COUNT_GES;
        
        IF V_COUNT_GES = 0 THEN 
        
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_GEST_ACT (
                    ACT_ID,
                    USU_ID,
                    GEE_ID,
                    GEH_ID,
                    TIPO_GESTOR
                )
                SELECT
                    ACT.ACT_ID
                    , USU.USU_ID
                    , '||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL GEE_ID
                    , '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL GEH_ID
                    , GEST.TIPO_GESTOR
                FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                JOIN '||V_ESQUEMA||'.V_GESTORES_ACTIVO GEST ON ACT.ACT_ID = GEST.ACT_ID AND GEST.TIPO_GESTOR = '''||V_GESTOR(I)||'''
                JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEST.USERNAME
                '||V_CLASE_ACTIVO||'
                    AND ACT.BORRADO = 0
                    AND NOT EXISTS (
                        SELECT 1
                        FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
                        JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC        ON GAC.ACT_ID    = GAH.ACT_ID
                        JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH      ON GEH.GEH_ID    = GAH.GEH_ID
                        JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE           ON GEE.GEE_ID    = GAC.GEE_ID
                        JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE    ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_ID = GEH.DD_TGE_ID
                            AND TGE.DD_TGE_CODIGO = '''||V_GESTOR(I)||'''
                        WHERE GEE.BORRADO = 0 AND GEH.BORRADO = 0
                            AND ACT.ACT_ID = GAH.ACT_ID)
                    '||V_ACT_ID;

            EXECUTE IMMEDIATE V_MSQL;
        
        ELSE 
            
            V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_GEST_ACT (
                    ACT_ID,
                    USU_ID,
                    GEE_ID,
                    GEH_ID,
                    TIPO_GESTOR
                )
                SELECT
                    ACT.ACT_ID
                    , USU.USU_ID
                    , '||V_ESQUEMA||'.S_GEE_GESTOR_ENTIDAD.NEXTVAL GEE_ID
                    , '||V_ESQUEMA||'.S_GEH_GESTOR_ENTIDAD_HIST.NEXTVAL GEH_ID
                    , GEST.TIPO_GESTOR
                FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                JOIN '||V_ESQUEMA||'.V_GESTORES_ACTIVO GEST ON ACT.ACT_ID = GEST.ACT_ID AND GEST.TIPO_GESTOR = '''||V_GESTOR(I)||'''
                JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEST.USERNAME
                '||V_CLASE_ACTIVO_NULL||'
                    AND ACT.BORRADO = 0
                    AND NOT EXISTS (
                        SELECT 1
                        FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO GAH
                        JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC        ON GAC.ACT_ID    = GAH.ACT_ID
                        JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH      ON GEH.GEH_ID    = GAH.GEH_ID
                        JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE           ON GEE.GEE_ID    = GAC.GEE_ID
                        JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE    ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND TGE.DD_TGE_ID = GEH.DD_TGE_ID
                            AND TGE.DD_TGE_CODIGO = '''||V_GESTOR(I)||'''
                        WHERE GEE.BORRADO = 0 AND GEH.BORRADO = 0
                            AND ACT.ACT_ID = GAH.ACT_ID)
                    '||V_ACT_ID;
             
            EXECUTE IMMEDIATE V_MSQL;
            
        END IF;
        
        PL_OUTPUT := PL_OUTPUT || '   [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' Se asignarán '||SQL%ROWCOUNT||' gestores de tipo '||V_GESTOR(I)||'.'||CHR(10);
        V_COUNT_1 := V_COUNT_1 + SQL%ROWCOUNT;
        
    END LOOP;
    PL_OUTPUT := PL_OUTPUT || '   [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' En total se asignarán '||V_COUNT_1||' gestores.'||CHR(10);

    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','TMP_GEST_ACT','2');

    IF V_COUNT_1 > 0 THEN

	    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD (
	            GEE_ID,
	            USU_ID,
	            DD_TGE_ID,
	            VERSION,
	            USUARIOCREAR,
	            FECHACREAR,
	            BORRADO)
	        SELECT
	            TMP.GEE_ID,
	            TMP.USU_ID,
	            TGE.DD_TGE_ID,
	            0,
	            '''||V_USUARIO||''',
	            SYSDATE,
	            0
	        FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP
	        JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = TMP.TIPO_GESTOR';
                        
	    EXECUTE IMMEDIATE V_MSQL;
	    
	    PL_OUTPUT := PL_OUTPUT || '   [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' GEE_GESTOR_ENTIDAD cargada. '||SQL%ROWCOUNT||' Filas.'||CHR(10);

	    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO (
	            GEE_ID,
	            ACT_ID)
	        SELECT
	            TMP.GEE_ID,
	            TMP.ACT_ID
	        FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP';                        

	    EXECUTE IMMEDIATE V_MSQL;
	    
	    PL_OUTPUT := PL_OUTPUT || '   [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' GAC_GESTOR_ADD_ACTIVO cargada. '||SQL%ROWCOUNT||' Filas.'||CHR(10);

	    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST (
	            GEH_ID,
	            USU_ID,
	            DD_TGE_ID,
	            GEH_FECHA_DESDE,
	            GEH_FECHA_HASTA,
	            VERSION,
	            USUARIOCREAR,
	            FECHACREAR,
	            BORRADO)
	        SELECT
	            TMP.GEH_ID,
	            TMP.USU_ID,
	            TGE.DD_TGE_ID,
	            SYSDATE AS GEH_FECHA_DESDE,
	            NULL AS GEH_FECHA_HASTA,
	            1 AS VERSION,
	            '''||V_USUARIO||''' AS USUARIOCREAR,
	            SYSDATE AS FECHACREAR,
	            0 AS BORRADO
	        FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP
	        JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_CODIGO = TMP.TIPO_GESTOR';                       

	    EXECUTE IMMEDIATE V_MSQL;
	    
	    PL_OUTPUT := PL_OUTPUT || '   [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' GEH_GESTOR_ENTIDAD_HIST cargada. '||SQL%ROWCOUNT||' Filas.'||CHR(10);

	    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO (
	            GEH_ID,
	            ACT_ID)
	        SELECT
	            TMP.GEH_ID,
	            TMP.ACT_ID
	        FROM '||V_ESQUEMA||'.TMP_GEST_ACT TMP';                      

	    EXECUTE IMMEDIATE V_MSQL;
	    
	    PL_OUTPUT := PL_OUTPUT || '   [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' GAH_GESTOR_ACTIVO_HISTORICO cargada. '||SQL%ROWCOUNT||' Filas.'||CHR(10);

	    COMMIT;

	    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','GEE_GESTOR_ENTIDAD','2');
	    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','GAC_GESTOR_ADD_ACTIVO','2');
	    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','GEH_GESTOR_ENTIDAD_HIST','2');
	    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','GAH_GESTOR_ACTIVO_HISTORICO','2');

	    PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);

	ELSE

		PL_OUTPUT := PL_OUTPUT || '[FIN] - NO EXISTEN GESTORES A ASIGNAR.'||CHR(10);

	END IF;

EXCEPTION
    WHEN OTHERS THEN
        PL_OUTPUT := PL_OUTPUT || '[ERROR] Se ha producido un error en la ejecucion: ' || TO_CHAR(SQLCODE) || CHR(10);
        PL_OUTPUT := PL_OUTPUT || '-----------------------------------------------------------' || CHR(10);
        PL_OUTPUT := PL_OUTPUT || SQLERRM || CHR(10);
        PL_OUTPUT := PL_OUTPUT || V_MSQL || CHR(10);
        ROLLBACK;
        RAISE;
END SP_AGA_ASIGNA_GESTOR_ACTIVO_V3;
/
EXIT;
