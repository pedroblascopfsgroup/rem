--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9367
--## PRODUCTO=NO
--##
--## Finalidad: Modificar configuracion gestores
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_TABLA VARCHAR2(50 CHAR) := 'ACT_GES_DIST_GESTORES';
	
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9367'; -- USUARIO CREAR/MODIFICAR

	V_USERNAME VARCHAR2(50 CHAR) := 'grupoMOBBVA';
	V_PERFIL VARCHAR2(50 CHAR) := 'HAYAGBOINM';
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO'); 

	DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobando si existe el usuario '||V_USERNAME||'');

	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USERNAME||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS = 0 THEN	  

		DBMS_OUTPUT.PUT_LINE('[INFO]: No existe el usuario '||V_USERNAME||'');		

	ELSE

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USERNAME = '''||V_USERNAME||''' 
				AND COD_CARTERA = 16 AND TIPO_GESTOR = '''||V_PERFIL||''' AND BORRADO = 0';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS = 0 THEN

			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (ID,TIPO_GESTOR,COD_CARTERA,USERNAME,NOMBRE_USUARIO,USUARIOCREAR,FECHACREAR) VALUES (
								'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL, '''||V_PERFIL||''',16,'''||V_USERNAME||''',
								(SELECT USU_NOMBRE FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USERNAME||'''), '''||V_USUARIO||''',
								SYSDATE)';
			EXECUTE IMMEDIATE V_MSQL;

			DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros correctamente.');

		ELSE

			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO YA EXISTE.');

		END IF;
				
	END IF;	
	
	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TABLA||' ACTUALIZADA CORRECTAMENTE ');
   
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
