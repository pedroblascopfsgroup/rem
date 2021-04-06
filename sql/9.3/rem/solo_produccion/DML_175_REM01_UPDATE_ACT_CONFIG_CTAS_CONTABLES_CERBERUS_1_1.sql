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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_ITEM VARCHAR2(25 CHAR):= 'REMVIP-9202';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_CONFIG_CTAS_CONTABLES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
    
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
    -- CUENTA_CONTABLE   DD_TGA_CODIGO  DD_STG_CODIGO, EJERCICIO, TIPO_IMPORTE
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		T_TIPO_DATA('6295000', '15', '82', 'BAS')
		
	); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_INICIO);

    DBMS_OUTPUT.PUT_LINE('[INFO] Vaciamos tabla temporal... ');
    V_SQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA;
    EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id de la cartera, porque es el mismo para todos.');

    V_SQL := 'SELECT DD_CRA_ID
       FROM '||V_ESQUEMA||'.DD_CRA_CARTERA
       WHERE DD_CRA_CODIGO = ''07''';
    EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;
	 
    -- LOOP para insertar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN TMP_'||V_TEXT_TABLA||' ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    	LOOP
      
	        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	    	DBMS_OUTPUT.PUT_LINE('[INFO] Insertamos los registros para todos los ejercicios.'); 

	       	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' (CCC_CTAS_ID, CCC_CUENTA_CONTABLE, DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, DD_SCR_ID, FECHACREAR, BORRADO) 
				WITH MAX AS (
	        		SELECT NVL(MAX(CCC_CTAS_ID), 0) MAXIMUM
	        		FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
	        	)
				SELECT MAXIMUM + ROWNUM CCC_CTAS_ID,
					'''||V_TMP_TIPO_DATA(1)||''' CCC_CUENTA_CONTABLE,
					(SELECT DD_TGA_ID 
						FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO 
						WHERE DD_TGA_CODIGO = '''||V_TMP_TIPO_DATA(2)||''') DD_TGA_ID,
					(SELECT DD_STG_ID 
						FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG 
						JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID 
							AND TGA.DD_TGA_CODIGO = '''||V_TMP_TIPO_DATA(2)||'''
						WHERE STG.DD_STG_CODIGO = '''||V_TMP_TIPO_DATA(3)||''') DD_STG_ID,
					(SELECT DD_TIM_ID
						FROM '||V_ESQUEMA||'.DD_TIM_TIPO_IMPORTE
						WHERE BORRADO = 0
							AND DD_TIM_CODIGO = '''||V_TMP_TIPO_DATA(4)||''') DD_TIM_ID,
					'||TRIM(V_DD_CRA_ID)||' DD_CRA_ID,
                    SCR.DD_SCR_ID,
					SYSDATE,
					0
				FROM '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR
				JOIN MAX ON 1 = 1
                WHERE SCR.DD_SCR_CODIGO IN (''151'',''152'')';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' registro/s insertado/s.');

      	END LOOP;

	V_SQL := 'SELECT COUNT(1) 
		FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' TMP';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

    COMMIT;

    V_PASO_FIN := SYSTIMESTAMP;
    V_DURACION := V_PASO_FIN - V_INICIO;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_'||V_TEXT_TABLA||' informada con '||V_NUM_TABLAS||' registros. '||V_DURACION);
    V_PASO_INI := SYSTIMESTAMP;

    DBMS_OUTPUT.PUT_LINE('[INFO] Preparamos cuentas para tabla de negocio.');

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
    DBMS_OUTPUT.PUT_LINE('[INFO] Cuentas BBVA preparadas para tabla de negocio. '||V_DURACION);

    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA INTO V_NUM_TABLAS;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NUM_TABLAS||' registros en la tabla TMP_'||V_TEXT_TABLA);

    DBMS_OUTPUT.PUT_LINE('[INFO] Abrimos un nuevo proceso para borrar las CC que puediera haber para esta CARTERA + SUBCARTERA + TIPO GASTO + SUBTIPO GASTO + EJERCICIO para despues insertar las buenas...');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
      USING (
          SELECT DISTINCT DD_CRA_ID, DD_SCR_ID, DD_TGA_ID, DD_STG_ID, (SELECT EJE_ID FROM ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = 2020) AS EJE_ID
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      ) T2
      ON (
	      T1.DD_CRA_ID = T2.DD_CRA_ID
	      AND
	      T1.DD_SCR_ID = T2.DD_SCR_ID
	      AND
	      T1.DD_TGA_ID = T2.DD_TGA_ID
	      AND 
	      T1.DD_STG_ID = T2.DD_STG_ID
	      AND 
	      T1.EJE_ID = T2.EJE_ID
      )
      WHEN MATCHED THEN
          UPDATE SET T1.BORRADO = 1,
          T1.USUARIOBORRAR = '''||V_ITEM||''',
          T1.FECHABORRAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Borradas '||SQL%ROWCOUNT||' CC para el Ejercicio 2020.');

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
      USING (
          SELECT DISTINCT DD_CRA_ID, DD_SCR_ID, DD_TGA_ID, DD_STG_ID, (SELECT EJE_ID FROM ACT_EJE_EJERCICIO EJE WHERE EJE.EJE_ANYO = 2021) AS EJE_ID
          FROM '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||'
      ) T2
      ON (
	      T1.DD_CRA_ID = T2.DD_CRA_ID
	      AND
	      T1.DD_SCR_ID = T2.DD_SCR_ID
	      AND
	      T1.DD_TGA_ID = T2.DD_TGA_ID
	      AND 
	      T1.DD_STG_ID = T2.DD_STG_ID
	      AND 
	      T1.EJE_ID = T2.EJE_ID
      )
      WHEN MATCHED THEN
          UPDATE SET T1.BORRADO = 1,
          T1.USUARIOBORRAR = '''||V_ITEM||''',
          T1.FECHABORRAR = SYSDATE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Borradas '||SQL%ROWCOUNT||' CC para el Ejercicio 2021.');



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
