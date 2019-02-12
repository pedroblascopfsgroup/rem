--/*
--##########################################
--## AUTOR=Rasul Akhmeddibirov
--## FECHA_CREACION=20190211
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

		-- 		 PERFIL	
    	T_PERFIL('HAYAGESTFORMADM'),
		T_PERFIL('SUPERFORM'),
		T_PERFIL('SUPERGESTACT'),
		T_PERFIL('SUPERADMIN'),
		T_PERFIL('SUPERMIDDLE'),
		T_PERFIL('SUPERPUBLI'),
		T_PERFIL('SUPERFRONT'),
		T_PERFIL('SUPERPLANIF')
		
    );   
    V_TMP_PERFIL T_PERFIL;


BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ALTER TABLA TMP_FUN_PEF');


	FOR I IN V_PERFILES.FIRST .. V_PERFILES.LAST
		LOOP
			V_TMP_PERFIL := V_PERFILES(I);

			DBMS_OUTPUT.PUT_LINE('[INFO] Comprobar si se ha creado la columna previamente.');

			V_MSQL := 'SELECT COUNT(*) 
			FROM USER_TAB_COLS
			WHERE COLUMN_NAME = '''||TRIM(V_TMP_PERFIL(1))||'''
			AND TABLE_NAME = ''TMP_FUN_PEF''';
		
			EXECUTE IMMEDIATE V_MSQL INTO V_NUM_FILAS;

			IF V_NUM_FILAS = 0 THEN
				
				DBMS_OUTPUT.PUT_LINE('[INFO] Insertando la nueva columna.');

				V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.TMP_FUN_PEF
							ADD '||TRIM(V_TMP_PERFIL(1))||' VARCHAR2(1 CHAR)';
		
				EXECUTE IMMEDIATE V_MSQL;
		
				DBMS_OUTPUT.PUT_LINE('[INFO] COLUMNA AÑADIDA');

			ELSE
				DBMS_OUTPUT.PUT_LINE('[INFO] COLUMNA YA EXISTE');
			END IF;
		END LOOP;
			
		DBMS_OUTPUT.PUT_LINE('[FIN] Se han insertado las columnas que no existian.');

	COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
		  DBMS_OUTPUT.put_line(V_MSQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
