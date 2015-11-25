--/*
--##########################################
--## AUTOR=Alberto b
--## FECHA_CREACION=20151112
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1.0-rcj14
--## INCIDENCIA_LINK=PRODUCTO-419
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla DD_SNN_SINONOAPLICA
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


	DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.ACU_OPERACIONES_TERMINOS... Nuevos campos: OP_FECHA_SOL_PREVISTA, OP_NUM_CONTRATO_DESCUENTO, OP_NUM_CONTRATO_PTMO_PROMOTOR,OP_COD_PERSONA_AFECTADA ');
	V_SQL := 'select COUNT(1) from all_tab_cols where UPPER(OWNER)='''||V_ESQUEMA||''' 
		  and UPPER(table_name)=''ACU_OPERACIONES_TERMINOS'' and UPPER(column_name)in(''OP_FECHA_SOL_PREVISTA'', ''OP_NUM_CONTRATO_DESCUENTO'', ''OP_NUM_CONTRATO_PTMO_PROMOTOR'',''OP_COD_PERSONA_AFECTADA'')';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT = 0 THEN
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.ACU_OPERACIONES_TERMINOS ADD (OP_FECHA_SOL_PREVISTA DATE, OP_NUM_CONTRATO_DESCUENTO VARCHAR2(50), OP_NUM_CONTRATO_PTMO_PROMOTOR VARCHAR2(50), OP_COD_PERSONA_AFECTADA VARCHAR2(50))';
		DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.ACU_OPERACIONES_TERMINOS... Estructura actualizada.');
	ELSE 
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.ACU_OPERACIONES_TERMINOS... Ya existe.');
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
