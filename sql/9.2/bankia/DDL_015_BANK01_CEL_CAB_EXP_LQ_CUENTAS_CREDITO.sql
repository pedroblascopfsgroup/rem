/*
--##########################################
--## AUTOR=Alejandro I�igo
--## FECHA_CREACION=20160118
--## ARTEFACTO=ETL
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=BKREC-706
--## PRODUCTO=NO
--##########################################
--*/




WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); /* Sentencia a ejecutar    */
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; /* Configuracion Esquema*/
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; /* Configuracion Esquema Master*/
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; /* Configuracion Indice*/
    V_SQL VARCHAR2(4000 CHAR); /* Vble. para consulta que valida la existencia de una tabla.*/
    V_NUM_TABLAS NUMBER(16); /* Vble. para validar la existencia de una tabla.  */
    ERR_NUM NUMBER(25);  /* Vble. auxiliar para registrar errores en el script.*/
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.*/

    V_TEXT1 VARCHAR2(2400 CHAR); /* Vble. auxiliar*/
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; /* Configuracion Esquema minirec*/
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; /* Configuracion Esquema recovery_bankia_dwh*/
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; /* Configuracion Esquema recovery_bankia_datastage*/
	
BEGIN


    /*  tabla CEL_CAB_EXP_LQ_CUENTAS_CREDITO <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla CEL_CAB_EXP_LQ_CUENTAS_CREDITO');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'CEL_CAB_EXP_LQ_CUENTAS_CREDITO';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO... Tabla borrada OK');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO
      (
	    CEL_PCO_LIQ_ID      NUMBER(16)   ,
		CEL_XCOEMP          VARCHAR2(5 CHAR) ,
		CEL_COPSER          VARCHAR2(5 CHAR) ,
		CEL_IDPRIG          VARCHAR2(17 CHAR) ,
		CEL_IDCOEC          VARCHAR2(15 CHAR) ,
		CEL_FEVACM          DATE,        
		CEL_FEPEAU          DATE,        
		CEL_FFVPMA          DATE,        
		CEL_CLLIQ1          VARCHAR2(1 CHAR) ,
		CEL_CDIGMO          VARCHAR2(1 CHAR) ,
		CEL_FILLR1          VARCHAR2(32 CHAR) ,
	    CEL_COTREG          NUMBER(3),            
		CEL_COEXPD          NUMBER(15),            
		CEL_NUSECT          NUMBER(9),           
		CEL_CATORG          NUMBER(9),           
		CEL_FILLR2          VARCHAR2(8 CHAR) ,
		CEL_NOMBRE          VARCHAR2(40 CHAR) ,
		CEL_NUCTOP          NUMBER(15),
		CEL_IMLIAC          NUMBER(15),
		CEL_NCTAOP          VARCHAR2(23 CHAR) ,
		CEL_FILLR3          VARCHAR2(463 CHAR) ,
        USUARIOCREAR        VARCHAR2(50 CHAR) not null,
        FECHACREAR          TIMESTAMP(6) not null,
        USUARIOMODIFICAR    VARCHAR2(50 CHAR),
        FECHAMODIFICAR      TIMESTAMP(6),		
		VERSION             INTEGER DEFAULT 0  NOT NULL,
		USUARIOBORRAR       VARCHAR2(50 CHAR)         ,
		FECHABORRAR         TIMESTAMP(6)         ,
		BORRADO             NUMBER(1) DEFAULT 0  NOT NULL  ) ' ; 
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CEL_CAB_EXP_LQ_CUENTAS_CREDITO... Tabla creada');		
		
		EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '.IDX_CEL_PCO_LIQ_ID ON ' || V_ESQUEMA || '.CEL_CAB_EXP_LQ_CUENTAS_CREDITO (CEL_PCO_LIQ_ID) ' ||
		'  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 ' ||
  		'  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE ' || V_TS_INDEX;
  		
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CEL_PCO_LIQ_ID... Indice creado');		
		
		
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_XCOEMP        is ''CODIGO DE EMPRESA               '' ' ;                                
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_COPSER        is ''CLASE DE PRODUCTO               '' ' ;  
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_IDPRIG        is ''IDENTIFICADOR DE PRODUCTO O SE  '' ' ;  
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_IDCOEC        is ''IDENTIFICADOR COND. ESPE. CONT  '' ' ;  
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_FEVACM        is ''FECHA VALOR CONTABLE DEL MOVIM  '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_FEPEAU        is ''FECHA DE LA PETICION            '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_FFVPMA        is ''VENCIMIENTO PENDIENTE MAS ANTI  '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_CLLIQ1        is ''TIPO DE LIQUIDACION             '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_CDIGMO        is ''DIGITO DE CONTROL DE MONEDA     '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_FILLR1        is ''                                '' ' ;				
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_COTREG        is ''CODIGO TIPO DE REGISTRO       '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_COEXPD        is ''CODIGO DE EXPEDIENTE          '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_NUSECT        is ''NUMERO SECUENCIAL             '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_CATORG        is ''CANTIDAD TOTAL DE REGISTROS   '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_FILLR2        is ''FILLER 2                      '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_NOMBRE        is ''NOMBRE Y APELLIDOS            '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_NUCTOP        is ''NUMERO DE CUENTA OPERATIVA    '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_IMLIAC        is ''IMPORTE LIMITE ACTUAL DEL CRED'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_NCTAOP        is ''Numero de cuenta operactiva   '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO.CEL_FILLR3        is ''FILLER 3                      '' ' ;
		

DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.CEL_CAB_EXP_LQ_CUENTAS_CREDITO... Tabla CREADA OK');
    
DBMS_OUTPUT.PUT_LINE('[END] Tabla CEL_CAB_EXP_LQ_CUENTAS_CREDITO');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		
