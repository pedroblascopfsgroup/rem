--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=202130408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9367
--## PRODUCTO=NO
--##
--## Finalidad: Insertar usuarios a grupo
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
	V_TABLA VARCHAR2(50 CHAR) := 'GRU_GRUPOS_USUARIOS';
	
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-9367'; -- USUARIO CREAR/MODIFICAR

	V_USERNAME VARCHAR2(50 CHAR) := 'grupoMOBBVA';
	V_NOMBRE_GRU VARCHAR2(100 CHAR) := 'Grupo Gestor Backoffice Inmobiliario BBVA';

	V_PERFIL VARCHAR2(50 CHAR) := 'HAYAGBOINM';
	V_PERFIL_DESCRIPCION VARCHAR2(100 CHAR) := 'Gestor Comercial Backoffice Inmobiliario';

	TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
	V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
		T_FUNCION( 'grupoMOBBVA' , 'ejust'),
		T_FUNCION( 'grupoMOBBVA' , 'rribera'),
		T_FUNCION( 'grupoMOBBVA' , 'igomezr'),
		T_FUNCION( 'grupoMOBBVA' , 'gdelrosal'),
		T_FUNCION( 'grupoMOBBVA' , 'ext.mvilches'),
		T_FUNCION( 'grupoMOBBVA' , 'ext.csastre'),
		T_FUNCION( 'grupoMOBBVA' , 'ext.adec'),
		T_FUNCION( 'grupoMOBBVA' , 'ext.sgomezc')
	); 
	V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INFO] INICIO'); 

	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||' ');
	FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
	LOOP
		V_TMP_FUNCION := V_FUNCION(I);

		V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||'''';
		EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS > 0 THEN
		
			DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobando si existe el usuario '''||V_TMP_FUNCION(2)||''' asociado al grupo '''||V_TMP_FUNCION(1)||'');

			V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' WHERE USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''') 
						AND USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''')';
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;

			IF V_NUM_TABLAS > 0 THEN	  

				DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe el usuario en ese grupo.');		

			ELSE
			
				DBMS_OUTPUT.PUT_LINE('[INFO]: Insertando relación '''||V_TMP_FUNCION(1)||''' - '''||V_TMP_FUNCION(2)||'''.');

				V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||' (GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, USUARIOCREAR, FECHACREAR)
							SELECT '||V_ESQUEMA_M||'.S_'||V_TABLA||'.NEXTVAL,(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||'''),
							(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||'''),'''||V_USUARIO||''', SYSDATE FROM DUAL';
				EXECUTE IMMEDIATE V_MSQL;

				DBMS_OUTPUT.PUT_LINE('[INFO] Relación insertada correctamente.');
					
			END IF;	

		ELSE 

			DBMS_OUTPUT.PUT_LINE('[INFO]: No existe el usuario '||V_TMP_FUNCION(2)||'');		

		END IF;

	END LOOP;
	
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
