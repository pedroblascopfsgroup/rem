--/*
--##########################################
--## AUTOR=ENRIQUE JIMENEZ DIAZ
--## FECHA_CREACION=20151022
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-866
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de TABLAS DE DICCIONARIOS DE VENCIDOS Y PRODUCCION
--##                   
--##                               , esquema CM01. Con estructura correcta
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

 
 V_ESQUEMA VARCHAR2(25 CHAR):=   '#ESQUEMA#'; 			-- Configuracion Esquema
 V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; 		-- Configuracion Esquema Master 
 TABLA1 VARCHAR(30) :='VEN_VENCIDOS';
 TABLADD1 VARCHAR(30) :='DD_TVE_TIPO_VENCIDO';
 TABLADD2 VARCHAR(30) :='DD_MBD_MOTIVO_BAJA_DUDOSO';
 TABLADD3 VARCHAR(30) :='DD_MAD_MOTIVO_ALTA_DUDOSO';
 err_num NUMBER;
 err_msg VARCHAR2(2048); 
 V_MSQL1 VARCHAR2(8500 CHAR);
 V_EXISTE NUMBER (1):=null;



BEGIN 



  -- CREAMOS LA TABLA DE NEGOCIO 
  V_EXISTE:=0;
  
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLA1||'';


  V_MSQL1 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA1||' 
   (
        VEN_ID                      NUMBER(16)          NOT NULL, 
        VEN_FECHA_EXTRACCION        DATE                NOT NULL, 
        VEN_FECHA_CARGA             DATE                NOT NULL,
        CNT_ID                      NUMBER(16)          NOT NULL,
        DD_TVE_ID                   NUMBER(16)          NOT NULL, 
        DD_TVE_ANTERIOR             NUMBER(16)          ,
        DD_MAD_ID                   NUMBER(16)          , 
        DD_MBD_ID                   NUMBER(16)          ,        
        VEN_IMPORTE_INICIAL         NUMBER(14,2)        ,
        VEN_CAPITAL_VIVO            NUMBER(14,2)        ,
        VEN_IMPORTE_PTE_DIFER       NUMBER(14,2)        ,
        VEN_FECHA_BAJA_DUDOSO       DATE                ,
        VEN_FECHA_ALTA_DUDOSO       DATE                ,
        VEN_FECHA_CAMBIO_TRAMO      DATE                ,
        VEN_FECHA_IMPAGO            DATE                ,
        VEN_ARRASTRE                VARCHAR(1 CHAR)     ,
        VEN_CHAR_EXTRA1             VARCHAR(50 CHAR)   ,
        VEN_CHAR_EXTRA2             VARCHAR(50 CHAR)   ,
        VEN_FLAG_EXTRA1             VARCHAR(1 CHAR)   ,
        VEN_FLAG_EXTRA2             VARCHAR(1 CHAR)   ,
        VEN_DATE_EXTRA1             DATE                ,
        VEN_DATE_EXTRA2             DATE                ,
        VEN_DATE_EXTRA3             DATE                ,
        VEN_NUM_EXTRA1              NUMBER(14,2)        ,
        VEN_NUM_EXTRA2              NUMBER(14,2)        ,
        VEN_NUM_EXTRA3              NUMBER(14,2)        ,                                                                  
        FICHERO_CARGA               VARCHAR2(50 CHAR)   NOT NULL,                                        
        VERSION                     INTEGER             DEFAULT 0                     NOT NULL,
        USUARIOCREAR                VARCHAR2(25 CHAR)   NOT NULL,
        FECHACREAR                  DATE                DEFAULT SYSDATE               NOT NULL,
        BORRADO                     INTEGER             DEFAULT 0                     NOT NULL,
        USUARIOMODIFICAR            VARCHAR2(25 CHAR),
        FECHAMODIFICAR              DATE,
        USUARIOBORRAR               VARCHAR2(25 CHAR),
        FECHABORRAR                 DATE, 
        CONSTRAINT "UK_'||TABLA1||'" UNIQUE ("VEN_ID") 
   ) SEGMENT CREATION IMMEDIATE';


 IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE( TABLA1||' CREADA');
  ELSE
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA1||' CASCADE CONSTRAINTS');
     DBMS_OUTPUT.PUT_LINE( TABLA1||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE( TABLA1||' CREADA');
     
     -- EXECUTE IMMEDIATE ('ALTER TABLE '||TABLA1||' ADD CONSTRAINT FK_'||TABLADD1||' FOREIGN KEY (DD_TVE_ID)  REFERENCES '||V_ESQUEMA||'.'||TABLADD1||' (DD_TVE_ID) ENABLE');
     -- DBMS_OUTPUT.PUT_LINE( 'CONSTRAINT FK_'||TABLADD1||' CREADA EN TABLA '||TABLA1);  

     -- EXECUTE IMMEDIATE ('ALTER TABLE '||TABLA1||' ADD CONSTRAINT FK_'||TABLADD1||'2 FOREIGN KEY (DD_TVE_ANTERIOR)  REFERENCES '||V_ESQUEMA||'.'||TABLADD1||' (DD_TVE_ID) ENABLE');
     -- DBMS_OUTPUT.PUT_LINE( 'CONSTRAINT FK_'||TABLADD2||' CREADA EN TABLA '||TABLA1);          
  END IF;



  -- CREAMOS LA SECUENCIA DE LA TABLA DE NEGOCIO 
  V_EXISTE:=0;
  
  SELECT count(*) INTO V_EXISTE
  FROM all_sequences
  WHERE sequence_name = 'S_'||TABLA1 and sequence_owner=V_ESQUEMA;
    
  if V_EXISTE is not null and V_EXISTE = 1 then
     EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_'||TABLA1);
     DBMS_OUTPUT.PUT_LINE( 'S_'||TABLA1||' SECUENCIA CREADA');
  end if;

  EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_'||TABLA1||'
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');





  -- PRIMER DICCIONARIO DD_TVE_TIPO_VENCIDO  

  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLADD1||'';


  V_MSQL1 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLADD1||' 
   (
        DD_TVE_ID                   NUMBER(16)          NOT NULL, 
        DD_TVE_CODIGO               VARCHAR2(10 CHAR)   NOT NULL, 
        DD_TVE_DESCRIPCION          VARCHAR2(100 CHAR),
        DD_TVE_DESCRIPCION_LARGA    VARCHAR2(250 CHAR), 
        VERSION                     INTEGER             DEFAULT 0                     NOT NULL,
        USUARIOCREAR                VARCHAR2(25 CHAR)   NOT NULL,
        FECHACREAR                  DATE                DEFAULT SYSDATE               NOT NULL,
        BORRADO                     INTEGER             DEFAULT 0                     NOT NULL,
        USUARIOMODIFICAR            VARCHAR2(25 CHAR),
        FECHAMODIFICAR              DATE,
        USUARIOBORRAR               VARCHAR2(25 CHAR),
        FECHABORRAR                 DATE, 
        CONSTRAINT "UK_'||TABLADD1||'" UNIQUE ("DD_TVE_ID") 
   ) SEGMENT CREATION IMMEDIATE';


 IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE( TABLADD1||' CREADA');
     
     EXECUTE IMMEDIATE ('ALTER TABLE '||TABLA1||' ADD CONSTRAINT FK_'||TABLADD1||' FOREIGN KEY (DD_TVE_ID)  REFERENCES '||V_ESQUEMA||'.'||TABLADD1||' (DD_TVE_ID) ENABLE');
     DBMS_OUTPUT.PUT_LINE( 'CONSTRAINT FK_'||TABLADD1||' CREADA EN TABLA '||TABLA1);     

     EXECUTE IMMEDIATE ('ALTER TABLE '||TABLA1||' ADD CONSTRAINT FK_'||TABLADD1||'2 FOREIGN KEY (DD_TVE_ANTERIOR)  REFERENCES '||V_ESQUEMA||'.'||TABLADD1||' (DD_TVE_ID) ENABLE');
     DBMS_OUTPUT.PUT_LINE( 'CONSTRAINT FK_'||TABLADD1||'2 CREADA EN TABLA '||TABLA1);        
  ELSE
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLADD1||'');
     DBMS_OUTPUT.PUT_LINE( TABLADD1||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE( TABLADD1||' CREADA');
     
     EXECUTE IMMEDIATE ('ALTER TABLE '||TABLA1||' ADD CONSTRAINT FK_'||TABLADD1||' FOREIGN KEY (DD_TVE_ID)  REFERENCES '||V_ESQUEMA||'.'||TABLADD1||' (DD_TVE_ID) ENABLE');
     DBMS_OUTPUT.PUT_LINE( 'CONSTRAINT FK_'||TABLADD1||' CREADA EN TABLA '||TABLA1);     

     EXECUTE IMMEDIATE ('ALTER TABLE '||TABLA1||' ADD CONSTRAINT FK_'||TABLADD1||'2 FOREIGN KEY (DD_TVE_ANTERIOR)  REFERENCES '||V_ESQUEMA||'.'||TABLADD1||' (DD_TVE_ID) ENABLE');
     DBMS_OUTPUT.PUT_LINE( 'CONSTRAINT FK_'||TABLADD1||'2 CREADA EN TABLA '||TABLA1);     
  END IF;


  -- CREAMOS LA SECUENCIA DE LA TABLA DE DICCIONARIO 1 
  V_EXISTE:=0;
  
  SELECT count(*) INTO V_EXISTE
  FROM all_sequences
  WHERE sequence_name = 'S_'||TABLADD1 and sequence_owner=V_ESQUEMA;
    
  if V_EXISTE is not null and V_EXISTE = 1 then
     EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_'||TABLADD1);
     DBMS_OUTPUT.PUT_LINE( 'S_'||TABLADD1||' SECUENCIA CREADA');
  end if;

  EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_'||TABLADD1||'
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');



  -- SEGUNDO DICCIONARIO DD_MBD_MOTIVO_BAJA_DUDOSO

  V_EXISTE:=0;
  
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLADD2||'';

 
  V_MSQL1 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLADD2||' 
   (
        DD_MBD_ID                   NUMBER(16)          NOT NULL, 
        DD_MBD_CODIGO               VARCHAR2(10 CHAR)   NOT NULL, 
        DD_MBD_DESCRIPCION          VARCHAR2(50 CHAR),
        DD_MBD_DESCRIPCION_LARGA    VARCHAR2(100 CHAR), 
        VERSION                     INTEGER             DEFAULT 0                     NOT NULL,
        USUARIOCREAR                VARCHAR2(25 CHAR)   NOT NULL,
        FECHACREAR                  DATE                DEFAULT SYSDATE               NOT NULL,
        BORRADO                     INTEGER             DEFAULT 0                     NOT NULL,
        USUARIOMODIFICAR            VARCHAR2(25 CHAR),
        FECHAMODIFICAR              DATE,
        USUARIOBORRAR               VARCHAR2(25 CHAR),
        FECHABORRAR                 DATE, 
        CONSTRAINT "UK_'||TABLADD2||'" UNIQUE ("DD_MBD_ID") 
   ) SEGMENT CREATION IMMEDIATE';


 IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE( TABLADD2||' NO EXISTIA, CREADA TABLA');
     EXECUTE IMMEDIATE ('ALTER TABLE '||TABLA1||' ADD CONSTRAINT FK_'||TABLADD2||' FOREIGN KEY (DD_MBD_ID)  REFERENCES '||V_ESQUEMA||'.'||TABLADD2||' (DD_MBD_ID) ENABLE');
     DBMS_OUTPUT.PUT_LINE( 'CONSTRAINT FK_'||TABLADD2||' CREADA EN TABLA '||TABLA1);  
  ELSE
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLADD2||'');
     DBMS_OUTPUT.PUT_LINE( TABLADD2||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE( TABLADD2||' EXISTIA, BORRADA Y CREADA TABLA');
     EXECUTE IMMEDIATE ('ALTER TABLE '||TABLA1||' ADD CONSTRAINT FK_'||TABLADD2||' FOREIGN KEY (DD_MBD_ID)  REFERENCES '||V_ESQUEMA||'.'||TABLADD2||' (DD_MBD_ID) ENABLE');
     DBMS_OUTPUT.PUT_LINE( 'CONSTRAINT FK_'||TABLADD2||' CREADA EN TABLA '||TABLA1);  
  END IF;


  -- CREAMOS LA SECUENCIA DE LA TABLA DE DICCIONARIO 2 
  V_EXISTE:=0;
  
  SELECT count(*) INTO V_EXISTE
  FROM all_sequences
  WHERE sequence_name = 'S_'||TABLADD2 and sequence_owner=V_ESQUEMA;
    
  if V_EXISTE is not null and V_EXISTE = 1 then
     EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_'||TABLADD2);
     DBMS_OUTPUT.PUT_LINE( 'S_'||TABLADD2||' SECUENCIA CREADA');
  end if;

  EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_'||TABLADD2||'
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
      

  -- TERCER DICCIONARIO DD_MAD_MOTIVO_ALTA_DUDOSO

  V_EXISTE:=0;
  
  SELECT COUNT(*) INTO V_EXISTE
  FROM ALL_TABLES
  WHERE TABLE_NAME = ''||TABLADD3||'';

 
  V_MSQL1 := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLADD3||' 
   (
        DD_MAD_ID                   NUMBER(16)          NOT NULL, 
        DD_MAD_CODIGO               VARCHAR2(10 CHAR)   NOT NULL, 
        DD_MAD_DESCRIPCION          VARCHAR2(50 CHAR),
        DD_MAD_DESCRIPCION_LARGA    VARCHAR2(100 CHAR), 
        VERSION                     INTEGER             DEFAULT 0                     NOT NULL,
        USUARIOCREAR                VARCHAR2(25 CHAR)   NOT NULL,
        FECHACREAR                  DATE                DEFAULT SYSDATE               NOT NULL,
        BORRADO                     INTEGER             DEFAULT 0                     NOT NULL,
        USUARIOMODIFICAR            VARCHAR2(25 CHAR),
        FECHAMODIFICAR              DATE,
        USUARIOBORRAR               VARCHAR2(25 CHAR),
        FECHABORRAR                 DATE, 
        CONSTRAINT "UK_'||TABLADD3||'" UNIQUE ("DD_MAD_ID") 
   ) SEGMENT CREATION IMMEDIATE';


 IF V_EXISTE = 0 THEN
      EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE( TABLADD3||'NO EXISTIA, CREARA TABLA');
     EXECUTE IMMEDIATE ('ALTER TABLE '||TABLA1||' ADD CONSTRAINT FK_'||TABLADD3||' FOREIGN KEY (DD_MAD_ID)  REFERENCES '||V_ESQUEMA||'.'||TABLADD3||' (DD_MAD_ID) ENABLE');
     DBMS_OUTPUT.PUT_LINE( 'CONSTRAINT FK_'||TABLADD3||' CREADA EN TABLA '||TABLA1);      
  ELSE
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLADD3||'');
     EXECUTE IMMEDIATE V_MSQL1;
     DBMS_OUTPUT.PUT_LINE( TABLADD3||' EXISTIA, BORRADA Y CREADA TABLA');
     EXECUTE IMMEDIATE ('ALTER TABLE '||TABLA1||' ADD CONSTRAINT FK_'||TABLADD3||' FOREIGN KEY (DD_MAD_ID)  REFERENCES '||V_ESQUEMA||'.'||TABLADD3||' (DD_MAD_ID) ENABLE');
     DBMS_OUTPUT.PUT_LINE( 'CONSTRAINT FK_'||TABLADD3||' CREADA EN TABLA '||TABLA1);    
  END IF;


  -- CREAMOS LA SECUENCIA DE LA TABLA DE DICCIONARIO 3 
  V_EXISTE:=0;
  
  SELECT count(*) INTO V_EXISTE
  FROM all_sequences
  WHERE sequence_name = 'S_'||TABLADD3 and sequence_owner=V_ESQUEMA;
    
  if V_EXISTE is not null and V_EXISTE = 1 then
     EXECUTE IMMEDIATE('DROP SEQUENCE '|| V_ESQUEMA || '.S_'||TABLADD3);
     DBMS_OUTPUT.PUT_LINE( 'S_'||TABLADD3||' SECUENCIA CREADA');
  end if;

  EXECUTE IMMEDIATE('CREATE SEQUENCE '|| V_ESQUEMA || '.S_'||TABLADD3||'
      START WITH 1
      MAXVALUE 999999999999999999999999999
      MINVALUE 1
      NOCYCLE
      CACHE 20
      NOORDER');
      
      

 EXCEPTION

 WHEN OTHERS THEN
   err_num := SQLCODE;
   err_msg := SQLERRM;

   DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
   DBMS_OUTPUT.put_line(err_msg);

   ROLLBACK;
   RAISE;
 END;
  /
 EXIT;
