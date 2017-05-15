--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20170515
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0.10
--## INCIDENCIA_LINK=HREOS-2069
--## PRODUCTO=SI
--##
--## Finalidad: Borrar carga del activo 6076271 y actualizar fecha
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
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET ACT_FECHA_REV_CARGAS = TO_DATE(''2017-04-18'', ''YYYY-MM-DD'')' || 
    ' WHERE ACT_NUM_ACTIVO = 6076271 ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando fecha revisión de cargas.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO SET ACT_CON_CARGAS = 0' || 
    ' WHERE ACT_NUM_ACTIVO = 6076271 ';
	DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando estado de cargas.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.ACT_CRG_CARGAS ' || 
    ' WHERE ACT_ID IN (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = 6076271) AND USUARIOCREAR = ''MIG''';
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrado de carga.......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    
    

    
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