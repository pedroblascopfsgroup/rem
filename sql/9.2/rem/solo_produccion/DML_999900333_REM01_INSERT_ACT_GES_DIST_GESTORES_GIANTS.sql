--/*
--##########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20180926
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1973
--## PRODUCTO=NO
--##
--## Finalidad:  Copiar la asignacion de gestores de Bankia para GFORM y SFORM a la cartera Giants (Cartera 12).
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_GES_DIST_GESTORES';
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1973';

    
 BEGIN

	--QUITAMOS (BORRADO LÓGICO) LOS GESTORES DE GIANTS DE FORMALIZACION	
	V_SQL := '  UPDATE REM01.ACT_GES_DIST_GESTORES DIS SET
					 DIS.USUARIOBORRAR = '''||V_USUARIO||''',
					 DIS.FECHABORRAR = SYSDATE,
					 DIS.BORRADO = 0
				WHERE DIS.TIPO_GESTOR IN (''GFORM'',''SFORM'')
				  AND DIS.COD_CARTERA = 12
		     ';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrado lógico de  '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA);


	--AÑADIMOS A GIANTS LOS GESTOR/SUPERVISOR DE FORMALIZACION DE BANKIA
	V_SQL := '  INSERT INTO REM01.ACT_GES_DIST_GESTORES DIS (
					ID, TIPO_GESTOR, COD_CARTERA, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION,
					COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO,
					USUARIOCREAR, FECHACREAR, BORRADO
				)
					SELECT  REM01.S_ACT_GES_DIST_GESTORES.NEXTVAL, 
							TIPO_GESTOR, 12, COD_ESTADO_ACTIVO, COD_TIPO_COMERZIALZACION,
							COD_PROVINCIA, COD_MUNICIPIO, COD_POSTAL, USERNAME, NOMBRE_USUARIO,
							'''||V_USUARIO||''', SYSDATE, BORRADO
					FROM REM01.ACT_GES_DIST_GESTORES DIS2
					WHERE DIS2.TIPO_GESTOR IN (''GFORM'',''SFORM'')
					  AND DIS2.COD_CARTERA = 3
					  AND DIS2.BORRADO = 0
		     ';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Insertados '||SQL%ROWCOUNT||' registros en la tabla '||V_TABLA);

    COMMIT;
    
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
