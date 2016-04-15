--/*
--##########################################
--## AUTOR=Alberto B.
--## FECHA_CREACION=20160413
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.2-hy
--## INCIDENCIA_LINK= HR-2245
--## PRODUCTO=NO
--##
--## Finalidad:
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
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_EXISTE NUMBER(16);  -- Vble. para controlar si existe el codigo
BEGIN	

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GESTORIA_PREDOC''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_EXISTE;
	
	IF V_NUM_EXISTE > 0 THEN
		V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR SET DD_TGE_DESCRIPCION = ''Gestoría preparación documental'' WHERE DD_TGE_CODIGO = ''GESTORIA_PREDOC''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('OK ACTUALIZADO');
	ELSE
		DBMS_OUTPUT.PUT_LINE('No exite el registro');
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GEXT''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_EXISTE;
	
	IF V_NUM_EXISTE > 0 THEN
		V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR SET DD_TGE_DESCRIPCION = ''Letrado'' WHERE DD_TGE_CODIGO = ''GEXT''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('OK ACTUALIZADO');
	ELSE
		DBMS_OUTPUT.PUT_LINE('No exite el registro');
	END IF;
	
	
	COMMIT;
	    
    
	DBMS_OUTPUT.PUT_LINE('[INFO] Fin.');


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
  	