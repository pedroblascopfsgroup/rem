--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20220521
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11643
--## PRODUCTO=NO
--## FINALIDAD: Poblar la tabla ACT_TFP_TRANSICIONES_FASESP, con todas las combinaciones posibles entre origen y destino   
--## (CROSS JOIN) eliminando las combinaciones en las que TFP_ORIGEN = TFP_DESTINO         
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    V_TABLA VARCHAR2(150 CHAR):= 'ACT_TFP_TRANSICIONES_FASESP'; -- Vble. con el nombre de la tabla.
    V_TABLA_DATOS VARCHAR2(150 CHAR):= 'DD_SFP_SUBFASE_PUBLICACION'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(20 CHAR) := 'REMVIP-11643'; -- Vble. auxiliar para almacenar el usuario crear
    
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    -- Comprobamos si existe las tablas   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS = 1 THEN 	
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_DATOS||''' AND OWNER = '''||V_ESQUEMA||'''';
	        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN 

                --Si existe lo modificamos
                DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO');
                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (TFP_ORIGEN, TFP_DESTINO, USUARIOCREAR, FECHACREAR)
                             SELECT C1.DD_SFP_ID, C2.DD_SFP_ID,'''|| V_USU ||''', SYSDATE
                            FROM '||V_ESQUEMA||'.'||V_TABLA_DATOS||' C1 CROSS JOIN '||V_ESQUEMA||'.'||V_TABLA_DATOS||' C2 WHERE C1.DD_SFP_ID != C2.DD_SFP_ID
                            AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' T WHERE T.TFP_ORIGEN = C1.DD_SFP_ID AND T.TFP_DESTINO = C2.DD_SFP_ID) 
                            AND ( C1.DD_SFP_CODIGO IN (37,36,35) OR (C1.DD_SFP_CODIGO NOT IN (37,36,35) AND C2.DD_SFP_CODIGO IN (37,36,35)))';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||SQL%ROWCOUNT||' REGISTROS '); 
            
                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (TFP_ORIGEN, TFP_DESTINO, USUARIOCREAR, FECHACREAR)
                            SELECT NULL, SFP.DD_SFP_ID, '''|| V_USU ||''', SYSDATE
                            FROM '||V_ESQUEMA||'.'||V_TABLA_DATOS||' SFP
                            WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' T WHERE T.TFP_ORIGEN IS NULL AND T.TFP_DESTINO = SFP.DD_SFP_ID)';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||SQL%ROWCOUNT||' REGISTROS '); 
                
                V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (TFP_ORIGEN, TFP_DESTINO, USUARIOCREAR, FECHACREAR)
                            SELECT SFP.DD_SFP_ID, NULL, '''|| V_USU ||''', SYSDATE
                            FROM '||V_ESQUEMA||'.'||V_TABLA_DATOS||' SFP
                            WHERE NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' T WHERE T.TFP_ORIGEN = SFP.DD_SFP_ID AND T.TFP_DESTINO IS NULL)';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] INSERTADOS '||SQL%ROWCOUNT||' REGISTROS '); 
                
                DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS CORRECTAMENTE');

            END IF;    	
           	    	   
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.'||V_TABLA||'... ACTUALIZADO CORRECTAMENTE');  
        
        END IF;       
   

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.PUT_LINE(V_MSQL);

          ROLLBACK;
          RAISE;          

END;

/

EXIT



   



   