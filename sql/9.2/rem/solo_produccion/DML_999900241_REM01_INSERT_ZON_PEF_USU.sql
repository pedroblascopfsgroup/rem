--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-97
--## PRODUCTO=NO
--##
--## Finalidad: Añadir perfil de gestor y supervisor comercial a Esther Navidades
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
    V_TABLA VARCHAR2(27 CHAR) := 'ZON_PEF_USU'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-97';
	V_ACT_ID_HAYA VARCHAR2(32 CHAR);
	ZON_ID NUMBER(16);
	PEF_ID NUMBER(16);
	USU_ID NUMBER(16);
    
 BEGIN
 
  EXECUTE IMMEDIATE 'SELECT ZON_ID FROM '||V_ESQUEMA||'.ZON_ZONIFICACION
   WHERE ZON_COD = ''01545465454''' INTO ZON_ID;

  EXECUTE IMMEDIATE 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS
   WHERE USU_USERNAME = ''enavidades''' INTO USU_ID;

  EXECUTE IMMEDIATE 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES
   WHERE PEF_CODIGO = ''HAYAGESTCOM''' INTO PEF_ID;

  EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE USU_ID = '||USU_ID||' 
   AND PEF_ID = '||PEF_ID INTO V_COUNT;
   
   
  IF V_COUNT = 0 THEN
  
  	  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
 			  ZON_ID
			, PEF_ID
			, USU_ID
			, ZPU_ID
			, USUARIOCREAR
			, FECHACREAR
 			) VALUES (
 			  '||ZON_ID||'
 			, '||PEF_ID||'
 			, '||USU_ID||'
 			, S_'||V_TABLA||'.NEXTVAL
 			, '''||V_USUARIO||'''
 			, SYSDATE
 			)
		  ';
	  EXECUTE IMMEDIATE V_SQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);
  END IF;
  
  EXECUTE IMMEDIATE 'SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES
   WHERE PEF_CODIGO = ''HAYASUPCOM''' INTO PEF_ID;
  
  EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ZON_PEF_USU WHERE USU_ID = '||USU_ID||' 
   AND PEF_ID = '||PEF_ID INTO V_COUNT;
   
  IF V_COUNT = 0 THEN
  	  V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
 			  ZON_ID
			, PEF_ID
			, USU_ID
			, ZPU_ID
			, USUARIOCREAR
			, FECHACREAR
 			) VALUES (
 			  '||ZON_ID||'
 			, '||PEF_ID||'
 			, '||USU_ID||'
 			, S_'||V_TABLA||'.NEXTVAL
 			, '''||V_USUARIO||'''
 			, SYSDATE
 			)
		  ';
	  EXECUTE IMMEDIATE V_SQL;
	  DBMS_OUTPUT.PUT_LINE('[INFO] Insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);
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

