--/*
--#########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20180207
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3259
--## PRODUCTO=NO
--## 
--## Finalidad: añadir permisos a los usuarios: acampos, mblascop, acarabal, dmontero, saragon 
--##            
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
    V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3259';
    V_SQL VARCHAR2(4000 CHAR); 
    ERR_NUM NUMBER;-- Numero de errores
    ERR_MSG VARCHAR2(2048);-- Mensaje de error
    PL_OUTPUT VARCHAR2(32000 CHAR);
	V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.


	TYPE T_USUARIO IS TABLE OF VARCHAR2(150);

    -- FILAS A MODIFICAR O CREAR
    TYPE T_ARRAY_USUARIOS IS TABLE OF T_USUARIO;
	
    V_USUARIOS T_ARRAY_USUARIOS := T_ARRAY_USUARIOS(
                  --USUARIO			-- PERFIL
        T_USUARIO('acampos', 		'SUPERFORM'),

        T_USUARIO('mblascop', 		'SUPERGESTACT'),

        T_USUARIO('acarabal', 		'SUPERADMIN'),
		T_USUARIO('dmontero', 		'SUPERADMIN'),

        T_USUARIO('imartin', 		'SUPERMIDDLE'),
		T_USUARIO('lclaret', 		'SUPERMIDDLE'),
		T_USUARIO('rsanchez', 		'SUPERMIDDLE'),
		T_USUARIO('mruiz', 			'SUPERMIDDLE'),
		T_USUARIO('afraile', 		'SUPERMIDDLE'),

        T_USUARIO('saragon', 		'SUPERPUBLI'),

		T_USUARIO('csanchezb', 		'SUPERFRONT'),
		T_USUARIO('lmartinga', 		'SUPERFRONT'),
		T_USUARIO('jdominguezr', 	'SUPERFRONT'),
		T_USUARIO('jgracia', 		'SUPERFRONT'),

		T_USUARIO('fvaldes', 		'SUPERPLANIF'),
		T_USUARIO('dgonzalez', 		'SUPERPLANIF')
    );

	V_TMP_USUARIO T_USUARIO;

BEGIN

	FOR I IN V_USUARIOS.FIRST .. V_USUARIOS.LAST
    LOOP

		V_TMP_USUARIO := V_USUARIOS(I);

		DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos que existe el perfil '||TRIM(V_TMP_USUARIO(2))||'.');

		V_SQL := 'SELECT COUNT(*) PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_USUARIO(2))||''' ';
		EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_PERFIL;


		DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos que existe el usuario '||TRIM(V_TMP_USUARIO(2))||'.');

		V_SQL := 'SELECT COUNT(*) PEF_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_USUARIO(1))||''' ';
		EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_USUARIO;

		IF V_EXISTE_PERFIL = 1 AND V_EXISTE_USUARIO = 1 THEN

			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si existe el usuario ' ||TRIM(V_TMP_USUARIO(1))|| ' con el perfil '||TRIM(V_TMP_USUARIO(2))||'.');

			V_SQL := 'SELECT COUNT(*) 
					FROM '||V_ESQUEMA||'.ZON_PEF_USU 
					WHERE PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_USUARIO(2))||''')
					AND USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_USUARIO(1))||''')';

		EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
		IF V_NUM_FILAS = 0 THEN

				V_SQL := 	'INSERT INTO '||V_ESQUEMA||'.ZON_PEF_USU (
								ZON_ID,
								PEF_ID,
								USU_ID,
								ZPU_ID,
								USUARIOCREAR,
								FECHACREAR
							) VALUES (
								19504,
								(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_USUARIO(2))||'''),
								(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||TRIM(V_TMP_USUARIO(1))||'''),
								S_ZON_PEF_USU.NEXTVAL,
								''REMVIP-3259'',
								SYSDATE
							)';

				EXECUTE IMMEDIATE V_SQL;
				DBMS_OUTPUT.PUT_LINE('  [INFO] Se han insertado '||SQL%ROWCOUNT||' en la tabla ZON_PEF_USU.');
		
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[FIN] El registro ya existe.');
		
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
