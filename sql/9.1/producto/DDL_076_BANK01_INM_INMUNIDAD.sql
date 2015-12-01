--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20151023
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
    ---------------------
    --  INM_INMUNIDAD  --
    ---------------------   
    
    --** Comprobamos si existe la tabla   

    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''INM_INMUNIDAD'' and owner = '''||v_esquema||'''
             ';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP TABLE '||v_esquema||'.INM_INMUNIDAD CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.INM_INMUNIDAD... Tabla borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.INM_INMUNIDAD... Comprobaciones previas FIN');

    --** Creamos la tabla
    V_MSQL := 'CREATE TABLE '||v_esquema||'.INM_INMUNIDAD 
               ( EXP_ID                       NUMBER(16) NOT NULL
               , RCF_SCA_ID                   NUMBER(16)
               , ACU_ID                       NUMBER(16) NOT NULL
               , DD_EAC_CODIGO                VARCHAR2(50 Char) NOT NULL
               , ACU_FECHA_PROPUESTA          DATE
               , ACU_FECHA_ESTADO             DATE
               , RCF_TPP_ID                   NUMBER(16)
               , RCF_STP_ID                   NUMBER(16)
               , RCF_POA_ID                   NUMBER(16)
               , RCF_PAA_TIEMPO_INMUNIDAD1    NUMBER(5)
               , RCF_PAA_TIEMPO_INMUNIDAD2    NUMBER(5)
               , FECHA_FIN_INMUNIDAD          DATE
               )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.INM_INMUNIDAD... Tabla creada');
    
    --** Creamos Indices
    V_MSQL := 'CREATE UNIQUE INDEX IDX_INM_INMUNIDAD_EXP ON '||v_esquema||'.INM_INMUNIDAD (EXP_ID)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] UNIQUE '||v_esquema||'.IDX_INM_INMUNIDAD_EXP... Indice creado');
    
    --** Creamos claves ajenas
    -- exp_expedientes
    V_MSQL := 'ALTER TABLE '||v_esquema||'.INM_INMUNIDAD
                 ADD (CONSTRAINT FK_EXP_INMUNI FOREIGN KEY (EXP_ID)
                      REFERENCES '||v_esquema||'.EXP_EXPEDIENTES (EXP_ID) )';
    EXECUTE IMMEDIATE V_MSQL;     
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.EXP_EXPEDIENTES ... FK Creada');

    
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
    
