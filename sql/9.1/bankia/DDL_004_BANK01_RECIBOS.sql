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


    /*  tabla RCB_RECIBOS_LIQ <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla RCB_RECIBOS_LIQ');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'RCB_RECIBOS_LIQ';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ... Tabla borrada OK');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ
      (
	    RCB_PCO_LIQ_ID      NUMBER(16)   ,   
	    RCB_XCOEMP VARCHAR2(5),               
		RCB_COPSER VARCHAR2(5),             
		RCB_IDPRIG VARCHAR2(17),            
		RCB_IDCOEC VARCHAR2(15),            
		RCB_FEVACM DATE,                    
		RCB_FEPEAU DATE,                    
		RCB_FFVPMA DATE,                    
		RCB_CLLIQ1 VARCHAR2(1),               
		RCB_CDIGMO VARCHAR2(1),              
		RCB_FILLR1 VARCHAR2(32),            
		RCB_IDRECV VARCHAR2(23),            
        RCB_FEVCTR DATE,                    
		RCB_FEREAM DATE,                    
		RCB_CDINTS NUMBER(9,6),              
		RCB_CDINTM NUMBER(9,6),              
        RCB_IMCPRC NUMBER(15,2),            
		RCB_IMPRTV NUMBER(15,2),            
		RCB_IMCGTA NUMBER(15,2),            
		RCB_IMINDR NUMBER(15,2),            
		RCB_IMBIM4 NUMBER(15,2),            
		RCB_IDEOTG NUMBER(15,2),            
		RCB_IMDEUD NUMBER(15,2),            
		RCB_FILLR2 VARCHAR2(422) ,
        USUARIOCREAR        VARCHAR2(10 CHAR) not null,
        FECHACREAR          TIMESTAMP(6) not null,
        USUARIOMODIFICAR    VARCHAR2(10 CHAR),
        FECHAMODIFICAR      TIMESTAMP(6)	,		
		VERSION                   	INTEGER DEFAULT 0  NOT NULL,
		USUARIOBORRAR             	VARCHAR2(50)         ,
		FECHABORRAR               	TIMESTAMP(6)         ,
		BORRADO                  	NUMBER(1) DEFAULT 0  NOT NULL   )	 ' ; 
		
		EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '.IDX_RCB_PCO_LIQ_ID ON ' || V_ESQUEMA || '.RCB_RECIBOS_LIQ (RCB_PCO_LIQ_ID) ' ||
		'  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 ' ||
  		'  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) TABLESPACE ' || V_TS_INDEX;
  		
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.RCB_PCO_LIQ_ID... Indice creado');				
		
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_XCOEMP        is ''EMPRESA CONTRATO''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_COPSER        is ''TIPO PRODUCTO''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IDPRIG        is ''NUMERO CONTRATO''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IDCOEC        is ''ID. CONDICION ESPECIAL CONTRATO''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_FEVACM        is ''FECHA LIQUIDACION''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_FEPEAU        is ''FECHA PETICION''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_FFVPMA        is ''FECHA VENCIMIENTO MAS ANTIGUO''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_CLLIQ1        is ''TIPO DE LIQUIDACION''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_CDIGMO        is ''MONEDA SOLICTADA''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_FILLR1        is ''FILLER''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IDRECV        is ''NUMERO RECIBO''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_FEVCTR        is ''FECHA VENCIMIENTO''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_FEREAM        is ''FECHA VALOR (APLICACIÓN INTERESES)''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_CDINTS        is ''TIPO INTERES COBRO''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_CDINTM        is ''TIPO INTERES DEMORA''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IMCPRC        is ''CAPITAL''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IMPRTV        is ''INTERESES''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IMCGTA        is ''COMISIONES''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IMINDR        is ''DEMORA''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IMBIM4        is ''IMPUESTO''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IDEOTG        is ''GASTOS''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_IMDEUD        is ''TOTAL''  ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ.RCB_FILLR2        is ''FILLER''  ';

		

DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.RCB_RECIBOS_LIQ... Tabla CREADA OK');
    
DBMS_OUTPUT.PUT_LINE('[END] Tabla RCB_RECIBOS_LIQ');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		
