--/*
--##########################################
--## AUTOR=Juan Beltrán
--## FECHA_CREACION=20191104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5417
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES: Borrar el texto de los gastos 10737017 y 10716478.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-5417';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_TABLA_GPV VARCHAR2(30 CHAR) := 'GPV_GASTOS_PROVEEDOR'; -- Variable para tabla.
	V_TABLA_GIC VARCHAR2(30 CHAR) := 'GIC_GASTOS_INFO_CONTABILIDAD'; -- Variable para tabla.
	
	V_EXISTE_REGISTRO NUMBER(16); -- Vble. para almacenar la busqueda.
	V_REGISTRO_ID NUMBER(16); -- Vble. para almacenar el id de la busqueda.

    TYPE T_CUENTA IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_CUENTAS IS TABLE OF T_CUENTA;
    V_CUENTAS T_ARRAY_CUENTAS := T_ARRAY_CUENTAS(        
            --NUM_GASTO_HAYA		   
      T_CUENTA('10737017'),
      T_CUENTA('10716478')
    );
    V_TMP_CUENTA T_CUENTA;

BEGIN

    FOR I IN V_CUENTAS.FIRST .. V_CUENTAS.LAST

    LOOP
        V_TMP_CUENTA := V_CUENTAS(I);


        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando si existe el gasto '||TRIM(V_TMP_CUENTA(1))||'');

		V_SQL := 	'SELECT COUNT(*)
					FROM '||V_ESQUEMA||'.'||V_TABLA_GPV||'
					WHERE GPV_NUM_GASTO_HAYA = '||TRIM(V_TMP_CUENTA(1))||'';

        EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_REGISTRO;

        IF V_EXISTE_REGISTRO = 1 THEN
        
	        V_SQL := 	'SELECT GPV_ID
						FROM '||V_ESQUEMA||'.'||V_TABLA_GPV||'
						WHERE GPV_NUM_GASTO_HAYA = '||TRIM(V_TMP_CUENTA(1))||'';
	
	        EXECUTE IMMEDIATE V_SQL INTO V_REGISTRO_ID;

            V_SQL :=    'UPDATE '||V_ESQUEMA||'.'||V_TABLA_GPV||'
                          SET DD_DEG_ID = NULL
                        , USUARIOMODIFICAR = '''||V_USUARIO||'''
						, FECHAMODIFICAR = SYSDATE
                          WHERE GPV_NUM_GASTO_HAYA = '||TRIM(V_TMP_CUENTA(1))||''; 
                          
            EXECUTE IMMEDIATE V_SQL;            
            
            V_SQL :=    'UPDATE '||V_ESQUEMA||'.'||V_TABLA_GIC||'
                          SET DD_DEG_ID_CONTABILIZA = NULL
                        , USUARIOMODIFICAR = '''||V_USUARIO||'''
						, FECHAMODIFICAR = SYSDATE
                          WHERE GPV_ID = '||V_REGISTRO_ID||'';                          

            EXECUTE IMMEDIATE V_SQL;  
            
            DBMS_OUTPUT.PUT_LINE('[INFO] Registro procesado correctamente.');
            
        ELSE
        
            DBMS_OUTPUT.PUT_LINE('[INFO] Registro no encontrado.');
            
        END IF;

    END LOOP;

	DBMS_OUTPUT.PUT_LINE('[FIN] Proceso finalizado.');
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
