--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20201113
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11745
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CONFIG_PTDAS_PREP los datos añadidos en T_ARRAY_DATA
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-11745';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_PTDAS_PREP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
	  V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.

    V_CONSTRAINT_NAME VARCHAR2(30 CHAR);

    CURSOR CONSTRAINTS_ENABLED IS SELECT CONSTRAINT_NAME
      FROM ALL_CONSTRAINTS
      WHERE TABLE_NAME = 'ACT_CONFIG_PTDAS_PREP'
          AND STATUS = 'ENABLED'
          AND CONSTRAINT_TYPE IN ('C', 'U', 'F', 'P');

    CURSOR CONSTRAINTS_DISABLED IS SELECT CONSTRAINT_NAME 
      FROM ALL_CONSTRAINTS
      WHERE TABLE_NAME = 'ACT_CONFIG_PTDAS_PREP'
          AND STATUS = 'DISABLED'
          AND CONSTRAINT_TYPE IN ('C', 'U', 'F', 'P');
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

    --ANALIZAMOS LA TABLA
    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','ACT_CONFIG_PTDAS_PREP');
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TEXT_TABLA||' analizada.');

    /*--DESACTIVAMOS CLAVES ANTES DE EMPEZAR PARA MEJORAR EL DESEMPEÑO
    FOR CLAVES IN CONSTRAINTS_ENABLED 
      LOOP

        V_CONSTRAINT_NAME := CLAVES.CONSTRAINT_NAME; 

        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
          DISABLE CONSTRAINT '||V_CONSTRAINT_NAME;
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Desactivada la clave '||V_CONSTRAINT_NAME);

      END LOOP;*/

    DBMS_OUTPUT.PUT_LINE('[INFO] Vaciamos tabla temporal... ');
    V_SQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA;
    EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id de la cartera, porque es el mismo para todos.');

    V_SQL :=    'SELECT DD_CRA_ID 
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
                WHERE DD_CRA_CODIGO = ''08''';
    EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;
	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN TMP_'||V_TEXT_TABLA||' ');
    V_MSQL := '
      INSERT INTO '|| V_ESQUEMA ||'.TMP_'||V_TEXT_TABLA||' (' ||
        ' CPP_PTDAS_ID, CPP_PARTIDA_PRESUPUESTARIA, DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, DD_SCR_ID'||
        '  , PRO_ID, EJE_ID, CPP_ARRENDAMIENTO, CPP_REFACTURABLE, FECHACREAR, BORRADO)'||
        ' SELECT ROWNUM, CPP.CPP_PARTIDA_PRESUPUESTARIA, STG.DD_TGA_ID, STG.DD_STG_ID, TIM.DD_TIM_ID, CPP.DD_CRA_ID, CPP.DD_SCR_ID'||
        '  , CPP.PRO_ID, CPP.EJE_ID, CPP.CPP_ARRENDAMIENTO, CPP.CPP_REFACTURABLE, SYSDATE, 0'||
        ' FROM '||V_ESQUEMA||'.CPP_CONFIG_PTDAS_PREP CPP'||
        ' JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CPP.DD_STG_ID'||
        '  AND STG.BORRADO = 0'||
        ' JOIN '||V_ESQUEMA||'.DD_TIM_TIPO_IMPORTE TIM ON TIM.DD_TIM_CODIGO = ''BAS'''||
        '  AND TIM.BORRADO = 0'||
        ' WHERE CPP.BORRADO = 0 '||
        '  AND CPP.CPP_PARTIDA_PRESUPUESTARIA IS NOT NULL'||
        '  AND CPP.DD_CRA_ID IS NOT NULL'||
        '  AND CPP.DD_CRA_ID <> '||V_DD_CRA_ID||'
      ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: Tabla TMP_'||V_TEXT_TABLA||' RELLENADA CORRECTAMENTE CON '||SQL%ROWCOUNT||' REGISTROS.');

    DBMS_OUTPUT.PUT_LINE('[INFO]: Tabla TMP_'||V_TEXT_TABLA||' MODIFICADA CORRECTAMENTE ');

    DBMS_OUTPUT.PUT_LINE('[INFO]: Preparamos partidas para tabla de negocio.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' T1
      USING (
          SELECT CPP_PTDAS_ID
              , ROW_NUMBER() OVER(
                  PARTITION BY DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, DD_SCR_ID
                      , PRO_ID, EJE_ID, CPP_ARRENDAMIENTO, CPP_REFACTURABLE, DD_TBE_ID
                      , CPP_ACTIVABLE, CPP_PLAN_VISITAS, DD_TCH_ID, DD_TRT_ID
                      , CPP_VENDIDO
                  ORDER BY CPP_PTDAS_ID
              ) RN
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      ) T2
      ON (T1.CPP_PTDAS_ID = T2.CPP_PTDAS_ID)
      WHEN MATCHED THEN 
          UPDATE SET T1.CPP_PRINCIPAL = CASE WHEN T2.RN = 1 THEN 1 ELSE 0 END';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      SET DD_TIM_ID = (SELECT DD_TIM_ID FROM DD_TIM_TIPO_IMPORTE WHERE DD_TIM_CODIGO = ''BAS'')
      WHERE DD_TIM_ID IS NULL';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' T1
      USING (
          SELECT CPP_PTDAS_ID
              , ROW_NUMBER() OVER(
                  PARTITION BY DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, DD_SCR_ID
                      , PRO_ID, EJE_ID, CPP_ARRENDAMIENTO, CPP_REFACTURABLE, DD_TBE_ID
                      , CPP_ACTIVABLE, CPP_PLAN_VISITAS, DD_TCH_ID, DD_TRT_ID
                      , CPP_VENDIDO
                  ORDER BY CPP_PTDAS_ID
              ) RN
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
          WHERE CPP_PRINCIPAL = 0
      ) T2
      ON (T1.CPP_PTDAS_ID = T2.CPP_PTDAS_ID AND T2.RN > 1)
      WHEN MATCHED THEN
          UPDATE SET T1.BORRADO = 1';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      WHERE BORRADO = 1';
    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: Partidas preparadas.');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
          CPP_PTDAS_ID
          , CPP_PARTIDA_PRESUPUESTARIA
          , DD_TGA_ID
          , DD_STG_ID
          , DD_TIM_ID
          , DD_CRA_ID
          , DD_SCR_ID
          , PRO_ID
          , EJE_ID
          , CPP_ARRENDAMIENTO
          , CPP_REFACTURABLE
          , USUARIOCREAR
          , FECHACREAR
          , DD_TBE_ID
          , CPP_APARTADO
          , CPP_CAPITULO
          , CPP_ACTIVABLE
          , CPP_PLAN_VISITAS
          , DD_TCH_ID
          , CPP_PRINCIPAL
          , DD_TRT_ID
          , CPP_VENDIDO
      )
      SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
          , CPP.CPP_PARTIDA_PRESUPUESTARIA
          , CPP.DD_TGA_ID
          , CPP.DD_STG_ID
          , CPP.DD_TIM_ID
          , CPP.DD_CRA_ID
          , CPP.DD_SCR_ID
          , CPP.PRO_ID
          , CPP.EJE_ID
          , CPP.CPP_ARRENDAMIENTO
          , CPP.CPP_REFACTURABLE
          , '''||V_ITEM||'''
          , SYSDATE
          , CPP.DD_TBE_ID
          , CPP.CPP_APARTADO
          , CPP.CPP_CAPITULO
          , CPP.CPP_ACTIVABLE
          , CPP.CPP_PLAN_VISITAS
          , CPP.DD_TCH_ID
          , CPP.CPP_PRINCIPAL
          , CPP.DD_TRT_ID
          , CPP.CPP_VENDIDO
      FROM (
          SELECT TMP.CPP_PARTIDA_PRESUPUESTARIA
              , TMP.DD_TGA_ID
              , TMP.DD_STG_ID
              , TMP.DD_TIM_ID
              , TMP.DD_CRA_ID
              , TMP.DD_SCR_ID
              , PRO.PRO_ID
              , TMP.PRO_ID TMP_PRO
              , TMP.EJE_ID
              , TMP.CPP_ARRENDAMIENTO
              , TMP.CPP_REFACTURABLE
              , NULL DD_TBE_ID
              , TMP.CPP_APARTADO
              , TMP.CPP_CAPITULO
              , 0 CPP_ACTIVABLE
              , 0 CPP_PLAN_VISITAS
              , NULL DD_TCH_ID
              , TMP.CPP_PRINCIPAL
              , NULL DD_TRT_ID
              , VEN.NUMERO CPP_VENDIDO
              , RANK() OVER(
                  PARTITION BY TMP.DD_TGA_ID, TMP.DD_STG_ID, TMP.DD_TIM_ID, TMP.DD_CRA_ID, TMP.DD_SCR_ID, TMP.EJE_ID, PRO.PRO_ID, TMP.CPP_ARRENDAMIENTO, TMP.CPP_REFACTURABLE
                      , TMP.CPP_PRINCIPAL
                  ORDER BY 
                      CASE 
                          WHEN TMP.PRO_ID IS NOT NULL AND NVL(PRO.PRO_ID, 0) = NVL(TMP.PRO_ID, 0) THEN 0
                          WHEN TMP.PRO_ID IS NULL AND NVL(PRO.PRO_ID, 0) <> NVL(TMP.PRO_ID, 0) THEN 1
                          ELSE 2
                      END
                  ) RN 
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' TMP
          JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = TMP.DD_CRA_ID
              AND CRA.BORRADO = 0
          JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.DD_CRA_ID = CRA.DD_CRA_ID
              AND PRO.BORRADO = 0
          JOIN '||V_ESQUEMA||'.AUX_CERO_UNO VEN ON 1 = 1
          WHERE TMP.DD_SCR_ID IS NOT NULL
              AND TMP.BORRADO = 0
      ) CPP
      WHERE CPP.RN = 1
          AND (CPP.TMP_PRO = CPP.PRO_ID OR CPP.TMP_PRO IS NULL)
          AND NOT EXISTS (
              SELECT 1
              FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AUX
              WHERE AUX.DD_TGA_ID = CPP.DD_TGA_ID
                  AND AUX.DD_STG_ID = CPP.DD_STG_ID
                  AND AUX.DD_TIM_ID = CPP.DD_TIM_ID
                  AND AUX.DD_CRA_ID = CPP.DD_CRA_ID
                  AND NVL(AUX.DD_SCR_ID, 0) = NVL(CPP.DD_SCR_ID, NVL(AUX.DD_SCR_ID, 0))
                  AND AUX.PRO_ID = CPP.PRO_ID
                  AND AUX.EJE_ID = CPP.EJE_ID
                  AND NVL(AUX.CPP_ARRENDAMIENTO, 0) = NVL(CPP.CPP_ARRENDAMIENTO, NVL(AUX.CPP_ARRENDAMIENTO, 0))
                  AND AUX.CPP_REFACTURABLE = CPP.CPP_REFACTURABLE
                  AND NVL(AUX.DD_TBE_ID, 0) = NVL(CPP.DD_TBE_ID, 0)
                  AND AUX.CPP_ACTIVABLE = CPP.CPP_ACTIVABLE
                  AND AUX.CPP_PLAN_VISITAS = CPP.CPP_PLAN_VISITAS
                  AND NVL(AUX.DD_TCH_ID, 0) = NVL(CPP.DD_TCH_ID, 0)
                  AND AUX.CPP_PRINCIPAL = CPP.CPP_PRINCIPAL
                  AND NVL(AUX.DD_TRT_ID, 0) = NVL(CPP.DD_TRT_ID, 0)
                  AND NVL(AUX.CPP_VENDIDO, 0) = NVL(CPP.CPP_VENDIDO, NVL(AUX.CPP_VENDIDO, 0))
                  AND AUX.BORRADO = 0
    )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' partidas con subcartera inicial insertadas');

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
          CPP_PTDAS_ID
          , CPP_PARTIDA_PRESUPUESTARIA
          , DD_TGA_ID
          , DD_STG_ID
          , DD_TIM_ID
          , DD_CRA_ID
          , DD_SCR_ID
          , PRO_ID
          , EJE_ID
          , CPP_ARRENDAMIENTO
          , CPP_REFACTURABLE
          , USUARIOCREAR
          , FECHACREAR
          , DD_TBE_ID
          , CPP_APARTADO
          , CPP_CAPITULO
          , CPP_ACTIVABLE
          , CPP_PLAN_VISITAS
          , DD_TCH_ID
          , CPP_PRINCIPAL
          , DD_TRT_ID
          , CPP_VENDIDO
      )
      SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
          , CPP.CPP_PARTIDA_PRESUPUESTARIA
          , CPP.DD_TGA_ID
          , CPP.DD_STG_ID
          , CPP.DD_TIM_ID
          , CPP.DD_CRA_ID
          , CPP.DD_SCR_ID
          , CPP.PRO_ID
          , CPP.EJE_ID
          , CPP.CPP_ARRENDAMIENTO
          , CPP.CPP_REFACTURABLE
          , '''||V_ITEM||'''
          , SYSDATE
          , CPP.DD_TBE_ID
          , CPP.CPP_APARTADO
          , CPP.CPP_CAPITULO
          , CPP.CPP_ACTIVABLE
          , CPP.CPP_PLAN_VISITAS
          , CPP.DD_TCH_ID
          , CPP.CPP_PRINCIPAL
          , CPP.DD_TRT_ID
          , CPP.CPP_VENDIDO
      FROM (
          SELECT TMP.CPP_PARTIDA_PRESUPUESTARIA
              , TMP.DD_TGA_ID
              , TMP.DD_STG_ID
              , TMP.DD_TIM_ID
              , TMP.DD_CRA_ID
              , SCR.DD_SCR_ID
              , PRO.PRO_ID
              , TMP.PRO_ID TMP_PRO
              , TMP.EJE_ID
              , TMP.CPP_ARRENDAMIENTO
              , TMP.CPP_REFACTURABLE
              , NULL DD_TBE_ID
              , TMP.CPP_APARTADO
              , TMP.CPP_CAPITULO
              , 0 CPP_ACTIVABLE
              , 0 CPP_PLAN_VISITAS
              , NULL DD_TCH_ID
              , TMP.CPP_PRINCIPAL
              , NULL DD_TRT_ID
              , VEN.NUMERO CPP_VENDIDO
              , RANK() OVER(
                  PARTITION BY TMP.DD_TGA_ID, TMP.DD_STG_ID, TMP.DD_TIM_ID, TMP.DD_CRA_ID, SCR.DD_SCR_ID, TMP.EJE_ID, PRO.PRO_ID, TMP.CPP_ARRENDAMIENTO, TMP.CPP_REFACTURABLE
                      , TMP.CPP_PRINCIPAL
                  ORDER BY 
                      CASE 
                          WHEN TMP.PRO_ID IS NOT NULL AND NVL(PRO.PRO_ID, 0) = NVL(TMP.PRO_ID, 0) THEN 0
                          WHEN TMP.PRO_ID IS NULL AND NVL(PRO.PRO_ID, 0) <> NVL(TMP.PRO_ID, 0) THEN 1
                          ELSE 2
                      END
                  ) RN 
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' TMP
          JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = TMP.DD_CRA_ID
              AND CRA.BORRADO = 0
          JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = CRA.DD_CRA_ID
              AND SCR.BORRADO = 0
          JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.DD_CRA_ID = CRA.DD_CRA_ID
              AND PRO.BORRADO = 0
          JOIN '||V_ESQUEMA||'.AUX_CERO_UNO VEN ON 1 = 1
          WHERE TMP.DD_SCR_ID IS NULL
              AND TMP.BORRADO = 0
      ) CPP
      WHERE CPP.RN = 1
          AND (CPP.TMP_PRO = CPP.PRO_ID OR CPP.TMP_PRO IS NULL)
          AND NOT EXISTS (
              SELECT 1
              FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AUX
              WHERE AUX.DD_TGA_ID = CPP.DD_TGA_ID
                  AND AUX.DD_STG_ID = CPP.DD_STG_ID
                  AND AUX.DD_TIM_ID = CPP.DD_TIM_ID
                  AND AUX.DD_CRA_ID = CPP.DD_CRA_ID
                  AND NVL(AUX.DD_SCR_ID, 0) = NVL(CPP.DD_SCR_ID, NVL(AUX.DD_SCR_ID, 0))
                  AND AUX.PRO_ID = CPP.PRO_ID
                  AND AUX.EJE_ID = CPP.EJE_ID
                  AND NVL(AUX.CPP_ARRENDAMIENTO, 0) = NVL(CPP.CPP_ARRENDAMIENTO, NVL(AUX.CPP_ARRENDAMIENTO, 0))
                  AND AUX.CPP_REFACTURABLE = CPP.CPP_REFACTURABLE
                  AND NVL(AUX.DD_TBE_ID, 0) = NVL(CPP.DD_TBE_ID, 0)
                  AND AUX.CPP_ACTIVABLE = CPP.CPP_ACTIVABLE
                  AND AUX.CPP_PLAN_VISITAS = CPP.CPP_PLAN_VISITAS
                  AND NVL(AUX.DD_TCH_ID, 0) = NVL(CPP.DD_TCH_ID, 0)
                  AND AUX.CPP_PRINCIPAL = CPP.CPP_PRINCIPAL
                  AND NVL(AUX.DD_TRT_ID, 0) = NVL(CPP.DD_TRT_ID, 0)
                  AND NVL(AUX.CPP_VENDIDO, 0) = NVL(CPP.CPP_VENDIDO, NVL(AUX.CPP_VENDIDO, 0))
                  AND AUX.BORRADO = 0
    )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' partidas sin subcartera inicial insertadas');

    COMMIT;  

    --ACTIVAMOS CLAVES ANTES DE EMPEZAR PARA MEJORAR EL DESEMPEÑO
    FOR CLAVES IN CONSTRAINTS_DISABLED 
      LOOP

        V_CONSTRAINT_NAME := CLAVES.CONSTRAINT_NAME; 

        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
          ENABLE CONSTRAINT '||V_CONSTRAINT_NAME;
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Activada la clave '||V_CONSTRAINT_NAME);

      END LOOP;

    DBMS_OUTPUT.PUT_LINE('[FIN]');   

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          DBMS_OUTPUT.put_line(V_MSQL);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
