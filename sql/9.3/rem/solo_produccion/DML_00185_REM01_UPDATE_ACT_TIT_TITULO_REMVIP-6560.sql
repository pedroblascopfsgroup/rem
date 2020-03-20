--/*
--##########################################
--## AUTOR=Juan Beltran
--## FECHA_CREACION=20200311
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6560
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES: Actualizar fecha de presentación en el registro y situación 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6560';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_TABLA VARCHAR2(30 CHAR) := 'ACT_TIT_TITULO'; -- Variable para tabla.
	V_EXISTE_REGISTRO NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.
	V_ACT_ID NUMBER(16); -- Vble. para almacenar el id del activo.

    TYPE T_TITULO IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_TITULOS IS TABLE OF T_TITULO;
    V_TITULOS T_ARRAY_TITULOS := T_ARRAY_TITULOS(        
            --NUM_ACTIVO	FECHA_REGISTRO	ESTADO_TITULO
        T_TITULO('5956900','17/05/2010','02')       
    );
    
    V_TMP_TITULO T_TITULO;

BEGIN

    FOR I IN V_TITULOS.FIRST .. V_TITULOS.LAST

    LOOP
        V_TMP_TITULO := V_TITULOS(I);


        DBMS_OUTPUT.PUT_LINE('[INFO] Comprobando si existe titulo para el activo  '||TRIM(V_TMP_TITULO(1)));
        
        V_SQL := 	'SELECT ACT_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO
					WHERE ACT_NUM_ACTIVO  = '||TRIM(V_TMP_TITULO(1))||'';

        EXECUTE IMMEDIATE V_SQL INTO V_ACT_ID;

		V_SQL := 	'SELECT COUNT(*)
					FROM '||V_ESQUEMA||'.'||V_TABLA||'
					WHERE ACT_ID = '||V_ACT_ID||'';

        EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_REGISTRO;

        IF V_EXISTE_REGISTRO > 0 THEN

            V_SQL :=    'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
                        SET 
						  TIT_FECHA_INSC_REG =   TO_DATE('''||TRIM(V_TMP_TITULO(2))||''', ''DD/MM/YYYY'')
						, DD_ETI_ID = (SELECT DD_ETI_ID FROM '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO WHERE DD_ETI_CODIGO  = '||TRIM(V_TMP_TITULO(3))||')
                        , USUARIOMODIFICAR = '''||V_USUARIO||'''
						, FECHAMODIFICAR = SYSDATE 
                        WHERE ACT_ID = '||V_ACT_ID||'						 
						AND BORRADO = 0';                          

            EXECUTE IMMEDIATE V_SQL;            
            DBMS_OUTPUT.PUT_LINE('[INFO] Registro procesado correctamente.');
            
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Registro de titulo no encontrado.');
            
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
