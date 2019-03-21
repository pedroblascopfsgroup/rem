--/*
--######################################### 
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190318
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3628
--## PRODUCTO=SI
--## 
--## Finalidad: Borrar APR_AUX_STOCK_GEST_REM_TO_UVEM.TIPO_GESTORIA
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
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- #TABLESPACE_INDEX# Configuracion Tablespace de Indices
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  
 BEGIN
    
	-----------------------
	---     TABLA       ---
	-----------------------
	
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME =''APR_AUX_STOCK_GEST_REM_TO_UVEM'' AND OWNER='''||V_ESQUEMA||''''
	INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN
	
	DBMS_OUTPUT.PUT_LINE('Eliminar campo APR_AUX_STOCK_GEST_REM_TO_UVEM.TIPO_GESTORIA' );

	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.APR_AUX_STOCK_GEST_REM_TO_UVEM
		   DROP COLUMN TIPO_GESTORIA '	;						
	
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('Campo eliminado');
	
	
	COMMIT;

 	END IF;
	
	
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
