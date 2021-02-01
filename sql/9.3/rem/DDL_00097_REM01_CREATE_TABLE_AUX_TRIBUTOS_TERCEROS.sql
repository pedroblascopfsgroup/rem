--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20201001
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11181
--## PRODUCTO=NO
--## Finalidad:  
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

	DBMS_OUTPUT.PUT_LINE('******** APR_AUX_GES_CC_PP_GR ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.APR_AUX_GES_CC_PP_GR... Comprobaciones previas');
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''APR_AUX_GES_CC_PP_GR'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.APR_AUX_GES_CC_PP_GR... Ya existe.');
	ELSE
		-- Creamos la tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.APR_AUX_GES_CC_PP_GR...');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.APR_AUX_GES_CC_PP_GR
		(
		    "GLD_ID"            NUMBER(16, 0) NOT NULL ENABLE
		    , "DD_TGA_ID"       NUMBER(16, 0) NOT NULL ENABLE
		    , "DD_STG_ID"       NUMBER(16, 0) NOT NULL ENABLE
		    , "TIM_BASE"        NUMBER(1)
		    , "TIM_RECARGO"     NUMBER(1)
		    , "TIM_INTERESES"   NUMBER(1)
		    , "TIM_TASAS"       NUMBER(1)
		    , "DD_CRA_ID"       NUMBER(16, 0) NOT NULL ENABLE
		    , "DD_SCR_ID"       NUMBER(16, 0)
		    , "PRO_ID"          NUMBER(16, 0)
		    , "EJE_ID"          NUMBER(16, 0) NOT NULL ENABLE
		    , "ARRENDADO"       NUMBER(1)
		    , "REFACTURABLE"    NUMBER(1)
		    , "DD_TBE_ID"       NUMBER(16, 0)
		    , "ACTIVABLE"       NUMBER(1)
		    , "PLAN_VISITAS"    NUMBER(1)
		    , "DD_TCH_ID"       NUMBER(16, 0)
		    , "DD_TRT_ID"       NUMBER(16, 0)
		    , "VENDIDO"         NUMBER(1)
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.APR_AUX_GES_CC_PP_GR... Tabla creada.');
		
	END IF;

	DBMS_OUTPUT.PUT_LINE('******** APR_AUX_GES_CC_PP_GR_2 ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.APR_AUX_GES_CC_PP_GR_2... Comprobaciones previas');
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''APR_AUX_GES_CC_PP_GR_2'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.APR_AUX_GES_CC_PP_GR_2... Ya existe.');
	ELSE
		-- Creamos la tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.APR_AUX_GES_CC_PP_GR_2...');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.APR_AUX_GES_CC_PP_GR_2
		(
		    "GLD_ID"            			NUMBER(16, 0) NOT NULL ENABLE
		    , "DD_TIM_CODIGO"   			VARCHAR2(50 CHAR)
		    , CCC_CUENTA_CONTABLE   		VARCHAR2(50 CHAR)
		    , CPP_PARTIDA_PRESUPUESTARIA	VARCHAR2(50 CHAR)
		    , CCC_SUBCUENTA_CONTABLE    	VARCHAR2(50 CHAR)
		    , CPP_APARTADO          		VARCHAR2(50 CHAR)
		    , CPP_CAPITULO          		VARCHAR2(50 CHAR)
		)
		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.APR_AUX_GES_CC_PP_GR_2... Tabla creada.');
		
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
