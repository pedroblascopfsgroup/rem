--/*
--######################################### 
--## AUTOR=P
--## FECHA_CREACION=20200408
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-9998
--## PRODUCTO=NO
--## 
--## Finalidad: Inserción de un buzon en USU_USUARIOS
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
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
V_NUM_TABLAS NUMBER(16); -- Vble. para cconsulta de existencia de una tabla 
V_NUM_REGISTROS NUMBER(16); 
V_ENTORNO NUMBER(16); -- Vble. para validar el entorno en el que estamos.    
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
V_USUARIOMODIFICAR VARCHAR2(50 CHAR) := 'HREOS-9998';
V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'USU_USUARIOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
  
BEGIN

        --Comprobacion de la tabla
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA_M||''' AND TABLE_NAME = ''USU_USUARIOS'''; 
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN              
            -- Verificar el entorno en el que estamos
            V_MSQL := 'SELECT CASE
                  WHEN SYS_CONTEXT ( ''USERENV'', ''DB_NAME'' ) = ''orarem'' THEN 1
                  ELSE 0
                  END AS ES_PRO
              FROM DUAL';

            EXECUTE IMMEDIATE V_MSQL INTO V_ENTORNO; 

            IF V_ENTORNO = 1 THEN
            	--Entorno de produccion
              	--Comprobar el dato a insertar.
        		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' 
							WHERE USU_USERNAME = ''buzonbankiaasista'' and USU_NOMBRE = ''BUZON BANKIA ASISTA''';
        		EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;

		        IF V_NUM_REGISTROS > 0 THEN
		          	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||'  
		          				SET  USU_NOMBRE = ''BUZON BANKIA ASISTA'', USU_MAIL = ''pablo.garcia@pfsgroup.es'', USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''', FECHAMODIFICAR = SYSDATE
								WHERE USU_USERNAME = ''buzonbankiaasista''';		     		
		        	EXECUTE IMMEDIATE V_MSQL;
		        	DBMS_OUTPUT.PUT_LINE('[INFO] Modifiado usuario buzonbankiaasista.......');
		        ELSE
		      		V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' (USU_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE, USU_MAIL, USUARIOCREAR, FECHACREAR) 
		          				VALUES ('||V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL, ''buzonbankiaasista'', ''kQtgqb'', ''BUZON BANKIA ASISTA'', ''bankiahaya@grupoassista.com'', '''||V_USUARIOMODIFICAR||''', SYSDATE)';		     		
		        	EXECUTE IMMEDIATE V_MSQL;
		        	DBMS_OUTPUT.PUT_LINE('[INFO] Creado usuario buzonbankiaasista.......');
		        END IF;
          			

		    ELSE
		    	--Entorno NO produccion
		    	--Comprobar el dato a insertar.
        		V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' 
							WHERE USU_USERNAME = ''buzonbankiaasista'' and USU_NOMBRE = ''BUZON BANKIA ASISTA''';
        		EXECUTE IMMEDIATE V_SQL INTO V_NUM_REGISTROS;		    	
		    	
        		IF V_NUM_REGISTROS > 0 THEN
		          	V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||'  
		          				SET  USU_NOMBRE = ''BUZON BANKIA ASISTA'', USU_MAIL = ''pruebashrem@gmail.com'', USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||''', FECHAMODIFICAR = SYSDATE
								WHERE USU_USERNAME = ''buzonbankiaasista''';		     		
		        	EXECUTE IMMEDIATE V_MSQL;
		        	DBMS_OUTPUT.PUT_LINE('[INFO] Modifiado usuario buzonbankiaasista.......');
		        ELSE		    
			    	V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' (USU_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE, USU_MAIL, USUARIOCREAR, FECHACREAR) 
			          VALUES ('||V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL, ''buzonbankiaasista'', ''1234'', ''BUZON BANKIA ASISTA'', ''pruebashrem@gmail.com'', '''||V_USUARIOMODIFICAR||''', SYSDATE)';
			      	DBMS_OUTPUT.PUT_LINE('[INFO] Insertando usuario ficticio buzonbankiaasista.......');
					EXECUTE IMMEDIATE V_MSQL;
				END IF;
			END IF;
      
        ELSE
            DBMS_OUTPUT.PUT_LINE('  [INFO] '''||V_ESQUEMA_M||''' USU_USUARIOS... No existe.');  
        END IF;

    COMMIT;  
  
EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    
    DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
    DBMS_OUTPUT.PUT_LINE(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
