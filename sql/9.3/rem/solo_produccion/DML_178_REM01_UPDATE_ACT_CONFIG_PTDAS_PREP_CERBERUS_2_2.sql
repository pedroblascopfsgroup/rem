--/*
--##########################################
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20210325
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9202
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en ACT_CONFIG_CTAS_CONTABLES los datos añadidos en T_ARRAY_DATA
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'REMVIP-9202';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_PTDAS_PREP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
	  V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.

    V_CONSTRAINT_NAME VARCHAR2(30 CHAR);

    V_DURACION INTERVAL DAY(0) TO SECOND;
    V_INICIO TIMESTAMP := SYSTIMESTAMP;
    V_FIN TIMESTAMP;
    V_PASO_INI TIMESTAMP;
    V_PASO_FIN TIMESTAMP;

    CURSOR CONSTRAINTS_ENABLED IS SELECT CONSTRAINT_NAME
      FROM ALL_CONSTRAINTS
      WHERE TABLE_NAME = 'ACT_CONFIG_CTAS_CONTABLES'
          AND STATUS = 'ENABLED'
          AND CONSTRAINT_TYPE IN ('C', 'U', 'F', 'P');

    CURSOR CONSTRAINTS_DISABLED IS SELECT CONSTRAINT_NAME 
      FROM ALL_CONSTRAINTS
      WHERE TABLE_NAME = 'ACT_CONFIG_CTAS_CONTABLES'
          AND STATUS = 'DISABLED'
          AND CONSTRAINT_TYPE IN ('C', 'U', 'F', 'P');
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_INICIO);

    --ANALIZAMOS LA TABLA
    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','ACT_CONFIG_CTAS_CONTABLES');
    
    V_PASO_FIN := SYSTIMESTAMP;
    V_DURACION := V_PASO_FIN - V_INICIO;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TEXT_TABLA||' analizada. '||V_DURACION);
    V_PASO_INI := SYSTIMESTAMP;

    --ACTIVAMOS CLAVES ANTES DE EMPEZAR PARA MEJORAR EL DESEMPEÑO
    FOR CLAVES IN CONSTRAINTS_DISABLED 
      LOOP

        V_CONSTRAINT_NAME := CLAVES.CONSTRAINT_NAME; 

        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
          ENABLE CONSTRAINT '||V_CONSTRAINT_NAME;
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Activada la clave '||V_CONSTRAINT_NAME);

      END LOOP;

    /*--DESACTIVAMOS CLAVES ANTES DE EMPEZAR PARA MEJORAR EL DESEMPEÑO
    FOR CLAVES IN CONSTRAINTS_ENABLED 
      LOOP

        V_CONSTRAINT_NAME := CLAVES.CONSTRAINT_NAME; 

        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||'
           DISABLE CONSTRAINT '||V_CONSTRAINT_NAME;
        EXECUTE IMMEDIATE V_MSQL;

        DBMS_OUTPUT.PUT_LINE('[INFO] Desactivada la clave '||V_CONSTRAINT_NAME);

      END LOOP;*/

    V_PASO_FIN := SYSTIMESTAMP;
    V_DURACION := V_PASO_FIN - V_PASO_INI;
    DBMS_OUTPUT.PUT_LINE('[INFO] Constraints de la tabla '||V_TEXT_TABLA||' desactivadas. '||V_DURACION);
    V_PASO_INI := SYSTIMESTAMP;

    V_PASO_FIN := SYSTIMESTAMP;
    V_DURACION := V_PASO_FIN - V_PASO_INI;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' cuentas borradas. '||V_DURACION);

    V_PASO_INI := SYSTIMESTAMP;

    DBMS_OUTPUT.PUT_LINE('[INFO] Insertamos cuentas en tabla de negocio.');

    V_MSQL := 'INSERT /*+APPEND*/ INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
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
              , tmp.DD_SCR_ID
              , PRO.PRO_ID
              , TMP.PRO_ID TMP_PRO
              , EJE.EJE_ID
              , ARR.NUMERO CPP_ARRENDAMIENTO
              , 0 CPP_REFACTURABLE
              , NULL DD_TBE_ID
              , 0 CPP_ACTIVABLE
              , 0 CPP_PLAN_VISITAS
              , NULL DD_TCH_ID
              , TMP.CPP_PRINCIPAL
              , NULL DD_TRT_ID
              , VEN.NUMERO CPP_VENDIDO
              , RANK() OVER(
                  PARTITION BY TMP.DD_TGA_ID, TMP.DD_STG_ID, TMP.DD_TIM_ID, TMP.DD_CRA_ID, tmp.DD_SCR_ID, EJE.EJE_ID, PRO.PRO_ID, TMP.CPP_PRINCIPAL
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
          JOIN '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO ON PRO.DD_CRA_ID = TMP.DD_CRA_ID
              AND PRO.BORRADO = 0
          /*JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_CRA_ID = TMP.DD_CRA_ID
              AND SCR.BORRADO = 0*/
          JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE.BORRADO = 0
          JOIN '||V_ESQUEMA||'.AUX_CERO_UNO ARR ON 1 = 1
          JOIN '||V_ESQUEMA||'.AUX_CERO_UNO VEN ON 1 = 1
          WHERE TMP.BORRADO = 0
              AND EJE.EJE_ANYO >= 2020
      ) CPP
      WHERE CPP.RN = 1';
    EXECUTE IMMEDIATE V_MSQL;

    V_PASO_FIN := SYSTIMESTAMP;
    V_DURACION := V_PASO_FIN - V_PASO_INI;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' cuentas insertadas. '||V_DURACION);

    COMMIT;  

    DBMS_OUTPUT.PUT_LINE('[INFO] Por ultimo, borramos fisicamente las PP borradas de manera logica en el DML anterior y que sustituimos por estas nuevas');

    execute immediate := 'delete from '||V_ESQUEMA||'.'||V_TEXT_TABLA||' where usuarioborrar = '''||V_ITEM||'''';

    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' cuentas borradas fisicamente.');

    COMMIT;

    V_FIN := SYSTIMESTAMP;
    V_DURACION := V_FIN - V_INICIO;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_DURACION);

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
