-- /*
--##########################################
--## AUTOR=JAVIER RUIZ
--## FECHA_CREACION=20150702
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-52
--## PRODUCTO=SI
--## Finalidad: DML que crea la funcion para ver la pestaña titulos en el expediente
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
-- */

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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage
    
BEGIN
	
          DBMS_OUTPUT.PUT_LINE('[INFO] Insertando funcion TAB_TITULOS_EXPEDIENTE');
          V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.FUN_FUNCIONES
   						(FUN_ID, FUN_DESCRIPCION_LARGA, FUN_DESCRIPCION, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
 					VALUES
   						('||V_ESQUEMA_M||'.S_FUN_FUNCIONES.NEXTVAL, ''Pestaña de titulos de expediente'', ''TAB_TITULOS_EXPEDIENTE'', 0, ''JAVIER'', SYSDATE, 0)';
          EXECUTE IMMEDIATE V_MSQL;
          DBMS_OUTPUT.PUT_LINE('[INFO] Funcion TAB_TITULOS_EXPEDIENTE insertada OK');
          
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
        