--/*
--##########################################
--## AUTOR=LORENZO LERATE
--## FECHA_CREACION=20160224
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-2209
--## PRODUCTO=No
--## 
--## Finalidad: Otra tabla temporal para el ETL de CIRBE para evitar duplicidades
--## INSTRUCCIONES:Sustituir variables
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
    
    ---------------------------
    --  DD_ARV_ARRAS_VENC    --
    ---------------------------  
    
    --** Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''APR_AUX_ABI_CIRBE_CONSOL_2'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP TABLE '||v_esquema||'.APR_AUX_ABI_CIRBE_CONSOL_2 CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.APR_AUX_ABI_CIRBE_CONSOL_2... Tabla borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.APR_AUX_ABI_CIRBE_CONSOL_2... Comprobaciones previas FIN');

    --** Creamos la tabla

    V_MSQL := '
				CREATE TABLE '||v_esquema||'.APR_AUX_ABI_CIRBE_CONSOL_2
				   (	"CIR_ID" NUMBER(16,0), 
					"DD_CRC_ID" NUMBER(16,0), 
					"DD_TMC_ID" NUMBER(16,0), 
					"DD_TSC_ID" NUMBER(16,0), 
					"DD_TVC_ID" NUMBER(16,0), 
					"DD_COC_ID" NUMBER(16,0), 
					"DD_TGC_ID" NUMBER(16,0), 
					"DD_CIC_ID" NUMBER(16,0), 
					"CIRBE_ANTERIOR" NUMBER(16,0), 
					"CIR_DISPONIBLE" NUMBER(14,2), 
					"CIR_DISPUESTO" NUMBER(14,2), 
					"CIR_CANT_PART_SOLID" NUMBER(16,0), 
					"PER_ID" NUMBER(16,0), 
					"CIR_FECHA_ACTUALIZAC" TIMESTAMP (6), 
					"CIR_FECHA_EXTRACCION" DATE, 
					"CIR_FICHERO_CARGA" VARCHAR2(50 CHAR), 
					"VERSION" NUMBER(*,0), 
					"USUARIOCREAR" VARCHAR2(50 CHAR), 
					"FECHACREAR" TIMESTAMP (6), 
					"USUARIOMODIFICAR" VARCHAR2(50 CHAR), 
					"FECHAMODIFICAR" TIMESTAMP (6), 
					"USUARIOBORRAR" VARCHAR2(50 CHAR), 
					"FECHABORRAR" TIMESTAMP (6), 
					"BORRADO" NUMBER(1,0)
   				  )';

    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.APR_AUX_ABI_CIRBE_CONSOL_2... Tabla creada');    
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
