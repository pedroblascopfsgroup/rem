--/*
--##########################################
--## AUTOR=Alberto b
--## FECHA_CREACION=20151115
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1.0-rcj17
--## INCIDENCIA_LINK=-
--## PRODUCTO=NO
--## Finalidad: Alteracion tabla 
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
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_STRING VARCHAR2(10); -- Vble. para validar la existencia de si el campo es nulo
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN


	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.ACU_CAMPOS_TIPO_ACUERDO...');
	V_SQL := 'SELECT COUNT(1) from all_constraints where constraint_name = ''FK_TERMINOS_TPR''';
		  
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT = 1 THEN
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO DROP CONSTRAINT FK_TERMINOS_TPR';
		DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO... Estructura actualizada.');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO... FK_TERMINOS_TPR Ya no existe.');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.ACU_CAMPOS_TIPO_ACUERDO...');
	V_SQL := 'SELECT NULLABLE FROM USER_TAB_COLUMNS WHERE TABLE_NAME = ''TEA_TERMINOS_ACUERDO'' and column_name = ''DD_TPR_ID''';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL INTO V_STRING;
	IF V_STRING = 'N' THEN
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.TEA_TERMINOS_ACUERDO MODIFY DD_TPR_ID NULL';
		DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO... Estructura actualizada.');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.TEA_TERMINOS_ACUERDO... EL CAMPO DD_TPR_ID YA ES NULO.');
	END IF;
    
	
    
		
		
		
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
