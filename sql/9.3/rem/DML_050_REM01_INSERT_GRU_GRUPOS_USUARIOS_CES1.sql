--/*
--###########################################
--## AUTOR=Alfonso Rodriguez
--## FECHA_CREACION=20191209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8577
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de relaciones Grupos-Usuarios REM
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
	
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-8577'; -- USUARIO CREAR/MODIFICAR
	V_TABLA VARCHAR2(50 CHAR) := 'GRU_GRUPOS_USUARIOS';
	V_ENTIDAD_ID NUMBER(16);
	V_ID NUMBER(16);
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '); 
	-- LOOP para insertar los valores en ZON_PEF_USU -----------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
	
	DBMS_OUTPUT.PUT_LINE('****************************************************');	
	DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobando si existe el usuario  asociado al grupo');


	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.usu_usuarios WHERE USU_USERNAME = ''grucoces1''';

	DBMS_OUTPUT.PUT_LINE(V_SQL);	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

		
	-- Si existe la FILA
	IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO]: No hacemos nada. Existe el grupo');		
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO]: 	Insertando relación');

		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||'' ||
			' (GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
			' SELECT '||V_ESQUEMA_M||'.S_'||V_TABLA||'.NEXTVAL' ||
			',(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''grucoces1'')' ||
			',(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''grucoces1'')' ||
			',0, '''||V_USUARIO||''', SYSDATE, 0 FROM DUAL 
			WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA_M||'.'||V_TABLA||' AUX_GRU 
			WHERE USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''grucoces1''))';
	    	
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Relación insertada correctamente.');

	END IF;

		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS (GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) 
			SELECT '||V_ESQUEMA_M||'.S_GRU_GRUPOS_USUARIOS.NEXTVAL
			,  (SELECT grupo.usu_id FROM '||V_ESQUEMA_M||'.usu_usuarios grupo where grupo.borrado = 0 and grupo.usu_username = ''grucoces1'') grupo
			, gru.usu_id_usuario
			, 0
			, '''||V_USUARIO||'''
			, SYSDATE
			, 0
			FROM '||V_ESQUEMA_M||'.usu_usuarios usu
			left join '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS gru on usu.usu_id = gru.usu_id_grupo and gru.borrado = 0
			where usu.borrado = 0 and usu.usu_username = ''grucoces'' and not exists (select 1 from '||V_ESQUEMA_M||'.usu_usuarios aux where aux.usu_username = ''grucoces'' and aux.usu_id = gru.usu_id_usuario)
			and not exists (SELECT 1 FROM '||V_ESQUEMA_M||'.usu_usuarios usu_aux left join '||V_ESQUEMA_M||'.GRU_GRUPOS_USUARIOS grucoces1 on usu_aux.usu_id = grucoces1.usu_id_grupo and grucoces1.borrado = 0
			where usu_aux.borrado = 0 and usu_aux.usu_username = ''grucoces1'' and grucoces1.usu_id_usuario = gru.usu_id_usuario)';
	    	
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Relación insertada correctamente.');
			
	
	
	COMMIT;
	--ROLLBACK;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   
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
EXIT;
