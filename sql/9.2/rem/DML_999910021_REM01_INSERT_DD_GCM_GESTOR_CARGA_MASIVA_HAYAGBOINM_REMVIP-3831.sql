--/*
--#########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190401
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3831
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3831';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_TABLA VARCHAR2(30 CHAR) := 'DD_GCM_GESTOR_CARGA_MASIVA'; -- Variable para tabla.
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
	V_EJE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del año.
	
	V_EXISTE_REGISTRO NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.

    TYPE T_CUENTA IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_CUENTAS IS TABLE OF T_CUENTA;
    V_CUENTAS T_ARRAY_CUENTAS := T_ARRAY_CUENTAS(
        
                --CODIGO GESTOR		   --CARTERA	--DD_GCM_ACTIVO		--DD_GCM_EXPEDIENTE		--DD_GCM_AGRUPACION
        T_CUENTA('GIAFORM',			    '02',				1,						0,					1)

    );
    V_TMP_CUENTA T_CUENTA;

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Haciendo comprobaciones previas... ');


    FOR I IN V_CUENTAS.FIRST .. V_CUENTAS.LAST
    LOOP
        V_TMP_CUENTA := V_CUENTAS(I);


        DBMS_OUTPUT.PUT_LINE('[INFO] Recogemos el valor id de la cartera.');

		V_SQL :=    'SELECT DD_CRA_ID 
					FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
					WHERE DD_CRA_CODIGO = '''||TRIM(V_TMP_CUENTA(2))||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;

		DBMS_OUTPUT.PUT_LINE('[INFO] Comprobaciones previas.');

        

		V_SQL := 	'SELECT COUNT(*)
					FROM '||V_ESQUEMA||'.'||V_TABLA||'
					WHERE DD_GCM_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||'''
					AND DD_CRA_ID = '||V_DD_CRA_ID||'';

        EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_REGISTRO;

        IF V_EXISTE_REGISTRO = 0 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] Añadiendo al nuevo gestor '||TRIM(V_TMP_CUENTA(1))||' para la cartera '||V_DD_CRA_ID||'.');
			DBMS_OUTPUT.PUT_LINE('[INFO] Configuración (activo: '||TRIM(V_TMP_CUENTA(3))||' | expediente: '||TRIM(V_TMP_CUENTA(4))||' | agrupación: '||TRIM(V_TMP_CUENTA(5))||')');

            V_SQL :=    'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
                        (
                              DD_GCM_ID
                            , DD_GCM_CODIGO
                            , DD_GCM_DESCRIPCION
                            , DD_GCM_DESCRIPCION_LARGA
                            , DD_CRA_ID
                            , DD_GCM_ACTIVO
                            , DD_GCM_EXPEDIENTE
                            , DD_GCM_AGRUPACION
                            , VERSION
                            , USUARIOCREAR
							, FECHACREAR
							, BORRADO
                        )
                        VALUES
                        (
                            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
							, '''||TRIM(V_TMP_CUENTA(1))||'''
							, (SELECT DD_TGE_DESCRIPCION 
							   FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR
							   WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||''')
							, (SELECT DD_TGE_DESCRIPCION_LARGA
							   FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR
							   WHERE DD_TGE_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||''')
                            , '||V_DD_CRA_ID||'
                            , '||TRIM(V_TMP_CUENTA(3))||'
                            , '||TRIM(V_TMP_CUENTA(4))||'
							, '||TRIM(V_TMP_CUENTA(5))||'
							, 0
                            , '''||V_USUARIO||'''
                            , SYSDATE
                            , 0
                        )';

            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Nuevo gestor '||TRIM(V_TMP_CUENTA(1))||' ha sido insertado satisfactoriamente.');

        ELSE 
            
            V_SQL := 	'SELECT COUNT(*)
					FROM '||V_ESQUEMA||'.'||V_TABLA||'
					WHERE DD_GCM_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||'''
					AND DD_CRA_ID = '||V_DD_CRA_ID||'
                    AND DD_GCM_ACTIVO = '||TRIM(V_TMP_CUENTA(3))||'
					AND DD_GCM_EXPEDIENTE = '||TRIM(V_TMP_CUENTA(4))||'
					AND DD_GCM_AGRUPACION = '||TRIM(V_TMP_CUENTA(5))||'';

            EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_REGISTRO;
            
            IF V_EXISTE_REGISTRO = 0 THEN
                
                DBMS_OUTPUT.PUT_LINE('[INFO] Procediendo a actualizar el registro.');

                V_SQL :=    'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                          SET DD_GCM_ACTIVO =   '||TRIM(V_TMP_CUENTA(3))||'
                        , DD_GCM_EXPEDIENTE =   '||TRIM(V_TMP_CUENTA(4))||'
                        , DD_GCM_AGRUPACION =   '||TRIM(V_TMP_CUENTA(5))||'
                        , VERSION = VERSION + 1
                        , USUARIOMODIFICAR = '''||V_USUARIO||'''
						, FECHAMODIFICAR = SYSDATE
                          WHERE DD_GCM_CODIGO = '''||TRIM(V_TMP_CUENTA(1))||'''
                          AND DD_CRA_ID = '||V_DD_CRA_ID||'';

                EXECUTE IMMEDIATE V_SQL;

            ELSE 
                DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro con los datos correctos.');
            END IF;

            DBMS_OUTPUT.PUT_LINE('[INFO] Registro procesado correctamente.');

        END IF;

    END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN] Finalizado el proceso de cinfiguración de masivos.');
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
