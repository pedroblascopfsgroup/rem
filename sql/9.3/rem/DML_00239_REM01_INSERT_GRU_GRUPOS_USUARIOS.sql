--/*
--##########################################
--## AUTOR=CARLES MOLINS
--## FECHA_CREACION=20201018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8110
--## PRODUCTO=NO
--##
--## Finalidad: Crear grupo
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
	V_ENTORNO NUMBER(16);
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8110'; -- USUARIO CREAR/MODIFICAR

	V_USERNAME VARCHAR2(50 CHAR) := 'grpformgencat';
	V_NOMBRE_GRU VARCHAR2(100 CHAR) := 'Grupo Gestor Formalizacion GENCAT';

	V_PERFIL VARCHAR2(50 CHAR) := 'GFORM';
	V_PERFIL_DESCRIPCION VARCHAR2(100 CHAR) := 'Gestor formalización';
	V_PERFIL_DESPACHO VARCHAR2(50 CHAR) := 'REMGFORM';
	V_PERFIL_PERF VARCHAR2(50 CHAR) := 'HAYAGESTFORM';

	PL_OUTPUT VARCHAR2(32000 CHAR);
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO'); 
     
    #ESQUEMA#.SP_UPG_USER_PERFIL_GESTOR(V_USUARIO,V_USERNAME,NULL,V_USERNAME,V_PERFIL_DESPACHO,V_PERFIL,V_PERFIL_DESCRIPCION,V_PERFIL_PERF,
										V_PERFIL_DESCRIPCION,V_PERFIL,V_PERFIL_DESCRIPCION,NULL,0,PL_OUTPUT);
        
    DBMS_OUTPUT.PUT_LINE(PL_OUTPUT);

	V_MSQL := 'SELECT count(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USERNAME||''' ';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN    

		V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET 
				USU_NOMBRE = '''||V_NOMBRE_GRU||''',
				USUARIOMODIFICAR = '''||V_USUARIO||''', 
				FECHAMODIFICAR = SYSDATE 
				WHERE USU_USERNAME = '''||V_USERNAME||'''';

		EXECUTE IMMEDIATE V_MSQL;	

		DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en USU_USUARIOS');  

	ELSE

		DBMS_OUTPUT.PUT_LINE('[ INFO ]: El usuario '||V_USERNAME||' no existe.');

	END IF;	

	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[INFO]: FIN ');
   
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
