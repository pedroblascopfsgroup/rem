/*
--##########################################
--## AUTOR=Alejandro I?igo
--## FECHA_CREACION=20160613
--## ARTEFACTO=ETL
--## VERSION_ARTEFACTO=2.10
--## INCIDENCIA_LINK=PRODUCTO-1449
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

    /*  tabla REC_FICHERO_COBROS <-- ELIMINAR */

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla REC_FICHERO_COBROS');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'REC_FICHERO_COBROS' and owner = V_ESQUEMA ;
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.REC_FICHERO_COBROS CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.REC_FICHERO_COBROS... Tabla borrada OK');
	else
	  DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.REC_FICHERO_COBROS... No existe');
    end if;	
            
    EXECUTE IMMEDIATE 'CREATE TABLE '|| V_ESQUEMA ||'.REC_FICHERO_COBROS 
	   (	
	    RCF_AGE_ID              NUMBER (16)                  NOT NULL, 
		CODIGO_PROPIETARIO     	NUMBER(5,0) 	             NOT NULL, 
		TIPO_PRODUCTO 			VARCHAR2(5 CHAR)             NOT NULL, 
		NUMERO_CONTRATO 		NUMBER(17,0) 	             NOT NULL, 
		NUMERO_ESPEC 			NUMBER(15,0) 	             NOT NULL, 
		ID_CARTERA 				NUMBER(16,0) 	             NOT NULL, 
		CARTERA_EXPEDIENTE 		VARCHAR2(255 CHAR)           NOT NULL,
		CODIGO_COBRO 			VARCHAR2(20 CHAR)            NOT NULL,
		FECHA_VALOR 			DATE						 NOT NULL, 
		FECHA_MOVIMIENTO 		DATE						 NOT NULL, 
		CD_ORIGEN_COBRO 		VARCHAR2(20 CHAR)			 NOT NULL, 
		ORIGEN_COBRO 			VARCHAR2(50 CHAR)			 NOT NULL, 
		CAPITAL_VENCIDO 		NUMBER(16,2)	   DEFAULT 0 NOT NULL,
		CAPITAL_NO_VENCIDO 		NUMBER(16,2)	   DEFAULT 0 NOT NULL,
		INTERESES_ORDINARIOS 	NUMBER(16,2)	   DEFAULT 0 NOT NULL,
		INTERESES_MORATORIOS 	NUMBER(16,2)	   DEFAULT 0 NOT NULL,
		COMISIONES 				NUMBER(16,2)	   DEFAULT 0 NOT NULL, 
		GASTOS 					NUMBER(16,2)	   DEFAULT 0 NOT NULL,
		IMPUESTOS 				NUMBER(16,2)	   DEFAULT 0 NOT NULL,
		LCHAR_EXTRA1 			VARCHAR2(50 CHAR)			         ,
		LCHAR_EXTRA2 			VARCHAR2(50 CHAR)			         ,
		FLAG_EXTRA1				VARCHAR2(1 CHAR)			         ,
		FLAG_EXTRA2				VARCHAR2(1 CHAR)			         ,
		DATE_EXTRA1 			DATE						         ,
		DATE_EXTRA2 			DATE						         ,
		NUMERO_EXTRA1 			NUMBER(14,2)				         ,
		NUMERO_EXTRA2 			NUMBER(14,2)				         ,
		USUARIOCREAR       		VARCHAR2(50 CHAR)            NOT NULL,
		FECHACREAR        		TIMESTAMP(6)                 NOT NULL,
		USUARIOMODIFICAR  		VARCHAR2(50 CHAR)         	         ,
		FECHAMODIFICAR    		TIMESTAMP(6)              	         ,		
		VERSION           		INTEGER            DEFAULT 0 NOT NULL,
		USUARIOBORRAR     		VARCHAR2(50 CHAR)			         ,
		FECHABORRAR       		TIMESTAMP(6)        		         ,
		BORRADO           		NUMBER(1)          DEFAULT 0 NOT NULL ) ' ;
  		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.REC_FICHERO_COBROS... Tabla creada');				
		
		/*Creamos clave primaria*/
		
		 EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.REC_FICHERO_COBROS ADD CONSTRAINT PK_REC_FICHERO_COBROS PRIMARY KEY (CODIGO_COBRO) ' ;
		 
		DBMS_OUTPUT.PUT_LINE('[INFO] Clave primaria PK_REC_FICHERO_COBROS... creada');
	
		DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON ÉXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit
