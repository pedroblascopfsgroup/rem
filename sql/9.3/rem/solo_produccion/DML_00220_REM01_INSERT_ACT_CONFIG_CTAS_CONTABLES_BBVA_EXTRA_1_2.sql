--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210312
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9206
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
    V_ITEM VARCHAR2(25 CHAR):= 'REMVIP-9206';

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
		T_TIPO_DATA('Z01', '15', '84', 'BAS'),
		T_TIPO_DATA('Z01', '15', '70', 'BAS'),
		T_TIPO_DATA('Z01', '15', '82', 'BAS'),
		T_TIPO_DATA('Z01', '15', '81', 'BAS'),
		T_TIPO_DATA('Z02', '15', '73', 'BAS'),
		T_TIPO_DATA('Z02', '15', '76', 'BAS'),
		T_TIPO_DATA('Z02', '15', '75', 'BAS'),
		T_TIPO_DATA('Z02', '15', '74', 'BAS'),
		T_TIPO_DATA('Z01', '15', '83', 'BAS'),
		T_TIPO_DATA('ZA06', '15', '80', 'BAS'),
		T_TIPO_DATA('Z01', '15', '79', 'BAS'),
		T_TIPO_DATA('Z02', '15', '72', 'BAS'),
		T_TIPO_DATA('Z01', '15', '77', 'BAS'),
		T_TIPO_DATA('Z01', '15', '71', 'BAS'),
		T_TIPO_DATA('Z01', '15', '78', 'BAS'),
		T_TIPO_DATA('Z04', '13', '55', 'BAS'),
		T_TIPO_DATA('Z33', '06', '29', 'BAS'),
		T_TIPO_DATA('Z33', '06', '28', 'BAS'),
		T_TIPO_DATA('Z33', '05', '93', 'BAS'),
		T_TIPO_DATA('Z33', '05', '27', 'BAS'),
		T_TIPO_DATA('Z33', '05', '26', 'BAS'),
		T_TIPO_DATA('Z17', '12', '53', 'BAS'),
		T_TIPO_DATA('Z17', '12', '54', 'BAS'),
		T_TIPO_DATA('Z35', '01', '05', 'BAS'),
		T_TIPO_DATA('Z39', '01', '01', 'BAS'),
		T_TIPO_DATA('Z39', '01', '02', 'BAS'),
		T_TIPO_DATA('ZA07', '01', '06', 'BAS'),
		T_TIPO_DATA('Z38', '01', '07', 'BAS'),
		T_TIPO_DATA('Z37', '01', '03', 'BAS'),
		T_TIPO_DATA('Z37', '01', '04', 'BAS'),
		T_TIPO_DATA('Z48', '01', '92', 'BAS'),
		T_TIPO_DATA('Z08', '14', '62', 'BAS'),
		T_TIPO_DATA('Z17', '14', '60', 'BAS'),
		T_TIPO_DATA('Z06', '14', '58', 'BAS'),
		T_TIPO_DATA('Z08', '14', '61', 'BAS'),
		T_TIPO_DATA('Z08', '14', '69', 'BAS'),
		T_TIPO_DATA('Z08', '14', '57', 'BAS'),
		T_TIPO_DATA('Z08', '14', '68', 'BAS'),
		T_TIPO_DATA('Z36', '14', '59', 'BAS'),
		T_TIPO_DATA('Z08', '14', '64', 'BAS'),
		T_TIPO_DATA('Z08', '14', '63', 'BAS'),
		T_TIPO_DATA('Z08', '14', '67', 'BAS'),
		T_TIPO_DATA('Z08', '14', '66', 'BAS'),
		T_TIPO_DATA('Z08', '14', '65', 'BAS'),
		T_TIPO_DATA('Z33', '07', '31', 'BAS'),
		T_TIPO_DATA('Z33', '07', '30', 'BAS'),
		T_TIPO_DATA('Z33', '08', '33', 'BAS'),
		T_TIPO_DATA('Z33', '08', '32', 'BAS'),
		T_TIPO_DATA('Z33', '08', '34', 'BAS'),
		T_TIPO_DATA('Z23', '18', '89', 'BAS'),
		T_TIPO_DATA('Z36', '03', '19', 'BAS'),
		T_TIPO_DATA('Z36', '03', '20', 'BAS'),
		T_TIPO_DATA('Z50', '17', '88', 'BAS'),
		T_TIPO_DATA('Z46', '04', '24', 'BAS'),
		T_TIPO_DATA('Z46', '04', '25', 'BAS'),
		T_TIPO_DATA('Z46', '04', '23', 'BAS'),
		T_TIPO_DATA('Z46', '04', '22', 'BAS'),
		T_TIPO_DATA('Z46', '04', '21', 'BAS'),
		T_TIPO_DATA('Z26', '10', '42', 'BAS'),
		T_TIPO_DATA('Z26', '10', '41', 'BAS'),
		T_TIPO_DATA('Z26', '10', '40', 'BAS'),
		T_TIPO_DATA('Z26', '10', '39', 'BAS'),
		T_TIPO_DATA('Z13', '11', '97', 'BAS'),
		T_TIPO_DATA('Z13', '11', '96', 'BAS'),
		T_TIPO_DATA('Z13', '11', '95', 'BAS'),
		T_TIPO_DATA('Z13', '11', '48', 'BAS'),
		T_TIPO_DATA('Z21', '11', '49', 'BAS'),
		T_TIPO_DATA('Z13', '11', '94', 'BAS'),
		T_TIPO_DATA('Z15', '11', '44', 'BAS'),
		T_TIPO_DATA('Z13', '11', '52', 'BAS'),
		T_TIPO_DATA('Z13', '11', '47', 'BAS'),
		T_TIPO_DATA('Z15', '11', '46', 'BAS'),
		T_TIPO_DATA('Z19', '11', '43', 'BAS'),
		T_TIPO_DATA('Z05', '11', '51', 'BAS'),
		T_TIPO_DATA('Z08', '11', '50', 'BAS'),
		T_TIPO_DATA('Z29', '09', '36', 'BAS'),
		T_TIPO_DATA('Z30', '09', '35', 'BAS'),
		T_TIPO_DATA('Z31', '09', '37', 'BAS'),
		T_TIPO_DATA('Z36', '02', '10', 'BAS'),
		T_TIPO_DATA('Z36', '02', '09', 'BAS'),
		T_TIPO_DATA('Z36', '02', '08', 'BAS'),
		T_TIPO_DATA('Z36', '02', '12', 'BAS'),
		T_TIPO_DATA('Z36', '02', '14', 'BAS'),
		T_TIPO_DATA('Z36', '02', '16', 'BAS'),
		T_TIPO_DATA('Z36', '02', '15', 'BAS'),
		T_TIPO_DATA('Z36', '02', '18', 'BAS'),
		T_TIPO_DATA('Z36', '02', '17', 'BAS'),
		T_TIPO_DATA('Z36', '02', '13', 'BAS'),
		T_TIPO_DATA('Z36', '02', '11', 'BAS'),
		T_TIPO_DATA('Z24', '16', '86', 'BAS'),
		T_TIPO_DATA('Z24', '16', '87', 'BAS'),
		T_TIPO_DATA('Z24', '16', '85', 'BAS'),
		T_TIPO_DATA('Z48', '01', '05', 'INT'),
		T_TIPO_DATA('Z48', '01', '01', 'INT'),
		T_TIPO_DATA('Z48', '01', '02', 'INT'),
		T_TIPO_DATA('Z48', '01', '06', 'INT'),
		T_TIPO_DATA('Z48', '01', '07', 'INT'),
		T_TIPO_DATA('Z48', '01', '03', 'INT'),
		T_TIPO_DATA('Z48', '01', '04', 'INT'),
		T_TIPO_DATA('Z48', '01', '92', 'INT'),
		T_TIPO_DATA('Z48', '03', '19', 'INT'),
		T_TIPO_DATA('Z48', '03', '20', 'INT'),
		T_TIPO_DATA('Z48', '04', '24', 'INT'),
		T_TIPO_DATA('Z48', '04', '25', 'INT'),
		T_TIPO_DATA('Z48', '04', '23', 'INT'),
		T_TIPO_DATA('Z48', '04', '22', 'INT'),
		T_TIPO_DATA('Z48', '04', '21', 'INT'),
		T_TIPO_DATA('Z48', '02', '10', 'INT'),
		T_TIPO_DATA('Z48', '02', '09', 'INT'),
		T_TIPO_DATA('Z48', '02', '08', 'INT'),
		T_TIPO_DATA('Z48', '02', '12', 'INT'),
		T_TIPO_DATA('Z48', '02', '14', 'INT'),
		T_TIPO_DATA('Z48', '02', '16', 'INT'),
		T_TIPO_DATA('Z48', '02', '15', 'INT'),
		T_TIPO_DATA('Z48', '02', '18', 'INT'),
		T_TIPO_DATA('Z48', '02', '17', 'INT'),
		T_TIPO_DATA('Z48', '02', '13', 'INT'),
		T_TIPO_DATA('Z48', '02', '11', 'INT'),
		T_TIPO_DATA('Z52', '01', '05', 'TAS'),
		T_TIPO_DATA('Z52', '01', '01', 'TAS'),
		T_TIPO_DATA('Z52', '01', '02', 'TAS'),
		T_TIPO_DATA('Z52', '01', '06', 'TAS'),
		T_TIPO_DATA('Z52', '01', '07', 'TAS'),
		T_TIPO_DATA('Z52', '01', '03', 'TAS'),
		T_TIPO_DATA('Z52', '01', '04', 'TAS'),
		T_TIPO_DATA('Z52', '01', '92', 'TAS'),
		T_TIPO_DATA('Z52', '03', '19', 'TAS'),
		T_TIPO_DATA('Z52', '03', '20', 'TAS'),
		T_TIPO_DATA('Z52', '04', '24', 'TAS'),
		T_TIPO_DATA('Z52', '04', '25', 'TAS'),
		T_TIPO_DATA('Z52', '04', '23', 'TAS'),
		T_TIPO_DATA('Z52', '04', '22', 'TAS'),
		T_TIPO_DATA('Z52', '04', '21', 'TAS'),
		T_TIPO_DATA('Z52', '02', '10', 'TAS'),
		T_TIPO_DATA('Z52', '02', '09', 'TAS'),
		T_TIPO_DATA('Z52', '02', '08', 'TAS'),
		T_TIPO_DATA('Z52', '02', '12', 'TAS'),
		T_TIPO_DATA('Z52', '02', '14', 'TAS'),
		T_TIPO_DATA('Z52', '02', '16', 'TAS'),
		T_TIPO_DATA('Z52', '02', '15', 'TAS'),
		T_TIPO_DATA('Z52', '02', '18', 'TAS'),
		T_TIPO_DATA('Z52', '02', '17', 'TAS'),
		T_TIPO_DATA('Z52', '02', '13', 'TAS'),
		T_TIPO_DATA('Z52', '02', '11', 'TAS'),
		T_TIPO_DATA('Z46', '01', '05', 'REC'),
		T_TIPO_DATA('Z46', '01', '01', 'REC'),
		T_TIPO_DATA('Z46', '01', '02', 'REC'),
		T_TIPO_DATA('Z46', '01', '06', 'REC'),
		T_TIPO_DATA('Z46', '01', '07', 'REC'),
		T_TIPO_DATA('Z46', '01', '03', 'REC'),
		T_TIPO_DATA('Z46', '01', '04', 'REC'),
		T_TIPO_DATA('Z46', '01', '92', 'REC'),
		T_TIPO_DATA('Z46', '03', '19', 'REC'),
		T_TIPO_DATA('Z46', '03', '20', 'REC'),
		T_TIPO_DATA('Z46', '04', '24', 'REC'),
		T_TIPO_DATA('Z46', '04', '25', 'REC'),
		T_TIPO_DATA('Z46', '04', '23', 'REC'),
		T_TIPO_DATA('Z46', '04', '22', 'REC'),
		T_TIPO_DATA('Z46', '04', '21', 'REC'),
		T_TIPO_DATA('Z46', '02', '10', 'REC'),
		T_TIPO_DATA('Z46', '02', '09', 'REC'),
		T_TIPO_DATA('Z46', '02', '08', 'REC'),
		T_TIPO_DATA('Z46', '02', '12', 'REC'),
		T_TIPO_DATA('Z46', '02', '14', 'REC'),
		T_TIPO_DATA('Z46', '02', '16', 'REC'),
		T_TIPO_DATA('Z46', '02', '15', 'REC'),
		T_TIPO_DATA('Z46', '02', '18', 'REC'),
		T_TIPO_DATA('Z46', '02', '17', 'REC'),
		T_TIPO_DATA('Z46', '02', '13', 'REC'),
		T_TIPO_DATA('Z46', '02', '11', 'REC')
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
       WHERE DD_CRA_CODIGO = ''16''';
    EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;
	 
    -- LOOP para insertar los valores -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN TMP_'||V_TEXT_TABLA||' ');
    FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    	LOOP
      
	        V_TMP_TIPO_DATA := V_TIPO_DATA(I);

	    	DBMS_OUTPUT.PUT_LINE('[INFO] Insertamos los registros para todos los ejercicios.'); 

	       	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_'||V_TEXT_TABLA||' (CCC_CTAS_ID, CCC_CUENTA_CONTABLE, DD_TGA_ID, DD_STG_ID, DD_TIM_ID, DD_CRA_ID, FECHACREAR, BORRADO) 
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
					SYSDATE,
					0
				FROM DUAL
				JOIN MAX ON 1 = 1';
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
