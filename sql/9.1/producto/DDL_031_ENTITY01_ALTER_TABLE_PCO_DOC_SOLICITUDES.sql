--/*
--##########################################
--## AUTOR=VICENTE LOZANO
--## FECHA_CREACION=20150909
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=Producto-95
--## PRODUCTO=SI
--## Finalidad: DDL Añadir nuevas columnas
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.PCO_DOC_SOLICITUDES... Nuevo campo: PCO_DOC_SOLICITANTE');
	V_SQL := 'select COUNT(1) from all_tab_cols where UPPER(OWNER)='''||V_ESQUEMA||''' 
		  and UPPER(table_name)=''PCO_LIQ_LIQUIDACIONES'' and UPPER(column_name)=''PCO_DOC_SOLICITANTE''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT = 0 THEN
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.PCO_DOC_SOLICITUDES ADD PCO_DOC_SOLICITANTE NUMBER(16) CONSTRAINT FK_SOLICITANTE_DOC_USD REFERENCES USD_USUARIOS_DESPACHOS(USD_ID)';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.PCO_DOC_SOLICITUDES... Estructura actualizada.');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.PCO_DOC_SOLICITUDES... PCO_DOC_SOLICITANTE Ya existe.');
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
