--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20191125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8603
--## PRODUCTO=NO
--## Finalidad: Añadir nueva columna DD_TDC_ID a la tabla ACT_ACTIVO
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
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN
		EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME ='''||V_TEXT_TABLA||''' AND OWNER='''||V_ESQUEMA||''''
		INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS > 0 THEN
		
			V_SQL:= 'ALTER TABLE '||V_ESQUEMA||'.ACT_ACTIVO ADD DD_TDC_ID NUMBER(16,0)';
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('[COLUMNA DD_TDC_ID AÑADIDA]');
			
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DD_TDC_ID IS ''Tipo de territorio.''';
			
			V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_DD_TDC_ID FOREIGN KEY (DD_TDC_ID) REFERENCES '||V_ESQUEMA||'.DD_TDC_TERRITORIOS_DIR_COM (DD_TDC_ID) ON DELETE SET NULL)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DD_TDC_ID... Foreign key creada.');
		
		ELSE 
			DBMS_OUTPUT.PUT_LINE('[ACT_ACTIVO no existe...]');
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
