--/*
--##########################################
--## AUTOR=Carlos Gil Gimeno
--## FECHA_CREACION=20160524
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.4
--## INCIDENCIA_LINK=PRODUCTO-1442
--## PRODUCTO=NO
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
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_BORRADO NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    TYPE T_RULE IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_RULES IS TABLE OF T_RULE;
    V_RULE T_ARRAY_RULES := T_ARRAY_RULES(
      T_RULE('Sin accion, Persona', 'TAF_PER_SIN_ACCION','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('No localizado, Persona', 'TAF_PER_NO_LOCALIZADO','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Contactado / En negociación, Persona', 'TAF_PER_CNTDO_NEG','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Compromiso de Pago, Persona', 'TAF_PER_COM_PGO','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Adecuación, Persona', 'TAF_PER_ADECUACION','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Dación en Pago, Persona', 'TAF_PER_DACION','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Cancelación con Quita, Persona', 'TAF_PER_CNCL_QUITA','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Pase a Litigio, Persona', 'TAF_PER_PASE_LIT','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Prefallido, Persona', 'TAF_PER_PRE_FAIL','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Ilocalizable, Persona', 'TAF_PER_LOCALIZABLE','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Sin accion, Contrato', 'TAF_CNT_SIN_ACCION','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('No localizado, Contrato', 'TAF_CNT_NO_LOCALIZADO','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Contactado / En negociación, Contrato', 'TAF_CNT_CNTDO_NEG','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Compromiso de Pago, Contrato', 'TAF_CNT_COM_PGO','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Adecuación, Contrato', 'TAF_CNT_ADECUACION','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Dación en Pago, Contrato', 'TAF_CNT_DACION','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Cancelación con Quita, Contrato', 'TAF_CNT_CNCL_QUITA','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Pase a Litigio, Contrato', 'TAF_CNT_PASE_LIT','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Prefallido, Contrato', 'TAF_CNT_PRE_FAIL','dictionary', 'number', 'DDSiNo','Actuacion'),
      T_RULE('Ilocalizable, Contrato', 'TAF_CNT_LOCALIZABLE','dictionary', 'number', 'DDSiNo','Actuacion')
    );   
    V_TMP_RULE T_RULE;
BEGIN
	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.DD_RULE_DEFINITION ... Empezando a insertar datos en DD_RULE_DEFINITION ');
    FOR I IN V_RULE.FIRST .. V_RULE.LAST
      LOOP
            V_TMP_RULE := V_RULE(I);
            V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_RULE_DEFINITION WHERE RD_COLUMN = '''||V_TMP_RULE(2)||''' AND RD_TAB = '''||V_TMP_RULE(6)||'''';
			DBMS_OUTPUT.PUT_LINE(V_SQL);
		    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
		    IF V_NUM_TABLAS > 0 THEN	  
				DBMS_OUTPUT.PUT_LINE('[INFO] Existe el registro en la tabla '||V_ESQUEMA||'.DD_RULE_DEFINITION.');
			ELSE
		    	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.NEXTVAL, '''||V_TMP_RULE(1)||''', '''||V_TMP_RULE(2)||''','''||V_TMP_RULE(3)||''', '''||V_TMP_RULE(4)||''', '''||V_TMP_RULE(5)||''','''||V_TMP_RULE(6)||''',''PRODUCTO-1442'',SYSDATE,NULL,NULL,NULL,NULL,0)';
		    	DBMS_OUTPUT.PUT_LINE(V_MSQL);
				EXECUTE IMMEDIATE V_MSQL;
				DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.DD_RULE_DEFINITION');
			END IF;
      END LOOP;
	
	
    COMMIT;
	
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
