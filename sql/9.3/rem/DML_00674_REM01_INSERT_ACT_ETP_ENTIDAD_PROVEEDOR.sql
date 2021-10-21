--/*
--######################################### 
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20210818
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14956
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
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-14956';
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_DD_CRA_ID VARCHAR(50 CHAR); -- Vble. que almacena el id de la cartera.
    V_PVE_ID VARCHAR(50 CHAR); -- Vble. que almacena el id del proveedor.
    
	CURSOR PROVEEDOR IS SELECT PVE_ID FROM #ESQUEMA#.ACT_ETP_ENTIDAD_PROVEEDOR WHERE DD_CRA_ID = (SELECT DD_CRA_ID FROM DD_CRA_CARTERA WHERE DD_CRA_CODIGO = '03') AND BORRADO = 0; 
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');    
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA||'] ');
    
    -- Recogemos el valor id de la cartera, porque es el mismo para todos
    V_SQL :=    'SELECT DD_CRA_ID 
                FROM '||V_ESQUEMA||'.DD_CRA_CARTERA 
                WHERE DD_CRA_CODIGO = ''17''';
   EXECUTE IMMEDIATE V_SQL INTO V_DD_CRA_ID;
   
   -- LOOP para insertar los valores en ACT_ETP_ENTIDAD_PROVEEDOR segun la cartera --	
	FOR PVE IN PROVEEDOR LOOP
	
		V_PVE_ID:=PVE.PVE_ID;
	        
	        --Comprobamos el dato a insertar
		   	V_SQL :=   'SELECT COUNT(1) 
	                    FROM '||V_ESQUEMA||'.'||V_TABLA||'
	                    WHERE DD_CRA_ID = '||V_DD_CRA_ID||'
	                    	AND PVE_ID = '||V_PVE_ID||'
	                    	AND BORRADO = 0';
						
	        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;        
	        
	       --Si no existe, lo insertamos
	        IF V_NUM_TABLAS = 0 THEN            
			 V_SQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		           ETP_ID
		          , DD_CRA_ID
		          , PVE_ID
		          , VERSION
		          , USUARIOCREAR
		          , FECHACREAR
		          , BORRADO)
		          VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL
		          ,'||V_DD_CRA_ID||'
		          ,'||V_PVE_ID||'
		          , 0
		          ,'''||V_USUARIO||'''
		          , SYSDATE
		          , 0)';
			EXECUTE IMMEDIATE V_SQL;
			
	          DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO CON CARTERA '||V_DD_CRA_ID||' Y PROVEEDOR '||V_PVE_ID||' EN LA TABLA '||V_TABLA||' INSERTADO CORRECTAMENTE');
	        
	        ELSE 
	        
	            DBMS_OUTPUT.PUT_LINE('[INFO] YA EXISTE EL REGISTRO CON CARTERA '||V_DD_CRA_ID||' Y PROVEEDOR '||V_PVE_ID||'');		
	          
	       END IF;
	      
    END LOOP;	
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN] Script finalizado correctamente');
    
    
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
