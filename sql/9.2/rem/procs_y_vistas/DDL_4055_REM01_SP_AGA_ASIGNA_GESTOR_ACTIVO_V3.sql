--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20190216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5387
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
--##        0.6 HREOS-5387 Daniel Algaba: añadimos el Supervisor comercial Backoffice Inmobiliario
--##		0.7 HREOS-5049 Carlos López: Optimización
--##		0.8 HREOS-5160 Mariam Lliso: modificada la asignación de gestores
--##		0.9 HREOS-5239 Daniel Algaba: corrección multicartera CERBERUS
--##        1.0 HREOS-5443 Daniel Algaba: corrección para que no filtre por la TMP_GEST_CONT en activos con subcarteras
--##        1.1 HREOS-5387 Daniel Algaba: añadimos el Supervisor comercial Backoffice Inmobiliario
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
--v1.0

    V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
    V_MSQL VARCHAR2(4000 CHAR);
    V_NUM NUMBER(16);
    V_COUNT_1 NUMBER(16) := 0;
    V_COUNT_GES NUMBER(16) := 0;
    V_ACT_ID VARCHAR2(50 CHAR) := NULL;
    V_CLASE_ACTIVO VARCHAR (500 CHAR);
    V_CLASE_ACTIVO_NULL VARCHAR (500 CHAR);

    V_GESTOR_FINANCIERO VARCHAR2(4000 CHAR) := ' (''GPUBL'',''SPUBL'',''GCOM'',''SCOM'',''FVDNEG'',''FVDBACKOFR'',''FVDBACKVNT'',''SUPFVD'',''SFORM'',''GCODI'',''GCOINM'',''GCOIN'',''GLIBINVINM'',''GLIBSINTER'',''GLIBRES'',''GESRES'',''SUPRES'',''HAYAGBOINM'',''HAYASBOINM'') ';
    V_GESTOR_INMOBILIAR VARCHAR2(4000 CHAR) := ' (''GADM'',''SUPADM'',''GACT'',''SUPACT'',''GPREC'',''SPREC'',''GPUBL'',''SPUBL'',''GCOM'',''SCOM'',''FVDNEG'',''FVDBACKOFR'',''FVDBACKVNT'',''SUPFVD'',''SFORM'',''GGADM'',''GIAFORM'',''GTOCED'',''CERT'',''GIAADMT'',''PTEC'', ''GTREE'',''GCODI'',''GCOINM'',''GCOIN'',''GLIBINVINM'',''GLIBSINTER'',''GLIBRES'',''HAYAGBOINM'',''HAYASBOINM'',''SBACKOFFICEINMLIBER'',''GEDI'', ''SUPEDI'', ''GSUE'', ''SUPSUE'',''GALQ'',''SUALQ'', ''GESTCOMALQ'', ''SUPCOMALQ'', ''GFORMADM'')';
    V_GESTOR            VARCHAR2(4000 CHAR);

    CURSOR C_LOG IS
       SELECT COUNT(1) NUM
            , TIPO_GESTOR
         FROM #ESQUEMA#.TMP_GEST_ACT
         GROUP BY TIPO_GESTOR;
BEGIN
    PL_OUTPUT := '[INICIO]'||CHR(10);

    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE','TMP_GEST_ACT');
    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE','TMP_GEST_GAH');
    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE','TMP_GEST_CONT');
    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('TRUNCATE','TMP_V_GESTORES_ACTIVO');

    IF P_CLASE_ACTIVO = '01' THEN --ACTIVOS FINANCIEROS
        V_GESTOR := V_GESTOR_FINANCIERO;
        V_CLASE_ACTIVO :=  'JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
            JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND SCR.DD_SCR_ID = ACT.DD_SCR_ID
            WHERE SCR.DD_SCR_CODIGO IN (''01'',''03'',''05'',''10'',''12'',''21'',''134'',''38'',''00'')';
        V_CLASE_ACTIVO_NULL :=  'LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
            LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND SCR.DD_SCR_ID = ACT.DD_SCR_ID
            WHERE SCR.DD_SCR_CODIGO IS NULL';
    ELSIF P_CLASE_ACTIVO = '02' THEN-- ACTIVOS INMOBILIAROS
        V_GESTOR := V_GESTOR_INMOBILIAR;
        V_CLASE_ACTIVO := 'JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
            JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND SCR.DD_SCR_ID = ACT.DD_SCR_ID
            WHERE SCR.DD_SCR_CODIGO NOT IN (''01'',''03'',''05'',''10'',''12'',''21'',''134'',''38'',''00'')';
        V_CLASE_ACTIVO_NULL := 'LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
            LEFT JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID AND SCR.DD_SCR_ID = ACT.DD_SCR_ID
            WHERE SCR.DD_SCR_CODIGO IS NULL';
    END IF;

    IF P_ACT_ID IS NOT NULL THEN --SI SE PASA UN ACTIVO, SE HARÁ ÚNICAMENTE PARA EL MISMO
        V_ACT_ID := ' AND ACT.ACT_ID = '||P_ACT_ID;
    END IF;

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_V_GESTORES_ACTIVO (
                    ACT_ID, TIPO_GESTOR, USERNAME )
              SELECT ACT.ACT_ID,ACT.TIPO_GESTOR, ACT.USERNAME
                FROM '||V_ESQUEMA||'.V_GESTORES_ACTIVO ACT
               WHERE ACT.TIPO_GESTOR IN '||V_GESTOR||
               V_ACT_ID
               ;

    EXECUTE IMMEDIATE V_MSQL;

    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','TMP_V_GESTORES_ACTIVO');


    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_GEST_GAH (
                    ACT_ID, TIPO_GESTOR )
              SELECT ACT.ACT_ID,TGE.DD_TGE_CODIGO
                FROM '||V_ESQUEMA||'.GAH_GESTOR_ACTIVO_HISTORICO ACT
                JOIN '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO GAC        ON GAC.ACT_ID    = ACT.ACT_ID
                JOIN '||V_ESQUEMA||'.GEH_GESTOR_ENTIDAD_HIST GEH      ON GEH.GEH_ID    = ACT.GEH_ID AND GEH.BORRADO = 0
                JOIN '||V_ESQUEMA||'.GEE_GESTOR_ENTIDAD GEE           ON GEE.GEE_ID    = GAC.GEE_ID AND GEE.BORRADO = 0
                JOIN '||V_ESQUEMA_MASTER||'.DD_TGE_TIPO_GESTOR TGE    ON TGE.DD_TGE_ID = GEE.DD_TGE_ID
                                                                      AND TGE.DD_TGE_ID = GEH.DD_TGE_ID
                                                                      AND TGE.BORRADO = 0
                                                                      AND TGE.DD_TGE_CODIGO IN '||V_GESTOR||
                V_ACT_ID;

    EXECUTE IMMEDIATE V_MSQL;

    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','TMP_GEST_GAH');


    --------------------------------------------------------------------
    ----------- ASIGNAMOS GESTORES ---------------------------
    --------------------------------------------------------------------

        V_MSQL := ' INSERT INTO '||V_ESQUEMA||'.TMP_GEST_CONT (NUMERO, TIPO_GESTOR)
          SELECT COUNT(1),GEST.TIPO_GESTOR
            FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
            /*JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO pac on act.act_id = pac.act_id and pac.borrado = 0 and pac.PAC_INCLUIDO = 0 *//*en perimetro haya*/
            /*JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO NOT IN (''05'')*/ /*VENDIDO*/
            JOIN '||V_ESQUEMA||'.TMP_V_GESTORES_ACTIVO GEST ON ACT.ACT_ID = GEST.ACT_ID AND GEST.TIPO_GESTOR IN '||V_GESTOR||'
            JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEST.USERNAME
            '||V_CLASE_ACTIVO_NULL||'
                AND ACT.BORRADO = 0
                AND NOT EXISTS (
                    SELECT 1
                      FROM '||V_ESQUEMA||'.TMP_GEST_ACT GAH
                     WHERE ACT.ACT_ID = GAH.ACT_ID)
                '||V_ACT_ID||
         ' GROUP BY GEST.TIPO_GESTOR ' ;

        EXECUTE IMMEDIATE V_MSQL ;
        
        #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','TMP_GEST_CONT');

        --IF V_COUNT_GES = 0 THEN

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
              /*JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO pac on act.act_id = pac.act_id and pac.borrado = 0 and pac.PAC_INCLUIDO = 0 *//*en perimetro haya*/
              /*JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO NOT IN (''05'')*/ /*VENDIDO*/
                JOIN '||V_ESQUEMA||'.TMP_V_GESTORES_ACTIVO GEST ON ACT.ACT_ID = GEST.ACT_ID AND GEST.TIPO_GESTOR IN '||V_GESTOR||'
                JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEST.USERNAME
                '||V_CLASE_ACTIVO||'
                    AND ACT.BORRADO = 0
                    AND NOT EXISTS (
                        SELECT 1
                          FROM '||V_ESQUEMA||'.TMP_GEST_GAH GAH
                         WHERE ACT.ACT_ID = GAH.ACT_ID
                           AND GEST.TIPO_GESTOR = GAH.TIPO_GESTOR)
                    '||V_ACT_ID;

            EXECUTE IMMEDIATE V_MSQL;

            V_COUNT_1 := SQL%ROWCOUNT;
            
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
                /*JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO pac on act.act_id = pac.act_id and pac.borrado = 0 and pac.PAC_INCLUIDO = 0 *//*en perimetro haya*/
                /*JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID AND SCM.DD_SCM_CODIGO NOT IN (''05'')*/ /*VENDIDO*/
                JOIN '||V_ESQUEMA||'.TMP_V_GESTORES_ACTIVO GEST ON ACT.ACT_ID = GEST.ACT_ID AND GEST.TIPO_GESTOR IN '||V_GESTOR||'
                JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU ON USU.USU_USERNAME = GEST.USERNAME
                '||V_CLASE_ACTIVO_NULL||'
                    AND ACT.BORRADO = 0
                    AND NOT EXISTS (
                        SELECT 1
                          FROM '||V_ESQUEMA||'.TMP_GEST_GAH GAH
                         WHERE ACT.ACT_ID = GAH.ACT_ID
                           AND GEST.TIPO_GESTOR = GAH.TIPO_GESTOR)
                    AND EXISTS (SELECT 1
                                  FROM TMP_GEST_CONT CONT
                                 WHERE CONT.TIPO_GESTOR = GEST.TIPO_GESTOR)
                    '||V_ACT_ID;

            EXECUTE IMMEDIATE V_MSQL;
            V_COUNT_1 := V_COUNT_1 + SQL%ROWCOUNT;


    FOR R IN C_LOG LOOP
      PL_OUTPUT := PL_OUTPUT || '   [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' Se asignarán '||R.NUM||' gestores de tipo '||R.TIPO_GESTOR||'.'||CHR(10);
    END LOOP;

    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','TMP_GEST_ACT');

    PL_OUTPUT := PL_OUTPUT || '   [INFO] - '||TO_CHAR(SYSDATE,'HH24:MI:SS')||' En total se asignarán '||V_COUNT_1||' gestores.'||CHR(10);


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

      IF P_ACT_ID IS NULL THEN
        #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','GEE_GESTOR_ENTIDAD','2');
        #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','GAC_GESTOR_ADD_ACTIVO','2');
        #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','GEH_GESTOR_ENTIDAD_HIST','2');
        #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','GAH_GESTOR_ACTIVO_HISTORICO','2');
      END IF;

        PL_OUTPUT := PL_OUTPUT || '[FIN]'||CHR(10);

      ELSE

          PL_OUTPUT := PL_OUTPUT || '[FIN] - NO EXISTEN GESTORES A ASIGNAR.'||CHR(10);

      END IF;

    COMMIT;

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
