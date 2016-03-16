--/*
--##########################################
--## AUTOR=Alberto B
--## FECHA_CREACION=20160309
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-cj
--## INCIDENCIA_LINK=CMREC-2205
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_EXISTE2 NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_NUM_EXISTE3 NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    V_NUM_EXISTE4 NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** TAP_TAREA_PROCEDIMIENTO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO... Comprobaciones previas'); 
    
    --Comprobamos que exista la tarea
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO = ''CJ005_ActualizarCreditos''';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_EXISTE;
    
    IF V_NUM_EXISTE > 0 THEN
    	
    	--Comprobamos que exista la subtarea
   		V_SQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_STA_CODIGO = ''TGESHREIN''';
   		DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_EXISTE2;
		
		IF V_NUM_EXISTE > 0 THEN
		
			--Comprobamos que exista el gestor
			V_SQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GESHREIN''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_EXISTE3;
			
			IF V_NUM_EXISTE > 0 THEN
		
				--Actualizamos el gestor
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_STA_ID = (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_TGE_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GESHREIN'') AND DD_STA_CODIGO = ''TGESHREIN'') WHERE TAP_CODIGO =''CJ005_ActualizarCreditos''';
				DBMS_OUTPUT.PUT_LINE(V_MSQL);
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
			ELSE
			
				DBMS_OUTPUT.PUT_LINE('[INFO] No exite el gestor en '||V_ESQUEMA||'.DD_TGE_TIPO_GESTOR');
			
			END IF;
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO] No exite la subtarea en '||V_ESQUEMA||'.DD_STA_SUBTIPO_TAREA_BASE');
		
		END IF;
		
		--Comprobamos que exista el supervisor
		V_SQL := 'SELECT COUNT (1) FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUHRE''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_EXISTE4;
			
			IF V_NUM_EXISTE > 0 THEN
				
				--Actualizamos el supervisor
				V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUHRE'') WHERE TAP_CODIGO =''CJ005_ActualizarCreditos''';
				DBMS_OUTPUT.PUT_LINE(V_MSQL);
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
			ELSE
			
				DBMS_OUTPUT.PUT_LINE('[INFO] No exite el supervisor en '||V_ESQUEMA||'.DD_TGE_TIPO_GESTOR');
			
			END IF;
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] No exite la tarea en '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO');
	
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
