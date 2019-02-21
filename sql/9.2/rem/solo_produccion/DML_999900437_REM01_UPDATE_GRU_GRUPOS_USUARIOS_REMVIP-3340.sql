/*
--##########################################
--## AUTOR=Rasul Akhmeddiribov
--## FECHA_CREACION=20190214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3340
--## PRODUCTO=NO
--##
--## Finalidad: Borrado logico de usuarios en la GRU_GRUPOS_USUARIOS
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3340';
    V_SQL VARCHAR2(4000 CHAR); 
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);
	V_EXISTE_PERFIL NUMBER(16); -- Vble. para validar la existencia de los nuevos perfiles.
	V_EXISTE_USUARIO NUMBER(16); -- Vble. para validar la existencia de los usuarios.
	V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.


    TYPE T_USUARIO IS TABLE OF VARCHAR2(1000);

    TYPE T_ARRAY_USUARIOS IS TABLE OF T_USUARIO;
    V_USUARIOS T_ARRAY_USUARIOS := T_ARRAY_USUARIOS(
		 
                        --USU_USERNAME
        T_USUARIO('52370957A_duplicado'),
        T_USUARIO('11814546K_duplicado'),
        T_USUARIO('46927378H_duplicado'),
        T_USUARIO('acabello_duplicado'),
        T_USUARIO('orubio_duplicado'),
        T_USUARIO('jvallejo_duplicado'),
        T_USUARIO('achillon_duplicado'),
        T_USUARIO('ralvarez_duplicado')
	
    ); 
    V_TMP_USUARIO T_USUARIO;

    
BEGIN	
	
    FOR I IN V_USUARIOS.FIRST .. V_USUARIOS.LAST
    LOOP

		V_TMP_USUARIO := V_USUARIOS(I);

		DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos que existe el usuario '||TRIM(V_TMP_USUARIO(1))||' y que está borrado.');

		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_USUARIO(1))||''' AND BORRADO = 1';
		EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_USUARIO;

		IF V_EXISTE_USUARIO = 1 THEN

            DBMS_OUTPUT.PUT_LINE('[INFO] Se va a aplicar el borrado lógico sobre la relación entre el grupo y el usuario '||TRIM(V_TMP_USUARIO(1))||'.');

            V_SQL := 	'UPDATE '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS
                        SET BORRADO = 1,
                        USUARIOBORRAR = ''REMVIP-3340'',
                        FECHABORRAR = SYSDATE
                        WHERE USU_ID_USUARIO  = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_USUARIO(1))||''') ';

            EXECUTE IMMEDIATE V_SQL;

            DBMS_OUTPUT.PUT_LINE('[INFO] Se ha borrado la relación entre el grupo y el usuario '||TRIM(V_TMP_USUARIO(1))||'.');
			
        ELSE
        
            DBMS_OUTPUT.PUT_LINE('[FIN] El registro ya está borrado.');
        
        END IF;
		
	END LOOP;

   COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/

EXIT;
