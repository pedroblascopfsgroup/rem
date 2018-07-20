--/*
--###########################################
--## AUTOR=Sergio Ortuño
--## FECHA_CREACION=20180718
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1352
--## PRODUCTO=NO
--## 
--## Finalidad: Creacion de Usuarios REM
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_TABLA VARCHAR2(50 CHAR) := 'GRU_GRUPOS_USUARIOS';
  V_TABLA_USUARIOS VARCHAR2(50 CHAR) := 'USU_USUARIOS';

  V_COUNT NUMBER(16);
  V_ID NUMBER(16);
  
BEGIN	

 DBMS_OUTPUT.PUT_LINE('[INICIO] ');
 
 
 
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA_USUARIOS||' WHERE USU_USERNAME = ''SBACKOFFICEINMLIBER''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

	IF V_COUNT > 0 THEN
		
		V_SQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.'||V_TABLA_USUARIOS||' WHERE USU_USERNAME = ''SBACKOFFICEINMLIBER''';
		EXECUTE IMMEDIATE V_SQL INTO V_ID;
		
		
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' GRU 
				JOIN '||V_ESQUEMA_M||'.'||V_TABLA_USUARIOS||' USU ON USU.USU_ID = GRU.USU_ID_USUARIO AND USU.USU_USERNAME IN (''SBACKOFFICEINMLIBER'',''imartin'',''lclaret'')
				WHERE GRU.USUARIOCREAR = ''REMVIP-1352''';
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
		IF V_COUNT > 0 THEN
		
			DBMS_OUTPUT.PUT_LINE('[INFO] El grupo ya se encontraba insertado, no realizamos acción');
		
		ELSE
		
			V_SQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||' (
					GRU_ID
					,USU_ID_GRUPO
					,USU_ID_USUARIO
					,USUARIOCREAR
					,FECHACREAR
					)
					SELECT '||V_ESQUEMA_M||'.S_GRU_GRUPOS_USUARIOS.NEXTVAL,
					'||V_ID||',
					USU_ID,
					''REMVIP-1352'',
					SYSDATE
					FROM '||V_ESQUEMA_M||'.'||V_TABLA_USUARIOS||' WHERE USU_USERNAME IN (''SBACKOFFICEINMLIBER'',''imartin'',''lclaret'')		
					';
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Grupo insertado correctamente');
			DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la GRU_GRUPOS_USUARIOS');
			
		END IF;
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] El SBACKOFFICEINMLIBER no existe, no realizamos acción');
		
	END IF;
    
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('[FIN]: PROCESO ACTUALIZADO CORRECTAMENTE ');
 

EXCEPTION

   WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;

/

EXIT
