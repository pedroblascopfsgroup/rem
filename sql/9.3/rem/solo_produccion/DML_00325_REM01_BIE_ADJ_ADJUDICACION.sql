--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20200605
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7237
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7237';

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_EXISTE_REGISTRO NUMBER(16); -- Vble. para almacenar el resultado de la busqueda.
	V_ACT_ID NUMBER(16); -- Vble. para almacenar el id del activo.

    TYPE T_TITULO IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_TITULOS IS TABLE OF T_TITULO;
    V_TITULOS T_ARRAY_TITULOS := T_ARRAY_TITULOS(        
            --NUM_ACTIVO	FECHA_REGISTRO	ESTADO_TITULO
		T_TITULO('7227008'),
		T_TITULO('7227109'),
		T_TITULO('7228988'),
		T_TITULO('7228989'),
		T_TITULO('7228990'),
		T_TITULO('7228991'),
		T_TITULO('7228992'),
		T_TITULO('7228993'),
		T_TITULO('7228994'),
		T_TITULO('7228995'),
		T_TITULO('7228996'),
		T_TITULO('7228997'),
		T_TITULO('7228998'),
		T_TITULO('7228999'),
		T_TITULO('7229000'),
		T_TITULO('7229001'),
		T_TITULO('7229002'),
		T_TITULO('7229003'),
		T_TITULO('7229004'),
		T_TITULO('7229005'),
		T_TITULO('7229006'),
		T_TITULO('7229007'),
		T_TITULO('7229008'),
		T_TITULO('7229009'),
		T_TITULO('7229010'),
		T_TITULO('7229011'),
		T_TITULO('7229012'),
		T_TITULO('7229013'),
		T_TITULO('7229014'),
		T_TITULO('7229015'),
		T_TITULO('7229016'),
		T_TITULO('7229017'),
		T_TITULO('7229018'),
		T_TITULO('7229019'),
		T_TITULO('7229020'),
		T_TITULO('7229021'),
		T_TITULO('7229022'),
		T_TITULO('7229023'),
		T_TITULO('7229024'),
		T_TITULO('7229025'),
		T_TITULO('7229026'),
		T_TITULO('7229027'),
		T_TITULO('7229028'),
		T_TITULO('7229029'),
		T_TITULO('7229030'),
		T_TITULO('7229031'),
		T_TITULO('7229032'),
		T_TITULO('7229033'),
		T_TITULO('7229034'),
		T_TITULO('7229035'),
		T_TITULO('7229036'),
		T_TITULO('7229037'),
		T_TITULO('7229038'),
		T_TITULO('7229039'),
		T_TITULO('7229040'),
		T_TITULO('7229041'),
		T_TITULO('7229042'),
		T_TITULO('7229043'),
		T_TITULO('7229044'),
		T_TITULO('7229045'),
		T_TITULO('7229046'),
		T_TITULO('7229047'),
		T_TITULO('7229048'),
		T_TITULO('7229049')


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

        IF V_ACT_ID > 0 THEN

         

            V_SQL :=    'UPDATE '||V_ESQUEMA||'.BIE_ADJ_ADJUDICACION 
			SET BIE_ADJ_F_DECRETO_FIRME = TO_DATE(''10/10/2019'', ''DD/MM/YYYY''),
			BIE_ADJ_F_DECRETO_N_FIRME = TO_DATE(''10/10/2019'', ''DD/MM/YYYY''),
                        USUARIOMODIFICAR = '''||V_USUARIO||''',
			FECHAMODIFICAR = SYSDATE 
                        WHERE BIE_ID = (SELECT BIE_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||V_ACT_ID||')			 
			AND BORRADO = 0';                          

            EXECUTE IMMEDIATE V_SQL;            

            V_SQL :=    'UPDATE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SET 
			SPS_OCUPADO = 0
                        , USUARIOMODIFICAR = '''||V_USUARIO||'''
			, FECHAMODIFICAR = SYSDATE 
                        WHERE ACT_ID = '||V_ACT_ID||'
			AND BORRADO = 0';                          

            EXECUTE IMMEDIATE V_SQL;       

            V_SQL :=    'UPDATE '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL SET 
			AJD_FECHA_ADJUDICACION = TO_DATE(''10/10/2019'', ''DD/MM/YYYY'')
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
