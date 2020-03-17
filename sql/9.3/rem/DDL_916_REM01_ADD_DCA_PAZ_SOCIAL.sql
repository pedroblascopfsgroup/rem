--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20191209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8733
--## PRODUCTO=NO
--## Finalidad: Añadir nueva columna DCA_PAZ_SOCIAL a la tabla AUX_ACT_DCA_DTS_CNT_ALQ
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

  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AUX_ACT_DCA_DTS_CNT_ALQ'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN
		EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME ='''||V_TEXT_TABLA||''' AND OWNER='''||V_ESQUEMA||''''
		INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS > 0 THEN
		
			V_SQL:= 'ALTER TABLE '||V_ESQUEMA||'.AUX_ACT_DCA_DTS_CNT_ALQ ADD DCA_PAZ_SOCIAL NUMBER(1,0)';
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('[COLUMNA DCA_PAZ_SOCIAL AÑADIDA]');
			
			EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.DCA_PAZ_SOCIAL IS ''Corresponde al valor PAZ_SOCIAL de DWH''';
		
		ELSE 
			DBMS_OUTPUT.PUT_LINE('[Tabla AUX_ACT_DCA_DTS_CNT_ALQ no existe...]');
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
