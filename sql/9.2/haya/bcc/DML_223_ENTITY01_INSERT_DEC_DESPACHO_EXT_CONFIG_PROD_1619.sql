--/*
--##########################################
--## AUTOR=Vicente Lozano
--## FECHA_CREACION=20160524
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1619
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
		select des_id from #ESQUEMA#.des_despacho_externo where dd_tde_id = (select dd_tde_id from #ESQUEMA_MASTER#.dd_tde_tipo_despacho where dd_tde_codigo = 'D-CJ-LETR');
	V_SUST #ESQUEMA#.des_despacho_externo.des_id%TYPE;
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('******** DEC_DESPACHO_EXT_CONFIG ********'); 
	
	

	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_TDE_TIPO_DESPACHO WHERE DD_TDE_CODIGO = ''D-CJ-LETR''';

	DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN
    	--Iterar sobre todos los despachos de tipo D-CJ-LETR
    	 OPEN C_SUSTITUCIONES;
   			LOOP
    			FETCH C_SUSTITUCIONES INTO V_SUST;
    			EXIT WHEN C_SUSTITUCIONES%NOTFOUND;
    			V_MSQL_ID := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DEC_DESPACHO_EXT_CONFIG DEC WHERE DES_ID ='||V_SUST||'';
    			EXECUTE IMMEDIATE V_MSQL_ID INTO V_NUM_TABLAS;
              				DBMS_OUTPUT.PUT_LINE(V_NUM_TABLAS);
    			IF V_NUM_TABLAS = 0 THEN
    				--hacemos
    				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DEC_DESPACHO_EXT_CONFIG (DEC_ID,DES_ID,DEC_DESPACHO_INTEGRAL,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) VALUES ' ||
    						'(S_DEC_DESPACHO_EXT_CONFIG.nextval,'||V_SUST||',1,0,''SUPER'',SYSDATE,0)';
    				EXECUTE IMMEDIATE V_MSQL;
    				DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.DEC_DESPACHO_EXT_CONFIG');
    			END IF;	
    		END LOOP;
    	CLOSE C_SUSTITUCIONES;
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
