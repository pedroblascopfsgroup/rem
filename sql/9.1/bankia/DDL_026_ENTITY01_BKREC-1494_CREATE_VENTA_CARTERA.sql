--/*
--##########################################
--## AUTOR=RAFAEL ARACIL LOPEZ  
--## FECHA_CREACION=20151125
--## ARTEFACTO=proc_venta_cartera
--## VERSION_ARTEFACTO=9.1.17-bk
--## INCIDENCIA_LINK=BKREC-1494
--## PRODUCTO=SI
--## 
--## Finalidad: CREAR TABLAS FINALIZACION PROCEDIMIENTOS VENTA CARTERA
--## INSTRUCCIONES:  LANZAR Y LISTO
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion BANK01
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion BANK01 Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);
     v_table_count number(38);


 BEGIN

   
DBMS_OUTPUT.PUT_LINE('[START]  tabla TMP_CONTRATOS_VENTA');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''TMP_CONTRATOS_VENTA'' and owner = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.TMP_CONTRATOS_VENTA 
       (
   TEXTO_VENTA VARCHAR2(20 CHAR) NOT NULL 
  ,CODIGO_PROPIETARIO NUMBER(6, 0) NOT NULL 
, TIPO_PRODUCTO VARCHAR2(5 CHAR) NOT NULL 
, NUMERO_CONTRATO NUMBER(17, 0) NOT NULL 
, NUMERO_ESPEC NUMBER(15, 0) NOT NULL 
)';


    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.TMP_CONTRATOS_VENTA.. Tabla creada OK');


  end if;
  
  
  
  
  
DBMS_OUTPUT.PUT_LINE('[START]  tabla TMP_CONTRATOS_VENTA_RECHAZOS');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''TMP_CONTRATOS_VENTA_RECHAZOS'' and owner = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.TMP_CONTRATOS_VENTA_RECHAZOS 
       (
   "FECHA_EJECUCION" DATE, 
    "FICHERO" VARCHAR2(1024 BYTE), 
    "ROWREJECTED" VARCHAR2(1024 BYTE), 
    "ERRORCODE" VARCHAR2(255 BYTE), 
   TEXTO_VENTA VARCHAR2(20 CHAR) NOT NULL 
  ,CODIGO_PROPIETARIO NUMBER(6, 0) NOT NULL 
, TIPO_PRODUCTO VARCHAR2(5 CHAR) NOT NULL 
, NUMERO_CONTRATO NUMBER(17, 0) NOT NULL 
, NUMERO_ESPEC NUMBER(15, 0) NOT NULL 

)';


    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.TMP_CONTRATOS_VENTA_RECHAZOS.. Tabla creada OK');


  end if;
  
  
  
 
 
 

DBMS_OUTPUT.PUT_LINE('[START]  tabla FIN_AUX_CNT_PRC_VIVOS');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''FIN_AUX_CNT_PRC_VIVOS'' and owner = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.FIN_AUX_CNT_PRC_VIVOS 
       (    
    "ASU_ID" NUMBER (16,0), 
    "PRC_ID" NUMBER (16,0), 
    "CNT_ID" NUMBER (16,0)
   )';



    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.FIN_AUX_CNT_PRC_VIVOS.. Tabla creada OK');


  end if;
  
  
  
DBMS_OUTPUT.PUT_LINE('[START]  tabla FIN_AUX_CONTRATOS_VENTA');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''FIN_AUX_CONTRATOS_VENTA'' and owner = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.FIN_AUX_CONTRATOS_VENTA 
       (        "CNT_ID" NUMBER (16,0)
  )';



    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.FIN_AUX_CONTRATOS_VENTA.. Tabla creada OK');


  end if;


   

DBMS_OUTPUT.PUT_LINE('[START]  tabla FIN_AUX_PRC_CERRAR_INICIAL');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''FIN_AUX_PRC_CERRAR_INICIAL'' and owner = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.FIN_AUX_PRC_CERRAR_INICIAL 
       (    
    "ASU_ID" NUMBER (16,0), 
    "PRC_ID" NUMBER (16,0),
        "CNT_ID" NUMBER (16,0)

   )';



    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.FIN_AUX_PRC_CERRAR_INICIAL.. Tabla creada OK');


  end if;
  
  
  

DBMS_OUTPUT.PUT_LINE('[START]  tabla FIN_AUX_PRC_CERRAR_FINAL');

EXECUTE IMMEDIATE 'select count(1) from all_tables where table_name = ''FIN_AUX_PRC_CERRAR_FINAL'' and owner = ''' || V_ESQUEMA || '''' into v_table_count;
if v_table_count = 0 then
EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.FIN_AUX_PRC_CERRAR_FINAL 
       (    
    "ASU_ID" NUMBER (16,0), 
    "PRC_ID" NUMBER (16,0)
    )';



    DBMS_OUTPUT.PUT_LINE('CREATE TABLE '|| V_ESQUEMA ||'.FIN_AUX_PRC_CERRAR_FINAL.. Tabla creada OK');


  end if;
  

 
 
 

  DBMS_OUTPUT.PUT_LINE( 'FIN DEL PROCESO DE CREACION');

/*
 EXCEPTION



    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
*/
END;
/

EXIT;

