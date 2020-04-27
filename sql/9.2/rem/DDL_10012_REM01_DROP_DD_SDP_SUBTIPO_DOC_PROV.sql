--/*
--#########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20200220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-9384
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar tabla DD_SDP_SUBTIPO_DOC_PROVEEDOR
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
  V_TABLA VARCHAR2(40 CHAR) := 'DD_SDP_SUBTIPO_DOC_PROVEEDOR';
  TABLE_COUNT NUMBER(1,0) := 0;
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
  
 BEGIN
    	SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = 'ACT_APR_ADJUNTO_PROVEEDOR' AND OWNER= ''||V_ESQUEMA||'';

	IF TABLE_COUNT > 0 THEN

	    V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_SDP_ID'' and TABLE_NAME = ''ACT_APR_ADJUNTO_PROVEEDOR'' and owner = '''||V_ESQUEMA||'''';
	    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	    
	    IF V_NUM_TABLAS = 1 THEN
		
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_APR_ADJUNTO_PROVEEDOR.DD_SDP_ID... Ya existe');
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.ACT_APR_ADJUNTO_PROVEEDOR DROP COLUMN DD_SDP_ID ';
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_APR_ADJUNTO_PROVEEDOR.DD_SDP_ID... borrada');
		
		SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

		IF TABLE_COUNT > 0 THEN
		    	DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' INSERVIBLE. SE PROCEDE A BORRAR.');
		    	EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';

			COMMIT;

		END IF;	
		       
	    END IF;

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
