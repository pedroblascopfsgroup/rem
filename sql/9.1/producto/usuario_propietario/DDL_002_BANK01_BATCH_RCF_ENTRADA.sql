--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20151001
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.16-bk
--## INCIDENCIA_LINK=BKREC-58
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
    
    -------------------------
    --  BATCH_RCF_ENTRADA  --
    -------------------------  
    
    --** Comprobamos si existe la tabla   

    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''BATCH_RCF_ENTRADA'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP TABLE '||v_esquema||'.BATCH_RCF_ENTRADA CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_RCF_ENTRADA... Tabla borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_RCF_ENTRADA... Comprobaciones previas FIN');


    --** Creamos la tabla

    V_MSQL := 'CREATE TABLE ' ||v_esquema||'.BATCH_RCF_ENTRADA 
               (
		RCF_ESQ_ID NUMBER (16)
		,RCF_ESQ_PLAZO INTEGER
		,RCF_ESQ_FECHA_LIB TIMESTAMP(6)
		,RCF_ESQ_BORRADO NUMBER (1)
		,RCF_DD_EES_ID NUMBER (16)
		,RCF_DD_EES_CODIGO VARCHAR2 (20 Char)
		,RCF_DD_EES_BORRADO NUMBER (1)
		,RCF_DD_MTR_ID NUMBER (16)
		,RCF_DD_MTR_CODIGO VARCHAR2 (20 Char)
		,RCF_DD_MTR_BORRADO NUMBER (1)
		,RCF_CAR_ID NUMBER (16)
		,RCF_CAR_NOMBRE VARCHAR2 (250 Char)
		,RCF_CAR_BORRADO NUMBER (1)
		,RCF_DD_ECA_ID NUMBER (16)
		,RCF_DD_ECA_CODIGO NUMBER (16)
		,RCF_DD_ECA_BORRADO NUMBER (16)
		,RD_ID NUMBER (16)
		,RD_NAME VARCHAR2 (250 Char)
		,RD_DEFINITION VARCHAR2 (4000 Char)
		,RD_BORRADO NUMBER (1)
		,RCF_AGE_ID NUMBER (16)
		,RCF_AGE_NOMBRE VARCHAR2 (100 Char)
		,RCF_AGE_CODIGO VARCHAR2 (10 Char)
		,RCF_AGE_BORRADO NUMBER (1)
		,RCF_ESC_ID NUMBER (16)
		,RCF_ESC_PRIORIDAD NUMBER (16)
		,RCF_ESC_BORRADO NUMBER (1)
		,RCF_DD_TCE_ID NUMBER (16)
		,RCF_DD_TCE_CODIGO VARCHAR2 (20 Char)
		,RCF_DD_TCE_BORRADO NUMBER (1)
		,RCF_DD_TGC_ID NUMBER (16)
		,RCF_DD_TGC_CODIGO VARCHAR2 (20 Char)
		,RCF_DD_TGC_BORRADO NUMBER (1)
		,RCF_DD_AER_ID NUMBER (16)
		,RCF_DD_AER_CODIGO VARCHAR2 (20 Char)
		,RCF_DD_AER_BORRADO NUMBER (1)
		,RCF_SCA_ID NUMBER (16)
		,RCF_SCA_NOMBRE VARCHAR2 (250 Char)
		,RCF_SCA_PARTICION INTEGER
		,RCF_SCA_BORRADO NUMBER (1)
		,RCF_DD_TPR_ID NUMBER (16)
		,RCF_DD_TPR_CODIGO VARCHAR2 (20 Char)
		,RCF_DD_TPR_BORRADO NUMBER (1)
		,RCF_ITV_ID NUMBER (16)
		,RCF_ITV_NOMBRE VARCHAR2 (250 Char)
		,RCF_ITV_FECHA_ALTA TIMESTAMP(6)
		,RCF_ITV_PLAZO_MAX NUMBER (8)
		,RCF_ITV_NO_GEST NUMBER (8)
		,RCF_ITV_BORRADO NUMBER (1)
		,RCF_MFA_ID NUMBER (16)
		,RCF_MFA_NOMBRE VARCHAR2 (250 Char)
		,RCF_MFA_BORRADO NUMBER (1)
		,RCF_POA_ID NUMBER (16)
		,RCF_POA_CODIGO VARCHAR2 (20 Char)
		,RCF_POA_BORRADO NUMBER (1)
		,RCF_MOR_ID NUMBER (16)
		,RCF_MOR_NOMBRE VARCHAR2 (250 Char)
		,RCF_MOR_BORRADO NUMBER (1)
		,RCF_SUA_ID NUMBER (16)
		,RCF_SUA_COEFICIENTE INTEGER
		,RCF_SUA_BORRADO NUMBER (1)
		,RCF_SUR_ID NUMBER (16)
		,RCF_SUR_POSICION INTEGER
		,RCF_SUR_PORCENTAJE NUMBER (16)
		,RCF_SUR_BORRADO NUMBER (1)     
               ) nologging';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BATCH_RCF_ENTRADA... Tabla creada');


    --** Creamos Indices
 
    V_MSQL := 'CREATE INDEX IDX_BATCH_RCF_ENTRADA_CAR ON '||v_esquema||'.BATCH_RCF_ENTRADA (RCF_CAR_ID) nologging';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.IDX_BATCH_RCF_ENTRADA_CAR... Indice creado');
    V_MSQL := 'CREATE INDEX IDX_BATCH_RCF_ENTRADA_SCA ON '||v_esquema||'.BATCH_RCF_ENTRADA (RCF_SCA_ID) nologging';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.IDX_BATCH_RCF_ENTRADA_SCA... Indice creado');
    V_MSQL := 'CREATE BITMAP INDEX IDX_BATCH_RCF_ENTRADA_EES ON '||v_esquema||'.BATCH_RCF_ENTRADA (RCF_DD_EES_CODIGO) nologging';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.IDX_BATCH_RCF_ENTRADA_EES... Indice creado');



    
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
    










