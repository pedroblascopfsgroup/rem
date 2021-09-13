--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210901
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10257
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'REMVIP-10257';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_CTAS_CONTABLES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
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
    
    
    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    -- CUENTA_CONTABLE   DD_TGA_CODIGO DD_STG_CODIGO DD_TIM_CODIGO   DD_SCR_CODIGO
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('6230600022', '11', '116', '138'),
        T_TIPO_DATA('6230000', '11', '116', '151'),
        T_TIPO_DATA('6230000', '11', '116', '152'),
        T_TIPO_DATA('6230600022', '11', '117', '138'),
        T_TIPO_DATA('6230000', '11', '117', '151'),
        T_TIPO_DATA('6230000', '11', '117', '152')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_INICIO);

    --ANALIZAMOS LA TABLA
    #ESQUEMA#.OPERACION_DDL.DDL_TABLE('ANALYZE','ACT_CONFIG_CTAS_CONTABLES');

    V_PASO_FIN := SYSTIMESTAMP;
    V_DURACION := V_PASO_FIN - V_INICIO;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TEXT_TABLA||' analizada. '||V_DURACION);
    V_PASO_INI := SYSTIMESTAMP;
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

    V_SQL := 'SELECT DD_CRA_ID 
      FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
      WHERE DD_CRA_CODIGO = ''07''';
    EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id del año, porque es el mismo para todos.');

    V_SQL := 'SELECT EJE_ID 
      FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO 
      WHERE EJE_ANYO = 2021';
    EXECUTE IMMEDIATE V_SQL INTO V_EJE_ID;

	 
    -- LOOP para insertar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN TMP_'||V_TEXT_TABLA||' ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      LOOP
      
        V_TMP_TIPO_DATA := V_TIPO_DATA(I);
       
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' WHERE CCC_CUENTA_CONTABLE = '''||TRIM(V_TMP_TIPO_DATA(1))||''' 
          AND DD_TGA_ID = (SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TMP_TIPO_DATA(2)||''')
          AND DD_STG_ID = (SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(3)||''')
          AND DD_CRA_ID = '||V_DD_CRA_ID||'
          AND DD_SCR_ID = (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(4)||''')
          AND EJE_ID = '||V_EJE_ID||'';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        IF V_NUM_TABLAS = 1 THEN
          DBMS_OUTPUT.PUT_LINE('[INFO]: La CCC '''||TRIM(V_TMP_TIPO_DATA(1))||''' ya existe');
        ELSE
          DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');   
          V_ID := I;	
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.TMP_'||V_TEXT_TABLA||' (' ||
            'CCC_CTAS_ID, CCC_CUENTA_CONTABLE, DD_TGA_ID, DD_STG_ID, DD_CRA_ID, DD_SCR_ID, EJE_ID, FECHACREAR, BORRADO) VALUES (' ||
            ''|| V_ID ||','''||V_TMP_TIPO_DATA(1)||''',(SELECT DD_TGA_ID FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO WHERE DD_TGA_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''),'||
            '(SELECT DD_STG_ID FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO WHERE DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(3)||'''),'||
            ' '''||TRIM(V_DD_CRA_ID)||''','||
            ' (SELECT DD_SCR_ID FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA WHERE DD_SCR_CODIGO = '''||V_TMP_TIPO_DATA(4)||'''),'||
            ' '''||TRIM(V_EJE_ID)||''',SYSDATE,0)';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO]: '||SQL%ROWCOUNT||' REGISTRO/S INSERTADO/S CORRECTAMENTE.');
        END IF;

      END LOOP;
    COMMIT;

    V_PASO_FIN := SYSTIMESTAMP;
    V_DURACION := V_PASO_FIN - V_PASO_INI;
    DBMS_OUTPUT.PUT_LINE('[INFO]: Tabla TMP_'||V_TEXT_TABLA||' MODIFICADA CORRECTAMENTE. '||V_DURACION);
    V_PASO_INI := SYSTIMESTAMP;

    DBMS_OUTPUT.PUT_LINE('[INFO]: Preparamos cuentas para tabla de negocio.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' T1
      USING (
          SELECT CCC_CTAS_ID
              , ROW_NUMBER() OVER(
                  PARTITION BY DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, DD_SCR_ID
                      , PRO_ID, EJE_ID, CCC_ARRENDAMIENTO, CCC_REFACTURABLE, DD_TBE_ID
                      , CCC_ACTIVABLE, CCC_PLAN_VISITAS, DD_TCH_ID, DD_TRT_ID
                      , CCC_VENDIDO
                  ORDER BY CCC_CTAS_ID
              ) RN
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      ) T2
      ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID)
      WHEN MATCHED THEN 
          UPDATE SET T1.CCC_PRINCIPAL = CASE WHEN T2.RN = 1 THEN 1 ELSE 0 END';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      SET DD_TIM_ID = (SELECT DD_TIM_ID FROM DD_TIM_TIPO_IMPORTE WHERE DD_TIM_CODIGO = ''BAS'')
      WHERE DD_TIM_ID IS NULL';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' T1
      USING (
          SELECT CCC_CTAS_ID
              , ROW_NUMBER() OVER(
                  PARTITION BY DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, DD_SCR_ID
                      , PRO_ID, EJE_ID, CCC_ARRENDAMIENTO, CCC_REFACTURABLE, DD_TBE_ID
                      , CCC_ACTIVABLE, CCC_PLAN_VISITAS, DD_TCH_ID, DD_TRT_ID
                      , CCC_VENDIDO
                  ORDER BY CCC_CTAS_ID
              ) RN
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
          WHERE CCC_PRINCIPAL = 0
      ) T2
      ON (T1.CCC_CTAS_ID = T2.CCC_CTAS_ID AND T2.RN > 1)
      WHEN MATCHED THEN
          UPDATE SET T1.BORRADO = 1';
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      WHERE BORRADO = 1';
    EXECUTE IMMEDIATE V_MSQL;

    V_PASO_FIN := SYSTIMESTAMP;
    V_DURACION := V_PASO_FIN - V_PASO_INI;
    DBMS_OUTPUT.PUT_LINE('[INFO]: Cuentas preparadas. '||V_DURACION);

    V_PASO_INI := SYSTIMESTAMP;

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
          CCC_CTAS_ID
          , CCC_CUENTA_CONTABLE
          , DD_TGA_ID
          , DD_STG_ID
          , DD_TIM_ID
          , DD_CRA_ID
          , DD_SCR_ID
          , PRO_ID
          , EJE_ID
          , CCC_ARRENDAMIENTO
          , CCC_REFACTURABLE
          , USUARIOCREAR
          , FECHACREAR
          , DD_TBE_ID
          , CCC_SUBCUENTA_CONTABLE
          , CCC_ACTIVABLE
          , CCC_PLAN_VISITAS
          , DD_TCH_ID
          , CCC_PRINCIPAL
          , DD_TRT_ID
          , CCC_VENDIDO
      )
      SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL
          , CCC.CCC_CUENTA_CONTABLE
          , CCC.DD_TGA_ID
          , CCC.DD_STG_ID
          , CCC.DD_TIM_ID
          , CCC.DD_CRA_ID
          , CCC.DD_SCR_ID
          , CCC.PRO_ID
          , CCC.EJE_ID
          , CCC.CCC_ARRENDAMIENTO
          , CCC.CCC_REFACTURABLE
          , '''||V_ITEM||'''
          , SYSDATE
          , CCC.DD_TBE_ID
          , CCC.CCC_SUBCUENTA_CONTABLE
          , CCC.CCC_ACTIVABLE
          , CCC.CCC_PLAN_VISITAS
          , CCC.DD_TCH_ID
          , CCC.CCC_PRINCIPAL
          , CCC.DD_TRT_ID
          , CCC.CCC_VENDIDO
      FROM (
          SELECT TMP.CCC_CUENTA_CONTABLE
              , TMP.DD_TGA_ID
              , TMP.DD_STG_ID
              , TMP.DD_TIM_ID
              , TMP.DD_CRA_ID
              , TMP.DD_SCR_ID
              , PRO.PRO_ID
              , TMP.PRO_ID TMP_PRO
              , TMP.EJE_ID
              , ARR.NUMERO CCC_ARRENDAMIENTO
              , 0 CCC_REFACTURABLE
              , NULL DD_TBE_ID
              , TMP.CCC_SUBCUENTA_CONTABLE
              , 0 CCC_ACTIVABLE
              , 0 CCC_PLAN_VISITAS
              , NULL DD_TCH_ID
              , TMP.CCC_PRINCIPAL
              , NULL DD_TRT_ID
              , VEN.NUMERO CCC_VENDIDO
              , RANK() OVER(
                  PARTITION BY TMP.DD_TGA_ID, TMP.DD_STG_ID, TMP.DD_TIM_ID, TMP.DD_CRA_ID, TMP.DD_SCR_ID, TMP.EJE_ID, PRO.PRO_ID, TMP.CCC_PRINCIPAL
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
          JOIN '||V_ESQUEMA||'.AUX_CERO_UNO ARR ON 1 = 1
          JOIN '||V_ESQUEMA||'.AUX_CERO_UNO VEN ON 1 = 1
          WHERE TMP.DD_SCR_ID IS NOT NULL
              AND TMP.BORRADO = 0
      ) CCC
      WHERE CCC.RN = 1
          AND (CCC.TMP_PRO = CCC.PRO_ID OR CCC.TMP_PRO IS NULL)
          AND NOT EXISTS (
              SELECT 1
              FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' AUX
              WHERE AUX.DD_TGA_ID = CCC.DD_TGA_ID
                  AND AUX.DD_STG_ID = CCC.DD_STG_ID
                  AND AUX.DD_TIM_ID = CCC.DD_TIM_ID
                  AND AUX.DD_CRA_ID = CCC.DD_CRA_ID
                  AND NVL(AUX.DD_SCR_ID, 0) = NVL(CCC.DD_SCR_ID, NVL(AUX.DD_SCR_ID, 0))
                  AND AUX.PRO_ID = CCC.PRO_ID
                  AND AUX.EJE_ID = CCC.EJE_ID
                  AND NVL(AUX.CCC_ARRENDAMIENTO, 0) = NVL(CCC.CCC_ARRENDAMIENTO, NVL(AUX.CCC_ARRENDAMIENTO, 0))
                  AND AUX.CCC_REFACTURABLE = CCC.CCC_REFACTURABLE
                  AND NVL(AUX.DD_TBE_ID, 0) = NVL(CCC.DD_TBE_ID, 0)
                  AND AUX.CCC_ACTIVABLE = CCC.CCC_ACTIVABLE
                  AND AUX.CCC_PLAN_VISITAS = CCC.CCC_PLAN_VISITAS
                  AND NVL(AUX.DD_TCH_ID, 0) = NVL(CCC.DD_TCH_ID, 0)
                  AND AUX.CCC_PRINCIPAL = CCC.CCC_PRINCIPAL
                  AND NVL(AUX.DD_TRT_ID, 0) = NVL(CCC.DD_TRT_ID, 0)
                  AND NVL(AUX.CCC_VENDIDO, 0) = NVL(CCC.CCC_VENDIDO, NVL(AUX.CCC_VENDIDO, 0))
                  AND AUX.BORRADO = 0
          )';
    EXECUTE IMMEDIATE V_MSQL;

    V_PASO_FIN := SYSTIMESTAMP;
    V_DURACION := V_PASO_FIN - V_PASO_INI;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' cuentas insertadas '||V_DURACION);

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

