--/*
--#########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20200414
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-6947
--## PRODUCTO=SI
--##
--## Finalidad: Inserción RST_BROKER
--##
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--## 	    0.2 VRO - REMVIP-5079 Añadidos registros, comprobaciones y que sea relanzable
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para cconsulta de existencia de una tabla
  V_NUM_REGISTROS NUMBER(16);
  V_ENTORNO NUMBER(16); -- Vble. para validar el entorno en el que estamos.
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.


  --Array que contiene los registros que se van a crear en entorno PRO
  TYPE T_COL_PRO IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_COL_PRO IS TABLE OF T_COL_PRO;
  V_COL_PRO T_ARRAY_COL_PRO := T_ARRAY_COL_PRO(
      -- Recordatorios
	T_COL_PRO('192.168.127.49', 'ff',0, 0)

  );
  V_TMP_COL_PRO T_COL_PRO;

--Array que contiene los registros que se van a crear en entorno PREVIO
  TYPE T_COL_PRE IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_COL_PRE IS TABLE OF T_COL_PRE;
  V_COL_PRE T_ARRAY_COL_PRE := T_ARRAY_COL_PRE(
      -- Recordatorios
	T_COL_PRE('192.168.127.49', 'ff',0, 0)

  );
  V_TMP_COL_PRE T_COL_PRE;

BEGIN

        --Comprobacion de la tabla
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = ''RST_BROKER''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS > 0 THEN
            -- Verificar el entorno en el que estamos
            V_MSQL := 'SELECT CASE
                  WHEN SYS_CONTEXT ( ''USERENV'', ''DB_NAME'' ) = ''orarem'' THEN 1
                  ELSE 0
                  END AS ES_PRO
              FROM DUAL';

            EXECUTE IMMEDIATE V_MSQL INTO V_ENTORNO;

            IF V_ENTORNO = 1 THEN

		FOR I IN V_COL_PRO.FIRST .. V_COL_PRO.LAST
		LOOP

		V_TMP_COL_PRO := V_COL_PRO(I);

			-- Comprobar el dato a insertar.
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.RST_BROKER WHERE RST_IP = '''||TRIM(V_TMP_COL_PRO(1))||'''
				  AND RST_KEY = '''||TRIM(V_TMP_COL_PRO(2))||''' AND  RST_VALIDAR_FIRMA = '''||TRIM(V_TMP_COL_PRO(3))||'''
	   			  AND RST_VALIDAR_TOKEN = '''||TRIM(V_TMP_COL_PRO(4))||''' ';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;

	       		IF V_NUM_REGISTROS < 1 THEN

				DBMS_OUTPUT.PUT_LINE('  [INFO] Creando el registro en PRO...');

				-- Añadimos el registro
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.RST_BROKER (RST_BROKER_ID, RST_IP, RST_KEY, RST_VALIDAR_FIRMA, RST_VALIDAR_TOKEN, USUARIOCREAR, FECHACREAR, VERSION, BORRRADO)
				    VALUES ('||V_ESQUEMA||'.S_RST_BROKER.NEXTVAL, '''||TRIM(V_TMP_COL_PRO(1))||''', '''||TRIM(V_TMP_COL_PRO(2))||''', '''||TRIM(V_TMP_COL_PRO(3))||''' , '''||TRIM(V_TMP_COL_PRO(4))||''' , ''REMVIP-6947'', SYSDATE, 0, 0)';

				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('REGISTRO '''||TRIM(V_TMP_COL_PRO(1))||''' INSERTADO');

			ELSE
				DBMS_OUTPUT.PUT_LINE('EL REGISTRO YA EXISTE');
			END IF;

	        END LOOP;

            ELSE

		FOR I IN V_COL_PRE.FIRST .. V_COL_PRE.LAST
		LOOP

		V_TMP_COL_PRE := V_COL_PRE(I);

			-- Comprobar el dato a insertar.
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.RST_BROKER WHERE RST_IP = '''||TRIM(V_TMP_COL_PRE(1))||'''
				  AND RST_KEY = '''||TRIM(V_TMP_COL_PRE(2))||''' AND  RST_VALIDAR_FIRMA = '''||TRIM(V_TMP_COL_PRE(3))||'''
	   			  AND RST_VALIDAR_TOKEN = '''||TRIM(V_TMP_COL_PRE(4))||''' ';

			EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;

	       		IF V_NUM_REGISTROS < 1 THEN

				DBMS_OUTPUT.PUT_LINE('  [INFO] Creando el registro en entorno previo...');

				-- Añadimos el registro
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.RST_BROKER (RST_BROKER_ID, RST_IP, RST_KEY, RST_VALIDAR_FIRMA, RST_VALIDAR_TOKEN, USUARIOCREAR, FECHACREAR, VERSION, BORRADO)
				    VALUES ('||V_ESQUEMA||'.S_RST_BROKER.NEXTVAL, '''||TRIM(V_TMP_COL_PRE(1))||''', '''||TRIM(V_TMP_COL_PRE(2))||''', '''||TRIM(V_TMP_COL_PRE(3))||''' , '''||TRIM(V_TMP_COL_PRE(4))||''' , ''REMVIP-6947'', SYSDATE, 0, 0)';

				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('REGISTRO '''||TRIM(V_TMP_COL_PRE(1))||''' INSERTADO');

			ELSE
				DBMS_OUTPUT.PUT_LINE('EL REGISTRO YA EXISTE');
			END IF;

	        END LOOP;

	     END IF;

        ELSE
            DBMS_OUTPUT.PUT_LINE('  [INFO] '''||V_ESQUEMA||''' RST_BROKER... No existe.');
        END IF;

    COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('KO!');
    err_num := SQLCODE;
    err_msg := SQLERRM;

    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(err_msg);

    ROLLBACK;
    RAISE;

END;

/

EXIT;