--/*
--##########################################
--## Author: DGG
--## Finalidad: DDL que añade nuevos cambos al asunto , codigo externo y los dos diccionarios propiedad y gestion
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 

BEGIN

SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_cols  
         WHERE UPPER(table_name) = 'ASU_ASUNTOS' and (UPPER(column_name) = 'DD_PAS_ID') 
         AND OWNER = 'BANK01'; 
          
     if V_NUM_TABLAS = 0 then 
	 
EXECUTE IMMEDIATE 'CREATE SEQUENCE BANK01.S_DD_PAS_PROPIEDAD_ASUNTO'; 	 
	 
EXECUTE IMMEDIATE 'CREATE TABLE BANK01.DD_PAS_PROPIEDAD_ASUNTO
(
  DD_PAS_ID                 NUMBER(16)          NOT NULL,
  DD_PAS_CODIGO             VARCHAR2(50 BYTE)   NOT NULL,
  DD_PAS_DESCRIPCION        VARCHAR2(100 BYTE)  NOT NULL,
  DD_PAS_DESCRIPCION_LARGA  VARCHAR2(250 BYTE),
  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
  USUARIOCREAR              VARCHAR2(10 BYTE)   NOT NULL,
  FECHACREAR                TIMESTAMP(6)        NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 BYTE),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 BYTE),
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


EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX BANK01.PK_DD_PAS_PROPIEDAD_ASUNTO ON BANK01.DD_PAS_PROPIEDAD_ASUNTO
(DD_PAS_ID)
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


EXECUTE IMMEDIATE 'ALTER TABLE BANK01.DD_PAS_PROPIEDAD_ASUNTO ADD (
  CONSTRAINT PK_DD_PAS_PROPIEDAD_ASUNTO
 PRIMARY KEY
 (DD_PAS_ID)
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
			   
EXECUTE IMMEDIATE 'CREATE SEQUENCE BANK01.S_DD_GES_GESTION_ASUNTO'; 

EXECUTE IMMEDIATE 'CREATE TABLE BANK01.DD_GES_GESTION_ASUNTO
(
  DD_GES_ID                 NUMBER(16)          NOT NULL,
  DD_GES_CODIGO             VARCHAR2(50 BYTE)   NOT NULL,
  DD_GES_DESCRIPCION        VARCHAR2(100 BYTE)  NOT NULL,
  DD_GES_DESCRIPCION_LARGA  VARCHAR2(250 BYTE),
  VERSION                   INTEGER             DEFAULT 0                     NOT NULL,
  USUARIOCREAR              VARCHAR2(10 BYTE)   NOT NULL,
  FECHACREAR                TIMESTAMP(6)        NOT NULL,
  USUARIOMODIFICAR          VARCHAR2(10 BYTE),
  FECHAMODIFICAR            TIMESTAMP(6),
  USUARIOBORRAR             VARCHAR2(10 BYTE),
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


EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX BANK01.PK_DD_GES_GESTION_ASUNTO ON BANK01.DD_GES_GESTION_ASUNTO
(DD_GES_ID)
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


EXECUTE IMMEDIATE 'ALTER TABLE BANK01.DD_GES_GESTION_ASUNTO ADD (
  CONSTRAINT PK_DD_GES_GESTION_ASUNTO
 PRIMARY KEY
 (DD_GES_ID)
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
end if; 
			   
DBMS_OUTPUT.PUT_LINE('[INFO] CREADOS DICCIONARIOS DD_PAS_PROPIEDAD_ASUNTO y DD_GES_GESTION_ASUNTO'); 			   
			   

SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_cols  
         WHERE UPPER(table_name) = 'ASU_ASUNTOS' and (UPPER(column_name) = 'ASU_ID_EXTERNO') 
         AND OWNER = 'BANK01'; 
          
     if V_NUM_TABLAS = 0 then  
        EXECUTE IMMEDIATE 'ALTER TABLE BANK01.ASU_ASUNTOS  
                              ADD (ASU_ID_EXTERNO VARCHAR2(50)) ' ; 
        EXECUTE IMMEDIATE 'comment on column BANK01.ASU_ASUNTOS.ASU_ID_EXTERNO is ''Identificacion Asunto original (migracion BANKIA FASE2)'''; 
        DBMS_OUTPUT.PUT_LINE('[INFO] ASU_ASUNTOS... Modificada - Anyadida columna ASU_ID_EXTERNO ');                    
    end if; 
	
	
	
SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_cols  
         WHERE UPPER(table_name) = 'ASU_ASUNTOS' and (UPPER(column_name) = 'DD_PAS_ID') 
         AND OWNER = 'BANK01'; 
          
     if V_NUM_TABLAS = 0 then 
	 
	EXECUTE IMMEDIATE 'ALTER TABLE
   BANK01.ASU_ASUNTOS
ADD
   DD_PAS_ID NUMBER(16)';
   
   EXECUTE IMMEDIATE 'ALTER TABLE BANK01.ASU_ASUNTOS ADD CONSTRAINT FK_ASU_PAS_ID
      FOREIGN KEY (DD_PAS_ID) REFERENCES BANK01.DD_PAS_PROPIEDAD_ASUNTO (DD_PAS_ID)';
   
   	EXECUTE IMMEDIATE 'ALTER TABLE
   BANK01.ASU_ASUNTOS
ADD
   DD_GES_ID NUMBER(16)';
   
   EXECUTE IMMEDIATE 'ALTER TABLE BANK01.ASU_ASUNTOS ADD CONSTRAINT FK_ASU_GES_ID
      FOREIGN KEY (DD_GES_ID) REFERENCES BANK01.DD_GES_GESTION_ASUNTO (DD_GES_ID)';
   
   DBMS_OUTPUT.PUT_LINE('[INFO] ASU_ASUNTOS... Modificada - Anyadida columna DD_PAS_ID y DD_GES_ID '); 
   
   end if; 



	
	
COMMIT;


EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT	