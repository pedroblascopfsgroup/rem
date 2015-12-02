--/*
--##########################################
--## AUTOR=Manuel Mejias
--## FECHA_CREACION=20150708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3-hy-rc01
--## INCIDENCIA_LINK=PRODUCTO-109
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_COLS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN	

V_SQL := 'select COUNT(1) from all_tab_cols where UPPER(OWNER)='''||V_ESQUEMA||''' 
  and UPPER(table_name)=''CNV_AUX_CCDD_PR_CONV_CIERR_DD'' and UPPER(column_name)=''ORIGEN_PROPUESTA''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLS;

IF V_NUM_COLS > 0 THEN 
	DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD...no se modifica nada.');
ELSE
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD ADD ORIGEN_PROPUESTA VARCHAR2(20 CHAR) DEFAULT ''AUTOMATICO'' '; 
	
END IF;
		
EXECUTE IMMEDIATE V_SQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD... Tabla modificada');  



V_SQL := 'select COUNT(1) from all_tab_cols where UPPER(OWNER)='''||V_ESQUEMA||''' 
  and UPPER(table_name)=''CNV_AUX_CCDD_PR_CONV_CIERR_DD'' and UPPER(column_name)=''RESULTADO_VALIDACION''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLS;

IF V_NUM_COLS > 0 THEN 
	DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD...no se modifica nada.');
ELSE
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD ADD RESULTADO_VALIDACION NUMBER(1,0) DEFAULT 1'; 
	
END IF;
		
EXECUTE IMMEDIATE V_SQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD... Tabla modificada');



V_SQL := 'select COUNT(1) from all_tab_cols where UPPER(OWNER)='''||V_ESQUEMA||''' 
  and UPPER(table_name)=''CNV_AUX_CCDD_PR_CONV_CIERR_DD'' and UPPER(column_name)=''DD_RVC_ID''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_COLS; 

IF V_NUM_COLS > 0 THEN 
	DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD...no se modifica nada.');
ELSE
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD ADD DD_RVC_ID  NUMBER(16) '; 

END IF;

EXECUTE IMMEDIATE V_SQL;
DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.CNV_AUX_CCDD_PR_CONV_CIERR_DD... Tabla modificada');  


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