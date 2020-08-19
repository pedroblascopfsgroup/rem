--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20200805
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7443
--## PRODUCTO=NO
--##
--## Finalidad: INSERTAR PROPIETARIOS Y ASIGNAR ACTIVOS
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_TABLA NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_TABLA_ACT VARCHAR2(27 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_PRO VARCHAR2(27 CHAR) := 'ACT_PRO_PROPIETARIO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TABLA_PRO_ACT VARCHAR2(27 CHAR) := 'ACT_PAC_PROPIETARIO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-7443';
    V_PROPIETARIO NUMBER(16); -- Vble. para validar la existencia de un propietario.
    V_PROPIETARIO_ID NUMBER(16); -- Vble. para validar la existencia de un id de propietario.
    V_ACTIVO NUMBER(16); -- Vble. para validar la existencia de un activo.
    V_ACTIVO_ID NUMBER(16); -- Vble. para validar la existencia de un id de activo.
    V_PRO_ACTIVO NUMBER(16); -- Vble. para validar la existencia de un propietario para el activo.

    TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
		-- NIF / RAZON_SOC / ACT_UVEM / ACT_HAYA
	T_TIPO_DATA('V85143659','CAIXA PENEDES PYMES 1 TDA',34577776,7300538),
	T_TIPO_DATA('V85500866','CAIXA PENEDES FTGENCAT 1 TDA',34342924,7300524),
	T_TIPO_DATA('V84856319','CAIXA PENEDES 1 TDA',34715893,7302137)
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;

 BEGIN
	DBMS_OUTPUT.PUT_LINE('[INICIO]');

	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''PRO_DOCIDENTIF'' AND TABLE_NAME = '''||V_TABLA_PRO||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLA;

	IF V_NUM_TABLA = 1 THEN

	DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE LA TABLA '''||V_TABLA_PRO||'''');
	DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAMOS PROPIETARIOS');

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      	    LOOP
      		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PRO||' WHERE PRO_DOCIDENTIF = '''||V_TMP_TIPO_DATA(1)||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_PROPIETARIO;

		IF V_PROPIETARIO = 0 THEN

			V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_PRO||' (PRO_ID,PRO_NOMBRE,PRO_DOCIDENTIF,USUARIOCREAR,FECHACREAR) VALUES
			('||V_ESQUEMA||'.S_'||V_TABLA_PRO||'.NEXTVAL, '''||V_TMP_TIPO_DATA(2)||''','''||V_TMP_TIPO_DATA(1)||''','''||V_USUARIO||''',SYSDATE)'; 
			EXECUTE IMMEDIATE V_SQL ;
			
			DBMS_OUTPUT.put_line('[INFO] Se ha insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA_PRO||'');

		ELSE

			DBMS_OUTPUT.put_line('[INFO] YA EXISTE EL PROPIETARIO CON NIF '''||V_TMP_TIPO_DATA(1)||'''');

		END IF;
	END LOOP;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] FIN DE INSERTAR PROPIETARIOS');
	    
    	ELSE

		DBMS_OUTPUT.put_line('[INFO] NO EXISTE LA TABLA '''||V_TABLA_PRO||'''');

	END IF;

	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''ACT_NUM_ACTIVO'' AND TABLE_NAME = '''||V_TABLA_ACT||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLA;

	IF V_NUM_TABLA = 1 THEN

	DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE LA TABLA '''||V_TABLA_ACT||'''');
	DBMS_OUTPUT.PUT_LINE('[INFO] COMPROBAMOS LOS ACTIVOS');

	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
      	    LOOP
      		V_TMP_TIPO_DATA := V_TIPO_DATA(I);

		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(4)||''' AND 			ACT_NUM_ACTIVO_UVEM = '''||V_TMP_TIPO_DATA(3)||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_ACTIVO;

		IF V_ACTIVO = 1 THEN

			V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''PAC_ID'' AND TABLE_NAME = '''||V_TABLA_PRO_ACT||''' and owner = '''||V_ESQUEMA||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLA;

			IF V_NUM_TABLA = 1 THEN

				DBMS_OUTPUT.PUT_LINE('[INFO] EXISTE LA TABLA '''||V_TABLA_PRO_ACT||'''');
				DBMS_OUTPUT.PUT_LINE('[INFO] BUSCAMOS EL PROPIETARIO CON NIF '''||V_TMP_TIPO_DATA(1)||''' Y EL ACTIVO DE HAYA '''||V_TMP_TIPO_DATA(4)||'''');
				V_SQL := 'SELECT PRO_ID FROM '||V_ESQUEMA||'.'||V_TABLA_PRO||' WHERE PRO_DOCIDENTIF = '''||V_TMP_TIPO_DATA(1)||'''';
				EXECUTE IMMEDIATE V_SQL INTO V_PROPIETARIO_ID;
				V_SQL := 'SELECT ACT_ID FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' WHERE ACT_NUM_ACTIVO = '''||V_TMP_TIPO_DATA(4)||''' AND 			ACT_NUM_ACTIVO_UVEM = '''||V_TMP_TIPO_DATA(3)||'''';
				EXECUTE IMMEDIATE V_SQL INTO V_ACTIVO_ID;
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_PRO_ACT||' WHERE ACT_ID = '''||V_ACTIVO_ID||''' AND 			BORRADO = 0';
				EXECUTE IMMEDIATE V_SQL INTO V_PRO_ACTIVO;

				IF V_PRO_ACTIVO = 0 THEN

					V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA_PRO_ACT||' (PAC_ID,ACT_ID, PRO_ID,USUARIOCREAR,FECHACREAR)
					VALUES ('||V_ESQUEMA||'.S_'||V_TABLA_PRO_ACT||'.NEXTVAL,'''||V_ACTIVO_ID||''', '''||V_PROPIETARIO_ID||''','''||V_USUARIO||''',SYSDATE)'; 
					EXECUTE IMMEDIATE V_SQL ;
			
					DBMS_OUTPUT.put_line('[INFO] Se ha insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA_PRO_ACT||'');

				ELSE

					V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA_PRO_ACT||' 
					SET PRO_ID = '''||V_PROPIETARIO_ID||''',
					USUARIOMODIFICAR = '''||V_USUARIO||''',
					FECHAMODIFICAR = SYSDATE
					WHERE ACT_ID = '''||V_ACTIVO_ID||''' AND BORRADO = 0'; 
					EXECUTE IMMEDIATE V_SQL ;
			
					DBMS_OUTPUT.put_line('[INFO] Se ha modificado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA_PRO_ACT||'');

				END IF;			

			ELSE 
				
				DBMS_OUTPUT.put_line('[INFO] NO EXISTE LA TABLA '''||V_TABLA_PRO_ACT||'''');

			END IF;

		ELSE

			DBMS_OUTPUT.put_line('[INFO] NO EXISTE EL ACTIVO DE HAYA '''||V_TMP_TIPO_DATA(4)||'''');

		END IF;
	END LOOP;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] FIN DE INSERTAR ACTIVOS A PROPIETARIOS');
	    
    	ELSE

		DBMS_OUTPUT.put_line('[INFO] NO EXISTE LA TABLA '''||V_TABLA_ACT||'''');

	END IF;
		DBMS_OUTPUT.put_line('[FIN]');
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

