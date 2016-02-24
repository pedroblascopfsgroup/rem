
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


    /*  tabla MLQ_MOV_LIQ_CUENTAS_CREDITO <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla MLQ_MOV_LIQ_CUENTAS_CREDITO');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'MLQ_MOV_LIQ_CUENTAS_CREDITO';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO... Tabla borrada OK');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO
      (
	    MLQ_PCO_LIQ_ID      NUMBER(16) ,		
		MLQ_XCOEMP          VARCHAR2(5 CHAR) ,
		MLQ_COPSER          VARCHAR2(5 CHAR) ,
		MLQ_IDPRIG          VARCHAR2(17 CHAR) ,
		MLQ_IDCOEC          VARCHAR2(15 CHAR) ,
		MLQ_FEVACM          DATE,        
		MLQ_FEPEAU          DATE,        
		MLQ_FFVPMA          DATE,        
		MLQ_CLLIQ1          VARCHAR2(1 CHAR) ,
		MLQ_CDIGMO          VARCHAR2(1 CHAR) ,
		MLQ_FILLR1          VARCHAR2(32 CHAR) ,
	    MLQ_COTREG          NUMBER(3),            
		MLQ_COEXPD          NUMBER(15),            
		MLQ_NUSECT          NUMBER(9),           
		MLQ_CATORG          NUMBER(9),           
		MLQ_FILLR2          VARCHAR2(8 CHAR) ,
		MLQ_NUIDLQ          NUMBER(5),                 		
		MLQ_CORGEC          NUMBER(2),          
		MLQ_COSTEC          NUMBER(2),          
		MLQ_FECHAO          DATE,
		MLQ_FECHAV          DATE,                 
		MLQ_CNCORT          VARCHAR2(25 CHAR) ,
		MLQ_IMMOVY          VARCHAR2(17 CHAR) ,
		MLQ_CASALY          VARCHAR2(17 CHAR) ,
		MLQ_CADISY          VARCHAR2(3 CHAR) ,
		MLQ_CANUDY          VARCHAR2(17 CHAR) ,
		MLQ_CANUCY          VARCHAR2(17 CHAR) ,
		MLQ_CANUEY          VARCHAR2(17 CHAR) ,
		MLQ_FILLR3          VARCHAR2(418 CHAR) ,
        USUARIOCREAR        VARCHAR2(50 CHAR) not null,
        FECHACREAR          TIMESTAMP(6) not null,
        USUARIOMODIFICAR    VARCHAR2(50 CHAR),
        FECHAMODIFICAR      TIMESTAMP(6),		
		VERSION             INTEGER DEFAULT 0  NOT NULL,
		USUARIOBORRAR       VARCHAR2(50 CHAR)         ,
		FECHABORRAR         TIMESTAMP(6)         ,
		BORRADO             NUMBER(1) DEFAULT 0  NOT NULL  ) ' ; 
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MLQ_MOV_LIQ_CUENTAS_CREDITO... Tabla creada');		
		
		EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '.IDX_MLQ_PCO_LIQ_ID ON ' || V_ESQUEMA || '.MLQ_MOV_LIQ_CUENTAS_CREDITO (MLQ_PCO_LIQ_ID) ' ||
		'  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 ' ||
  		'  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE ' || V_TS_INDEX;
  		
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.MLQ_PCO_LIQ_ID... Indice creado');		
		

EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_XCOEMP        is ''CODIGO DE EMPRESA               '' ' ;                                
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_COPSER        is ''CLASE DE PRODUCTO               '' ' ;  
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_IDPRIG        is ''IDENTIFICADOR DE PRODUCTO O SE  '' ' ;  
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_IDCOEC        is ''IDENTIFICADOR COND. ESPE. CONT  '' ' ;  
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_FEVACM        is ''FECHA VALOR CONTABLE DEL MOVIM  '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_FEPEAU        is ''FECHA DE LA PETICION            '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_FFVPMA        is ''VENCIMIENTO PENDIENTE MAS ANTI  '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_CLLIQ1        is ''TIPO DE LIQUIDACION             '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_CDIGMO        is ''DIGITO DE CONTROL DE MONEDA     '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_FILLR1        is ''                                '' ' ;						
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_COTREG        is ''CODIGO TIPO DE REGISTRO       '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_COEXPD        is ''CODIGO DE EXPEDIENTE          '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_NUSECT        is ''NUMERO SECUENCIAL             '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_CATORG        is ''CANTIDAD TOTAL DE REGISTROS   '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_FILLR2        is ''FILLER 2                      '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_NUIDLQ        is ''NUMERO DE LIQUIDACION DEL EXPE'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_CORGEC        is ''CODIGO DE REGISTRO DEL EXTRACT'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_COSTEC        is ''CODIGO DE SUB-REGISTRO DEL EXT'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_FECHAO        is ''FECHA DE OPERACION            '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_FECHAV        is ''FECHA VALOR                   '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_CNCORT        is ''CONCEPTO CORTO DE OPERACION   '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_IMMOVY        is ''IMPORTE DEL MOVIMIENTO/OPERACI'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_CASALY        is ''SALDO                         '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_CADISY        is ''Nº DIAS MANTENIMIENTO SALDO-VA'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_CANUDY        is ''CANTIDAD NUMEROS COMERCIALES D'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_CANUCY        is ''CANTIDAD NUMEROS COMERCIALES A'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_CANUEY        is ''CANTIDAD NUMEROS COMERCIALES E'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO.MLQ_FILLR3        is ''FILLER 3                      '' ' ;
		

DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.MLQ_MOV_LIQ_CUENTAS_CREDITO... Tabla CREADA OK');
    
DBMS_OUTPUT.PUT_LINE('[END] Tabla MLQ_MOV_LIQ_CUENTAS_CREDITO');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		
