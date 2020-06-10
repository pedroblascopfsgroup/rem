--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7424
--## PRODUCTO=NO
--##
--## Finalidad: Creación de relaciones Grupos-Usuarios REM
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
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-7424'; -- USUARIO CREAR/MODIFICAR
	V_TABLA VARCHAR2(50 CHAR) := 'GRU_GRUPOS_USUARIOS';
	V_ENTIDAD_ID NUMBER(16);
	V_ID NUMBER(16);

	TYPE T_FUNCION IS TABLE OF VARCHAR2(150);
	TYPE T_ARRAY_FUNCION IS TABLE OF T_FUNCION;
	V_FUNCION T_ARRAY_FUNCION := T_ARRAY_FUNCION(
                --  USU_ID_GRUPO,  USU_ID_USUARIO
		--QIPERT
		T_FUNCION( 'qipert.divarian' , 'ext.agarciag'),
		T_FUNCION( 'qipert.divarian' , 'ext.sgomez'),
		T_FUNCION( 'qipert.divarian' , 'ext.vfernandezg'),
		T_FUNCION( 'qipert.divarian' , 'ext.vgomezc'),
		T_FUNCION( 'qipert.divarian' , 'ext.mgiraldo'),
		T_FUNCION( 'qipert.divarian' , 'ext.mgonzalezl'),
		T_FUNCION( 'qipert.divarian' , 'ext.mmartinezpa'),
		T_FUNCION( 'qipert.divarian' , 'ext.mvazquez'),
		T_FUNCION( 'qipert.divarian' , 'ext.nmolero'),
		T_FUNCION( 'qipert.divarian' , 'ext.ntabasco'),
		--INV SEGURIDAD
		--hay 2, los dos son grupos, este --invseguridad-- tiene usuarios en el grupo, este --inviseguridad.cat-- no tiene
		T_FUNCION( 'inviseguridad.cat' , 'ext.miglesiasye'),--
		T_FUNCION( 'inviseguridad.cat' , 'ext.abarragan'),--
		T_FUNCION( 'inviseguridad.cat' , 'ext.arodriguezme'),
		T_FUNCION( 'inviseguridad.cat' , 'ext.erios'),
		T_FUNCION( 'inviseguridad.cat' , 'ext.labad'),--
		T_FUNCION( 'inviseguridad.cat' , 'ext.lartachom'),
		T_FUNCION( 'inviseguridad.cat' , 'ext.rcastineira'),--
		T_FUNCION( 'inviseguridad.cat' , 'ext.ydiez'),
		T_FUNCION( 'inviseguridad.cat' , 'ext.cestebano'),--
		--
		T_FUNCION( 'invseguridad' , 'ext.miglesiasye'),
		T_FUNCION( 'invseguridad' , 'ext.abarragan'),
		T_FUNCION( 'invseguridad' , 'ext.arodriguezme'),--
		T_FUNCION( 'invseguridad' , 'ext.erios'),--
		T_FUNCION( 'invseguridad' , 'ext.labad'),
		T_FUNCION( 'invseguridad' , 'ext.lartachom'),--
		T_FUNCION( 'invseguridad' , 'ext.rcastineira'),
		T_FUNCION( 'invseguridad' , 'ext.ydiez'),--
		T_FUNCION( 'invseguridad' , 'ext.cestebano'),
		--acierta
		T_FUNCION( 'acierta.divarian' , 'ext.amiguel'),
		T_FUNCION( 'acierta.divarian' , 'ext.arisco'),
		T_FUNCION( 'acierta.divarian' , 'ext.cmunoz'),
		T_FUNCION( 'acierta.divarian' , 'ext.fmohamed'),
		T_FUNCION( 'acierta.divarian' , 'ext.idiaz'),
		T_FUNCION( 'acierta.divarian' , 'ext.rgilm'),
		T_FUNCION( 'acierta.divarian' , 'cas.agalan'), --no es email que toca, pero es el usuario
		T_FUNCION( 'acierta.divarian' , 'ext.iverdejo') --no es email que toca, pero es el usuario

	); 
	V_TMP_FUNCION T_FUNCION;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '); 
	-- LOOP para insertar los valores en GRU_GUPOS_USUARIOS -----------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
	FOR I IN V_FUNCION.FIRST .. V_FUNCION.LAST
	LOOP
		V_TMP_FUNCION := V_FUNCION(I);

		V_SQL := 'SELECT count(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''' ';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

		IF V_NUM_TABLAS > 0 THEN

			DBMS_OUTPUT.PUT_LINE('****************************************************');	
			DBMS_OUTPUT.PUT_LINE('[INFO]: Comprobando si existe el usuario '''||V_TMP_FUNCION(2)||''' asociado al grupo '''||V_TMP_FUNCION(1)||'');
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TABLA||' 
				WHERE USU_ID_GRUPO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''') 
				AND USU_ID_USUARIO = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''')';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
			-- Si existe la FILA
			IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO]: Ya existe el usuario en ese grupo.');		
			ELSE
				DBMS_OUTPUT.PUT_LINE('[ OK ]: 	No existe en el grupo. Comprobadno si existe usuario.');
			
				V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||'''';
				EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
			
				IF V_NUM_TABLAS > 0 THEN	
					DBMS_OUTPUT.PUT_LINE('[INFO]: 	Insertando relación '''||V_TMP_FUNCION(1)||''' - '''||V_TMP_FUNCION(2)||'''.');
					V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TABLA||'' ||
						' (GRU_ID, USU_ID_GRUPO, USU_ID_USUARIO, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)' ||
						' SELECT '||V_ESQUEMA_M||'.S_'||V_TABLA||'.NEXTVAL' ||
						',(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(1)||''')' ||
						',(SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_TMP_FUNCION(2)||''')' ||
						',0, '''||V_USUARIO||''', SYSDATE, 0 FROM DUAL';
				    DBMS_OUTPUT.PUT_LINE(V_MSQL);	
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] Relación insertada correctamente.');
				ELSE
					DBMS_OUTPUT.PUT_LINE('[INFO]: El usuario no existe en la BBDD.');	
				END IF;
				
			END IF;	
		ELSE
			DBMS_OUTPUT.PUT_LINE('[INFO]: El usuario no existe en la BBDD.');	
		END IF;

	END LOOP;
	
	COMMIT;
		
	DBMS_OUTPUT.PUT_LINE('[FIN]: '||V_TABLA||' ACTUALIZADO CORRECTAMENTE ');
   
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
