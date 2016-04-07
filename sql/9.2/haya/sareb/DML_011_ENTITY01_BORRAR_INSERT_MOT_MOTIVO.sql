--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160406
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.2
--## INCIDENCIA_LINK= PRODUCTO-1152
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de los registros. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN
	-- Comprobar existencia.
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.MOT_MOTIVO WHERE MOT_CODIGO = ''NOMODIFICA''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_REG;

	IF V_NUM_REG > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.MOT_MOTIVO... Ya existen los registros');
	ELSE
		-- Borrar Diccionarios existentes.
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.MOT_MOTIVO... Borrar todas las opciones en HAYA-SAREB');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.MOT_MOTIVO SET BORRADO = 1';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('DICCIONARIOS BORRADOS');
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.MOT_MOTIVO... Insertar nuevos diccionarios en HAYA-SAREB');
		
		-- Añadir nuevos Diccionarios.
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MOT_MOTIVO (MOT_ID,MOT_CODIGO,MOT_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_MOT_MOTIVO.NEXTVAL,''NOMODIFICA'',''No se modifica la clasificación actual'',''0'',''PROD-1152'',SYSDATE)';
		EXECUTE IMMEDIATE V_MSQL;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MOT_MOTIVO (MOT_ID,MOT_CODIGO,MOT_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_MOT_MOTIVO.NEXTVAL,''MEJORAEXPECT'',''Mejora en la expectativa de recuperación'',''0'',''PROD-1152'',SYSDATE)';
		EXECUTE IMMEDIATE V_MSQL;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.MOT_MOTIVO (MOT_ID,MOT_CODIGO,MOT_DESCRIPCION,VERSION,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_MOT_MOTIVO.NEXTVAL,''DETERIOROEXPECT'',''Deterioro en la expectativa de recuperación'',''0'',''PROD-1152'',SYSDATE)';
		EXECUTE IMMEDIATE V_MSQL;
		
		DBMS_OUTPUT.PUT_LINE('NUEVOS DICCIONARIOS AÑADIDOS');
	
		COMMIT;
	END IF;
    
	DBMS_OUTPUT.PUT_LINE('[INFO] MOT_MOTIVO ACTUALIZADA.');

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
  	