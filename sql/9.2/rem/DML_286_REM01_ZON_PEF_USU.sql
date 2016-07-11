--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20160506
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=0
--## PRODUCTO=SI
--##
--## Finalidad: Script que actualiza el perfil del usuario SUPER
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
    -- Usuario SUPER
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ZON_PEF_USU' ||
			  ' SET PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYASUPER'') '||
	          ' WHERE USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''SUPER'') ';
	EXECUTE IMMEDIATE V_MSQL;          
	
	-- Usuarios supervisores de activo
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ZON_PEF_USU' ||
			  ' SET PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYASUPACT'') '||
	          ' WHERE USU_ID IN (SELECT USU_ID FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS USD JOIN '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES ON DES.DES_ID = USD.DES_ID WHERE DES.DES_DESPACHO = ''REMSUPACT'') ';
	EXECUTE IMMEDIATE V_MSQL;   
	
	-- Usuarios supervisores de admisión
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.ZON_PEF_USU' ||
			  ' SET PEF_ID = (SELECT PEF_ID FROM '||V_ESQUEMA||'.PEF_PERFILES WHERE PEF_CODIGO = ''HAYASUPADM'') '||
	          ' WHERE USU_ID IN (SELECT USU_ID FROM '||V_ESQUEMA||'.USD_USUARIOS_DESPACHOS USD JOIN '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO DES ON DES.DES_ID = USD.DES_ID WHERE DES.DES_DESPACHO = ''REMSUPADM'') ';
	EXECUTE IMMEDIATE V_MSQL;   
	          
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando perfil del supervisor.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);

    
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