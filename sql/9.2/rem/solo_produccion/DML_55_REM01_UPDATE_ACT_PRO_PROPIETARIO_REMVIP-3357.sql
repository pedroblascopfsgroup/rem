--/*
--#########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190225
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=?
--## INCIDENCIA_LINK=REMVIP-3357
--## PRODUCTO=NO
--## 
--## Finalidad: Revivir al propietario BANCAJA 5 FTA
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

	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-3357';
	V_BORRADO_FISICO VARCHAR2(2 CHAR) := 'SI';--SI o NO, no vale ningún otro valor ni minúsculas, ni acentos.

	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	ERR_NUM NUMBER;-- Numero de errores
	ERR_MSG VARCHAR2(2048);-- Mensaje de error
	V_SQL VARCHAR2(4000 CHAR);

	V_TABLA VARCHAR2(30 CHAR) := 'ACT_PRO_PROPIETARIO'; -- Variable para tabla de salida para el borrado
	V_PORPIETARIO VARCHAR(50 CHAR) := 'BANCAJA 5 FTA'; -- Vble. para almacenar el nombre del propietario.
	V_EXISTE_PORPIETARIO NUMBER(16); -- Vble. para almacenar el resultado del propietario.

BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos que existe el propietario '||V_PORPIETARIO||'.');
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE PRO_NOMBRE = '''||V_PORPIETARIO||''' ';
	EXECUTE IMMEDIATE V_SQL INTO V_EXISTE_PORPIETARIO;

	IF V_EXISTE_PORPIETARIO > 0 THEN

		DBMS_OUTPUT.PUT_LINE('[INFO] Se va a aplicar el borrado lógico sobre el propietario '||V_PORPIETARIO||'.');

		V_SQL := 	'UPDATE '||V_ESQUEMA_M||'.'||V_TABLA||'
					SET BORRADO = 0,
					USUARIOMODIFICAR = '''||V_USUARIO||''',
					FECHAMODIFICAR = SYSDATE
					WHERE PRO_NOMBRE = '''||V_PORPIETARIO||''' ';

	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe el propietario '||V_PORPIETARIO||'.');
	END IF;

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
