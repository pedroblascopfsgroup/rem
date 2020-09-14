--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20200914
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11074
--## PRODUCTO=NO
--## Finalidad: 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
-- 0.1
DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    ERR_NUM NUMBER; -- N?mero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    V_MSQL := 'SELECT COUNT(1)
        FROM ALL_TAB_COLUMNS
        WHERE (TABLE_NAME, COLUMN_NAME, NULLABLE) IN (
            (''ACT_CONFIG_CTAS_CONTABLES'',''CCC_ARRENDAMIENTO'',''Y''),
            (''ACT_CONFIG_CTAS_CONTABLES'',''CCC_REFACTURABLE'',''Y''),
            (''ACT_CONFIG_CTAS_CONTABLES'',''CCC_PLAN_VISITAS'',''Y''),
            (''ACT_CONFIG_CTAS_CONTABLES'',''CCC_ACTIVABLE'',''Y'')
        )';
    EXECUTE IMMEDIATE V_MSQL INTO v_column_count;

    IF v_column_count = 4 THEN

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_CONFIG_CTAS_CONTABLES
            SET CCC_ARRENDAMIENTO = NVL2(CCC_ARRENDAMIENTO, CCC_ARRENDAMIENTO, 0)
                , CCC_REFACTURABLE = NVL2(CCC_REFACTURABLE, CCC_REFACTURABLE, 0)
                , CCC_PRINCIPAL = NVL2(CCC_PRINCIPAL, CCC_PRINCIPAL, 0)
                , CCC_PLAN_VISITAS = NVL2(CCC_PLAN_VISITAS, CCC_PLAN_VISITAS, 0)
                , CCC_ACTIVABLE = NVL2(CCC_ACTIVABLE, CCC_ACTIVABLE, 0)
            WHERE CCC_ARRENDAMIENTO IS NULL
                OR CCC_REFACTURABLE IS NULL
                OR CCC_PRINCIPAL IS NULL
                OR CCC_PLAN_VISITAS IS NULL
                OR CCC_ACTIVABLE IS NULL'; 
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('  [INFO] Se han actualizado '||SQL%ROWCOUNT||' en la tabla de cuentas contables.');

        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.ACT_CONFIG_CTAS_CONTABLES
            MODIFY (
                CCC_ARRENDAMIENTO DEFAULT 0 NOT NULL
                , CCC_REFACTURABLE DEFAULT 0 NOT NULL
                , CCC_PLAN_VISITAS DEFAULT 0 NOT NULL
                , CCC_ACTIVABLE DEFAULT 0 NOT NULL
            )';
        DBMS_OUTPUT.PUT_LINE('  [INFO] Campos alterados en ACT_CONFIG_CTAS_CONTABLES.');

    END IF;

    V_MSQL := 'SELECT COUNT(1)
        FROM ALL_TAB_COLUMNS
        WHERE (TABLE_NAME, COLUMN_NAME) IN (
            (''ACT_CONFIG_CTAS_CONTABLES'',''CPP_PRINCIPAL'')
        )';
    EXECUTE IMMEDIATE V_MSQL INTO v_column_count;

    IF v_column_count = 1 THEN

        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.ACT_CONFIG_CTAS_CONTABLES
            DROP COLUMN CPP_PRINCIPAL';
        DBMS_OUTPUT.PUT_LINE('  [INFO] Campos dropeados en ACT_CONFIG_CTAS_CONTABLES.');

    END IF;

    V_MSQL := 'SELECT COUNT(1)
        FROM ALL_TAB_COLUMNS
        WHERE (TABLE_NAME, COLUMN_NAME, NULLABLE) IN (
            (''ACT_CONFIG_PTDAS_PREP'',''CPP_ARRENDAMIENTO'',''Y''),
            (''ACT_CONFIG_PTDAS_PREP'',''CPP_REFACTURABLE'',''Y''),
            (''ACT_CONFIG_PTDAS_PREP'',''CPP_PLAN_VISITAS'',''Y''),
            (''ACT_CONFIG_PTDAS_PREP'',''CPP_ACTIVABLE'',''Y'')
        )';
    EXECUTE IMMEDIATE V_MSQL INTO v_column_count;

    IF v_column_count = 4 THEN

        V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_CONFIG_PTDAS_PREP
            SET CPP_ARRENDAMIENTO = NVL2(CPP_ARRENDAMIENTO, CPP_ARRENDAMIENTO, 0)
                , CPP_REFACTURABLE = NVL2(CPP_REFACTURABLE, CPP_REFACTURABLE, 0)
                , CPP_PLAN_VISITAS = NVL2(CPP_PLAN_VISITAS, CPP_PLAN_VISITAS, 0)
                , CPP_ACTIVABLE = NVL2(CPP_ACTIVABLE, CPP_ACTIVABLE, 0)
            WHERE CPP_ARRENDAMIENTO IS NULL
                OR CPP_REFACTURABLE IS NULL
                OR CPP_PLAN_VISITAS IS NULL
                OR CPP_ACTIVABLE IS NULL'; 
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('  [INFO] Se han actualizado '||SQL%ROWCOUNT||' en la tabla de partidas presupuestarias.');

        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.ACT_CONFIG_PTDAS_PREP
            MODIFY (
                CPP_ARRENDAMIENTO DEFAULT 0 NOT NULL
                , CPP_REFACTURABLE DEFAULT 0 NOT NULL
                , CPP_PLAN_VISITAS DEFAULT 0 NOT NULL
                , CPP_ACTIVABLE DEFAULT 0 NOT NULL
            )';
        DBMS_OUTPUT.PUT_LINE('  [INFO] Campos alterados en ACT_CONFIG_PTDAS_PREP.');

    END IF;

    V_MSQL := 'SELECT COUNT(1)
        FROM ALL_TAB_COLUMNS
        WHERE (TABLE_NAME, COLUMN_NAME) IN (
            (''ACT_CONFIG_PTDAS_PREP'',''CCC_PRINCIPAL'')
        )';
    EXECUTE IMMEDIATE V_MSQL INTO v_column_count;

    IF v_column_count = 1 THEN

        EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.ACT_CONFIG_PTDAS_PREP
            DROP COLUMN CCC_PRINCIPAL';
        DBMS_OUTPUT.PUT_LINE('  [INFO] Campos dropeados en ACT_CONFIG_PTDAS_PREP.');

    END IF;

    DBMS_OUTPUT.PUT_LINE('[FIN]');
  
    EXCEPTION
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY); 
    -- SIEMPRE DEBE HABER UN OTHERS
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
