/*
--##########################################
--## AUTOR=Alejandro I?igo
--## FECHA_CREACION=20160525
--## ARTEFACTO=ETL
--## VERSION_ARTEFACTO=1.00
--## INCIDENCIA_LINK=BKREC-2290
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

    /*  tabla CNA_CNT_ACTUAC_VIGENT_FSR <-- ELIMINAR */

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla CNA_CNT_ACTUAC_VIGENT_FSR');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'CNA_CNT_ACTUAC_VIGENT_FSR' and owner = V_ESQUEMA ;
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.CNA_CNT_ACTUAC_VIGENT_FSR CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.CNA_CNT_ACTUAC_VIGENT_FSR... Tabla borrada OK');
	else
	  DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.CNA_CNT_ACTUAC_VIGENT_FSR... No existe');
    end if;	
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.CNA_CNT_ACTUAC_VIGENT_FSR (	
		CNA_ID              NUMBER(16)    NOT NULL    ,
		CNT_ID              NUMBER(16)    NOT NULL 	  ,		
		DD_TAF_ID   	    NUMBER(16,0)  NOT NULL	  ,
		USUARIOCREAR       	VARCHAR2(50 CHAR) NOT NULL,
		FECHACREAR        	TIMESTAMP(6)      NOT NULL,
		USUARIOMODIFICAR  	VARCHAR2(50 CHAR)         ,
		FECHAMODIFICAR    	TIMESTAMP(6)              ,		
		VERSION           	INTEGER DEFAULT 0 NOT NULL,
		USUARIOBORRAR     	VARCHAR2(50 CHAR)		  ,
		FECHABORRAR       	TIMESTAMP(6)              ,
		BORRADO           	NUMBER(1) DEFAULT 0 NOT NULL ) ' ;
  		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CNA_CNT_ACTUAC_VIGENT_FSR... Tabla creada');				
		
		-- Creamos clave primaria
		
		 EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.CNA_CNT_ACTUAC_VIGENT_FSR ADD CONSTRAINT PK_CNT_ACTUAC_VIGENT_FSR PRIMARY KEY (CNA_ID) ' ;
		 
		 DBMS_OUTPUT.PUT_LINE('[INFO] Clave primaria PK_CNT_ACTUAC_VIGENT_FSR... creada');    
     
		 EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.CNA_CNT_ACTUAC_VIGENT_FSR ADD CONSTRAINT UK_CNT_ACTUAC_VIGENT_FSR UNIQUE (CNT_ID,DD_TAF_ID) ' ;     

		 DBMS_OUTPUT.PUT_LINE('[INFO] Clave única UK_CNT_ACTUAC_VIGENT_FSR... creada');
		 
		 EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.CNA_CNT_ACTUAC_VIGENT_FSR ADD CONSTRAINT FK_CNT_TAF_ID_ACTC_VIGENT_FSR FOREIGN KEY (DD_TAF_ID) REFERENCES ' || V_ESQUEMA || '.DD_TAF_TIPO_ACTUACION_FSR (DD_TAF_ID) ' ;
		 
		 DBMS_OUTPUT.PUT_LINE('[INFO] Clave ajena FK_CNT_ACTUAC_VIGENT_FSR... creada');
		 
		 EXECUTE IMMEDIATE 'CREATE INDEX IDX_CNA_TAF_ID_FSR ON ' || V_ESQUEMA || '.CNA_CNT_ACTUAC_VIGENT_FSR (DD_TAF_ID) ' ;
		 
		 DBMS_OUTPUT.PUT_LINE('[INFO] Índice IDX_CNA_TAF_ID_FSR... creado');		 
		 
		 EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.CNA_CNT_ACTUAC_VIGENT_FSR ADD CONSTRAINT FK_CNT_CNT_ID_ACTC_VIGENT_FSR FOREIGN KEY (CNT_ID) REFERENCES ' || V_ESQUEMA || '.CNT_CONTRATOS (CNT_ID) ' ;
		 
		 DBMS_OUTPUT.PUT_LINE('[INFO] Clave ajena FK_CNT_ACTUAC_VIGENT_FSR... creada');		 
		 
		 EXECUTE IMMEDIATE 'CREATE INDEX IDX_CNA_CNT_ID_FSR ON ' || V_ESQUEMA || '.CNA_CNT_ACTUAC_VIGENT_FSR (CNT_ID) ' ;
		 
		 DBMS_OUTPUT.PUT_LINE('[INFO] Índice IDX_CNA_CNT_ID_FSR... creado');		 		 	 
		 		 
		
		-- Comprobamos si existe la secuencia

		EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_CNA_CNT_ACTUAC_VIGENT_FSR'' 
				 and sequence_owner = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS; 

		-- Si existe secuencia la borramos
		IF V_NUM_TABLAS = 1 THEN
		  EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_CNA_CNT_ACTUAC_VIGENT_FSR';
		  DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_CNA_CNT_ACTUAC_VIGENT_FSR... Secuencia eliminada');    
		END IF; 
		
		EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_CNA_CNT_ACTUAC_VIGENT_FSR INCREMENT BY 1 MAXVALUE 999999999999999999999999999 MINVALUE 1 CACHE 20'; 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_CNA_CNT_ACTUAC_VIGENT_FSR... Secuencia creada');							
		
		
	
		DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON ÉXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit