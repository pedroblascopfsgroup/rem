--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20181205
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Indices para la busqueda de la GPV_ACT
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'GPV_ACT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	
BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Indices en GPV_ACT ------------------------------.');
	
		-- Creamos indice GPV_ACT_IDX1
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''GPV_ACT_IDX1'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE INDEX GPV_ACT_IDX1 ON '||V_ESQUEMA||'.GPV_ACT (GPV_ID) TABLESPACE '||V_TABLESPACE_IDX;		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPV_ACT_IDX1 - GPV_ID - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPV_ACT_IDX1 - Ya existe - no se hace nada.');
	END IF;
	
		-- Creamos indice GPV_ACT_IDX2
	V_MSQL := 'SELECT COUNT(1) FROM ALL_INDEXES WHERE INDEX_NAME = ''GPV_ACT_IDX2'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 0 THEN
		V_MSQL := 'CREATE INDEX GPV_ACT_IDX2 ON '||V_ESQUEMA||'.GPV_ACT (ACT_ID) TABLESPACE '||V_TABLESPACE_IDX;
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPV_ACT_IDX2 - ACT_ID - creado.');
	ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] Indice GPV_ACT_IDX2 - Ya existe - no se hace nada.');
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
