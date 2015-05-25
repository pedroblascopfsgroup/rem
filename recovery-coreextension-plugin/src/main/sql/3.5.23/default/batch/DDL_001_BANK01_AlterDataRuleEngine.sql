--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150519
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.0.1-rc07-bk
--## INCIDENCIA_LINK=BKFTRES-30
--## PRODUCTO=SI
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;

SET SERVEROUTPUT ON; 

DECLARE

  V_ESQUEMA VARCHAR(30) := '#ESQUEMA#';
  V_SQL VARCHAR2(4000);
  V_COUNT NUMBER(3);

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZAR TABLA DATA_RULE_ENGINE ');

  V_SQL := 'select count(1) from all_tab_columns ' ||
  	'where COLUMN_NAME=''ACN_NUM_REINCIDEN'' and table_name=''DATA_RULE_ENGINE'' and owner=''' || V_ESQUEMA || '''';

  EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

  IF V_COUNT > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla DATA_RULE_ENGINE ya actualizada.');
  ELSE
  	V_SQL := 'ALTER TABLE ' || V_ESQUEMA || '.DATA_RULE_ENGINE ADD ACN_NUM_REINCIDEN NUMBER(10.0)'; 
	  EXECUTE IMMEDIATE V_SQL;	
  END IF;

  DBMS_OUTPUT.PUT_LINE('[FIN] ACTUALIZAR TABLA DATA_RULE_ENGINE ');

  EXCEPTION
       WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('[ERROR] SE HA PRODUCIDO UN ERROR EN LA EJECUCIÓN: '||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            
            ROLLBACK;
            RAISE;

END;
/

EXIT 
