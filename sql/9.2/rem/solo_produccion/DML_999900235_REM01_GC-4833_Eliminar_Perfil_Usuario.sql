--/*
--##########################################
--## AUTOR=JESSICA SAMPERE 
--## FECHA_CREACION=20180117
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=REMNIVDOS-3286
--## PRODUCTO=NO
--##
--## Finalidad: Baja perfiles usuarios REM
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET TIMING ON
SET LINESIZE 2000
SET VERIFY OFF
SET TIMING ON
SET FEEDBACK ON


DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

	V_SQL VARCHAR2(4000 CHAR); -- Vble. con sentencia SQL a ejecutar	
	V_SQL_USU NUMBER(16);  --Vble. para volcar datos a utilizar en otras consultas.	
	V_SQL_PEF NUMBER(16);  --Vble. para volcar datos a utilizar en otras consultas.	
	

--------------------------------------------------------------
-- DATOS       ------------------------
--------------------------------------------------------------	

	V_TICKET VARCHAR2(50 CHAR) := 'REMNIVDOS-3286'; 
	V_USERNAME VARCHAR2(50 CHAR) := 'schaveli'; 
	V_PERFIL VARCHAR2(50 CHAR) := 'HAYACONSU'; 

	
--------------------------------------------------------------
-- FIN DATOS          ------------------------
--------------------------------------------------------------



BEGIN	
	DBMS_OUTPUT.PUT_LINE('Buscando el usuario');
	V_SQL := 'SELECT COUNT(*) FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS
				WHERE USU_USERNAME = '''|| V_USERNAME ||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_SQL_USU;
	
	DBMS_OUTPUT.PUT_LINE('Buscando el perfil');
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.PEF_PERFILES
				WHERE PEF_CODIGO = '''|| V_PERFIL ||''' ';
	EXECUTE IMMEDIATE V_SQL INTO V_SQL_PEF;

	IF V_SQL_USU = 1 AND V_SQL_PEF = 1 THEN	
		DBMS_OUTPUT.PUT_LINE('----------Actualizando----------');

		DBMS_OUTPUT.PUT_LINE('Seleccionando ID_USUARIO');
		V_SQL := 'SELECT USU_ID FROM '|| V_ESQUEMA_M ||'.USU_USUARIOS
					WHERE USU_USERNAME = '''|| V_USERNAME ||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_SQL_USU;
		
		DBMS_OUTPUT.PUT_LINE('Seleccionando ID_PERFIL');
		V_SQL := 'SELECT PEF_ID FROM '|| V_ESQUEMA ||'.PEF_PERFILES
					WHERE PEF_CODIGO = '''|| V_PERFIL ||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_SQL_PEF;
		
		DBMS_OUTPUT.PUT_LINE('Borando perfil '|| V_PERFIL ||' al usuario '|| V_USERNAME);		
			V_SQL := 'update '|| V_ESQUEMA ||'.ZON_PEF_USU SET 
				BORRADO = 1, 
				USUARIOBORRAR = '''|| V_TICKET ||''',
				FECHABORRAR = sysdate
				WHERE  USU_ID = '|| V_SQL_USU ||' AND PEF_ID = '|| V_SQL_PEF ||'';
			EXECUTE IMMEDIATE V_SQL;
		
	ELSIF V_SQL_USU = 0 THEN
		DBMS_OUTPUT.PUT_LINE('No se ha encontrado el usuario');
	ELSIF V_SQL_PEF = 0 THEN 
		DBMS_OUTPUT.PUT_LINE('No se ha encontrado el perfil');
	ELSE
		DBMS_OUTPUT.PUT_LINE('Hay mas de un usuario o perfil ');
	
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
