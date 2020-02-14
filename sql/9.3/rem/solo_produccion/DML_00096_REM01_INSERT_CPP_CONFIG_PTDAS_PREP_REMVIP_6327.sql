--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=201903011
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6327
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir las nuevas partidas presupuestarias para los gastos de Sareb para este 2019
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

	V_TABLA VARCHAR2(30 CHAR) := 'CPP_CONFIG_PTDAS_PREP'; -- Variable para tabla.
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
	V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.
	
	V_EXISTE_PARTIDA NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.

    TYPE T_CUENTA IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_CUENTAS IS TABLE OF T_CUENTA;
    V_CUENTAS T_ARRAY_CUENTAS := T_ARRAY_CUENTAS(

			T_CUENTA( '01', 'G011311', 0 ),
			T_CUENTA( '02', 'G011311', 0 ),
			T_CUENTA( '03', 'G011367', 0 ),
			T_CUENTA( '04', 'G011324', 0 ),
			T_CUENTA( '92', 'G011379', 0 ),

			T_CUENTA( '08', 'G011323', 0 ),
			T_CUENTA( '09', 'G011323', 0 ),
			T_CUENTA( '10', 'G011323', 0 ),
			T_CUENTA( '11', 'G011323', 0 ),
			T_CUENTA( '12', 'G011323', 0 ),
			T_CUENTA( '13', 'G011383', 0 ),
			T_CUENTA( '14', 'G011383', 0 ),
			T_CUENTA( '16', 'G011338', 0 ),
			T_CUENTA( '17', 'G011383', 0 ),
			T_CUENTA( '18', 'G011383', 0 ),
			T_CUENTA( '19', 'G011383', 0 ),
			T_CUENTA( '21', 'G011325', 0 ),
			T_CUENTA( '22', 'G011325', 0 ),
			T_CUENTA( '23', 'G011325', 0 ),
			T_CUENTA( '24', 'G011325', 0 ),
			T_CUENTA( '25', 'G011325', 0 ),
			T_CUENTA( '26', 'G011309', 0 ),
			T_CUENTA( '27', 'G011309', 0 ),
			T_CUENTA( '93', 'G011378', 0 ),
			T_CUENTA( '28', 'G011309', 0 ),
			T_CUENTA( '29', 'G011309', 0 ),
			T_CUENTA( '30', 'G011313', 0 ),
			T_CUENTA( '31', 'G011357', 0 ),
			T_CUENTA( '32', 'G011313', 0 ),
			T_CUENTA( '33', 'G011357', 0 ),
			T_CUENTA( '35', 'G011335', 0 ),
			T_CUENTA( '36', 'G011336', 0 ),
			T_CUENTA( '37', 'G011337', 0 ),
			T_CUENTA( '35', 'G011373', 1 ),
			T_CUENTA( '36', 'G011374', 1 ),
			T_CUENTA( '37', 'G011375', 1 ),
			T_CUENTA( '39', 'G011321', 0 ),
			T_CUENTA( '40', 'G011321', 0 ),
			T_CUENTA( '41', 'G011321', 0 ),
			T_CUENTA( '42', 'G011321', 0 ),
			T_CUENTA( '43', 'G011360', 0 ),
			T_CUENTA( '44', 'G011301', 0 ),
			T_CUENTA( '95', 'G011358', 0 ),
			T_CUENTA( '96', 'G011358', 0 ),
			T_CUENTA( '97', 'G011358', 0 ),
			T_CUENTA( '46', 'G011334', 0 ),
			T_CUENTA( '47', 'G011377', 0 ),
			T_CUENTA( '49', 'G011377', 0 ),
			T_CUENTA( '50', 'G011332', 0 ),
			T_CUENTA( '51', 'G011318', 0 ),
			T_CUENTA( '53', 'G011361', 0 ),
			T_CUENTA( '54', 'G011328', 0 ),
			T_CUENTA( '57', 'G011332', 0 ),	
			T_CUENTA( '58', 'G011329', 0 ),
			T_CUENTA( '59', 'G011351', 0 ),
			T_CUENTA( '60', 'G011330', 0 ),
			T_CUENTA( '61', 'G011333', 0 ),
			T_CUENTA( '62', 'G011346', 0 ),
			T_CUENTA( '63', 'G011332', 0 ),
			T_CUENTA( '64', 'G011360', 0 ),
			T_CUENTA( '65', 'G011376', 0 ),
			T_CUENTA( '66', 'G011376', 0 ),
			T_CUENTA( '67', 'G011376', 0 ),
			T_CUENTA( '68', 'G011332', 0 ),
			T_CUENTA( '69', 'G011332', 0 ),
			T_CUENTA( '70', 'G011317', 0 ),
			T_CUENTA( '71', 'G011316', 0 ),
			T_CUENTA( '72', 'G011315', 0 ),
			T_CUENTA( '73', 'G011315', 0 ),
			T_CUENTA( '74', 'G011315', 0 ),
			T_CUENTA( '75', 'G011315', 0 ),
			T_CUENTA( '76', 'G011316', 0 ),
			T_CUENTA( '77', 'G011316', 0 ),
			T_CUENTA( '78', 'G011316', 0 ),
			T_CUENTA( '79', 'G011316', 0 ),
			T_CUENTA( '81', 'G011332', 0 ),
			T_CUENTA( '82', 'G011316', 0 ),
			T_CUENTA( '83', 'G011316', 0 ),
			T_CUENTA( '85', 'G011327', 0 ),
			T_CUENTA( '86', 'G011327', 0 ),
			T_CUENTA( '87', 'G011327', 0 ),
			T_CUENTA( '89', 'G011349', 0 )
	        
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
                WHERE EJE_ANYO = 2020';
    EXECUTE IMMEDIATE V_SQL INTO V_EJE_ID;

    FOR I IN V_CUENTAS.FIRST .. V_CUENTAS.LAST
    LOOP
        V_TMP_CUENTA := V_CUENTAS(I);

        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando si existe la partida presupuestaria para el subtipo de gasto '||TRIM(V_TMP_CUENTA(1))||', para la cartera de Sareb y para el año de 2020.');

		V_SQL := 	'SELECT COUNT(*)
					FROM CPP_CONFIG_PTDAS_PREP CPP
					INNER JOIN '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = CPP.DD_STG_ID
					INNER JOIN '||V_ESQUEMA||'.DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = STG.DD_TGA_ID
					WHERE CPP.DD_STG_ID = (SELECT DD_STG_ID 
										   FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO 
										   WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||''')
					AND CPP.DD_CRA_ID = '||V_DD_CRA_ID||'
					AND EJE_ID = '||V_EJE_ID||'
					AND CPP_ARRENDAMIENTO = '||TRIM(V_TMP_CUENTA(3))||'';

        EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_PARTIDA;

        IF V_EXISTE_PARTIDA = 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] Añadiendo la partida presupuestaria '||TRIM(V_TMP_CUENTA(2))||' para el subtipo '||TRIM(V_TMP_CUENTA(1))||'.');

            V_SQL :=    'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
                        (
                              CPP_ID
                            , EJE_ID
                            , DD_STG_ID
                            , DD_CRA_ID
                            , CPP_PARTIDA_PRESUPUESTARIA
                            , VERSION
                            , USUARIOCREAR
                            , FECHACREAR
                            , BORRADO
                            , CPP_ARRENDAMIENTO
                        )
                        VALUES
                        (
                            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
							, '||V_EJE_ID||'
							, (SELECT DD_STG_ID 
								FROM '||V_ESQUEMA||'.DD_STG_SUBTIPOS_GASTO STG								
								WHERE DD_STG_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||''' )
                            , '||V_DD_CRA_ID||'
                            , '''||TRIM(V_TMP_CUENTA(2))||'''
                            , 0
                            , '''||V_USUARIO||'''
                            , SYSDATE
                            , 0
                            , '||TRIM(V_TMP_CUENTA(3))||'
                        )';

            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] La partida presupuestaria '||TRIM(V_TMP_CUENTA(3))||' ha sido insertada satisfactoriamente.');

        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el subgasto '||TRIM(V_TMP_CUENTA(1))||' con la partida presupuestaria '||TRIM(V_TMP_CUENTA(2))||' para el año 2020');
        END IF;

    END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso de inserción de partidas presupuestarias.');
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
