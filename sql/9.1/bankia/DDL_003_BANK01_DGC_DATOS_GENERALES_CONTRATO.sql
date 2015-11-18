/*
--##########################################
--## AUTOR=Alejandro I�igo
--## FECHA_CREACION=20151030
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


    /*  tabla DGC_DATOS_GENERALES_CNT_LIQ <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla DGC_DATOS_GENERALES_CNT_LIQ');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'DGC_DATOS_GENERALES_CNT_LIQ';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ... Tabla borrada OK');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ
      (
	    DGC_PCO_LIQ_ID      NUMBER(16)   ,   
	    DGC_XCOEMP VARCHAR2(5),               
		DGC_COPSER VARCHAR2(5),               
		DGC_IDPRIG VARCHAR2(17),              
		DGC_IDCOEC VARCHAR2(15),              
		DGC_FEVACM DATE,                    
		DGC_FEPEAU DATE,                    
		DGC_FFVPMA DATE,                    
		DGC_CLLIQ1 VARCHAR2(1),             
		DGC_CDIGMO VARCHAR2(1),             
		DGC_FILLR1 VARCHAR2(32),            
		DGC_IDCLIE NUMBER(9),               
		DGC_CODICE NUMBER(5),               
		DGC_IMDVSD NUMBER(15,2),            
		DGC_IMINDR NUMBER(15,2),            
		DGC_IMCPNV NUMBER(15,2),            
		DGC_IMCPVI NUMBER(15,2),            
		DGC_IMPRTV NUMBER(15,2),            
		DGC_IMCGTA NUMBER(15,2),            
		DGC_IDEOTG NUMBER(15,2),            
		DGC_IMCMPI NUMBER(15,2),            
		DGC_IMENOP NUMBER(15,2),            
		DGC_IMINEO NUMBER(15,2),            
		DGC_IMBIM4 NUMBER(15,2),            
		DGC_IMEXCD NUMBER(15,2),            
		DGC_CLMOAC VARCHAR2(3),             
		DGC_IMCCNS NUMBER(15,2),            
		DGC_IMCPAM NUMBER(15,2),            
		DGC_IMRIDT NUMBER(15,2),            
		DGC_COIBTQ VARCHAR2(34),            
		DGC_FEFOEZ DATE,                    
		DGC_ID501O  VARCHAR2(5),             
		DGC_NOMFED1 VARCHAR2(50),            
		DGC_NMPRTO  VARCHAR2(8),               
		DGC_ID501M  VARCHAR2(5),             
		DGC_NOMFED2 VARCHAR2(50),            
		DGC_NMPRTM VARCHAR2(8),               
		DGC_FEFICN DATE,                    
		DGC_FFCTTO DATE,                    
		DGC_IMDEUD NUMBER(15,2),              
		DGC_QIIB46 VARCHAR2(34),            
		DGC_FEULAC DATE,                    
		DGC_COCSBA NUMBER(5),             
		DGC_IMVRE2 NUMBER(15,2),
		DGC_FILLR2 VARCHAR2(154),
        USUARIOCREAR        VARCHAR2(10 CHAR) not null,
        FECHACREAR          TIMESTAMP(6) not null,
        USUARIOMODIFICAR    VARCHAR2(10 CHAR),
        FECHAMODIFICAR      TIMESTAMP(6)	,
		VERSION                   	INTEGER DEFAULT 0  NOT NULL,
		USUARIOBORRAR             	VARCHAR2(50)         ,
		FECHABORRAR               	TIMESTAMP(6)         ,
		BORRADO                  	NUMBER(1) DEFAULT 0  NOT NULL,			    
		CONSTRAINT DGC_UNIQUE_LIQ_EXTERN_ID UNIQUE (DGC_XCOEMP,DGC_COPSER,DGC_IDPRIG,DGC_IDCOEC,DGC_FEVACM,DGC_FEPEAU,DGC_CLLIQ1)							) ' ; 
		
		EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '.IDX_DGC_PCO_LIQ_ID ON ' || V_ESQUEMA || '.DGC_DATOS_GENERALES_CNT_LIQ (DGC_PCO_LIQ_ID) ' ||
		'  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 ' ||
  		'  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE ' || V_TS_INDEX;
  		
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DGC_PCO_LIQ_ID... Indice creado');				
				
		
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_XCOEMP        is ''EMPRESA CONTRATO          ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_COPSER        is ''TIPO PRODUCTO             ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IDPRIG        is ''NUMERO CONTRATO           ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IDCOEC        is ''ID COND ESPECIAL CONTRATO ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_FEVACM        is ''FECHA LIQUIDACION         ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_FEPEAU        is ''FECHA PETICION            ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_FFVPMA        is ''FECHA VENC MAS ANTIGUO    ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_CLLIQ1        is ''TIPO LIQUIDACION          ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_CDIGMO        is ''MONEDA SOLICTADA          ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_FILLR1        is ''FILLER                    ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IDCLIE        is ''NUMERO CLIENTE            ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_CODICE        is ''CENTRO ADMINISTRADOR      ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMDVSD        is ''TOT DEUDA VENC SIN DEMORA ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMINDR        is ''INTERES DE DEMORA         ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMCPNV        is ''CAPITAL NO VENCIDO        ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMCPVI        is ''CAPITAL VENCIDO           ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMPRTV        is ''PRODUCTOS VENCIDOS        ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMCGTA        is ''IMPORTE DE COMISIONES     ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IDEOTG        is ''IMPORTE GASTOS            ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMCMPI        is ''INTERES PERIODIFICADOS    ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMENOP        is ''IMPORTE ENTREGAS AMORTIZ  ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMINEO        is ''INTERESES S ENTREGAS      ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMBIM4        is ''IMPORTE DE IMPUESTOS      ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMEXCD        is ''IMPORTE EXCEDIDO          ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_CLMOAC        is ''TIPO MONEDA ACTUAL        ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMCCNS        is ''CAPITAL CONCEDIDO LIMITE  ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMCPAM        is ''CAPITAL AMORTIZADO		''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMRIDT        is ''IMPORTE DISPUESTO         ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_COIBTQ        is ''IBAN ASOCIADO             ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_FEFOEZ        is ''FECHA FORMALIZACION       ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_ID501O        is ''COD NOTARIO FEDATARIO OPER''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_NOMFED1        is ''NOM NOTARIO FEDATARIO OPER''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_NMPRTO        is ''NUM PROTOCOLO OPERACION   ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_ID501M        is ''COD NOTARIO FEDATAR MATRIZ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_NOMFED2        is ''NOM NOTARIO FEDATAR MATRIZ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_NMPRTM        is ''Nº PROTOCOLO MATRIZ       ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_FEFICN        is ''FECHA FIRMA OPERACION     ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_FFCTTO        is ''FECHA VENCIMIENTO FINAL   ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMDEUD        is ''DEUDA TOTAL               ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_QIIB46        is ''NUMERACION CAJA ORIGEN    ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_FEULAC        is ''FECHA ULTIMA ACTUALIZACION''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_COCSBA        is ''CODIGO CSB ENTIDAD ORIGEN ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_IMVRE2        is ''IMPORTE VALOR RESIDUAL    ''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ.DGC_FILLR2        is ''FILLER                    ''  ';		

DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.DGC_DATOS_GENERALES_CNT_LIQ... Tabla CREADA OK');
    
DBMS_OUTPUT.PUT_LINE('[END] Tabla DGC_DATOS_GENERALES_CNT_LIQ');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		
