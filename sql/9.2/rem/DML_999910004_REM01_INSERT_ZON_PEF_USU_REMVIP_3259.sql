--/*
--#########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190205
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


	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);

    -- FILAS A MODIFICAR O CREAR
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TMP_TIPO_DATA T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
                    --USU_USERNAME
        T_TIPO_DATA('''acampos'''),
        T_TIPO_DATA('''mblascop'''),
        T_TIPO_DATA('''acarabal'''),
        T_TIPO_DATA('''dmontero'''),
        T_TIPO_DATA('''saragon''')
    );


BEGIN

	DBMS_OUTPUT.PUT_LINE('[INICIO] Añadimos el perfil SUPERUSUARIONECOGIO a los usuarios acampos, mblascop, acarabal, dmontero, saragon.');

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
    LOOP

		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si existe el usuario ' ||TRIM(V_TMP_TIPO_DATA(1))|| ' con el perfil SUPERUSUARIONECOGIO.');
		
		V_SQL := 'SELECT COUNT(*) 
				FROM '||V_ESQUEMA||'.ZON_PEF_USU 
				WHERE PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SUPERUSUARIONECOGIO'')
				AND USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '||TRIM(V_TMP_TIPO_DATA(1))||')';
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
								(SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''SUPERUSUARIONECOGIO''),
								(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '||TRIM(V_TMP_TIPO_DATA(1))||'),
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
