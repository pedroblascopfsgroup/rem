--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20200922
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11250
--## PRODUCTO=NO
--## 
--## Finalidad:  Creación del SP SP_EXT_TIPO_DIARIO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1-Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE       SP_ACTUALIZA_DIARIOS (
    GPV_ID          IN NUMBER
    , V_USUARIO     IN VARCHAR2
) AS

V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar.
V_COUNT NUMBER(25); -- Variable para validaciones
V_COUNT_DIARIOS NUMBER(1); -- Variable para informar de diarios actualizados.
V_COUNT_IMPORTES NUMBER(16); -- Variable para informar de importes actualizados.
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema.
COD_RETORNO VARCHAR2(4000 CHAR);
RESULTADO VARCHAR2(4000 CHAR);
V_FECHA VARCHAR2(19 CHAR);
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.

BEGIN

    V_SQL := 'SELECT TO_CHAR(SYSDATE,''DD/MM/YYYY HH24:MI:SS'') 
        FROM DUAL';
    EXECUTE IMMEDIATE V_SQL INTO V_FECHA;

    V_SQL := 'SELECT COUNT(1)
        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
        WHERE GPV_ID = '||GPV_ID;
    EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

    IF V_COUNT = 0 THEN

        RESULTADO := 'KO';
        COD_RETORNO := 'No existe el gasto. (Información actualizada el '||V_FECHA||')';

    ELSE

        V_SQL := 'SELECT COUNT(1)
            FROM '||V_ESQUEMA||'.GLD_ENT GEN
            JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GLD_ID = GEN.GLD_ID
                AND GLD.BORRADO = 0
            JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID
                AND ENT.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.ACT_ETD_ENT_TDI ETD ON ETD.ENT_ID = GEN.ENT_ID
                AND ETD.BORRADO = 0
            WHERE GEN.BORRADO = 0
                AND ENT.DD_ENT_CODIGO IN (''ACT'', ''GEN'')
                AND GLD.GPV_ID = '||GPV_ID;
        EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

        IF V_COUNT = 0 THEN

            V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GIL_GASTOS_IMPORTES_LIBERBANK T1
                USING (
                    SELECT GIL.GIL_ID
                    FROM '||V_ESQUEMA||'.GIL_GASTOS_IMPORTES_LIBERBANK GIL
                    WHERE GIL.BORRADO = 0
                        AND GIL.GPV_ID = '||GPV_ID||'
                ) T2
                ON (T1.GIL_ID = T2.GIL_ID)
                WHEN MATCHED THEN
                    UPDATE SET T1.IMPORTE_ACTIVO = NULL
                        , T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        , T1.FECHAMODIFICAR = CURRENT_TIMESTAMP(6)
                        , T1.USUARIOBORRAR = '''||V_USUARIO||'''
                        , T1.FECHABORRAR = CURRENT_TIMESTAMP(6)
                        , T1.BORRADO = 1';
            EXECUTE IMMEDIATE V_SQL;

            RESULTADO := 'KO';
            COD_RETORNO := 'El gasto no tiene distribución por activos/genéricos o han sido eliminados. (Información actualizada el '||V_FECHA||')';

        ELSE

            V_SQL := 'SELECT COUNT(1)
                FROM '||V_ESQUEMA||'.ACT_ETD_ENT_TDI ETD
                JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = ETD.DD_ENT_ID
                    AND ENT.BORRADO = 0
                JOIN '||V_ESQUEMA||'.GLD_ENT GEN ON GEN.ENT_ID = ETD.ENT_ID
                    AND GEN.BORRADO = 0
                JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GLD_ID = GEN.GLD_ID
                    AND GLD.BORRADO = 0
                WHERE ENT.DD_ENT_CODIGO IN (''ACT'', ''GEN'')
                    AND ETD.BORRADO = 0
                    AND GLD.GPV_ID = '||GPV_ID;
            EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

            IF V_COUNT = 0 THEN

                RESULTADO := 'KO';
                COD_RETORNO := 'Sin información de tipos de diario para los activos/genéricos del gasto. (Información actualizada el '||V_FECHA||')';

            ELSE

                V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GDL_GASTOS_DIARIOS_LIBERBANK T1
                    USING (
                        SELECT GPV_ID
                            , DIARIO1
                            , DIARIO1_BASE
                            , DIARIO1_TIPO
                            , DIARIO1_CUOTA
                            , DIARIO2
                            , DIARIO2_BASE
                            , DIARIO2_TIPO
                            , DIARIO2_CUOTA
                        FROM '||V_ESQUEMA||'.V_DIARIOS_CALCULO_LBK
                        WHERE DIARIO1 IS NOT NULL
                            AND GPV_ID = '||GPV_ID||'
                    )T2
                    ON (T1.GPV_ID = T2.GPV_ID
                        AND T1.BORRADO = 0)
                    WHEN MATCHED THEN
                        UPDATE SET
                            T1.DIARIO1 = T2.DIARIO1
                            , T1.DIARIO1_BASE = T2.DIARIO1_BASE
                            , T1.DIARIO1_TIPO = T2.DIARIO1_TIPO
                            , T1.DIARIO1_CUOTA = T2.DIARIO1_CUOTA
                            , T1.DIARIO2 = T2.DIARIO2
                            , T1.DIARIO2_BASE = T2.DIARIO2_BASE
                            , T1.DIARIO2_TIPO = T2.DIARIO2_TIPO
                            , T1.DIARIO2_CUOTA = T2.DIARIO2_CUOTA
                            , T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                            , T1.FECHAMODIFICAR = CURRENT_TIMESTAMP(6)
                    WHEN NOT MATCHED THEN
                        INSERT
                            (T1.GDL_ID
                            , T1.GPV_ID
                            , T1.DIARIO1
                            , T1.DIARIO1_BASE
                            , T1.DIARIO1_TIPO
                            , T1.DIARIO1_CUOTA
                            , T1.DIARIO2
                            , T1.DIARIO2_BASE
                            , T1.DIARIO2_TIPO
                            , T1.DIARIO2_CUOTA
                            , T1.USUARIOCREAR)
                        VALUES
                            (REM01.S_GDL_GASTOS_DIARIOS_LIBERBANK.NEXTVAL
                            , T2.GPV_ID
                            , T2.DIARIO1
                            , T2.DIARIO1_BASE
                            , T2.DIARIO1_TIPO
                            , T2.DIARIO1_CUOTA
                            , T2.DIARIO2
                            , T2.DIARIO2_BASE
                            , T2.DIARIO2_TIPO
                            , T2.DIARIO2_CUOTA
                            , '''||V_USUARIO||'''
                            )';
                EXECUTE IMMEDIATE V_SQL;
                V_COUNT_DIARIOS := SQL%ROWCOUNT;

                IF V_COUNT_DIARIOS = 1 THEN

                    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.GIL_GASTOS_IMPORTES_LIBERBANK T1
                        USING (
                            SELECT GIL.GIL_ID
                                , VIL.IMPORTE_ACTIVO
                            FROM '||V_ESQUEMA||'.GIL_GASTOS_IMPORTES_LIBERBANK GIL
                            LEFT JOIN '||V_ESQUEMA||'.V_IMPORTES_GASTOS_LBK VIL ON VIL.GPV_ID = GIL.GPV_ID
                                AND VIL.ENT_ID = GIL.ENT_ID
                                AND VIL.DD_ENT_ID = GIL.DD_ENT_ID
                            WHERE GIL.BORRADO = 0
                                AND GIL.GPV_ID = '||GPV_ID||'
                        ) T2
                        ON (T1.GIL_ID = T2.GIL_ID)
                        WHEN MATCHED THEN
                            UPDATE SET T1.IMPORTE_ACTIVO = T2.IMPORTE_ACTIVO
                                , T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                                , T1.FECHAMODIFICAR = CURRENT_TIMESTAMP(6)
                                , T1.USUARIOBORRAR = CASE WHEN T2.IMPORTE_ACTIVO IS NULL THEN '''||V_USUARIO||''' END
                                , T1.FECHABORRAR = CASE WHEN T2.IMPORTE_ACTIVO IS NULL THEN CURRENT_TIMESTAMP(6) END
                                , T1.BORRADO = CASE WHEN T2.IMPORTE_ACTIVO IS NULL THEN 1 ELSE 0 END';
                    EXECUTE IMMEDIATE V_SQL;
                    V_COUNT_IMPORTES := SQL%ROWCOUNT;

                    V_SQL := 'INSERT INTO '||V_ESQUEMA||'.GIL_GASTOS_IMPORTES_LIBERBANK (
                            GIL_ID
                            , GPV_ID
                            , ENT_ID
                            , DD_ENT_ID
                            , IMPORTE_ACTIVO
                            , USUARIOCREAR
                        )
                        SELECT '||V_ESQUEMA||'.S_GIL_GASTOS_IMPORTES_LIBERBANK.NEXTVAL
                            , VIL.GPV_ID
                            , VIL.ENT_ID
                            , VIL.DD_ENT_ID
                            , VIL.IMPORTE_ACTIVO
                            , '''||V_USUARIO||'''
                        FROM '||V_ESQUEMA||'.V_IMPORTES_GASTOS_LBK VIL
                        LEFT JOIN '||V_ESQUEMA||'.GIL_GASTOS_IMPORTES_LIBERBANK GIL ON GIL.GPV_ID = VIL.GPV_ID
                            AND GIL.ENT_ID = VIL.ENT_ID
                            AND GIL.DD_ENT_ID = VIL.DD_ENT_ID
                            AND GIL.BORRADO = 0
                        WHERE GIL.GIL_ID IS NULL
                            AND VIL.GPV_ID = '||GPV_ID;
                    EXECUTE IMMEDIATE V_SQL;
                    V_COUNT_IMPORTES := V_COUNT_IMPORTES + SQL%ROWCOUNT;

                    IF V_COUNT_IMPORTES > 0 THEN

                        RESULTADO := 'OK';
                        COD_RETORNO := 'La información de diarios ('||V_COUNT_DIARIOS||') y repartos ('||V_COUNT_IMPORTES||') del gasto '||GPV_ID||', se ha fusionado. (Información actualizada el '||V_FECHA||')';

                    ELSE

                        RESULTADO := 'KO';
                        COD_RETORNO := 'Se ha fusionado la información de diarios ('||V_COUNT_DIARIOS||') del gasto '||GPV_ID||', pero no ha podido fusionarse la de repartos ('||V_COUNT_IMPORTES||'). (Información actualizada el '||V_FECHA||')';

                    END IF;

                ELSE

                    RESULTADO := 'KO';
                    COD_RETORNO := 'No ha sido posible fusionar la información de los diarios del gasto '||GPV_ID||'. (Información actualizada el '||V_FECHA||')';

                END IF;

            END IF;

        END IF;

    END IF;

    V_SQL := 'MERGE INTO '||V_ESQUEMA||'.MSG_CALC_DIARIOS T1
            USING (SELECT '||GPV_ID||' GPV_ID
                    , '''||RESULTADO||''' RESULTADO
                    , '''||COD_RETORNO||''' COD_RETORNO
                FROM DUAL) T2
            ON (T1.GPV_ID = T2.GPV_ID)
            WHEN MATCHED THEN UPDATE SET
                T1.RESULTADO = T2.RESULTADO
                , T1.ERR_MSG = T2.COD_RETORNO
            WHEN NOT MATCHED THEN INSERT (T1.GPV_ID, T1.RESULTADO, T1.ERR_MSG)
            VALUES (
                T2.GPV_ID
                , T2.RESULTADO
                , T2.COD_RETORNO
            )';
    EXECUTE IMMEDIATE V_SQL;
    COMMIT;


EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      ERR_NUM := SQLCODE;
      RAISE;
END SP_ACTUALIZA_DIARIOS;
/
EXIT
