--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200102
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6042
--## PRODUCTO=NO
--## 
--## Finalidad: ANULAR GASTOS
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6042';
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_GPV_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del gasto.
	V_EXISTE_GASTO NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.
	V_EXISTE_TRABAJO NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.
	V_ID_PROP NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.

    TYPE T_GASTO IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_GASTOS IS TABLE OF T_GASTO;
    V_GASTOS T_ARRAY_GASTOS := T_ARRAY_GASTOS(
		 
               --NUMERO GASTO
		T_GASTO('10482971'),
		T_GASTO('10482972'),
		T_GASTO('10482973'),
		T_GASTO('10482974'),
		T_GASTO('10482975'),
		T_GASTO('10482976'),
		T_GASTO('10482977'),
		T_GASTO('10482978'),
		T_GASTO('10482979'),
		T_GASTO('10482980'),
		T_GASTO('10482981'),
		T_GASTO('10482982'),
		T_GASTO('10482983'),
		T_GASTO('10482984'),
		T_GASTO('10482985'),
		T_GASTO('10482986'),
		T_GASTO('10482987'),
		T_GASTO('10482988'),
		T_GASTO('10482989'),
		T_GASTO('10482990'),
		T_GASTO('10482991'),
		T_GASTO('10482992'),
		T_GASTO('10482993'),
		T_GASTO('10482994'),
		T_GASTO('10482995'),
		T_GASTO('10482996'),
		T_GASTO('10482997'),
		T_GASTO('10482998'),
		T_GASTO('10482999'),
		T_GASTO('10483000'),
		T_GASTO('10482968'),
		T_GASTO('10482969'),
		T_GASTO('10482970')
   ); 
    V_TMP_GASTO T_GASTO;


BEGIN

	V_SQL := 'SELECT PRO_ID 
		  FROM '||V_ESQUEMA||'.ACT_PRO_PROPIETARIO 
		  WHERE PRO_DOCIDENTIF = ''B87616496''';

		  EXECUTE IMMEDIATE V_SQL INTO V_ID_PROP;

	DBMS_OUTPUT.PUT_LINE('[INICIO]');

		FOR I IN V_GASTOS.FIRST .. V_GASTOS.LAST
		LOOP
			V_TMP_GASTO := V_GASTOS(I);

			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando que existe el gasto '||TRIM(V_TMP_GASTO(1))||'.');

			V_SQL := 'SELECT COUNT(1)
					  FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR 
					  WHERE GPV_NUM_GASTO_HAYA = '||TRIM(V_TMP_GASTO(1));

			EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_GASTO;

			IF V_EXISTE_GASTO > 0 THEN

				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el gasto '||TRIM(V_TMP_GASTO(1)) );

				V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
					  SET PRO_ID = ' || V_ID_PROP || ',
					      USUARIOMODIFICAR = ''' || V_USUARIO || ''',
					      FECHAMODIFICAR = SYSDATE
					  WHERE GPV_NUM_GASTO_HAYA = '||TRIM(V_TMP_GASTO(1))||'';

				EXECUTE IMMEDIATE V_SQL;

				DBMS_OUTPUT.PUT_LINE('[INFO] El gasto '||TRIM(V_TMP_GASTO(1))||' ha sido ACTUALIZADO.');

			ELSE 
				DBMS_OUTPUT.PUT_LINE('[INFO] No se ha encontrado el gasto '||TRIM(V_TMP_GASTO(1)));
			END IF;

		DBMS_OUTPUT.PUT_LINE('***********************************');

		END LOOP;

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
