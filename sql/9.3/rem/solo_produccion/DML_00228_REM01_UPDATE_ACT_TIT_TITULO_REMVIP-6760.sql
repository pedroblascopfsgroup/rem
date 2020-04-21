--/*
--##########################################
--## AUTOR=Juan Beltran
--## FECHA_CREACION=20200331
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6760
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-6760';

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
        T_TITULO('7227040','15/10/2019','02'),
        T_TITULO('7227041','15/10/2019','02'),
        T_TITULO('7227042','15/10/2019','02'),
        T_TITULO('7227043','15/10/2019','02'),
        T_TITULO('7227044','15/10/2019','02'),
        T_TITULO('7227045','15/10/2019','02'),
        T_TITULO('7227046','15/10/2019','02'),
        T_TITULO('7227008','15/10/2019','02'),
        T_TITULO('7227009','15/10/2019','02'),
        T_TITULO('7227010','15/10/2019','02'),
        T_TITULO('7227011','15/10/2019','02'),
        T_TITULO('7227012','15/10/2019','02'),
        T_TITULO('7227013','15/10/2019','02'),
        T_TITULO('7227014','15/10/2019','02'),
        T_TITULO('7227015','15/10/2019','02'),
        T_TITULO('7227016','15/10/2019','02'),
        T_TITULO('7227017','15/10/2019','02'),
        T_TITULO('7227018','15/10/2019','02'),
        T_TITULO('7227019','15/10/2019','02'),
        T_TITULO('7227020','15/10/2019','02'),
        T_TITULO('7227021','15/10/2019','02'),
        T_TITULO('7227022','15/10/2019','02'),
        T_TITULO('7227023','15/10/2019','02'),
        T_TITULO('7227024','15/10/2019','02'),
        T_TITULO('7227025','15/10/2019','02'),
        T_TITULO('7227026','15/10/2019','02'),
        T_TITULO('7227027','15/10/2019','02'),
        T_TITULO('7227028','15/10/2019','02'),
        T_TITULO('7227029','15/10/2019','02'),
        T_TITULO('7227030','15/10/2019','02'),
        T_TITULO('7227031','15/10/2019','02'),
        T_TITULO('7227032','15/10/2019','02'),
        T_TITULO('7227033','15/10/2019','02'),
        T_TITULO('7227034','15/10/2019','02'),
        T_TITULO('7227035','15/10/2019','02'),
        T_TITULO('7227036','15/10/2019','02'),
        T_TITULO('7227037','15/10/2019','02'),
        T_TITULO('7227038','15/10/2019','02'),
        T_TITULO('7228988','15/10/2019','02'),
        T_TITULO('7228989','15/10/2019','02'),
        T_TITULO('7228990','15/10/2019','02'),
        T_TITULO('7228991','15/10/2019','02'),
        T_TITULO('7228992','15/10/2019','02'),
        T_TITULO('7228993','15/10/2019','02'),
        T_TITULO('7228994','15/10/2019','02'),
        T_TITULO('7228995','15/10/2019','02'),
        T_TITULO('7228996','15/10/2019','02'),
        T_TITULO('7228997','15/10/2019','02'),
        T_TITULO('7228998','15/10/2019','02'),
        T_TITULO('7228999','15/10/2019','02'),
        T_TITULO('7229000','15/10/2019','02'),
        T_TITULO('7229001','15/10/2019','02'),
        T_TITULO('7229002','15/10/2019','02'),
        T_TITULO('7229003','15/10/2019','02'),
        T_TITULO('7229004','15/10/2019','02'),
        T_TITULO('7229005','15/10/2019','02'),
        T_TITULO('7229006','15/10/2019','02'),
        T_TITULO('7229007','15/10/2019','02'),
        T_TITULO('7229008','15/10/2019','02'),
        T_TITULO('7229009','15/10/2019','02'),
        T_TITULO('7229010','15/10/2019','02'),
        T_TITULO('7229011','15/10/2019','02'),
        T_TITULO('7229012','15/10/2019','02'),
        T_TITULO('7229013','15/10/2019','02'),
        T_TITULO('7229014','15/10/2019','02'),
        T_TITULO('7229015','15/10/2019','02'),
        T_TITULO('7229016','15/10/2019','02'),
        T_TITULO('7229017','15/10/2019','02'),
        T_TITULO('7229018','15/10/2019','02'),
        T_TITULO('7229019','15/10/2019','02'),
        T_TITULO('7229020','15/10/2019','02'),
        T_TITULO('7229021','15/10/2019','02'),
        T_TITULO('7229022','15/10/2019','02'),
        T_TITULO('7229023','15/10/2019','02'),
        T_TITULO('7229024','15/10/2019','02'),
        T_TITULO('7229025','15/10/2019','02'),
        T_TITULO('7229026','15/10/2019','02'),
        T_TITULO('7229027','15/10/2019','02'),
        T_TITULO('7229028','15/10/2019','02'),
        T_TITULO('7229029','15/10/2019','02'),
        T_TITULO('7229030','15/10/2019','02'),
        T_TITULO('7229031','15/10/2019','02'),
        T_TITULO('7229032','15/10/2019','02'),
        T_TITULO('7229033','15/10/2019','02'),
        T_TITULO('7229034','15/10/2019','02'),
        T_TITULO('7229035','15/10/2019','02'),
        T_TITULO('7229036','15/10/2019','02'),
        T_TITULO('7229037','15/10/2019','02'),
        T_TITULO('7229038','15/10/2019','02'),
        T_TITULO('7229039','15/10/2019','02'),
        T_TITULO('7229040','15/10/2019','02'),
        T_TITULO('7229041','15/10/2019','02'),
        T_TITULO('7229042','15/10/2019','02'),
        T_TITULO('7229043','15/10/2019','02'),
        T_TITULO('7229044','15/10/2019','02'),
        T_TITULO('7229045','15/10/2019','02'),
        T_TITULO('7229046','15/10/2019','02'),
        T_TITULO('7229047','15/10/2019','02'),
        T_TITULO('7229048','15/10/2019','02'),
        T_TITULO('7229049','15/10/2019','02')


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
