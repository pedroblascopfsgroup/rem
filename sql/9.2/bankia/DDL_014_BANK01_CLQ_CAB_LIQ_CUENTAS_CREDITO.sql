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


    /*  tabla CLQ_CAB_LIQ_CUENTAS_CREDITO <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla CLQ_CAB_LIQ_CUENTAS_CREDITO');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'CLQ_CAB_LIQ_CUENTAS_CREDITO';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO... Tabla borrada OK');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO
      (
	    CLQ_PCO_LIQ_ID      NUMBER(16)   ,   
		CLQ_XCOEMP          VARCHAR2(5 CHAR) ,
		CLQ_COPSER          VARCHAR2(5 CHAR) ,
		CLQ_IDPRIG          VARCHAR2(17 CHAR) ,
		CLQ_IDCOEC          VARCHAR2(15 CHAR) ,
		CLQ_FEVACM          DATE,        
		CLQ_FEPEAU          DATE,        
		CLQ_FFVPMA          DATE,        
		CLQ_CLLIQ1          VARCHAR2(1 CHAR) , 
		CLQ_CDIGMO          VARCHAR2(1 CHAR) , 
		CLQ_FILLR1          VARCHAR2(32 CHAR) ,
	    CLQ_COTREG          NUMBER(3),            
		CLQ_COEXPD          NUMBER(15),            
		CLQ_NUSECT          NUMBER(9),           
		CLQ_CATORG          NUMBER(9),           
		CLQ_FILLR2          VARCHAR2(8 CHAR) ,
		CLQ_NUIDLQ          NUMBER(5),                 
		CLQ_CDTILQ          VARCHAR2(3 CHAR) ,
		CLQ_CDSILQ          VARCHAR2(1 CHAR) ,
		CLQ_FANTLQ          DATE,
		CLQ_FEVALQ          DATE,
		CLQ_FPROLQ          DATE,                 
		CLQ_COASLQ          VARCHAR2(1 CHAR) ,
		CLQ_FEFCON          DATE,
		CLQ_POINDB          NUMBER(7,5),         
		CLQ_IMLIAC          NUMBER(15),          
		CLQ_CDMOIM          NUMBER(5),
		CLQ_NUCTOP          NUMBER(15),
		CLQ_NCTAOP          VARCHAR2(23 CHAR)  ,
		CLQ_MONEDA          VARCHAR2(27 CHAR)  ,
		CLQ_DESLIQ			VARCHAR2(20 CHAR)  ,
		CLQ_FILLR3		    VARCHAR2(402 CHAR) ,
        USUARIOCREAR        VARCHAR2(50 CHAR) not null,
        FECHACREAR          TIMESTAMP(6) not null,
        USUARIOMODIFICAR    VARCHAR2(50 CHAR),
        FECHAMODIFICAR      TIMESTAMP(6),		
		VERSION             INTEGER DEFAULT 0  NOT NULL,
		USUARIOBORRAR       VARCHAR2(50 CHAR)         ,
		FECHABORRAR         TIMESTAMP(6)         ,
		BORRADO             NUMBER(1) DEFAULT 0  NOT NULL  ) ' ; 
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CLQ_CAB_LIQ_CUENTAS_CREDITO... Tabla creada');				
		
		EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '.IDX_CLQ_PCO_LIQ_ID ON ' || V_ESQUEMA || '.CLQ_CAB_LIQ_CUENTAS_CREDITO (CLQ_PCO_LIQ_ID) ' ||
		'  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 ' ||
  		'  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE ' || V_TS_INDEX;
  		
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CLQ_PCO_LIQ_ID... Indice creado');		
		
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_XCOEMP        is ''CODIGO DE EMPRESA               '' ' ;                                
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_COPSER        is ''CLASE DE PRODUCTO               '' ' ;  
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_IDPRIG        is ''IDENTIFICADOR DE PRODUCTO O SE  '' ' ;  
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_IDCOEC        is ''IDENTIFICADOR COND. ESPE. CONT  '' ' ;  
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_FEVACM        is ''FECHA VALOR CONTABLE DEL MOVIM  '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_FEPEAU        is ''FECHA DE LA PETICION            '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_FFVPMA        is ''VENCIMIENTO PENDIENTE MAS ANTI  '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_CLLIQ1        is ''TIPO DE LIQUIDACION             '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_CDIGMO        is ''DIGITO DE CONTROL DE MONEDA     '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_FILLR1        is ''                                '' ' ;		
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_COTREG        is ''CODIGO TIPO DE REGISTRO       '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_COEXPD        is ''CODIGO DE EXPEDIENTE          '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_NUSECT        is ''NUMERO SECUENCIAL             '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_CATORG        is ''CANTIDAD TOTAL DE REGISTROS   '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_FILLR2        is ''FILLER2                       '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_NUIDLQ        is ''NUMERO DE LIQUIDACION DEL EXPE'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_CDTILQ        is ''CODIGO TIPO + MOMENTO DE LIQUI'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_CDSILQ        is ''CODIGO SITUACION LIQUIDACION  '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_FANTLQ        is ''FECHA ANTERIOR LIQUIDACION    '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_FEVALQ        is ''FECHA DE VALOR DE LIQUIDACION '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_FPROLQ        is ''FECHA PROXIMA LIQUIDACION     '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_COASLQ        is ''CODIGO LIQUIDACION ASESORIA   '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_FEFCON        is ''FECHA FIN CONTRATO (AAAAMMDD) '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_POINDB        is ''% INTERES DEBE DEL CONTRATO   '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_IMLIAC        is ''IMPORTE LIMITE ACTUAL DEL CRED'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_CDMOIM        is ''CODIGO MONEDA DEL IMPORTE     '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_NUCTOP        is ''NUMERO DE CUENTA OPERATIVA    '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_NCTAOP        is ''Numero de cuenta operactiva   '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_MONEDA        is ''DESCRIPCION DE LA MONEDA.     '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_DESLIQ        is ''DESCRIPCION DE LA LIQUIDACION.'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO.CLQ_FILLR3        is ''FILLER3                       '' ' ; 


		

DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.CLQ_CAB_LIQ_CUENTAS_CREDITO... Tabla CREADA OK');
    
DBMS_OUTPUT.PUT_LINE('[END] Tabla CLQ_CAB_LIQ_CUENTAS_CREDITO');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		
