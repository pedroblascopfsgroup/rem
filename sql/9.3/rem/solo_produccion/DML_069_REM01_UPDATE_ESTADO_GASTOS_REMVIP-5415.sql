--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191003
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5415
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar estado del gasto 
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-5415';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_GPV_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del gasto.
	
	V_EXISTE_GASTO NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.



    TYPE T_GASTO IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_GASTOS IS TABLE OF T_GASTO;
    V_GASTOS T_ARRAY_GASTOS := T_ARRAY_GASTOS(
		 
                --NUMERO GASTO

              T_GASTO('9700558'),
		T_GASTO('10451966'),
		T_GASTO('10451806'),
		T_GASTO('10451808'),
		T_GASTO('10451809'),
		T_GASTO('10451811'),
		T_GASTO('10451812'),
		T_GASTO('10451813'),
		T_GASTO('10451815'),
		T_GASTO('10451816'),
		T_GASTO('10451817'),
		T_GASTO('10451819'),
		T_GASTO('10451820'),
		T_GASTO('10451821'),
		T_GASTO('10451823'),
		T_GASTO('10451824'),
		T_GASTO('10451825'),
		T_GASTO('10451827'),
		T_GASTO('10451828'),
		T_GASTO('10451829'),
		T_GASTO('10451831'),
		T_GASTO('10451832'),
		T_GASTO('10451833'),
		T_GASTO('10451835'),
		T_GASTO('10451836'),
		T_GASTO('10451837'),
		T_GASTO('10451839'),
		T_GASTO('10451840'),
		T_GASTO('10451841'),
		T_GASTO('10451843'),
		T_GASTO('10451844'),
		T_GASTO('10451845'),
		T_GASTO('10451847'),
		T_GASTO('10451848'),
		T_GASTO('10451850'),
		T_GASTO('10410408')


	
   ); 
    V_TMP_GASTO T_GASTO;



BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');


		FOR I IN V_GASTOS.FIRST .. V_GASTOS.LAST
		LOOP
			V_TMP_GASTO := V_GASTOS(I);

			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando que existe el gasto '||TRIM(V_TMP_GASTO(1))||'.');

			V_SQL := 'SELECT COUNT(1)
					  FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR 
					  WHERE GPV_NUM_GASTO_HAYA = '||TRIM(V_TMP_GASTO(1));

			EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_GASTO;

			IF V_EXISTE_GASTO > 0 THEN

				DBMS_OUTPUT.PUT_LINE('[INFO] Recogiendo el id del gasto '||TRIM(V_TMP_GASTO(1))||'.');

				V_SQL := 'SELECT GPV_ID
					  FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR 
					  WHERE GPV_NUM_GASTO_HAYA = '||TRIM(V_TMP_GASTO(1));

				EXECUTE IMMEDIATE V_SQL INTO V_GPV_ID;

				DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando el gasto '||TRIM(V_TMP_GASTO(1)) );

				EXECUTE IMMEDIATE V_SQL;

				V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
					  SET DD_EGA_ID = 2,
					      USUARIOMODIFICAR = ''REMVIP-5415'',
					      FECHAMODIFICAR = SYSDATE
					  WHERE GPV_ID = '||V_GPV_ID||'';

				EXECUTE IMMEDIATE V_SQL;

					  V_SQL := 'UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION
					  SET DD_EAH_ID = 2,
					      USUARIOMODIFICAR = ''REMVIP-5415'',
					      FECHAMODIFICAR = SYSDATE
					  WHERE GPV_ID = '||V_GPV_ID||'';

				EXECUTE IMMEDIATE V_SQL;

				DBMS_OUTPUT.PUT_LINE('[INFO] El gasto '||TRIM(V_TMP_GASTO(1))||' ha sido actualizado.');

				

			ELSE 
				DBMS_OUTPUT.PUT_LINE('[INFO] No se ha encontrado el gasto '||TRIM(V_TMP_GASTO(1))  );
			END IF;

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
