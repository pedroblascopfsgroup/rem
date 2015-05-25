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

  DBMS_OUTPUT.PUT_LINE('[INFO] INSERCIÓN DD_RULE_DEFINITION DE REINCIDENCIAS CONTRATOS ');

  -- comprobar si existe EN DD_RULE_DEFINITION LA RD_COLUMN
  V_SQL := 'select count(1) from ' || V_ESQUEMA || '.DD_RULE_DEFINITION ' ||
  	'where RD_COLUMN=''acn_num_reinciden''';

  EXECUTE IMMEDIATE V_SQL INTO V_COUNT;

  IF V_COUNT > 0 THEN
  	DBMS_OUTPUT.PUT_LINE('[INFO] DD_RULE_DEFINITION ya actualizada.');
  ELSE
	V_SQL := 'INSERT INTO ' || V_ESQUEMA || '.DD_RULE_DEFINITION ' || 
		' (RD_ID,RD_TITLE,RD_COLUMN,RD_TYPE,RD_VALUE_FORMAT,RD_BO_VALUES,RD_TAB,USUARIOCREAR,FECHACREAR) ' ||
		' VALUES ' ||
		' (' || V_ESQUEMA || '.S_DD_RULE_DEFINITION.NEXTVAL, ''Número de Reincidencias del Contrato'', ' || 
		' ''acn_num_reinciden'',''compare1'',''number'',null,''Contrato'',''PBO'',SYSDATE)';
	EXECUTE IMMEDIATE V_SQL;	
  END IF;

  DBMS_OUTPUT.PUT_LINE('[FIN] INSERCIÓN DD_RULE_DEFINITION DE REINCIDENCIAS CONTRATOS ');

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
