--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190410
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3946
--## PRODUCTO=NO
--## 
--## Finalidad: Actualizar estado del gasto y quitarlo de la provisión
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3946';

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

              	T_GASTO('10084976'),
              	T_GASTO('10084977'),
              	T_GASTO('10084978'),
              	T_GASTO('10084979'),
              	T_GASTO('10084981'),
              	T_GASTO('10084983'),
              	T_GASTO('10096741'),
              	T_GASTO('10096742'),
              	T_GASTO('10096743'),
              	T_GASTO('10096744'),
              	T_GASTO('10101908'),
              	T_GASTO('10101912'),
              	T_GASTO('10101909'),
              	T_GASTO('10101911'),
              	T_GASTO('10115244'),
              	T_GASTO('10188445'),
              	T_GASTO('10219116'),
              	T_GASTO('10144238'),
              	T_GASTO('10144104'),
              	T_GASTO('10219109'),
              	T_GASTO('10169442'),
              	T_GASTO('10219948'),
              	T_GASTO('10219949'),
              	T_GASTO('10219950'),
              	T_GASTO('10219951'),
              	T_GASTO('10219952'),
              	T_GASTO('10219953'),
              	T_GASTO('10219954'),
              	T_GASTO('10219958'),
              	T_GASTO('10219959'),
              	T_GASTO('10219960'),
              	T_GASTO('10219961'),
              	T_GASTO('10219962'),
              	T_GASTO('10219963'),
              	T_GASTO('10219964'),
              	T_GASTO('10144241'),
              	T_GASTO('10219966'),
              	T_GASTO('10219967'),
              	T_GASTO('10324201'),
              	T_GASTO('10260436'),
              	T_GASTO('10260437'),
              	T_GASTO('10260438'),
              	T_GASTO('10333446'),
              	T_GASTO('10339551'),
              	T_GASTO('10219990'),
              	T_GASTO('10219991'),
              	T_GASTO('10333348'),
              	T_GASTO('10261321'),
              	T_GASTO('10261322'),
              	T_GASTO('10261323'),
              	T_GASTO('10338642'),
              	T_GASTO('10333448'),
              	T_GASTO('10219971'),
              	T_GASTO('10219972'),
              	T_GASTO('10278506'),
              	T_GASTO('10330630'),
              	T_GASTO('10262331'),
              	T_GASTO('10339552'),
              	T_GASTO('10219947'),
              	T_GASTO('10262328'),
              	T_GASTO('10339558'),
              	T_GASTO('10413922'),
              	T_GASTO('10413923'),
              	T_GASTO('10413924'),
              	T_GASTO('10413925'),
              	T_GASTO('10413926'),
              	T_GASTO('10413927'),
              	T_GASTO('10413928'),
              	T_GASTO('10413929'),
              	T_GASTO('10413930'),
              	T_GASTO('10413931'),
              	T_GASTO('10413932'),
              	T_GASTO('10219944'),
              	T_GASTO('10338637'),
              	T_GASTO('10413911'),
              	T_GASTO('10413912'),
              	T_GASTO('10413913'),
              	T_GASTO('10413914'),
              	T_GASTO('10413915'),
              	T_GASTO('10413916'),
              	T_GASTO('10413917'),
              	T_GASTO('10413918'),
              	T_GASTO('10413919'),
              	T_GASTO('10413920'),
              	T_GASTO('10413921'),
              	T_GASTO('10262329'),
              	T_GASTO('10262330'),
              	T_GASTO('10338640'),
              	T_GASTO('10339555')


	
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
					  SET DD_EGA_ID = (SELECT DD_EGA_ID FROM  ' || V_ESQUEMA || '.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''12''),
					      PRG_ID = NULL,
					      USUARIOMODIFICAR = ''REMVIP-3946'',
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
