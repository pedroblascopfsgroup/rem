--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20151214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Añadir columna trámite y FK
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
 	table_count number(3); -- Vble. para validar la existencia de las Tablas.
 	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN	
	-- Comprobamos si ya se ha añadido
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME= ''DD_TAC_ID'' and DATA_TYPE = ''NUMBER'' and TABLE_NAME=''ACT_TRA_TRAMITE'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACT_TRA_TRAMITE.DD_TAC_ID... Ya está modificado');
	ELSE
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.ACT_TRA_TRAMITE ADD (DD_TAC_ID NUMBER(16,2))';
		
		DBMS_OUTPUT.PUT('[INFO] ACT_TRA_TRAMITES_TAC_FK: CREADA...');
		EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.ACT_TRA_TRAMITE ADD (CONSTRAINT ACT_TRA_TRAMITES_TAC_FK FOREIGN KEY (DD_TAC_ID) REFERENCES '||V_ESQUEMA||'.DD_TAC_TIPO_ACTUACION(DD_TAC_ID))';
		DBMS_OUTPUT.PUT_LINE('OK');
	END IF;
	
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