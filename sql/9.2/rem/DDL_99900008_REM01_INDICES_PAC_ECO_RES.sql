--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20170207
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Indices necesarios para la búsqueda de propuestas
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

 
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
	
BEGIN
	
	
		-- Creamos indice GPV_GASTOS_PROVEEDOR_IDX1
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''IDX_PAC_02'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX IDX_PAC_01 ON '||V_ESQUEMA||'.ACT_PAC_PROPIETARIO_ACTIVO (ACT_ID, PRO_ID ASC) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice IDX_PAC_01 - (ACT_ID, PRO_ID ASC)  - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice IDX_PAC_01 - Ya existe - no se hace nada.');
	END IF;
	
		-- Creamos indice GPV_GASTOS_PROVEEDOR_IDX2
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''IDX_ECO_01'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX IDX_ECO_01 ON '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL (ECO_ID, OFR_ID ASC) TABLESPACE '||V_TABLESPACE_IDX;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice IDX_ECO_01 -(ECO_ID, OFR_ID ASC) - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice IDX_ECO_01 - Ya existe - no se hace nada.');
	END IF;
	
		-- Creamos indice GPV_GASTOS_PROVEEDOR_IDX3
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''IDX_RES_01'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE UNIQUE INDEX IDX_RES_01 ON '||V_ESQUEMA||'.RES_RESERVAS (RES_ID, ECO_ID, DD_ERE_ID, BORRADO ASC) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice IDX_RES_01 - (RES_ID, ECO_ID, DD_ERE_ID, BORRADO ASC) - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice IDX_RES_01 - Ya existe - no se hace nada.');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] CREACION INDICES...OK');
	
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

EXIT