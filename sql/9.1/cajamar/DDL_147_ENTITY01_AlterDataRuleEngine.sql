--/*
--##########################################
--## AUTOR=Carlos Perez
--## FECHA_CREACION=20151214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc29.1
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
--## Finalidad: DDL
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN


  DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR TABLA DATA_RULE_ENGINE ');

  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''DD_EIC_ID'' and table_name=''DATA_RULE_ENGINE'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla DATA_RULE_ENGINE ya actualizada.');
  ELSE
  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.DATA_RULE_ENGINE ADD DD_EIC_ID NUMBER(16,0)'; 
	  EXECUTE IMMEDIATE V_SQL;	
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDO EL CAMPO DD_EIC_ID');

  
  
  
  
  
  
  
  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''DD_CRE_ID'' and table_name=''DATA_RULE_ENGINE'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla DATA_RULE_ENGINE ya actualizada.');
  ELSE
  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.DATA_RULE_ENGINE ADD DD_CRE_ID NUMBER(16,0)'; 
	  EXECUTE IMMEDIATE V_SQL;	
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDO EL CAMPO DD_CRE_ID');

  
    
  
  
  
  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''DD_TGL_ID'' and table_name=''DATA_RULE_ENGINE'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla DATA_RULE_ENGINE ya actualizada.');
  ELSE
  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.DATA_RULE_ENGINE ADD DD_TGL_ID NUMBER(16,0)'; 
	  EXECUTE IMMEDIATE V_SQL;	
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDO EL CAMPO DD_TGL_ID');

  DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZAR TABLA DATA_RULE_ENGINE ');

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