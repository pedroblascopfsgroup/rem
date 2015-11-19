--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20151021
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.16-bk
--## INCIDENCIA_LINK=BKREC-1118
--## PRODUCTO=SI
--## Finalidad: DDL
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

    --------------------------------
    --   TMP_ACUERDOSEXPEDIENTE   --
    --------------------------------   
    
    --** Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_ACUERDOSEXPEDIENTE'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP TABLE '||v_esquema||'.TMP_ACUERDOSEXPEDIENTE CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_ACUERDOSEXPEDIENTE... Tabla borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_ACUERDOSEXPEDIENTE... Comprobaciones previas FIN');
    
   
    --** Creamos la tabla
    V_MSQL := ' CREATE GLOBAL TEMPORARY TABLE '||v_esquema||'.TMP_ACUERDOSEXPEDIENTE
		(	
     		   "EXP_ID"                        NUMBER(16,0) NOT NULL, 
	           "RCF_SCA_ID"                    NUMBER(16,0), 
	           "RCF_ESQ_ID"                    NUMBER(16,0), 
	           "ACU_ID"                        NUMBER(16,0) NOT NULL, 
	           "DD_EAC_CODIGO"                 VARCHAR2(50 CHAR) NOT NULL, 
	           "ACU_FECHA_PROPUESTA"           DATE, 
	           "ACU_FECHA_ESTADO"              DATE, 
	           "RCF_TPP_ID"                    NUMBER(16,0), 
	           "RCF_STP_ID"                    NUMBER(16,0), 
	           "ACU_PRIOR"                     NUMBER
		) ON COMMIT PRESERVE ROWS';
		
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.TMP_ACUERDOSEXPEDIENTE... Tabla creada');
    
    
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
