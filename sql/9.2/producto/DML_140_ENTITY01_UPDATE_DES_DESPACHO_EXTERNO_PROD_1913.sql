--/*
--##########################################
--## AUTOR=Vicente Lozano
--## FECHA_CREACION=20160614
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.5
--## INCIDENCIA_LINK=PRODUCTO-1913
--## PRODUCTO=SI
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
    V_MSQL_ID VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de un des_id
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_EXISTE NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    CURSOR C_SUSTITUCIONES IS
		select des_id from #ESQUEMA#.des_despacho_externo where borrado = 1;
	V_SUST #ESQUEMA#.des_despacho_externo.des_id%TYPE;
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** DEE_DESPACHO_EXTRAS ********'); 
	
    	--Iterar sobre todos los despachos de borrados
    	 OPEN C_SUSTITUCIONES;
   			LOOP
    			FETCH C_SUSTITUCIONES INTO V_SUST;
    			EXIT WHEN C_SUSTITUCIONES%NOTFOUND;
    			V_MSQL_ID := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS WHERE DES_ID ='||V_SUST||'';
    			EXECUTE IMMEDIATE V_MSQL_ID INTO V_NUM_TABLAS;
              	DBMS_OUTPUT.PUT_LINE(V_NUM_TABLAS);
    			IF V_NUM_TABLAS = 0 THEN
    				--Insertamos
    				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS (DES_ID,DEE_COD_EST_ASE,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES ' ||
    						'('||V_SUST||',''1'',0,''SUPER'',SYSDATE,0)';
    				EXECUTE IMMEDIATE V_MSQL;
    				DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS');
    			ELSE
    				--Actualiza,os
    				V_MSQL := 'UPDATE '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS SET DEE_COD_EST_ASE=''1'' WHERE DES_ID='||V_SUST||'';
    				EXECUTE IMMEDIATE V_MSQL;
    				DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS');
    			END IF;	
    		END LOOP;
    	CLOSE C_SUSTITUCIONES;
   
    
    
    V_SQL := 'UPDATE '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO SET BORRADO=''0'' WHERE BORRADO=1';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.DES_DESPACHO_EXTERNO');
    	
	
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
