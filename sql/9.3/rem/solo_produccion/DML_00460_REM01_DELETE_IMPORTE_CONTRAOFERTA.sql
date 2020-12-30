--/*
--######################################### 
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20200922
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8105
--## PRODUCTO=NO
--## 
--## Finalidad: Eliminar importe contraoferta
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
V_NUM_TABLAS NUMBER(16); -- Vble. para consulta de existencia de una tabla 
V_NUM_REGISTROS NUMBER(16);    
ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8105';
V_TABLA VARCHAR2(2400 CHAR) := 'OFR_OFERTAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
V_TABLA2 VARCHAR2(2400 CHAR) := 'ACT_OFR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
V_OFERTA NUMBER(16):= 90259221; -- Vble. contiene num oferta
  
BEGIN

        --Comprobacion de la tabla
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''''; 
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN     

            --Comprobar el dato a modificar.
        	V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE OFR_NUM_OFERTA = '||V_OFERTA||' AND BORRADO = 0';
        	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_REGISTROS;

		    IF V_NUM_REGISTROS > 0 THEN
		          
			  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET OFR_IMPORTE_CONTRAOFERTA = NULL, USUARIOMODIFICAR = '''||V_USUARIO||''',
				  		FECHAMODIFICAR = SYSDATE WHERE OFR_NUM_OFERTA = '||V_OFERTA||' AND BORRADO = 0';		     		
		       	EXECUTE IMMEDIATE V_MSQL;
		       	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADA LA OFERTA NUM '||V_OFERTA||' EN '||V_TABLA||'');
		        
			ELSE

		       	DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA OFERTA NUM '||V_OFERTA||'');
		        
			END IF;
      
        ELSE

            DBMS_OUTPUT.PUT_LINE('  [INFO] '||V_ESQUEMA||'.'||V_TABLA||'... No existe.');  

        END IF;

        --Comprobacion de la tabla
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA2||''''; 
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS > 0 THEN     

            --Comprobar el dato a modificar.
        	V_MSQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLA2||' WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE OFR_NUM_OFERTA = '||V_OFERTA||' AND BORRADO = 0)';
        	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_REGISTROS;

		    IF V_NUM_REGISTROS > 0 THEN
		          
			  	V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA2||'
                    SET ACT_OFR_IMPORTE = (SELECT OFR_IMPORTE FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE OFR_NUM_OFERTA = '||V_OFERTA||' AND BORRADO = 0),
                    VERSION = 2 WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE OFR_NUM_OFERTA = '||V_OFERTA||' AND BORRADO = 0)';		     		
		       	EXECUTE IMMEDIATE V_MSQL;
		       	DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADA LA OFERTA NUM '||V_OFERTA||' EN '||V_TABLA2||'');
		        
			ELSE

		       	DBMS_OUTPUT.PUT_LINE('[INFO] NO EXISTE LA OFERTA NUM '||V_OFERTA||'');
		        
			END IF;
      
        ELSE

            DBMS_OUTPUT.PUT_LINE('  [INFO] '||V_ESQUEMA||'.'||V_TABLA2||'... No existe.');  

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