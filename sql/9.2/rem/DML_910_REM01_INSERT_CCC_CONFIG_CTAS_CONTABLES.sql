--/*
--#########################################
--## AUTOR=Lara Pablo
--## FECHA_CREACION=20190926
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7672
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar el estado de los siguientes gastos.
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-7672';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_TABLA VARCHAR2(30 CHAR) := 'CCC_CONFIG_CTAS_CONTABLES'; -- Variable para tabla.
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
	V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.
	
	
	V_EXISTE_CUENTA NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.

    TYPE T_CUENTA IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_CUENTAS IS TABLE OF T_CUENTA;
    V_CUENTAS T_ARRAY_CUENTAS := T_ARRAY_CUENTAS(
        
                --SUPTIPO GASTO									      --CARTERA			 --CUENTACONTABLE	      --AÑO	  --ARRENDAMIENTO		 --SUBCARTERA


		-- Derivación de deuda			
		T_CUENTA('101',                                                    '02',               6310000000,     		2019,      0,		             null),
		T_CUENTA('101',                                                    '07',               6310000000,     		2019,      0,			         '138'),
		T_CUENTA('101',                                                    '07',               6310000000,     		2019,      0,			         '105'),
		T_CUENTA('101',                                                    '12',               6310000000,     		2019,      0,			         null),
		T_CUENTA('101',                                                    '15',               6310000000,     		2019,      0,		             null),
		
		T_CUENTA('101',                                                    '07',               6310000000,     		2019,      1,			         '138'),
		T_CUENTA('101',                                                    '07',               6310000000,     		2019,      1,			         '105'),
		T_CUENTA('101',                                                    '11',               6310000000,     		2019,      1,			         null),
		T_CUENTA('101',                                                    '15',               6310000000,     		2019,      1,		             null),
		
		T_CUENTA('101',                                                    '07',               6310000001,     		2019,      0,			         '138'),
		T_CUENTA('101',                                                    '07',               6310000001,     		2019,      0,			         '105'),
		T_CUENTA('101',                                                    '12',               6310000001,     		2019,      0,			         null),
		T_CUENTA('101',                                                    '15',               6310000001,     		2019,      0,		             null),
		
		T_CUENTA('101',                                                    '07',               6310000001,     		2019,      1,			         '138'),
		T_CUENTA('101',                                                    '07',               6310000001,     		2019,      1,			         '105'),
		T_CUENTA('101',                                                    '11',               6310000001,     		2019,      1,			         null),
		T_CUENTA('101',                                                    '15',               6310000001,     		2019,      1,		             null),
      

		-- Hipoteca legal tácita			
		T_CUENTA('102',                                                    '02',               6310000000,     		2019,      0,		             null),
		T_CUENTA('102',                                                    '07',               6310000000,     		2019,      0,			         '138'),
		T_CUENTA('102',                                                    '07',               6310000000,     		2019,      0,			         '105'),
		T_CUENTA('102',                                                    '12',               6310000000,     		2019,      0,			         null),
		T_CUENTA('102',                                                    '15',               6310000000,     		2019,      0,		             null),
		
		
		T_CUENTA('102',                                                    '07',               6310000000,     		2019,      1,			         '138'),
		T_CUENTA('102',                                                    '07',               6310000000,     		2019,      1,			         '105'),
		T_CUENTA('102',                                                    '11',               6310000000,     		2019,      1,			         null),
		T_CUENTA('102',                                                    '15',               6310000000,     		2019,      1,		             null),
		
		T_CUENTA('102',                                                    '07',               6310000001,     		2019,      0,			         '138'),
		T_CUENTA('102',                                                    '07',               6310000001,     		2019,      0,			         '105'),
		T_CUENTA('102',                                                    '12',               6310000001,     		2019,      0,			         null),
		T_CUENTA('102',                                                    '15',               6310000001,     		2019,      0,		             null),
		
		T_CUENTA('102',                                                    '07',               6310000001,     		2019,      1,			         '138'),
		T_CUENTA('102',                                                    '07',               6310000001,     		2019,      1,			         '105'),
		T_CUENTA('102',                                                    '11',               6310000001,     		2019,      1,			         null),
		T_CUENTA('102',                                                    '15',               6310000001,     		2019,      1,		             null)
		


    );
    V_TMP_CUENTA T_CUENTA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id de la cartera, porque es el mismo para todos.');


    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id del año, porque es el mismo para todos.');

    V_SQL :=    'SELECT EJE_ID 
                FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO 
                WHERE EJE_ANYO = ''2019''';
    EXECUTE IMMEDIATE V_SQL INTO V_EJE_ID;

    FOR I IN V_CUENTAS.FIRST .. V_CUENTAS.LAST
    LOOP
        V_TMP_CUENTA := V_CUENTAS(I);

        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando si existe el subtipo de gasto '||TRIM(V_TMP_CUENTA(1))||'');

        IF TRIM(V_TMP_CUENTA(2)) != null THEN
	        V_SQL :=   'SELECT COUNT(1)
	                    FROM '||V_ESQUEMA||'.'||V_TABLA||' 
	                    WHERE DD_STG_ID = (SELECT DD_STG_ID 
											FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO 
											WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||''')
	                    AND DD_CRA_ID = (SELECT DD_CRA_ID  FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_CUENTA(2))||''')
						AND DD_SCR_ID = (SELECT DD_SCR_ID  FROM '||V_ESQUEMA||'.DD_SCR_CARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_CUENTA(6))||''')
	                    AND CCC_CUENTA_CONTABLE = '||TRIM(V_TMP_CUENTA(3))||'
	                    AND EJE_ID = '||V_EJE_ID||'
	                    AND CCC_ARRENDAMIENTO = '||TRIM(V_TMP_CUENTA(5))||'';
	
	        EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_CUENTA;
		ELSE
			V_SQL :=   'SELECT COUNT(1)
	                    FROM '||V_ESQUEMA||'.'||V_TABLA||' 
	                    WHERE DD_STG_ID = (SELECT DD_STG_ID 
											FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO 
											WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||''')
	                    AND DD_CRA_ID = (SELECT DD_CRA_ID  FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_CUENTA(2))||''')
	                    AND CCC_CUENTA_CONTABLE = '||TRIM(V_TMP_CUENTA(3))||'
	                    AND EJE_ID = '||V_EJE_ID||'
	                    AND CCC_ARRENDAMIENTO = '||TRIM(V_TMP_CUENTA(5))||'';
	
	        EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_CUENTA;
			
	    END IF;
	        
        IF V_EXISTE_CUENTA = 0 THEN

        	IF TRIM(V_TMP_CUENTA(2)) != null THEN
	            DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el gasto '||TRIM(V_TMP_CUENTA(1))||' con el nuevo estado "Pendiente autorizar".');
	
	            V_SQL :=    'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
	                        (
	                              CCC_ID
	                            , DD_STG_ID
	                            , DD_CRA_ID
	                            , VERSION
	                            , USUARIOCREAR
	                            , FECHACREAR
	                            , BORRADO
	                            , CCC_CUENTA_CONTABLE
	                            , EJE_ID
	                            , CCC_ARRENDAMIENTO
								, DD_SCR_ID
	                        )
	                        VALUES
	                        (
	                            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
	                            , (SELECT DD_STG_ID 
									FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO 
									WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||''')
	                            ,  (SELECT DD_CRA_ID  FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_CUENTA(2))||''')
	                            , 0
	                            , '''||V_USUARIO||'''
	                            , SYSDATE
	                            , 0
	                            , '||TRIM(V_TMP_CUENTA(3))||'
	                            , '||V_EJE_ID||'
	                            , '||TRIM(V_TMP_CUENTA(5))||'
								, (SELECT DD_SCR_ID  FROM '||V_ESQUEMA||'.DD_SCR_CARTERA WHERE DD_SCR_CODIGO = '''||TRIM(V_TMP_CUENTA(6))||''')
	                        )';
	
	            EXECUTE IMMEDIATE V_SQL;
            ELSE
            	 DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el gasto '||TRIM(V_TMP_CUENTA(1))||' con el nuevo estado "Pendiente autorizar".');
	
	            V_SQL :=    'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
	                        (
	                              CCC_ID
	                            , DD_STG_ID
	                            , DD_CRA_ID
	                            , VERSION
	                            , USUARIOCREAR
	                            , FECHACREAR
	                            , BORRADO
	                            , CCC_CUENTA_CONTABLE
	                            , EJE_ID
	                            , CCC_ARRENDAMIENTO
	                        )
	                        VALUES
	                        (
	                            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
	                            , (SELECT DD_STG_ID 
									FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO 
									WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||''')
	                            ,  (SELECT DD_CRA_ID  FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_CUENTA(2))||''')
	                            , 0
	                            , '''||V_USUARIO||'''
	                            , SYSDATE
	                            , 0
	                            , '||TRIM(V_TMP_CUENTA(3))||'
	                            , '||V_EJE_ID||'
	                            , '||TRIM(V_TMP_CUENTA(5))||'
	                        )';
	
	            EXECUTE IMMEDIATE V_SQL;
		
	        END IF;
            DBMS_OUTPUT.PUT_LINE('[INFO] El subtipo de gasto '||TRIM(V_TMP_CUENTA(1))||' ha sido insertado satisfactoriamente.');

        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el subgasto '||TRIM(V_TMP_CUENTA(1))||' con la cuenta contable '||TRIM(V_TMP_CUENTA(3))||' para el año '||TRIM(V_TMP_CUENTA(5))||'.');
        END IF;

    END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso de inserción de gastos.');
	COMMIT;

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      DBMS_OUTPUT.PUT_LINE(V_SQL);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
