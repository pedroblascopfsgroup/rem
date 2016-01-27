--/*
--##########################################
--## AUTOR=RUBEN ROVIRA
--## FECHA_CREACION=20151217
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=CMREC-1216
--## PRODUCTO=NO
--## 
--## Finalidad: DDL
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
    ITABLE_SPACE   VARCHAR(25) := '#TABLESPACE_INDEX#';
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
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_ARV_ARRAS_VENC'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP TABLE '||v_esquema||'.DD_ARV_ARRAS_VENC CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.DD_ARV_ARRAS_VENC... Tabla borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.DD_ARV_ARRAS_VENC... Comprobaciones previas FIN');

    --** Creamos la tabla

    V_MSQL := 'CREATE TABLE ' ||v_esquema||'.DD_ARV_ARRAS_VENC 
               (
					DD_ARV_ID					NUMBER(16,0),
					DD_ARV_CODIGO				VARCHAR2(50 CHAR)  NOT NULL,
					DD_ARV_DESCRIPCION			VARCHAR2(100 CHAR)  NOT NULL,
					DD_ARV_DESCRIPCION_LARGA	VARCHAR2(250 CHAR),
					VERSION						NUMBER(38,0),
					USUARIOCREAR				VARCHAR2(50 CHAR)  NOT NULL,
					FECHACREAR					TIMESTAMP(6)       NOT NULL,
					USUARIOMODIFICAR			VARCHAR2(50 CHAR),
					FECHAMODIFICAR				TIMESTAMP(6),
					USUARIOBORRAR				VARCHAR2(50 CHAR),
					FECHABORRAR					TIMESTAMP(6),
					BORRADO						NUMBER(1,0),
					CONSTRAINT PK_DD_ARV_ID PRIMARY KEY (DD_ARV_ID)
               )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.DD_ARV_ARRAS_VENC... Tabla creada');
       
    V_SQL :='SELECT COUNT(*) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_ARV_ARRAS_VENC'' AND SEQUENCE_OWNER='''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP SEQUENCE '||v_esquema||'.S_DD_ARV_ARRAS_VENC';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.S_DD_ARV_ARRAS_VENC... Secuencia borrada');  
    END IF;
	--Creamos la secuencia
        V_MSQL :='CREATE SEQUENCE '||v_esquema||'.S_DD_ARV_ARRAS_VENC INCREMENT BY 1 
              START WITH 1';
	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.S_DD_ARV_ARRAS_VENC... Secuencia creada'); 
    
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
