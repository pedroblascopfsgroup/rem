--/*
--##########################################
--## AUTOR=Jorge Ros
--## FECHA_CREACION=20160316
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=Sin-Item
--## PRODUCTO=NO
--##
--## Finalidad: Borra la funcion GENERAR_DOC_PRECONTENCIOSO de todos los perfiles de Haya-Sareb
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
    V_SQL_TGE VARCHAR2(4000 CHAR); -- Vble. para la query de consultar el id del codigo TGE.  
    V_ID_TGE VARCHAR2(25 CHAR); --Vbla. para almacenar el id del TGE
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.FUN_PEF... Borrar la funcion GENERAR_DOC_PRECONTENCIOSO de los perfiles de HAYA-SAREB');
    V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID=(SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION=''GENERAR_DOC_PRECONTENCIOSO'') ';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
    
    IF V_NUM_TABLAS > 0 THEN
    	V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.FUN_PEF WHERE FUN_ID=(SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION=''GENERAR_DOC_PRECONTENCIOSO'')';
    	EXECUTE IMMEDIATE V_MSQL;
    	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.FUN_PEF... Funcion borrada de los perfiles.');
    ELSE
    	DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.FUN_PEF... No hay ningún perfil con la funcion GENERAR_DOC_PRECONTENCIOSO');
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