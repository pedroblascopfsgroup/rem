--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20151110
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=BKREC-1421
--## PRODUCTO=SI
--## Finalidad: DML
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

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla. 
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN
    
    ----------------------------
    --   DD_RULE_DEFINITION   --
    ----------------------------  
    
    V_MSQL := 'INSERT INTO DD_RULE_DEFINITION (RD_ID,RD_TITLE,RD_COLUMN,RD_TYPE,RD_VALUE_FORMAT,RD_BO_VALUES,RD_TAB,USUARIOCREAR)
    VALUES ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.NEXTVAL,''Actuacion FSR en Centro Gestor, no Agencias'',''CAC_ACTUACION_EN_CURSO'',''dictionary'',''number'',''DDSiNo'',''Contrato'',''PFS'')';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.DD_RULE_DEFINITION... Alter table FIN');        
 
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
