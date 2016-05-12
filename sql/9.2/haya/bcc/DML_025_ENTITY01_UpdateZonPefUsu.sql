--/*
--##########################################
--## AUTOR=Alberto B.
--## FECHA_CREACION=20160416
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.2
--## INCIDENCIA_LINK=HR-2267
--## PRODUCTO=NO
--##
--## Finalidad: Realiza las inserciones de la resolución Resolución firme para la tarea H018_ResolucionFirme.
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);

BEGIN	
	
	V_SQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''pcarpio''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	
		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYACONSULTA''';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS > 0 THEN
		
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.ZON_PEF_USU SET BORRADO = 1, USUARIOBORRAR = ''HR-2267'', FECHABORRAR = SYSDATE WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''pcarpio'') AND PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYACONSULTA'')';
			DBMS_OUTPUT.PUT_LINE(V_MSQL);
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('ACTUALIZADO');
		ELSE
		
			 DBMS_OUTPUT.PUT_LINE('No existe el perfil');
		
		END IF;
	
	ELSE
	
	 	DBMS_OUTPUT.PUT_LINE('No existe el usuario');
	
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