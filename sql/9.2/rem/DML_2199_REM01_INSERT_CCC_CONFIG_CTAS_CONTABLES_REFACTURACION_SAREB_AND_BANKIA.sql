--/*
--#########################################
--## AUTOR=DAVID GARCÍA
--## FECHA_CREACION=201906025
--## ARTEFACTO=WEB
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6680
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

	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-6680';

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
        
                --SUPTIPO GASTO									      --CARTERA			 --CUENTACONTABLE	      --AÑO	  --ARRENDAMIENTO	-- TIPO GASTO           PRO_ID


		-- INFORMES TÉCNICOS Y OBTENCIÓN DOCUMENTOS			
		T_CUENTA('58',                                                    '02',               62300043,     		2019,      0,		    '14',                  'Refacturación Sareb'),
        T_CUENTA('57',                                                    '03',               62300044,     		2019,      0,			'14',                  'Central técnica Bankia'),
		T_CUENTA('61',                                                    '03',               62300044,     		2019,      0,			'14',                  'Central técnica Bankia'),
		T_CUENTA('62',                                                    '03',               62300044,     		2019,      0,			'14',                  'Central técnica Bankia'),
		T_CUENTA('63',                                                    '03',               62300044,     		2019,      0,			'14',                  'Central técnica Bankia'),
		T_CUENTA('68',                                                    '03',               62300044,     		2019,      0,			'14',                  'Central técnica Bankia'),
		T_CUENTA('69',                                                    '03',               62300044,     		2019,      0,			'14',                  'Central técnica Bankia'),
	

		-- ACTUACIÓN TÉCNICA Y MANTENIMIENTO			
		T_CUENTA('70',                                                    '02',               62300043,     		2019,      0,			'15',                   'Refacturación Sareb'),
		T_CUENTA('71',                                                    '02',               62300043,     		2019,      0,			'15',                   'Refacturación Sareb'),
		T_CUENTA('72',                                                    '02',               62300043,     		2019,      0,			'15',                   'Refacturación Sareb'),
		T_CUENTA('73',                                                    '02',               62300043,     		2019,      0,			'15',                   'Refacturación Sareb'),
		T_CUENTA('74',                                                    '02',               62300043,     		2019,      0,			'15',                   'Refacturación Sareb'),
		T_CUENTA('75',                                                    '02',               62300043,     		2019,      0,			'15',                   'Refacturación Sareb'),
		T_CUENTA('76',                                                    '02',               62300043,     		2019,      0,			'15',                   'Refacturación Sareb'),
		T_CUENTA('79',                                                    '02',               62300043,     		2019,      0,			'15',                   'Refacturación Sareb'),
		T_CUENTA('80',                                                    '02',               62300043,     		2019,      0,			'15',                   'Refacturación Sareb'),
		T_CUENTA('81',                                                    '02',               62300043,     		2019,      0,			'15',                   'Refacturación Sareb'),
        T_CUENTA('74',                                                    '03',               62300044,     		2019,      0,			'15',                   'Central técnica Bankia'),
		T_CUENTA('75',                                                    '03',               62300044,     		2019,      0,			'15',                   'Central técnica Bankia'),
		T_CUENTA('76',                                                    '03',               62300044,     		2019,      0,			'15',                   'Central técnica Bankia'),
		T_CUENTA('79',                                                    '03',               62300044,     		2019,      0,			'15',                   'Central técnica Bankia'),
		

		-- VIGILANCIA Y SEGURIDAD			
		T_CUENTA('85',                                                    '02',               62300043,     		2019,      0,			'16',                   'Refacturación Sareb')

    );
    V_TMP_CUENTA T_CUENTA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id de la cartera, porque es el mismo para todos.');


    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id del año, porque es el mismo para todos.');

    V_SQL :=    'SELECT EJE_ID 
                FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO 
                WHERE EJE_ANYO = 2019';
    EXECUTE IMMEDIATE V_SQL INTO V_EJE_ID;

    FOR I IN V_CUENTAS.FIRST .. V_CUENTAS.LAST
    LOOP
        V_TMP_CUENTA := V_CUENTAS(I);

        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando si existe el subtipo de gasto '||TRIM(V_TMP_CUENTA(1))||' para la cartera de Sareb y para el año de 2019.');

        V_SQL :=   'SELECT COUNT(1)
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' 
                    WHERE DD_STG_ID = (SELECT DD_STG_ID 
										FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO 
										WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||'''
										AND DD_TGA_ID = (SELECT DD_TGA_ID 
															FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO 
															WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_CUENTA(6))||'''))
                    AND DD_CRA_ID = (SELECT DD_CRA_ID  FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_CUENTA(2))||''')
					AND PRO_ID = (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO WHERE PRO.PRO_NOMBRE = '''|| TRIM(V_TMP_CUENTA(7)) ||''')
                    AND CCC_CUENTA_CONTABLE = '||TRIM(V_TMP_CUENTA(3))||'
                    AND EJE_ID = '||V_EJE_ID||'
                    AND CCC_ARRENDAMIENTO = '||TRIM(V_TMP_CUENTA(5))||'';

        EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_CUENTA;

        IF V_EXISTE_CUENTA = 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el gasto '||TRIM(V_TMP_CUENTA(1))||' con el nuevo estado "Pendiente autorizar".');

            V_SQL :=    'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
                        (
                              CCC_ID
                            , DD_STG_ID
                            , DD_CRA_ID
							, PRO_ID
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
								WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||''' 
								AND DD_TGA_ID = (SELECT DD_TGA_ID 
												FROM '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO 
												WHERE DD_TGA_CODIGO = '''||TRIM(V_TMP_CUENTA(6))||'''))
                            ,  (SELECT DD_CRA_ID  FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_CUENTA(2))||''')
							,  (SELECT PRO_ID FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO PRO WHERE PRO.PRO_NOMBRE = '''|| TRIM(V_TMP_CUENTA(7)) ||''')
                            , 0
                            , '''||V_USUARIO||'''
                            , SYSDATE
                            , 0
                            , '||TRIM(V_TMP_CUENTA(3))||'
                            , '||V_EJE_ID||'
                            , '||TRIM(V_TMP_CUENTA(5))||'
                        )';

            EXECUTE IMMEDIATE V_SQL;

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
