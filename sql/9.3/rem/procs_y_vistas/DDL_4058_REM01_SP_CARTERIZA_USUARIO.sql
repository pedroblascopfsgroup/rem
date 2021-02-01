--/*
--##########################################
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20180424
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.17
--## INCIDENCIA_LINK=REMVIP-583
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.CARTERIZA_USUARIO
    ( USU_USERNAME IN #ESQUEMA_MASTER#.USU_USUARIOS.USU_USERNAME%TYPE
    , DD_CRA_DESCRIPCION IN #ESQUEMA#.DD_CRA_CARTERA.DD_CRA_DESCRIPCION%TYPE
    , PL_OUTPUT OUT VARCHAR2)
    
    AS

   V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar        
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_COUNT NUMBER(16); -- Vble. para contar.
   V_KOUNT NUMBER(16); -- Vble. para kontar.
   V_QOUNT NUMBER(16); -- Vble. para qontar.
   USU_ID NUMBER(16);
   DD_CRA_ID NUMBER(16);
   DD_CRA_OLD VARCHAR2(64 CHAR);

BEGIN
	
	-- Comprobamos la existencia del usuario
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE LOWER(USU_USERNAME) = LOWER('''||USU_USERNAME||''')' INTO V_COUNT
					  ;
	
	IF V_COUNT = 1 THEN
		EXECUTE IMMEDIATE 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE LOWER(USU_USERNAME) = LOWER('''||USU_USERNAME||''')' INTO USU_ID
						  ;
	ELSE
		PL_OUTPUT := PL_OUTPUT || CHR(10) ||'[ERROR] El usuario no existe'
					;
	END IF;

	-- Comprobamos la existencia de la cartera
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE LOWER(DD_CRA_DESCRIPCION) = LOWER('''||DD_CRA_DESCRIPCION||''')' INTO V_KOUNT
					  ;

	IF V_KOUNT = 1 THEN
		EXECUTE IMMEDIATE 'SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE LOWER(DD_CRA_DESCRIPCION) = LOWER('''||DD_CRA_DESCRIPCION||''')' INTO DD_CRA_ID
						  ;
	ELSE
		PL_OUTPUT := PL_OUTPUT || CHR(10) ||'[ERROR] La cartera no existe'
					;
	END IF;

	IF V_COUNT = 1 THEN
		
		-- Si existe el usuario comprobamos que no este previamente carterizado		
		EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.UCA_USUARIO_CARTERA WHERE USU_ID = '||USU_ID INTO V_QOUNT;

	END IF;

	-- Si no estaba carterizado insertamos el nuevo registro
	IF V_COUNT = 1 AND V_KOUNT = 1 AND V_QOUNT = 0 THEN
		V_SQL := 'INSERT INTO '||V_ESQUEMA||'.UCA_USUARIO_CARTERA VALUES (
					  '||V_ESQUEMA||'.S_UCA_USUARIO_CARTERA.NEXTVAL
					, '||USU_ID||'
					, '||DD_CRA_ID||'
					)
				 ';

		EXECUTE IMMEDIATE V_SQL;

		PL_OUTPUT := PL_OUTPUT || CHR(10) ||'[INFO] Usuario '||USU_USERNAME||' correctamente carterizado para '||DD_CRA_DESCRIPCION||''
					;

	END IF;

	-- Si estaba carterizado actualizamos el anterior registro
	IF V_COUNT = 1 AND V_KOUNT = 1 AND V_QOUNT = 1 THEN

		EXECUTE IMMEDIATE 'SELECT DD_CRA_DESCRIPCION FROM '||V_ESQUEMA||'.DD_CRA_CARTERA WHERE DD_CRA_ID = 
		(SELECT DD_CRA_ID FROM '||V_ESQUEMA||'.UCA_USUARIO_CARTERA WHERE USU_ID = '||USU_ID||')' INTO DD_CRA_OLD;

		PL_OUTPUT := PL_OUTPUT || CHR(10) ||'[WARNING] El usuario '||USU_USERNAME||' está carterizado para '||DD_CRA_OLD||', se va a cambiar a '||DD_CRA_DESCRIPCION||''
					;

		V_SQL := 'UPDATE '||V_ESQUEMA||'.UCA_USUARIO_CARTERA SET
					DD_CRA_ID = '||DD_CRA_ID||'
					WHERE USU_ID = '||USU_ID||'
				 ';

		EXECUTE IMMEDIATE V_SQL;

		PL_OUTPUT := PL_OUTPUT || CHR(10) ||'[INFO] Usuario '||USU_USERNAME||' correctamente carterizado para '||DD_CRA_DESCRIPCION||''
					;

	END IF;

    COMMIT;
    
EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      PL_OUTPUT := PL_OUTPUT || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END CARTERIZA_USUARIO;
/
EXIT;
