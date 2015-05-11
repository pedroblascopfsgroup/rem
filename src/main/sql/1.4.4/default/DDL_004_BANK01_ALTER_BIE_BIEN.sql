--/*
--##########################################
--## Author: Recovery
--## Adaptado a BP : Sergio H.
--## Finalidad: DDL DD_SPO_SITUACION_POSESORIA
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
    V_COLUMN_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.       
BEGIN   

    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_SPO_SITUACION_POSESORIA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN    
       V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_SPO_SITUACION_POSESORIA 
                  DROP PRIMARY KEY CASCADE';            
       EXECUTE IMMEDIATE V_SQL;  
       DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SPO_SITUACION_POSESORIA... Claves primarias eliminadas');    
    END IF;


   -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_SPO_SITUACION_POSESORIA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
       V_SQL := 'DROP TABLE '||V_ESQUEMA||'.DD_SPO_SITUACION_POSESORIA CASCADE CONSTRAINTS';
       EXECUTE IMMEDIATE V_SQL;
       DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SPO_SITUACION_POSESORIA... Tabla borrada');  
    END IF;


    V_SQL := '
        CREATE TABLE '||V_ESQUEMA||'.DD_SPO_SITUACION_POSESORIA
        (
          DD_SPO_ID                 NUMBER(16)          NOT NULL,
          DD_SPO_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
          DD_SPO_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
          DD_SPO_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
          VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
          USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
          FECHACREAR                TIMESTAMP(6)        NOT NULL,
          USUARIOMODIFICAR          VARCHAR2(10 CHAR),
          FECHAMODIFICAR            TIMESTAMP(6),
          USUARIOBORRAR             VARCHAR2(10 CHAR),
          FECHABORRAR               TIMESTAMP(6),
          BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
        )
        TABLESPACE '||V_ESQUEMA||'
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
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SPO_SITUACION_POSESORIA... Índice creado');  


        V_SQL := '
        CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_DD_SPO_SITUACION_POSESORIA ON '||V_ESQUEMA||'.DD_SPO_SITUACION_POSESORIA
        (DD_SPO_ID)
        LOGGING
        TABLESPACE '||V_ESQUEMA||'
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
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_SPO_SITUACION_POSESORIA... Índice creado');  
        

        V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_SPO_SITUACION_POSESORIA ADD (
          CONSTRAINT PK_DD_SPO_SITUACION_POSESORIA
         PRIMARY KEY
         (DD_SPO_ID)
            USING INDEX 
            TABLESPACE '||V_ESQUEMA||'
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
               




    --Comprobamos si existen PK de esa tabla
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''DD_TRA_TASADORA'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la PK
    IF V_NUM_TABLAS = 1 THEN    
       V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_TRA_TASADORA 
                  DROP PRIMARY KEY CASCADE';            
       EXECUTE IMMEDIATE V_SQL;  
       DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TRA_TASADORA... Claves primarias eliminadas');    
    END IF;


   -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_TRA_TASADORA'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
       V_SQL := 'DROP TABLE '||V_ESQUEMA||'.DD_TRA_TASADORA CASCADE CONSTRAINTS';
       EXECUTE IMMEDIATE V_SQL;
       DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TRA_TASADORA... Tabla borrada');  
    END IF;


    V_SQL := '
        CREATE TABLE '||V_ESQUEMA||'.DD_TRA_TASADORA
        (
          DD_TRA_ID                 NUMBER(16)          NOT NULL,
          DD_TRA_CODIGO             VARCHAR2(10 CHAR)   NOT NULL,
          DD_TRA_DESCRIPCION        VARCHAR2(50 CHAR)   NOT NULL,
          DD_TRA_DESCRIPCION_LARGA  VARCHAR2(200 CHAR)  NOT NULL,
          VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
          USUARIOCREAR              VARCHAR2(10 CHAR)   NOT NULL,
          FECHACREAR                TIMESTAMP(6)        NOT NULL,
          USUARIOMODIFICAR          VARCHAR2(10 CHAR),
          FECHAMODIFICAR            TIMESTAMP(6),
          USUARIOBORRAR             VARCHAR2(10 CHAR),
          FECHABORRAR               TIMESTAMP(6),
          BORRADO                   NUMBER(1)           DEFAULT 0                     NOT NULL
        )
        TABLESPACE '||V_ESQUEMA||'
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
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TRA_TASADORA... Tabla creada');  

        V_SQL := '
        CREATE UNIQUE INDEX '||V_ESQUEMA||'.PK_DD_TRA_TASADORA ON '||V_ESQUEMA||'.DD_TRA_TASADORA
        (DD_TRA_ID)
        LOGGING
        TABLESPACE '||V_ESQUEMA||'
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
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TRA_TASADORA... Índice creado');          

        V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_TRA_TASADORA ADD (
          CONSTRAINT PK_DD_TRA_TASADORA
         PRIMARY KEY
         (DD_TRA_ID)
            USING INDEX 
            TABLESPACE '||V_ESQUEMA||'
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
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_TRA_TASADORA... PK creado');          
               

    -- Añadir columnas a BIE_BIEN
    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE LOWER(table_name) = 'bie_bien' and LOWER(column_name) = 'dd_spo_id';
    if v_column_count = 0 then
        V_SQL := '
        ALTER TABLE BIE_BIEN ADD (

            DD_SPO_ID NUMBER(16),
            BIE_VIVIENDA_HABITUAL NUMBER(1),
            BIE_NUMERO_ACTIVO  VARCHAR2(50),
            BIE_LICENCIA_PRI_OCUPACION VARCHAR2(50),
            BIE_PRIMERA_TRANSMISION VARCHAR2(50),
            BIE_CONTRATO_ALQUILER VARCHAR2(150)
                   )';
            EXECUTE IMMEDIATE V_SQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... Columnas añadidas');           
    else
                DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_BIEN... Ya existen las columnas');     
    end if;

    -- Eliminamos FK FK_BIE_SPO
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''BIE_BIEN'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''R''
    and CONSTRAINT_NAME = ''FK_BIE_SPO''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;


    IF V_NUM_TABLAS = 1 THEN    
      V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN 
                  DROP CONSTRAINT FK_BIE_SPO';            
         EXECUTE IMMEDIATE V_SQL;  
         DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... Claves externa eliminada');    
    END IF;
    
    V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_BIEN ADD (
         CONSTRAINT FK_BIE_SPO 
         FOREIGN KEY (DD_SPO_ID) 
         REFERENCES '||V_ESQUEMA||'.DD_SPO_SITUACION_POSESORIA (DD_SPO_ID)
         )';
    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;  
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... Claves externa creada');    
 




    -- Añadir columnas a BIE_VALORACIONES
    SELECT COUNT(1) INTO v_column_count FROM user_tab_cols WHERE LOWER(table_name) = 'bie_valoraciones' and LOWER(column_name) = 'bie_respuesta_consulta';
    if v_column_count = 0 then
        V_SQL := '
        ALTER TABLE BIE_VALORACIONES ADD (


            BIE_RESPUESTA_CONSULTA VARCHAR2(250),
            BIE_VALOR_TASACION_EXT  NUMBER(16,2),
            BIE_F_TAS_EXTERNA       DATE,
            DD_TRA_ID NUMBER(16),
            BIE_F_SOL_TASACION DATE

        )'; 
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_VALORACIONES... Columnas añadidas');           
    else
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_VALORACIONES... Ya existen las columnas');     
    end if;


    -- Eliminamos FK FK_BIE_VAL_TRA
    V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = ''BIE_VALORACIONES'' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''R''
    and CONSTRAINT_NAME = ''FK_BIE_VAL_TRA''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;


    IF V_NUM_TABLAS = 1 THEN    
      V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.BIE_VALORACIONES 
                  DROP CONSTRAINT FK_BIE_VAL_TRA';            
         EXECUTE IMMEDIATE V_SQL;  
         DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_BIEN... Claves externa eliminada');    
    END IF;
    
    V_SQL := '
        ALTER TABLE '||V_ESQUEMA||'.BIE_VALORACIONES ADD (
         CONSTRAINT FK_BIE_VAL_TRA
         FOREIGN KEY (DD_TRA_ID) 
         REFERENCES '||V_ESQUEMA||'.DD_TRA_TASADORA (DD_TRA_ID)
         )';
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.BIE_VALORACIONES... FK añadida');           
 
 
 
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