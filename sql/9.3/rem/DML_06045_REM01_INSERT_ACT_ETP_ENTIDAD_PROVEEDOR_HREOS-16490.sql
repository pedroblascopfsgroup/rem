--/*
--######################################### 
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20211123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16490
--## PRODUCTO=NO
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_ETP_ENTIDAD_PROVEEDOR';
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-16490';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    DD_CRA_BBVA NUMBER(16); -- Vble.  para validar la existencia de la cartera.
    DD_CRA_CERBERUS NUMBER(16); -- Vble.  para validar la existencia de la cartera.
    
    DD_CRA_BBVA_ID NUMBER(16); -- Vble. que almacena el id de la cartera.
    DD_CRA_CERBERUS_ID NUMBER(16); -- Vble. que almacena el id de la cartera.
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comprobaciones de carteras');    
    
    -- Comprobamos si existen las carteras BBVA y Cerberus y la tabla ACT_ETP_ENTIDAD_PROVEEDOR
    V_SQL :=    'SELECT COUNT(1) 
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
                WHERE DD_CRA_CODIGO = ''16''';
                
   EXECUTE IMMEDIATE V_SQL INTO DD_CRA_BBVA;
   
     V_SQL :=    'SELECT COUNT(1) 
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
                WHERE DD_CRA_CODIGO = ''07''';
                
   EXECUTE IMMEDIATE V_SQL INTO DD_CRA_CERBERUS;
   
   V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME ='''||V_TABLA||''' AND OWNER ='''||V_ESQUEMA||''' ';
   
   EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
   IF DD_CRA_BBVA > 0 AND DD_CRA_CERBERUS > 0 AND V_NUM_TABLAS > 0 THEN    
   	   
   	   DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
   	   
	   V_SQL :=    'SELECT DD_CRA_ID 
	                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
	                WHERE DD_CRA_CODIGO = ''16''';
	                
	   EXECUTE IMMEDIATE V_SQL INTO DD_CRA_BBVA_ID;
	   
	     V_SQL :=    'SELECT DD_CRA_ID 
	                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
	                WHERE DD_CRA_CODIGO = ''07''';
	                
	   EXECUTE IMMEDIATE V_SQL INTO DD_CRA_CERBERUS_ID;
	   
	   V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (ETP_ID,DD_CRA_ID,PVE_ID,VERSION,USUARIOCREAR,FECHACREAR,BORRADO) 
			SELECT  '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL, '||DD_CRA_CERBERUS_ID||', PVE_ID,0,'''||V_USUARIO||''',SYSDATE, 0 FROM '||V_ESQUEMA||'.'||V_TABLA||'  
				WHERE DD_CRA_ID = '||DD_CRA_BBVA_ID||' 
			    AND PVE_ID NOT IN(SELECT PVE_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_CRA_ID = '||DD_CRA_CERBERUS_ID||')';
			    
		EXECUTE IMMEDIATE V_SQL;
    	
		DBMS_OUTPUT.PUT_LINE('[INFO]: '|| SQL%ROWCOUNT ||' REGISTROS INSERTADOS EN LA TABLA '||V_TABLA||' CORRECTAMENTE');
    	
    	COMMIT;
   ELSE
  	 DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS EN LA TABLA '||V_TABLA||' NO INSERTADOS POR NO EXISTIR LAS CARTERAS BBVA O CERBERUS O LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'');
   END IF;
	        
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
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
EXIT
