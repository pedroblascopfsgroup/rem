--/*
--##########################################
--## AUTOR=Alberto Soler
--## FECHA_CREACION=20160603
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1861
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla TUP_HIS_HISTORICO
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN

    -- ******** TUP_HIS_HISTORICO *******
    DBMS_OUTPUT.PUT_LINE('******** TUP_HIS_HISTORICO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_HIS_HISTORICO... Comprobaciones previas'); 
    
    -- Creacion Tabla ETG_ENTIDAD_TIPO_GESTOR
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TUP_HIS_HISTORICO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TUP_HIS_HISTORICO... Tabla YA EXISTE y va a ser borrada');    
            EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.TUP_HIS_HISTORICO';    
     ELSE
        execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_TUP_HIS_HISTORICO  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_TUP_HIS_HISTORICO... Secuencia creada correctamente.');      
         
     END IF;
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TUP_HIS_HISTORICO
               (
                HIS_ID NUMBER(16) NOT NULL,
				DD_PLA_ID NUMBER(16),
				DD_TPO_ID NUMBER(16),
                IMPORTE NUMBER,
                EPT_ID NUMBER(16),
                PRC_ID NUMBER(16),
                USU_ID_ASIGNADO NUMBER(16),
                MENSAJE VARCHAR2(100 CHAR),
                VERSION NUMBER(1)  DEFAULT 0,
                USUARIOCREAR VARCHAR2(50 CHAR),
                FECHACREAR TIMESTAMP(6),
                USUARIOMODIFICAR VARCHAR2(50 CHAR),
                FECHAMODIFICAR TIMESTAMP(6),
                USUARIOBORRAR VARCHAR2(50 CHAR),
                FECHABORRAR TIMESTAMP(6),
                BORRADO NUMBER(1)  DEFAULT 0,
                CONSTRAINT PK_HIS PRIMARY KEY (HIS_ID)
               ) 
				';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA|| '.TUP_HIS_HISTORICO... Tabla creada');


        V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.TUP_HIS_HISTORICO ADD (
                  CONSTRAINT HIS_PLA_FK 
                 FOREIGN KEY (DD_PLA_ID) 
                 REFERENCES '||V_ESQUEMA||'.DD_PLA_PLAZAS (DD_PLA_ID),
                  CONSTRAINT HIS_TPO_FK 
                 FOREIGN KEY (DD_TPO_ID) 
                 REFERENCES '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO (DD_TPO_ID),
                 CONSTRAINT HIS_PRC_FK 
                 FOREIGN KEY (PRC_ID) 
                 REFERENCES '||V_ESQUEMA||'.PRC_PROCEDIMIENTOS (PRC_ID),
                  CONSTRAINT HIS_EPT_FK
                 FOREIGN KEY (EPT_ID) 
                 REFERENCES '||V_ESQUEMA||'.TUP_EPT_ESQUEMA_PLAZAS_TPO (EPT_ID))';
                 
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TUP_HIS_HISTORICO... FKs creadas');

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
