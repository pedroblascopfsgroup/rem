--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20170221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1603
--## PRODUCTO=NO
--##
--## Finalidad: Script que MODIFICA los nombre de las provincias en DD_PRV_PROVINCIA
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INFO] COMENZANDO EL PROCESO DE ACTUALIZACIÓN .......');
    
    --GIRONA
	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA' ||
		  ' SET DD_PRV_DESCRIPCION = ''Girona'', DD_PRV_DESCRIPCION_LARGA = ''Girona'' '||	  
		  ' WHERE DD_PRV_ID = 18';
		  
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando Girona .......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --LA RIOJA
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA' ||
		  ' SET DD_PRV_DESCRIPCION = ''La Rioja'', DD_PRV_DESCRIPCION_LARGA = ''La Rioja'' '||	  
		  ' WHERE DD_PRV_ID = 26';
		  
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando La Rioja .......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;

    --LLEIDA
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA' ||
		  ' SET DD_PRV_DESCRIPCION = ''Lleida'', DD_PRV_DESCRIPCION_LARGA = ''Lleida'' '||	  
		  ' WHERE DD_PRV_ID = 29';
		  
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando Lleida .......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --OURENSE
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA' ||
		  ' SET DD_PRV_DESCRIPCION = ''Ourense'', DD_PRV_DESCRIPCION_LARGA = ''Ourense'' '||	  
		  ' WHERE DD_PRV_ID = 36';
		  
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando Ourense .......');
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;
    
    --TENERIFE
    V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_PRV_PROVINCIA' ||
		  ' SET DD_PRV_DESCRIPCION = ''Santa C. Tenerife'', DD_PRV_DESCRIPCION_LARGA = ''Santa C. Tenerife	'' '||	  
		  ' WHERE DD_PRV_ID = 43';
		  
    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizando Santa C. Tenerife .......');
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