--/*
--##########################################
--## AUTOR=RAFAEL ARACIL LOPEZ
--## FECHA_CREACION=20151104
--## ARTEFACTO=
--## VERSION_ARTEFACTO=X.X.X_rcXX
--## INCIDENCIA_LINK=PROJECTKEY-ISSUENUMBER
--## PRODUCTO=
--## 
--## Finalidad: CREAR TABLAS GESTION HIPOTECARIA
--## INSTRUCCIONES:  LANZAR Y LISTO
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
     v_table_count number(38);


 BEGIN

   
DBMS_OUTPUT.PUT_LINE('[START]  tabla TMP_FICHEROS_FSR');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''TMP_FICHEROS_FSR'' and owner = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.TMP_FICHEROS_FSR 
       (
   FECHA_EXTRACCION DATE NOT NULL 
  ,FECHA_DATO DATE NOT NULL 
  ,CODIGO_PROPIETARIO NUMBER(6, 0) NOT NULL 
, CODIGO_ENTIDAD NUMBER(5, 0) NOT NULL 
, CODIGO_PERSONA NUMBER(17, 0) NOT NULL 
, TIPO_DOCUMENTO VARCHAR2(20 CHAR) NOT NULL 
, NIF_CIF_PASAP_NIE VARCHAR2(20 CHAR) NOT NULL 
, TIPO_ACTUACION VARCHAR2(2 CHAR) NOT NULL 
, DD_DESCRIPCION_ACTUACION VARCHAR2(45 CHAR) NOT NULL 
, FECHA_ALTA DATE  NOT NULL 
, MARCA_VIGENTE VARCHAR2(1 CHAR) )';


    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.TMP_FICHEROS_FSR.. Tabla creada OK');


  end if;
  
  
  

DBMS_OUTPUT.PUT_LINE('[START]  tabla TMP_FICHEROS_FSR_REJECTS');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''TMP_FICHEROS_FSR_REJECTS'' and owner = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.TMP_FICHEROS_FSR_REJECTS 
       (    "FECHA_EJECUCION" DATE, 
    "FICHERO" VARCHAR2(1024 BYTE), 
    "ROWREJECTED" VARCHAR2(1024 BYTE), 
    "ERRORCODE" VARCHAR2(255 BYTE), 
    "ERRORMESSAGE" VARCHAR2(255 BYTE)
  ,FECHA_EXTRACCION DATE NOT NULL 
  ,FECHA_DATO DATE NOT NULL 
  ,CODIGO_PROPIETARIO NUMBER(6, 0) NOT NULL 
, CODIGO_ENTIDAD NUMBER(5, 0) NOT NULL 
, CODIGO_PERSONA NUMBER(17, 0) NOT NULL 
, TIPO_DOCUMENTO VARCHAR2(20 CHAR) NOT NULL 
, NIF_CIF_PASAP_NIE VARCHAR2(20 CHAR) NOT NULL 
, TIPO_ACTUACION VARCHAR2(2 CHAR) NOT NULL 
, DD_DESCRIPCION_ACTUACION VARCHAR2(45 CHAR) NOT NULL 
, FECHA_ALTA DATE NOT NULL 
, MARCA_VIGENTE VARCHAR2(1 CHAR) 
   )';


    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.TMP_FICHEROS_FSR_REJECTS.. Tabla creada OK');


  end if;
  

 
 
 

DBMS_OUTPUT.PUT_LINE('[START]  tabla DD_TAF_TIPO_ACTUACION_FSR');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''DD_TAF_TIPO_ACTUACION_FSR'' and owner = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.DD_TAF_TIPO_ACTUACION_FSR 
       (    "DD_TAF_ID" NUMBER (16,0), 
    "DD_TAF_CODIGO" VARCHAR2 (10 CHAR), 
    "DD_TAF_DESCRIPCION" VARCHAR2(50 CHAR), 
    "DD_TAF_DESCRIPCION_LARGA" VARCHAR2(250 CHAR), 
    "DD_TAF_RESTRICTIVA" NUMBER(1),
    "VERSION" INTEGER DEFAULT 0 NOT NULL ENABLE, 
    "USUARIOCREAR" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
    "FECHACREAR" TIMESTAMP (6) NOT NULL ENABLE, 
    "USUARIOMODIFICAR" VARCHAR2(10 CHAR), 
    "FECHAMODIFICAR" TIMESTAMP (6), 
    "USUARIOBORRAR" VARCHAR2(10 CHAR), 
    "FECHABORRAR" TIMESTAMP (6), 
    "BORRADO" NUMBER(1) DEFAULT 0 NOT NULL ENABLE,
   CONSTRAINT "PK_DD_TAF_TIPO_ACTUACION_FSR" PRIMARY KEY ("DD_TAF_ID"),
     CONSTRAINT "DD_TAF_CODIGO_UK" UNIQUE ("DD_TAF_CODIGO")
   )';



    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.DD_TAF_TIPO_ACTUACION_FSR.. Tabla creada OK');


  end if;
  
  
  
  
DBMS_OUTPUT.PUT_LINE('[START]  tabla CLA_CLIENTES_ACTUACION_CURSO');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''CLA_CLIENTES_ACTUACION_CURSO'' and owner = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.CLA_CLIENTES_ACTUACION_CURSO 
       (    "CLA_ID" NUMBER (16,0), 
     "CLA_ACTUACION_EN_CURSO" NUMBER(1),
    "PER_ID" NUMBER (16,0) NOT NULL, 
    "VERSION" INTEGER DEFAULT 0 NOT NULL ENABLE, 
    "USUARIOCREAR" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
    "FECHACREAR" TIMESTAMP (6) NOT NULL ENABLE, 
    "USUARIOMODIFICAR" VARCHAR2(10 CHAR), 
    "FECHAMODIFICAR" TIMESTAMP (6), 
    "USUARIOBORRAR" VARCHAR2(10 CHAR), 
    "FECHABORRAR" TIMESTAMP (6), 
    "BORRADO" NUMBER(1) DEFAULT 0 NOT NULL ENABLE, 
  CONSTRAINT PK_CLIENTE_ACTUACION_CURSO PRIMARY KEY (CLA_ID),
       CONSTRAINT "FK_CLA_FK_PER_ID" FOREIGN KEY ("PER_ID")
      REFERENCES '|| V_ESQUEMA ||'."PER_PERSONAS" ("PER_ID") ENABLE
  )';





    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.CLA_CLIENTES_ACTUACION_CURSO.. Tabla creada OK');


  end if;
  

 DBMS_OUTPUT.PUT_LINE('[START]  tabla CAC_CONTRATOS_ACTUACION_CURSO');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''CAC_CONTRATOS_ACTUACION_CURSO'' and owner = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.CAC_CONTRATOS_ACTUACION_CURSO 
       ("CAC_ID" NUMBER (16,0),    
       "CNT_ID" NUMBER (16,0) NOT NULL, 
    "PER_ID" NUMBER (16,0) NOT NULL, 
    "CAC_ACTUACION_EN_CURSO" NUMBER(1) ,
    "VERSION" INTEGER DEFAULT 0 NOT NULL ENABLE, 
    "USUARIOCREAR" VARCHAR2(10 CHAR) NOT NULL ENABLE, 
    "FECHACREAR" TIMESTAMP (6) NOT NULL ENABLE, 
    "USUARIOMODIFICAR" VARCHAR2(10 CHAR), 
    "FECHAMODIFICAR" TIMESTAMP (6), 
    "USUARIOBORRAR" VARCHAR2(10 CHAR), 
    "FECHABORRAR" TIMESTAMP (6), 
    "BORRADO" NUMBER(1) DEFAULT 0 NOT NULL ENABLE, 
    CONSTRAINT PK_CONTRATO_ACTUACION_CURSO PRIMARY KEY (CAC_ID),
    CONSTRAINT "FK_CAC_FK_PER_ID" FOREIGN KEY ("PER_ID")
      REFERENCES '|| V_ESQUEMA ||'."PER_PERSONAS" ("PER_ID") ENABLE,
    CONSTRAINT "FK_CAC_FK_CNT_ID" FOREIGN KEY ("CNT_ID")
      REFERENCES '|| V_ESQUEMA ||'."CNT_CONTRATOS" ("CNT_ID") ENABLE,
    CONSTRAINT "DD_CAC_CNT_ID_UK" UNIQUE ("CNT_ID")


  )';






    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.CAC_CONTRATOS_ACTUACION_CURSO.. Tabla creada OK');


  end if;
  

  
  EXECUTE IMMEDIATE 'select count(1) from ALL_SEQUENCES where SEQUENCE_NAME = ''S_DD_TAF_TIPO_ACTUACION_FSR'' and SEQUENCE_OWNER = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then

EXECUTE IMMEDIATE 'CREATE SEQUENCE S_DD_TAF_TIPO_ACTUACION_FSR
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999999999999';
END IF;


  EXECUTE IMMEDIATE 'select count(1) from ALL_SEQUENCES where SEQUENCE_NAME = ''S_CLA_CLIENTES_ACTUACION_CURSO'' and SEQUENCE_OWNER = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE SEQUENCE S_CLA_CLIENTES_ACTUACION_CURSO
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999999999999';
END IF;


  EXECUTE IMMEDIATE 'select count(1) from ALL_SEQUENCES where SEQUENCE_NAME = ''S_CAC_CNT_ACTUACION_CURSO'' and SEQUENCE_OWNER = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE SEQUENCE S_CAC_CNT_ACTUACION_CURSO
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999999999999';
END IF;

  

 
 
 
 

  DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO DE CREACION');


 EXCEPTION



    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END;
/

EXIT;

