--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=201903011
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6327
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6327';

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
        
		T_CUENTA( '01', '6310000000', 0 ),
		T_CUENTA( '02', '6310000000', 0 ),
		T_CUENTA( '03', '6320000000', 0 ),
		T_CUENTA( '04', '6320000000', 0 ),

		T_CUENTA( '92', '6780000004', 0 ),
		T_CUENTA( '08', '6310000000', 0 ),
		T_CUENTA( '09', '6310000000', 0 ),
		T_CUENTA( '10', '6310000000', 0 ),
		T_CUENTA( '11', '6310000000', 0 ),
		T_CUENTA( '12', '6310000000', 0 ),
		T_CUENTA( '13', '6310000000', 0 ),
		T_CUENTA( '14', '6310000000', 0 ),
		T_CUENTA( '16', '6310000000', 0 ),
		T_CUENTA( '17', '6310000000', 0 ),
		T_CUENTA( '18', '6310000000', 0 ),

		T_CUENTA( '19', '6310000000', 0 ),

		T_CUENTA( '21', '6780000004', 0 ),
		T_CUENTA( '22', '6780000004', 0 ),
		T_CUENTA( '23', '6780000004', 0 ),
		T_CUENTA( '24', '6780000004', 0 ),
		T_CUENTA( '25', '6780000004', 0 ),
		T_CUENTA( '26', '6220000000', 0 ),
		T_CUENTA( '27', '6220000000', 0 ),
		T_CUENTA( '93', '6220000000', 0 ),
		T_CUENTA( '26', '6210400000', 1 ),
		T_CUENTA( '27', '6210400000', 1 ),
		T_CUENTA( '28', '6220000000', 0 ),
		T_CUENTA( '29', '6220000000', 0 ),
		T_CUENTA( '30', '6210500000', 0 ),
		T_CUENTA( '31', '6220000000', 0 ),
		T_CUENTA( '32', '6210500000', 0 ),
		T_CUENTA( '33', '6220000000', 0 ),
		T_CUENTA( '35', '6280200000', 0 ),
		T_CUENTA( '36', '6280100000', 0 ),
		T_CUENTA( '37', '6280500000', 0 ),
		T_CUENTA( '39', '6250000000', 0 ),
		T_CUENTA( '40', '6250000000', 0 ),
		T_CUENTA( '41', '6250000000', 0 ),
		T_CUENTA( '42', '6250000000', 0 ),

		T_CUENTA( '43', '6230600000', 0 ),
		T_CUENTA( '44', '6230600000', 0 ),
		T_CUENTA( '95', '6230600000', 0 ),
		T_CUENTA( '96', '6230600000', 0 ),
		T_CUENTA( '97', '6230600000', 0 ),
		T_CUENTA( '46', '6230600000', 0 ),
		T_CUENTA( '47', '6230600000', 0 ),
		T_CUENTA( '49', '6230600000', 0 ),
		T_CUENTA( '50', '6230700000', 0 ),
		T_CUENTA( '51', '6230000001', 0 ),
		T_CUENTA( '53', '6230100000', 0 ),
		T_CUENTA( '54', '6230100000', 0 ),

		T_CUENTA( '57', '6230700000', 0 ),
		T_CUENTA( '58', '6230700000', 0 ),
		T_CUENTA( '59', '6230700000', 0 ),
		T_CUENTA( '60', '6230700000', 0 ),
		T_CUENTA( '61', '6230700000', 0 ),
		T_CUENTA( '62', '6230700000', 0 ),
		T_CUENTA( '63', '6230700000', 0 ),
		T_CUENTA( '64', '6230600000', 0 ),
		T_CUENTA( '65', '6230700000', 0 ),
		T_CUENTA( '66', '6230700000', 0 ),
		T_CUENTA( '67', '6230700000', 0 ),
		T_CUENTA( '68', '6230700000', 0 ),
		T_CUENTA( '69', '6230700000', 0 ),
		T_CUENTA( '70', '6222000002', 0 ),
		T_CUENTA( '71', '6222000002', 0 ),
		T_CUENTA( '72', '6222000002', 0 ),
		T_CUENTA( '73', '6222000002', 0 ),
		T_CUENTA( '74', '6222000002', 0 ),
		T_CUENTA( '75', '6222000002', 0 ),
		T_CUENTA( '76', '6222000002', 0 ),
		T_CUENTA( '77', '6222000002', 0 ),
		T_CUENTA( '78', '6222000002', 0 ),
		T_CUENTA( '79', '6222000002', 0 ),
		T_CUENTA( '81', '6230700000', 0 ),
		T_CUENTA( '82', '6222000002', 0 ),
		T_CUENTA( '83', '6222000002', 0 ),
		T_CUENTA( '85', '6291100000', 0 ),
		T_CUENTA( '86', '6291100000', 0 ),
		T_CUENTA( '87', '6291100000', 0 ),
		T_CUENTA( '89', '6292000000', 0 )

    );

    V_TMP_CUENTA T_CUENTA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id de la cartera, porque es el mismo para todos.');

    V_SQL :=    'SELECT DD_CRA_ID 
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
                WHERE DD_CRA_CODIGO = ''02''';
    EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;

    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id del año, porque es el mismo para todos.');

    V_SQL :=    'SELECT EJE_ID 
                FROM '||V_ESQUEMA||'.ACT_EJE_EJERCICIO 
                WHERE EJE_ANYO = ''2020'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_EJE_ID;

    FOR I IN V_CUENTAS.FIRST .. V_CUENTAS.LAST
    LOOP
        V_TMP_CUENTA := V_CUENTAS(I);

        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando si existe el subtipo de gasto '||TRIM(V_TMP_CUENTA(1))||' para la cartera de Sareb y para el año de 2020.');

        V_SQL :=   'SELECT COUNT(1)
                    FROM '||V_ESQUEMA||'.'||V_TABLA||' 
                    WHERE DD_STG_ID = ( SELECT DD_STG_ID 
					FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO 
					WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||''' )
                    AND DD_CRA_ID = '||V_DD_CRA_ID||'
                    AND CCC_CUENTA_CONTABLE = '||TRIM(V_TMP_CUENTA(2))||'
                    AND EJE_ID = '||V_EJE_ID||'
                    AND CCC_ARRENDAMIENTO = '||TRIM(V_TMP_CUENTA(3))||'';

        EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_CUENTA;

        IF V_EXISTE_CUENTA = 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] Creando la configuración para el subtipo de gasto '||TRIM(V_TMP_CUENTA(1))||' ');

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
                            , ( SELECT DD_STG_ID 
				FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO 
				WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||''' )
                            , '||V_DD_CRA_ID||'
                            , 0
                            , '''||V_USUARIO||'''
                            , SYSDATE
                            , 0
                            , '||TRIM(V_TMP_CUENTA(2))||'
                            , '||V_EJE_ID||'
                            , '||TRIM(V_TMP_CUENTA(3))||'
                        )';

            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] El subtipo de gasto '||TRIM(V_TMP_CUENTA(1))||' ha sido insertado satisfactoriamente.');

        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el subgasto '||TRIM(V_TMP_CUENTA(1))||' con la cuenta contable '||TRIM(V_TMP_CUENTA(2))||' para el año 2020.');
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
