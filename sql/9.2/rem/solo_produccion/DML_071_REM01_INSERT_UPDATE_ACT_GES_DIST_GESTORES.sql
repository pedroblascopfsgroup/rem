--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20190314
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-3186';

 BEGIN

  EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TIPO_GESTOR = ''GGADM'' 
   AND USERNAME = ''tecnotra03'' AND COD_CARTERA = ''7'' AND COD_PROVINCIA IS NULL AND COD_MUNICIPIO IS NULL AND COD_POSTAL IS NULL ' INTO V_COUNT;
   
   
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
 			, 7 
 			, ''tecnotra01''
 			, ''TECNOTRAMIT GESTION SL. Admisión Usuario  genérico''
 			, '''||V_USUARIO||'''
 			, SYSDATE
 			)
		  ';
	  EXECUTE IMMEDIATE V_SQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);
  ELSE
  	  DBMS_OUTPUT.PUT_LINE('[INFO] El usuario tecnotra01 ya existia en '||V_TABLA);
  END IF;

  EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TIPO_GESTOR = ''GIAADMT'' 
   AND USERNAME = ''tecnotra02'' AND COD_CARTERA = ''7'' AND COD_PROVINCIA IS NULL AND COD_MUNICIPIO IS NULL AND COD_POSTAL IS NULL ' INTO V_COUNT;
   
   
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
 			, 7 
 			, ''tecnotra02''
 			, ''TECNOTRAMIT GESTION SL. Administración Usuario  genérico''
 			, '''||V_USUARIO||'''
 			, SYSDATE
 			)
		  ';
	  EXECUTE IMMEDIATE V_SQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);
  ELSE
  	  DBMS_OUTPUT.PUT_LINE('[INFO] El usuario tecnotra02 ya existia en '||V_TABLA);
  END IF;

  EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE TIPO_GESTOR = ''GIAFORM'' 
   AND USERNAME = ''tecnotra03'' AND COD_CARTERA = ''7'' AND COD_PROVINCIA IS NULL AND COD_MUNICIPIO IS NULL AND COD_POSTAL IS NULL ' INTO V_COUNT;
   
   
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
 			, 7 
 			, ''tecnotra03''
 			, ''TECNOTRAMIT GESTION SL. Administración Usuario  genérico''
 			, '''||V_USUARIO||'''
 			, SYSDATE
 			)
		  ';
	  EXECUTE IMMEDIATE V_SQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);
  ELSE
  	  DBMS_OUTPUT.PUT_LINE('[INFO] El usuario tecnotra03 ya existia en '||V_TABLA);
  END IF;

      V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' DIST SET 
		USERNAME = ''tecnotra03'',
		NOMBRE_USUARIO = ''TECNOTRAMIT GESTION SL. Formalización Usuario  genérico'', 
		USUARIOMODIFICAR = ''REMVIP-3186'',
		FECHAMODIFICAR = SYSDATE 
		WHERE TIPO_GESTOR = ''GIAFORM'' 
		AND COD_CARTERA = 7 
		AND USERNAME <> ''tecnotra03''
		  ';

	  EXECUTE IMMEDIATE V_SQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);

      V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' DIST SET 
		USERNAME = ''tecnotra02'',
		NOMBRE_USUARIO = ''TECNOTRAMIT GESTION SL. Administración Usuario  genérico'', 
		USUARIOMODIFICAR = ''REMVIP-3186'',
		FECHAMODIFICAR = SYSDATE 
		WHERE TIPO_GESTOR = ''GIAADMT'' 
		AND COD_CARTERA = 7 
		AND USERNAME <> ''tecnotra02''
		  ';

	  EXECUTE IMMEDIATE V_SQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);

      V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' DIST SET 
		USERNAME = ''tecnotra01'',
		NOMBRE_USUARIO = ''TECNOTRAMIT GESTION SL. Admisión Usuario  genérico'', 
		USUARIOMODIFICAR = ''REMVIP-3186'',
		FECHAMODIFICAR = SYSDATE 
		WHERE TIPO_GESTOR = ''GGADM'' 
		AND COD_CARTERA = 7 
		AND USERNAME <> ''tecnotra01''
		  ';

	  EXECUTE IMMEDIATE V_SQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);

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
