--/*
--##########################################
--## AUTOR=Alberto b
--## FECHA_CREACION=20151201
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1.0-cj-rc23
--## INCIDENCIA_LINK=PRODUCTO-496
--## PRODUCTO=SI
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

	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.DD_TPA_TIPO_ACUERDO...');
	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''DD_EIN_ID'' AND TABLE_NAME = ''DD_TPA_TIPO_ACUERDO''';
		  
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] El campo ya existe en la tabla');
	ELSE 
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO ADD DD_EIN_ID NUMBER(16)';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.DD_TPA_TIPO_ACUERDO... Estructura actualizada.');
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.DD_TPA_TIPO_ACUERDO...');
	V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_TPA_TIPO_ACUERDO'' AND CONSTRAINT_NAME = ''FK_DD_EIN_ENTIDAD_INFORMACION''';
	DBMS_OUTPUT.PUT_LINE(V_SQL);
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] La constraint ya existe en la tabla');
	ELSE
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_TPA_TIPO_ACUERDO ADD CONSTRAINT FK_DD_EIN_ENTIDAD_INFORMACION FOREIGN KEY (DD_EIN_ID) REFERENCES '||V_ESQUEMA_M||'.DD_EIN_ENTIDAD_INFORMACION(DD_EIN_ID)';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.DD_TPA_TIPO_ACUERDO... Estructura actualizada.');
	END IF;
    
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
