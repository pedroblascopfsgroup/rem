--/*
--##########################################
--## AUTOR=ALBERT PASTOR
--## FECHA_CREACION=20190717
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-6985
--## PRODUCTO=NO
--##
--## Finalidad: Crear tabla temporales para el cálculo de comisiones.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM_TABLAS NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(30 CHAR); -- Vble. final para almacenar el nombre de la tabla de ref.
	      
 BEGIN 

 --AUX_HASH_ORIGEN 
	
  V_TABLA := 'AUX_HASH_COMISION_ORIGEN'; 
    
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla 
    IF V_NUM_TABLAS = 1 THEN 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla existente');
  	
  	ELSE
  	
		DBMS_OUTPUT.PUT_LINE('[INICIO] ' || V_ESQUEMA || '.'||V_TABLA||'... Se va ha crear.');  		
		--Creamos la tabla
		V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
    COMISION_ID NUMBER(16,0), 
    HASH_COM RAW(32)
  )';

		EXECUTE IMMEDIATE V_SQL;
    COMMIT;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada'); 

    DBMS_OUTPUT.PUT_LINE('[INFO] Creamos los indices de la tabla' );  

    V_SQL := 'CREATE INDEX comision_ori_idx
    ON '||V_TABLA||' (COMISION_ID)
    COMPUTE STATISTICS';
    EXECUTE IMMEDIATE V_SQL;
  
    V_SQL := 'CREATE INDEX hash_ori_idx
    ON '||V_TABLA||' (HASH_COM)
    COMPUTE STATISTICS';
    EXECUTE IMMEDIATE V_SQL;		
    END IF;

COMMIT;
--AUX_HASH_DESTINO; 
V_TABLA := 'AUX_HASH_COMISION_DESTINO'; 
    
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla 
    IF V_NUM_TABLAS = 1 THEN 
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla existente');
    
    ELSE
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ' || V_ESQUEMA || '.'||V_TABLA||'... Se va ha crear.');      
    --Creamos la tabla
    V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
    COMISION_ID VARCHAR2(36 CHAR), 
    HASH_COM RAW(32)
  )';

    EXECUTE IMMEDIATE V_SQL;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');     

    DBMS_OUTPUT.PUT_LINE('[INFO] Creamos los indices de la tabla' );  

    V_SQL := 'CREATE INDEX comision_des_idx
    ON '||V_TABLA||' (COMISION_ID)
    COMPUTE STATISTICS';
    EXECUTE IMMEDIATE V_SQL;
  
    V_SQL := 'CREATE INDEX hash_des_idx
    ON '||V_TABLA||' (HASH_COM)
    COMPUTE STATISTICS';
    EXECUTE IMMEDIATE V_SQL;
    
  END IF;

COMMIT;
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso terminado.');
 
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
