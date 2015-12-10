/*
--##########################################
--## AUTOR=Alejandro I�igo
--## FECHA_CREACION=20151101
--## ARTEFACTO=ETL
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=BKREC-1142
--## PRODUCTO=NO
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); /* Sentencia a ejecutar    */
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; /*  Configuracion Esquema */
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; /*  Configuracion Esquema */
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#';/* Configuracion Indice*/
    V_SQL VARCHAR2(4000 CHAR); /*  Vble. para consulta que valida la existencia de una tabla.*/
    V_NUM_TABLAS NUMBER(16); /* Vble. para validar la existencia de una tabla.*/  
    ERR_NUM NUMBER(25); /*  Vble. auxiliar para registrar errores en el script.*/
    ERR_MSG VARCHAR2(1024 CHAR);/*  Vble. auxiliar para registrar errores en el script.*/

    V_TEXT1 VARCHAR2(2400 CHAR); /*   Vble. auxiliar*/
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; /*  Configuracion Esquema */ 
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; /*  Configuracion Esquema */ 
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; /*  Configuracion Esquema */ 
	
BEGIN


    /*  tabla APE_ALTA_PREPARACION_EFECTOS <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla APE_ALTA_PREPARACION_EFECTOS');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'APE_ALTA_PREPARACION_EFECTOS';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.APE_ALTA_PREPARACION_EFECTOS CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.APE_ALTA_PREPARACION_EFECTOS... Tabla borrada OK');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.APE_ALTA_PREPARACION_EFECTOS
      (
       APE_CODIGO_PREPARACION_NUSE	NUMBER(16)	 NOT NULL ,
	   APE_CODIGO_ENTIDAD	        NUMBER(4)	 NOT NULL ,
	   APE_CODIGO_PROPIETARIO       NUMBER (5)	 NOT NULL ,
	   APE_TIPO_PRODUCTO	        VARCHAR2(5)	 NOT NULL ,
	   APE_NUMERO_CONTRATO	        NUMBER (17)	 NOT NULL ,
	   APE_NUMERO_ESPEC	            NUMBER (15)	 NOT NULL ,
	   APE_NUMERO_EFECTO	        VARCHAR2(12) NOT NULL ,
	   APE_FECHA_PROCESO	        DATE         NOT NULL ,
       USUARIOCREAR        	        VARCHAR2(10) not null ,
       FECHACREAR          	        TIMESTAMP(6) not null ,
       USUARIOMODIFICAR    	        VARCHAR2(10)		  ,
       FECHAMODIFICAR      	        TIMESTAMP(6)		  ,	 
		VERSION                   	INTEGER DEFAULT 0  NOT NULL,
		USUARIOBORRAR             	VARCHAR2(50)         ,
		FECHABORRAR               	TIMESTAMP(6)         ,
		BORRADO                  	NUMBER(1) DEFAULT 0  NOT NULL,	   
	   CONSTRAINT PK_APE_ALTA_PREPARACION_EFEC PRIMARY KEY (APE_CODIGO_PREPARACION_NUSE,APE_CODIGO_PROPIETARIO,APE_TIPO_PRODUCTO,APE_NUMERO_CONTRATO,APE_NUMERO_ESPEC,APE_NUMERO_EFECTO)	)	 ' ; 	
		
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APE_ALTA_PREPARACION_EFECTOS.APE_CODIGO_PREPARACION_NUSE   is ''Código identificador de la preparación '' ' ;	                                            	
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APE_ALTA_PREPARACION_EFECTOS.APE_CODIGO_ENTIDAD	           is ''Código de la entidad original del contrato.	Poner siempre Bankia (2038). '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APE_ALTA_PREPARACION_EFECTOS.APE_CODIGO_PROPIETARIO        is ''Código que indica la entidad propietaria de la cartera (ej. Bankia, SAREB, otros) '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APE_ALTA_PREPARACION_EFECTOS.APE_TIPO_PRODUCTO	           is ''Catalogación del producto en la entidad.(Código según Dic. Datos) Informar PRODUCTO URSUS BANKIA (COTIPP) '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APE_ALTA_PREPARACION_EFECTOS.APE_NUMERO_CONTRATO	       is ''Identificador de la operación '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APE_ALTA_PREPARACION_EFECTOS.APE_NUMERO_ESPEC	           is ''Identificador de condiciones especiales de contratación '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APE_ALTA_PREPARACION_EFECTOS.APE_NUMERO_EFECTO	           is ''Numero de  efecto '' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APE_ALTA_PREPARACION_EFECTOS.APE_FECHA_PROCESO	           is ''Fecha en que se genera el dato '' ' ;

DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.APE_ALTA_PREPARACION_EFECTOS... Tabla CREADA OK');
    
DBMS_OUTPUT.PUT_LINE('[END] Tabla APE_ALTA_PREPARACION_EFECTOS');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		
