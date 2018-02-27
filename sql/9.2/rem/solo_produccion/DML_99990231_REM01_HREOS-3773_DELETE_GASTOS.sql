--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20180205
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3773
--## PRODUCTO=NO
--## Finalidad: Borrar los gastos rechazados REM.
--##           
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

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
	TYPE T_TABLAS IS TABLE OF VARCHAR2(150);      
    TYPE T_ARRAY_TABLAS IS TABLE OF T_TABLAS;          
    V_TEMP_TABLAS  T_TABLAS;
    C_TABLA T_ARRAY_TABLAS := T_ARRAY_TABLAS(T_TABLAS('REM01','GPV_GASTOS_PROVEEDOR'),
    										T_TABLAS('REM01','GIC_GASTOS_INFO_CONTABILIDAD'),
    										T_TABLAS('REM01','GPV_ACT'),
    										T_TABLAS('REM01','GDE_GASTOS_DETALLE_ECONOMICO'));
  
    
BEGIN
	 
	DBMS_OUTPUT.PUT_LINE('********************' );
	 DBMS_OUTPUT.PUT_LINE('**DESACTIVAMOS RESTRICCIONES CLAVE AJENA**' );
	 DBMS_OUTPUT.PUT_LINE('********************' );
	
	 FOR I IN C_TABLA.FIRST .. C_TABLA.LAST
	 LOOP
	    BEGIN
	      V_TEMP_TABLAS := C_TABLA(I);
	     
	      FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM SYS.USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='R' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
	      LOOP
	          BEGIN
	                 EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME;        
	          END;    
	      END LOOP;    
	     
	   EXCEPTION WHEN OTHERS THEN
	     NULL;
	   END;
	 END LOOP;
	 DBMS_OUTPUT.PUT_LINE('********************' );
	 DBMS_OUTPUT.PUT_LINE('**DESACTIVAMOS RESTRICCIONES CLAVE PRIMARIA**' );
	 DBMS_OUTPUT.PUT_LINE('********************' );
	
	 FOR I IN C_TABLA.FIRST .. C_TABLA.LAST
	 LOOP
	    BEGIN
	      V_TEMP_TABLAS := C_TABLA(I);
	     
	      FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM SYS.USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='P' AND STATUS='ENABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
	      LOOP
	          BEGIN
	               
	                 EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' DISABLE CONSTRAINT ' || J.CONSTRAINT_NAME || ' CASCADE ';        
	          END;    
	      END LOOP;    
	     
	   EXCEPTION WHEN OTHERS THEN
	     NULL;
	   END;
	 END LOOP;
	
	 
    DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de borrado de los gastos');
        
    
    V_SQL := ' DELETE FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD WHERE GPV_ID in (  
				 select GPV.GPV_ID from '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
				    left join '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE on gpv.gpv_id = gge.gpv_id 
				      where gge.gge_id is null)';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD... SE HAN BORRADO CORRECTAMENTE '||SQL%ROWCOUNT||' REGISTROS');
    
    V_SQL := ' DELETE FROM '||V_ESQUEMA||'.GPV_ACT WHERE GPV_ID in (
				  select GPV.GPV_ID from '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
				    left join '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE on gpv.gpv_id = gge.gpv_id 
				      where gge.gge_id is null)';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.GPV_ACT... SE HAN BORRADO CORRECTAMENTE '||SQL%ROWCOUNT||' REGISTROS');
    
    V_SQL := ' DELETE FROM '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO WHERE GPV_ID in (
				  select GPV.GPV_ID from '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
				    left join '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE on gpv.gpv_id = gge.gpv_id 
				      where gge.gge_id is null)';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO... SE HAN BORRADO CORRECTAMENTE '||SQL%ROWCOUNT||' REGISTROS');
    
    V_SQL := ' DELETE FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_ID in (
				  select GPV.GPV_ID from '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
				    left join '||V_ESQUEMA||'.GGE_GASTOS_GESTION GGE on gpv.gpv_id = gge.gpv_id 
				      where gge.gge_id is null)';
    EXECUTE IMMEDIATE V_SQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR... SE HAN BORRADO CORRECTAMENTE '||SQL%ROWCOUNT||' REGISTROS');
    	
    
	DBMS_OUTPUT.PUT_LINE('[FIN] El proceso de borrado de los gastos a finalizado correctamente');
	
	DBMS_OUTPUT.PUT_LINE('********************' );
	 DBMS_OUTPUT.PUT_LINE('**ACTIVAMOS RESTRICCIONES CLAVE AJENA**' );
	 DBMS_OUTPUT.PUT_LINE('********************' );
	 
	 FOR I IN C_TABLA.FIRST .. C_TABLA.LAST
	 LOOP
	      V_TEMP_TABLAS := C_TABLA(I);
	     
	      FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME FROM SYS.USER_CONSTRAINTS WHERE CONSTRAINT_TYPE='R'
	                AND STATUS='DISABLED' AND TABLE_NAME = V_TEMP_TABLAS(2))
	      LOOP
	          BEGIN                
	                     EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
	                     
	       EXCEPTION WHEN OTHERS THEN
	             NULL;
	       END;
	      END LOOP;            
	 END LOOP; 
	
	 DBMS_OUTPUT.PUT_LINE('*******************************' );
	 DBMS_OUTPUT.PUT_LINE('**FALTA ACTIVAR RESTRICCIONES**' );
	 DBMS_OUTPUT.PUT_LINE('*******************************' );
	
	  FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME
	              FROM SYS.USER_CONSTRAINTS
	             WHERE  STATUS='DISABLED')
	   LOOP
	  BEGIN                
	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;
	 
	  EXCEPTION WHEN OTHERS THEN
	  NULL;
	  END;
	  END LOOP;  
	
	  FOR J IN (SELECT TABLE_NAME, CONSTRAINT_NAME
	              FROM SYS.USER_CONSTRAINTS
	             WHERE  STATUS='DISABLED')
	   LOOP
	  BEGIN                
	EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.' || J.TABLE_NAME || ' ENABLE CONSTRAINT ' || J.CONSTRAINT_NAME;  
	  EXCEPTION WHEN OTHERS THEN
	  NULL;
	  END;
	  END LOOP;
	
	COMMIT;    
    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line(V_SQL);
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;
