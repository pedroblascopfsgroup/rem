--/*
--##########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20180207
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3259
--## PRODUCTO=NO
--##
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-3259'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 

    TYPE T_PERFIL IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_PERFILES IS TABLE OF T_PERFIL;

    -- ARRAY DE PERFILES para otorgales los permisos
    V_PERFILES T_ARRAY_PERFILES := T_ARRAY_PERFILES(

		-- 		 PERFIL					DESCRIPCION DEL PERFIL
    	T_PERFIL('SUPERFORM',			'Superusuario Formalización'),
		T_PERFIL('SUPERGESTACT',		'Superusuario Gestión Activos'),
		T_PERFIL('SUPERADMIN',			'Superusuario Admisión, Administración y CAT'),
		T_PERFIL('SUPERMIDDLE',			'Superusuario Middle Office'),
		T_PERFIL('SUPERPUBLI',			'Superusuario Publicaciones'),
		T_PERFIL('SUPERFRONT',			'Superusuario Front Office'),
		T_PERFIL('SUPERPLANIF',			'Superusuario Planificación Comercial')
    );   
    V_TMP_PERFIL T_PERFIL;
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.FUN_PEF... Empezando a insertar datos en la tabla');
    
    FOR I IN V_PERFILES.FIRST .. V_PERFILES.LAST
		LOOP
			V_TMP_PERFIL := V_PERFILES(I);


			V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = '''||TRIM(V_TMP_PERFIL(1))||''' ';
			
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
			
			IF V_NUM_FILAS = 0 THEN
			
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.PEF_PERFILES 
							(PEF_ID,
							PEF_DESCRIPCION_LARGA,
							PEF_DESCRIPCION,
							VERSION, 
							USUARIOCREAR, 
							FECHACREAR,
							BORRADO,
							PEF_CODIGO
							)VALUES(
							'||V_ESQUEMA||'.S_PEF_PERFILES.NEXTVAL,
							'''||TRIM(V_TMP_PERFIL(2))||''',
							'''||TRIM(V_TMP_PERFIL(2))||''',
							0,
							''REMVIP-3259'',
							SYSDATE,
							0,
							'''||TRIM(V_TMP_PERFIL(1))||'''
							)';
			
				EXECUTE IMMEDIATE V_MSQL;
			
				DBMS_OUTPUT.PUT_LINE('[FIN] REGISTRO INSERTADO');
				
			ELSE
				
				DBMS_OUTPUT.PUT_LINE('[FIN] REGISTRO YA EXISTE');
				
			END IF;

		END LOOP;
			
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
