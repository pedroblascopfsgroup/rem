--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20190306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3186
--## PRODUCTO=NO
--##
--## Finalidad: Insertar el usuario gestoría de admisión y administración de la cartera Galeon
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
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-3186';

 BEGIN

  EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TIPO_GESTOR = ''GGADM'' 
   AND USERNAME = ''garsa01'' AND COD_CARTERA = ''15'' ' INTO V_COUNT;
   
   
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
 			, ''GGADM''
 			, 15
 			, ''garsa01''
 			, ''GESTORES ADMINISTRATIVOS REUNIDOS SAE Admisión''
 			, '''||V_USUARIO||'''
 			, SYSDATE
 			)
		  ';
	  EXECUTE IMMEDIATE V_SQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);
  ELSE
  	  DBMS_OUTPUT.PUT_LINE('[INFO] El usuario ogf03 ya existia en '||V_TABLA);
  END IF;

   EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TIPO_GESTOR = ''GIAADMT'' 
   AND USERNAME = ''ogf02'' AND COD_CARTERA = ''15'' ' INTO V_COUNT;

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
 			, ''GIAADMT''
 			, 15
 			, ''ogf02''
 			, ''OFICINA DE GESTION DE FIRMAS SL Administración Usuario  genérico''
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
