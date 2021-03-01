--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13323
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
    V_ITEM VARCHAR2(25 CHAR):= 'HREOS-13323';

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
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_INICIO);

    V_PASO_INI := SYSTIMESTAMP;

    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (CCC_CTAS_ID,
          CCC_CUENTA_CONTABLE,
          DD_TGA_ID,
          DD_STG_ID,
          DD_TIM_ID,
          DD_CRA_ID,
          DD_SCR_ID,
          PRO_ID,
          EJE_ID,
          CCC_ARRENDAMIENTO,
          USUARIOCREAR,
          FECHACREAR,
          CCC_ACTIVABLE,
          CCC_PLAN_VISITAS,
          CCC_PRINCIPAL,
          CCC_VENDIDO)
      SELECT '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'.NEXTVAL CCC_CTAS_ID,
          CNF.CCC_CUENTA_CONTABLE,
          CNF.DD_TGA_ID,
          CNF.DD_STG_ID,
          CNF.DD_TIM_ID,
          CNF.DD_CRA_ID,
          CNF.DD_SCR_ID,
          CNF.PRO_ID,
          EJE.EJE_ID,
          CNF.CCC_ARRENDAMIENTO,
          '''||V_ITEM||''',
          SYSDATE,
          CNF.CCC_ACTIVABLE,
          CNF.CCC_PLAN_VISITAS,
          CNF.CCC_PRINCIPAL,
          CNF.CCC_VENDIDO
      FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CNF
      JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = CNF.DD_CRA_ID
          AND CRA.BORRADO = 0
      JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE_2021 ON EJE_2021.EJE_ID = CNF.EJE_ID
          AND EJE_2021.BORRADO = 0
      JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON TO_NUMBER(EJE.EJE_ANYO) BETWEEN 1989 AND 2020
          AND EJE.BORRADO = 0
      WHERE CNF.BORRADO = 0
          AND CRA.DD_CRA_CODIGO = ''16''
          AND EJE_2021.EJE_ANYO = ''2021''
          AND NOT EXISTS (
                  SELECT 1
                  FROM '||V_ESQUEMA||'.DD_TIM_TIPO_IMPORTE TIM
                  WHERE TIM.DD_TIM_ID = CNF.DD_TIM_ID
                      AND TIM.DD_TIM_CODIGO = ''BAS''
              )
          AND NOT EXISTS (
                  SELECT 1
                  FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' REF
                  WHERE REF.DD_CRA_ID = CRA.DD_CRA_ID
                      AND REF.EJE_ID = EJE.EJE_ID
                      AND REF.DD_TIM_ID = CNF.DD_TIM_ID
              )';
    EXECUTE IMMEDIATE V_MSQL;

    V_PASO_FIN := SYSTIMESTAMP;
    V_DURACION := V_PASO_FIN - V_PASO_INI;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' cuentas insertadas. '||V_DURACION);

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
