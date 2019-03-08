--/*
--#########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190307
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3393
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar la cuenta contable de gastos.
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3393';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_TABLA VARCHAR2(30 CHAR) := 'GIC_GASTOS_INFO_CONTABILIDAD'; -- Variable para tabla de salida para el borrado
	V_CUENTA_CONTABLE VARCHAR(50 CHAR) := '6220000000'; -- Vble. para almacenar el número de la nueva cuenta contable.
	V_AGRUPACION_GASTOS VARCHAR(50 CHAR) := '20700006983'; -- Vble. para almacenar el número de la nueva cuenta contable.
	V_PRG_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la agrupación de gastos.
	V_GPV_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del gasto.
	
	V_EXISTE_AGRUPACION_GASTO NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.
	V_EXISTE_GASTO NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.



    TYPE T_GASTO IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_GASTOS IS TABLE OF T_GASTO;
    V_GASTOS T_ARRAY_GASTOS := T_ARRAY_GASTOS(
		 
                --NUMERO GASTO
        T_GASTO('10045639'),
        T_GASTO('10045640'),
        T_GASTO('10045641'),
        T_GASTO('10045642'),
        T_GASTO('10045643'),
        T_GASTO('10045644'),
        T_GASTO('10045645'),
        T_GASTO('10045646'),
		T_GASTO('10045647'),
        T_GASTO('10045648'),
        T_GASTO('10045649'),
        T_GASTO('10045650'),
        T_GASTO('10045651'),
        T_GASTO('10045652'),
        T_GASTO('10045653'),
        T_GASTO('10045654'),
		T_GASTO('10045655')
	
    ); 
    V_TMP_GASTO T_GASTO;



BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando que existe la agrupación de gastos '||V_AGRUPACION_GASTOS||'.');
	V_SQL := 'SELECT COUNT(*)
			  FROM '||V_ESQUEMA||'.PRG_PROVISION_GASTOS
			  WHERE PRG_NUM_PROVISION = '''||V_AGRUPACION_GASTOS||''' ';

	EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_AGRUPACION_GASTO;

	IF V_EXISTE_AGRUPACION_GASTO > 0 THEN

		DBMS_OUTPUT.PUT_LINE('[INFO] Recogiendo el id de la agrupación de gastos '||V_AGRUPACION_GASTOS||'.');
		
		V_SQL := 'SELECT PRG_ID
				  FROM '||V_ESQUEMA||'.PRG_PROVISION_GASTOS
				  WHERE PRG_NUM_PROVISION = '''||V_AGRUPACION_GASTOS||''' ';

		EXECUTE IMMEDIATE V_SQL INTO V_PRG_ID;

		FOR I IN V_GASTOS.FIRST .. V_GASTOS.LAST
		LOOP
			V_TMP_GASTO := V_GASTOS(I);

			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando que existe el gasto '||TRIM(V_TMP_GASTO(1))||'.');

			V_SQL := 'SELECT COUNT(1)
					  FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR 
					  WHERE GPV_NUM_GASTO_HAYA = '||TRIM(V_TMP_GASTO(1))||'
					  AND PRG_ID = '||V_PRG_ID||'';

			EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_GASTO;

			IF V_EXISTE_GASTO > 0 THEN

				DBMS_OUTPUT.PUT_LINE('[INFO] Recogiendo el id del gasto '||TRIM(V_TMP_GASTO(1))||'.');

				V_SQL := 'SELECT GPV_ID
					  FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR 
					  WHERE GPV_NUM_GASTO_HAYA = '||TRIM(V_TMP_GASTO(1))||'
					  AND PRG_ID = '||V_PRG_ID||'';

				EXECUTE IMMEDIATE V_SQL INTO V_GPV_ID;

				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el gasto '||TRIM(V_TMP_GASTO(1))||' con la nueva cuenta contable '||V_CUENTA_CONTABLE||'.');

				V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
						  SET GIC_CUENTA_CONTABLE = '||V_CUENTA_CONTABLE||'
						  WHERE GPV_ID = '||V_GPV_ID||'';

				EXECUTE IMMEDIATE V_SQL;

				DBMS_OUTPUT.PUT_LINE('[INFO] El gasto '||TRIM(V_TMP_GASTO(1))||' ha sido actualizado.');

			ELSE 
				DBMS_OUTPUT.PUT_LINE('[INFO] No se ha encontrado el gasto '||TRIM(V_TMP_GASTO(1))||' de la agrupación de gastos '||V_PRG_ID||'.');
			END IF;

		END LOOP;

	ELSE 
		DBMS_OUTPUT.PUT_LINE('[INFO] No se ha encontrado la agrupación de gastos '||V_AGRUPACION_GASTOS||'.');
	END IF;


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
