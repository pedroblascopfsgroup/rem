--/*
--#########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190308
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3435
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3393';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_TABLA VARCHAR2(30 CHAR) := 'GPV_GASTOS_PROVEEDOR'; -- Variable para tabla 
	V_CODIGO_ESTADO_GASTO VARCHAR(50 CHAR) := '01'; -- Vble. para almacenar el código del nuevo estado del gasto.
	V_NUM_PROVISION VARCHAR(50 CHAR) := '181223021'; -- Vble. para almacenar el número de la provisión.
	V_PRG_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la agrupación de gastos.
	V_GPV_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del gasto.
	
	V_EXISTE_PROVISION_GASTO NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.
	V_EXISTE_GASTO NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.



    TYPE T_GASTO IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_GASTOS IS TABLE OF T_GASTO;
    V_GASTOS T_ARRAY_GASTOS := T_ARRAY_GASTOS(
		 
                --NUMERO GASTO
        T_GASTO('10097439'),
		T_GASTO('10097440'),
		T_GASTO('10097441'),
		T_GASTO('10097442'),
		T_GASTO('10097443'),
		T_GASTO('10097444'),
		T_GASTO('10097445'),
		T_GASTO('10097446'),
		T_GASTO('10097447'),
		T_GASTO('10097448'),
		T_GASTO('10097449'),
		T_GASTO('10097450'),
		T_GASTO('10097451'),
		T_GASTO('10097452'),
		T_GASTO('10097453'),
		T_GASTO('10097454'),
		T_GASTO('10097455'),
		T_GASTO('10097457'),
		T_GASTO('10097458'),
		T_GASTO('10097459'),
		T_GASTO('10097460')
	
    ); 
    V_TMP_GASTO T_GASTO;



BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando que existe la agrupación de gastos '||V_NUM_PROVISION||'.');
	V_SQL := 'SELECT COUNT(*)
			  FROM '||V_ESQUEMA||'.PRG_PROVISION_GASTOS
			  WHERE PRG_NUM_PROVISION = '''||V_NUM_PROVISION||''' ';

	EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_PROVISION_GASTO;

	IF V_EXISTE_PROVISION_GASTO > 0 THEN

		DBMS_OUTPUT.PUT_LINE('[INFO] Recogiendo el id de la agrupación de gastos '||V_NUM_PROVISION||'.');
		
		V_SQL := 'SELECT PRG_ID
				  FROM '||V_ESQUEMA||'.PRG_PROVISION_GASTOS
				  WHERE PRG_NUM_PROVISION = '''||V_NUM_PROVISION||''' ';

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

				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el gasto '||TRIM(V_TMP_GASTO(1))||' con el nuevo estado "Pendiente autorizar".');

				V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
						  SET DD_EGA_ID = (SELECT DD_EGA_ID FROM DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = '''||V_CODIGO_ESTADO_GASTO||''')
						  WHERE GPV_ID = '||V_GPV_ID||'';

				EXECUTE IMMEDIATE V_SQL;

				DBMS_OUTPUT.PUT_LINE('[INFO] El gasto '||TRIM(V_TMP_GASTO(1))||' ha sido actualizado.');

			ELSE 
				DBMS_OUTPUT.PUT_LINE('[INFO] No se ha encontrado el gasto '||TRIM(V_TMP_GASTO(1))||' de la agrupación de gastos '||V_PRG_ID||'.');
			END IF;

		END LOOP;

	ELSE 
		DBMS_OUTPUT.PUT_LINE('[INFO] No se ha encontrado la agrupación de gastos '||V_NUM_PROVISION||'.');
	END IF;

	DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso de actualización de gastos.');
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
