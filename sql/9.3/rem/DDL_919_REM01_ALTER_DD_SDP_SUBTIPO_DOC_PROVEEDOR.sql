--/*
--##########################################
--## AUTOR=JIN LI HU
--## FECHA_CREACION=20191106
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8222
--## PRODUCTO=NO
--## Finalidad: Arreglar tipo de las columnas de DD_SDP_SUBTIPO_DOC_PROVEEDOR
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

  V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DD_SDP_SUBTIPO_DOC_PROVEEDOR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

BEGIN
		EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME ='''||V_TEXT_TABLA||''' AND OWNER='''||V_ESQUEMA||''''
		INTO V_NUM_TABLAS;
		IF V_NUM_TABLAS > 0 THEN
		
			V_SQL:= 'ALTER TABLE '||V_ESQUEMA||'.DD_SDP_SUBTIPO_DOC_PROVEEDOR MODIFY USUARIOCREAR VARCHAR2(50 CHAR)';
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('[USUARIOCREAR Alterada]');
			
			V_SQL:= 'ALTER TABLE '||V_ESQUEMA||'.DD_SDP_SUBTIPO_DOC_PROVEEDOR MODIFY USUARIOMODIFICAR VARCHAR2(50 CHAR)';
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('[USUARIOMODIFICAR Alterada]');
			
			V_SQL:= 'ALTER TABLE '||V_ESQUEMA||'.DD_SDP_SUBTIPO_DOC_PROVEEDOR MODIFY USUARIOMODIFICAR VARCHAR2(50 CHAR)';
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('[USUARIOMODIFICAR Alterada]');
			
			V_SQL:= 'ALTER TABLE '||V_ESQUEMA||'.DD_SDP_SUBTIPO_DOC_PROVEEDOR MODIFY BORRADO DEFAULT 0';
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('[BORRADO Alterada]');
			
			V_SQL:= 'ALTER TABLE '||V_ESQUEMA||'.DD_SDP_SUBTIPO_DOC_PROVEEDOR MODIFY VERSION DEFAULT 0';
			EXECUTE IMMEDIATE V_SQL;
			
			DBMS_OUTPUT.PUT_LINE('[VERSION Alterada]'); 
		
		ELSE 
			DBMS_OUTPUT.PUT_LINE('[DD_SDP_SUBTIPO_DOC_PROVEEDOR no existe...]');
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
