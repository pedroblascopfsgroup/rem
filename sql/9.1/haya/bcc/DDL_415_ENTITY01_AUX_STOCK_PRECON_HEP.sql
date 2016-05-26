--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20160516
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-3354
--## PRODUCTO=NO
--## 
--## Finalidad: CREA TABLA AUXILIAR PRECONTENCIOSO HEP
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ITABLE_SPACE VARCHAR(25) :='#TABLESPACE_INDEX#';
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN
    
    -----------------------------
    --  AUX_STOCK_PRECON_HEP   --
    ----------------------------- 
    
    
        --** Comprobamos si existe la tabla   
    V_SQL := 'select count(1) from ALL_TABLES where TABLE_NAME = ''AUX_STOCK_PRECON_HEP''  and owner = upper('''||v_esquema||''')';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    IF V_NUM_TABLAS = 1 THEN 
    V_MSQL := 'DROP TABLE '||v_esquema||'.AUX_STOCK_PRECON_HEP';        
    EXECUTE IMMEDIATE V_MSQL;
    END IF;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.AUX_STOCK_PRECON_HEP TABLE BORRADA...');
    

    V_MSQL := 'CREATE TABLE '||v_esquema||'.AUX_STOCK_PRECON_HEP
   (	
  "PCO_PRC_HEP_SYS_GUID" VARCHAR2(36 CHAR) NOT NULL ENABLE, 
	"PCO_PRC_SYS_GUID" VARCHAR2(36 CHAR) NOT NULL ENABLE, 
	"DD_PCO_PEP_CODIGO" VARCHAR2(2 CHAR) NOT NULL ENABLE, 
	"PCO_PRC_HEP_FECHA_INCIO" TIMESTAMP (6), 
	"PCO_PRC_HEP_FECHA_FIN" TIMESTAMP (6),  
	"VERSION" NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
	"USUARIOCREAR" VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	"FECHACREAR" TIMESTAMP (6), 
	"USUARIOMODIFICAR" VARCHAR2(50 CHAR), 
	"FECHAMODIFICAR" TIMESTAMP (6), 
	"USUARIOBORRAR" VARCHAR2(50 CHAR), 
	"FECHABORRAR" TIMESTAMP (6), 
	"BORRADO" NUMBER(1,0) DEFAULT 0)';        
    EXECUTE IMMEDIATE V_MSQL;
    
	DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.AUX_STOCK_PRECON_HEP TABLA CREADA...');



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
