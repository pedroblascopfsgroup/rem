--/*
--######################################### 
--## AUTOR=Juan Torrella
--## FECHA_CREACION=20191113
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5152
--## PRODUCTO=SI
--## 
--## Finalidad: Inserción USU_USUARIOS
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
V_USUARIOMODIFICAR VARCHAR2(50 CHAR) := 'REMVIP-5152';
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
                 V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' WHERE USU_USERNAME = ''buzonfdv'''; 
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            	IF V_NUM_TABLAS = 0 THEN
                    V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' (USU_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE, USU_MAIL, USUARIOCREAR, FECHACREAR) 
    		          VALUES ('||V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL, ''buzonfdv'', ''DqhVAq'', ''BUZON APROBACIONES FDV'', ''aprobacionesfdv@haya.es'', '''||V_USUARIOMODIFICAR||''', SYSDATE)';
    		      
                    DBMS_OUTPUT.PUT_LINE('[INFO] Insertando usuario ficticio buzonfdv.......');

    		        EXECUTE IMMEDIATE V_MSQL;
                END IF;
		    ELSE 
                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' WHERE USU_USERNAME = ''buzonfdv'''; 
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
                IF V_NUM_TABLAS = 0 THEN
    		    	V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.'||V_TEXT_TABLA||' (USU_ID, USU_USERNAME, USU_PASSWORD, USU_NOMBRE, USU_MAIL, USUARIOCREAR, FECHACREAR) 
    		          VALUES ('||V_ESQUEMA_M||'.S_USU_USUARIOS.NEXTVAL, ''buzonfdv'', ''1234'', ''BUZON APROBACIONES FDV'', ''pruebashrem@gmail.com'', '''||V_USUARIOMODIFICAR||''', SYSDATE)';
    		      	DBMS_OUTPUT.PUT_LINE('[INFO] Insertando usuario ficticio buzonfdv.......');
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
    err_num := SQLCODE;
    err_msg := SQLERRM;
    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(err_msg);
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;
