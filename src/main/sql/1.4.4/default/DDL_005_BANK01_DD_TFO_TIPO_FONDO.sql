--/*
--##########################################
--## Author: Recovery
--## Adaptado a BP : Sergio H.
--## Finalidad: DDL DD_TFO_TIPO_FONDO
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_SQL VARCHAR2(32000 CHAR); -- Sentencias SQL
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
BEGIN   


    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_TFO_TIPO_FONDO'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN    
       V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_TFO_TIPO_FONDO 
                  DROP PRIMARY KEY CASCADE';            
       EXECUTE IMMEDIATE V_SQL;  
       DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TFO_TIPO_FONDO... Claves primarias eliminadas');    
    END IF;


   -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_TFO_TIPO_FONDO'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
       V_SQL := 'DROP TABLE '||V_ESQUEMA||'.DD_TFO_TIPO_FONDO CASCADE CONSTRAINTS';
       EXECUTE IMMEDIATE V_SQL;
       DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TFO_TIPO_FONDO... Tabla borrada');  
    END IF;


    V_SQL := '
        CREATE TABLE BANK01.DD_TFO_TIPO_FONDO
        (
          DD_TFO_ID                 NUMBER(16)          NOT NULL,
          DD_TFO_CODIGO             VARCHAR2(20 CHAR)   NOT NULL,
          DD_TFO_DESCRIPCION        VARCHAR2(50 CHAR),
          DD_TFO_DESCRIPCION_LARGA  VARCHAR2(250 CHAR),
          VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
          USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
          FECHACREAR                TIMESTAMP(6)        NOT NULL,
          USUARIOMODIFICAR          VARCHAR2(10 CHAR),
          FECHAMODIFICAR            TIMESTAMP(6),
          USUARIOBORRAR             VARCHAR2(10 CHAR),
          FECHABORRAR               TIMESTAMP(6),
          BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
        )
        TABLESPACE BANK01
        PCTUSED    0
        PCTFREE    10
        INITRANS   1
        MAXTRANS   255
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   )
        LOGGING 
        NOCOMPRESS 
        NOCACHE
        NOPARALLEL
        MONITORING';
        EXECUTE IMMEDIATE V_SQL;
        
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TFO_TIPO_FONDO... Tabla creada');  

        V_SQL := '
        CREATE UNIQUE INDEX BANK01.PK_DD_TFO_TIPO_FONDO ON BANK01.DD_TFO_TIPO_FONDO
        (DD_TFO_ID)
        LOGGING
        TABLESPACE BANK01
        PCTFREE    10
        INITRANS   2
        MAXTRANS   255
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   )
        NOPARALLEL';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TFO_TIPO_FONDO... Índice creado');  


        V_SQL := '
        CREATE UNIQUE INDEX BANK01.UK_DD_TFO_TIPO_FONDO ON BANK01.DD_TFO_TIPO_FONDO
        (DD_TFO_CODIGO)
        LOGGING
        TABLESPACE BANK01
        PCTFREE    10
        INITRANS   2
        MAXTRANS   255
        STORAGE    (
                    INITIAL          64K
                    NEXT             1M
                    MINEXTENTS       1
                    MAXEXTENTS       UNLIMITED
                    PCTINCREASE      0
                    BUFFER_POOL      DEFAULT
                   )
        NOPARALLEL';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TFO_TIPO_FONDO... Índice creado');  

        V_SQL := '
          ALTER TABLE BANK01.DD_TFO_TIPO_FONDO ADD (
          CONSTRAINT PK_DD_TFO_TIPO_FONDO
          PRIMARY KEY
         (DD_TFO_ID)
            USING INDEX 
            TABLESPACE BANK01
            PCTFREE    10
            INITRANS   2
            MAXTRANS   255
            STORAGE    (
                        INITIAL          64K
                        NEXT             1M
                        MINEXTENTS       1
                        MAXEXTENTS       UNLIMITED
                        PCTINCREASE      0
                       ),
          CONSTRAINT UK_DD_TFO_TIPO_FONDO
         UNIQUE (DD_TFO_CODIGO)
            USING INDEX 
            TABLESPACE BANK01
            PCTFREE    10
            INITRANS   2
            MAXTRANS   255
            STORAGE    (
                        INITIAL          64K
                        NEXT             1M
                        MINEXTENTS       1
                        MAXEXTENTS       UNLIMITED
                        PCTINCREASE      0
                       ))';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TFO_TIPO_FONDO... PK creado');  
                       
        V_SQL := '                       
            GRANT ALTER, DELETE, INDEX, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, 
            QUERY REWRITE, DEBUG, FLASHBACK ON BANK01.DD_TFO_TIPO_FONDO TO BANKMASTER';
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TFO_TIPO_FONDO... Grants concedidos');              


    -- Comprobamos si existe la secuencia
       V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_TFO_TIPO_FONDO'' and sequence_owner = '''||V_ESQUEMA||'''';
       EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
       if V_NUM_TABLAS = 1 THEN                        
               V_SQL := 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_TFO_TIPO_FONDO';
               EXECUTE IMMEDIATE V_SQL;
               DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_TFO_TIPO_FONDO... Secuencia eliminada');    
       END IF; 

       V_SQL := '
        CREATE SEQUENCE BANK01.S_DD_TFO_TIPO_FONDO
          START WITH 1
          MAXVALUE 999999999999999999999999999
          MINVALUE 1
          NOCYCLE
          CACHE 20
          NOORDER';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TFO_TIPO_FONDO... Secuencia creada');  

        V_SQL := 'GRANT SELECT ON BANK01.S_DD_TFO_TIPO_FONDO TO BANKMASTER';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_DD_TFO_TIPO_FONDO... Grants');  



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