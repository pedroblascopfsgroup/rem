--/*
--##########################################
--## AUTOR=Luis Caballero Pardillo
--## FECHA_CREACION=20160309	
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-901
--## PRODUCTO=SI
--## Finalidad: DML Borrado lógico de filas de FUN_PEF. Para eliminar la visibilidad del tab documento dentro de un expediente de todos los perfiles
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR); -- Vble. para la realización de la sentencia.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    

    BEGIN
		DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
		
	    V_MSQL := 'UPDATE ' || V_ESQUEMA || '.FUN_PEF SET BORRADO = 1 WHERE FUN_ID = (SELECT FUN_ID FROM '||V_ESQUEMA_M||'.FUN_FUNCIONES WHERE FUN_DESCRIPCION = ''ROLE_PUEDE_VER_TAB_EXP_TITULOS'')';
    	EXECUTE IMMEDIATE V_MSQL;
  		
    	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.FUN_PEF... filas actualizadas');  	
 
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