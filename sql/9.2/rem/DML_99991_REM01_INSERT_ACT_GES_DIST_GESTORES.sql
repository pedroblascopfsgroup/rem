--/*
--##########################################
--## AUTOR=JINLI HU 
--## FECHA_CREACION=20181203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2741
--## PRODUCTO=NO
--##
--## Finalidad: Insertar el usuario gestoría de formalización de la cartera Galeon
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
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-2741';

 BEGIN

  EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TIPO_GESTOR = ''GIAFORM'' 
   AND USERNAME = ''ogf03'' AND COD_CARTERA = ''15'' ' INTO V_COUNT;
   
   
  IF V_COUNT = 0 THEN
  
  	  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
 			  ID
			, TIPO_GESTOR
			, COD_CARTERA
			, USERNAME
			, NOMBRE_USUARIO
			, USUARIOCREAR
			, FECHACREAR
 			) VALUES (
 			  S_'||V_TABLA||'.NEXTVAL
 			, ''GIAFORM''
 			, 15
 			, ''ogf03''
 			, ''OGF''
 			, '''||V_USUARIO||'''
 			, SYSDATE
 			)
		  ';
	  EXECUTE IMMEDIATE V_SQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);
  ELSE
  	  DBMS_OUTPUT.PUT_LINE('[INFO] El usuario ogf03 ya existia en '||V_TABLA);
  END IF;

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

