--/*
--##########################################
--## AUTOR=Alberto Campos
--## FECHA_CREACION=20160104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc36
--## INCIDENCIA_LINK=CMREC-1722
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR TABLA PER_PERSONAS ');

  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''DD_SIC_ID'' and table_name=''PER_PERSONAS'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

  IF V_NUM_TABLAS > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla PER_PERSONAS ya actualizada.');
  ELSE
  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.PER_PERSONAS ADD DD_SIC_ID NUMBER(16, 0)'; 
	EXECUTE IMMEDIATE V_SQL;	
	  
	/*V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.PER_PERSONAS
							  ADD CONSTRAINT FK_DD_SIC_SITUAC_CONCURSAL
							  FOREIGN KEY (DD_SIC_ID)
							  REFERENCES '||V_ESQUEMA||'.DD_SIC_SITUAC_CONCURSAL(DD_SIC_ID)';			
	EXECUTE IMMEDIATE V_SQL;	*/						  
      
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] AÑADIDO EL CAMPO DD_SIC_ID ');
  DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZAR TABLA PER_PERSONAS ');

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