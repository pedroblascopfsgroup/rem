--/*
--#########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190417
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3616
--## PRODUCTO=NO
--## 
--## Finalidad: Relanzar gastos
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3616';

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

                         T_GASTO('10381107')
	
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

				V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR
					  SET DD_EGA_ID = ( SELECT DD_EGA_ID FROM  ' || V_ESQUEMA || '.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''06'' ),
					      USUARIOMODIFICAR = ''' || V_USUARIO || ''',
					      FECHAMODIFICAR = SYSDATE
					  WHERE GPV_ID = '||V_GPV_ID||'';

				EXECUTE IMMEDIATE V_SQL;


				V_SQL := 'UPDATE '||V_ESQUEMA||'.GPV_TBJ
					  SET BORRADO = 1,
					      USUARIOBORRAR = ''' || V_USUARIO || ''',
					      FECHABORRAR   = SYSDATE
					  WHERE GPV_ID = '||V_GPV_ID||'';	

				EXECUTE IMMEDIATE V_SQL;


				DBMS_OUTPUT.PUT_LINE('[INFO] El gasto '||TRIM(V_TMP_GASTO(1))||' ha sido anulado.');

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
