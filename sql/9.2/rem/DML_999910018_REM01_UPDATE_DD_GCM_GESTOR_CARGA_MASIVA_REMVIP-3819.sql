--/*
--#########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=201903014
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3586
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir a los gestores que se pueden agregar a los activos/expedientes/agrupaciones por carga masiva.
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3586';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

    V_EXISTE_GESTOR NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.

	V_TABLA VARCHAR2(30 CHAR) := 'DD_GCM_GESTOR_CARGA_MASIVA'; -- Variable para tabla.
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
	V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.
	
	

    TYPE T_CUENTA IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_CUENTAS IS TABLE OF T_CUENTA;
    V_CUENTAS T_ARRAY_CUENTAS := T_ARRAY_CUENTAS(
        
                --CODIGO GESTOR		   --CARTERA	--DD_GCM_ACTIVO	
        T_CUENTA('GCOM',			    '02',				1)
    );
    V_TMP_CUENTA T_CUENTA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');


    FOR I IN V_CUENTAS.FIRST .. V_CUENTAS.LAST
    LOOP
        V_TMP_CUENTA := V_CUENTAS(I);


    DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id de la cartera, porque es el mismo para todos.');

		V_SQL :=    'SELECT DD_CRA_ID 
					FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
					WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_CUENTA(2))||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;

		DBMS_OUTPUT.PUT_LINE('[INFO] Comprobaciones previas.');

		V_SQL := 	'SELECT COUNT(*)
					FROM '||V_ESQUEMA||'.'||V_TABLA||'
					WHERE DD_GCM_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||'''
					AND DD_CRA_ID = '||V_DD_CRA_ID||'
					AND DD_GCM_ACTIVO = '||TRIM(V_TMP_CUENTA(3))||'';

        EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_GESTOR;

        IF V_EXISTE_GESTOR = 0 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] Configuración (activo: '||TRIM(V_TMP_CUENTA(3))||'.');

            V_SQL :=    'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                        SET DD_GCM_ACTIVO = '||TRIM(V_TMP_CUENTA(3))||'
                        WHERE DD_GCM_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||'''
                        AND  DD_CRA_ID = (SELECT DD_CRA_ID 
									FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
									WHERE DD_CRA_CODIGO = '||TRIM(V_TMP_CUENTA(2))||')';

            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Gestor '||TRIM(V_TMP_CUENTA(1))||' actualizado satisfactoriamente.');

        ELSE 
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el gestor '||TRIM(V_TMP_CUENTA(1))||' para la cartera '||V_DD_CRA_ID||' con esa configuración (activo: '||TRIM(V_TMP_CUENTA(3))||'.');
        END IF;

    END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso correctamente.');
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
