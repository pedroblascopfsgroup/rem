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


    /*  tabla APP_ALTA_PREPARACION_PERSONAS <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla APP_ALTA_PREPARACION_PERSONAS');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'APP_ALTA_PREPARACION_PERSONAS';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS... Tabla borrada OK');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS
      (
		APP_CODIGO_PREPARACION_NUSE	NUMBER(16)    NOT NULL ,
		APP_CODIGO_PROPIETARIO		NUMBER(5)     NOT NULL ,
		APP_CODIGO_PERSONA			VARCHAR2(10)  NOT NULL ,
		APP_NUMERO_CLIENTE_NUSE	    NUMBER (17)	  NOT NULL , 
		APP_TIPO_PERSONA			NUMBER (1)	           ,
		APP_TIPO_DOCUMENTO			VARCHAR2(20)           ,
		APP_NIF_CIF_PASAP_NIE	    VARCHAR2(20)           ,
		APP_NOMBRE					VARCHAR2(100)          ,
		APP_NOM_COMPLETO	        VARCHAR2(300)          ,
		APP_APELLIDO1				VARCHAR2(100)          ,
		APP_APELLIDO2			    VARCHAR2(100)          ,
		APP_FECHA_PROCESO			DATE          NOT NULL ,
		APP_REL_PER_PDM	            VARCHAR(10)	  NOT NULL ,		
        USUARIOCREAR        		VARCHAR2(10)  not null ,
        FECHACREAR          		TIMESTAMP(6)  not null ,
        USUARIOMODIFICAR    		VARCHAR2(10)		   ,
        FECHAMODIFICAR      		TIMESTAMP(6)		   ,
		VERSION                   	INTEGER DEFAULT 0  NOT NULL,
		USUARIOBORRAR             	VARCHAR2(50)         ,
		FECHABORRAR               	TIMESTAMP(6)         ,
		BORRADO                  	NUMBER(1) DEFAULT 0  NOT NULL,		
	    CONSTRAINT PK_APP_ALTA_PREPARACION_PER PRIMARY KEY (APP_CODIGO_PREPARACION_NUSE,APP_CODIGO_PROPIETARIO,APP_CODIGO_PERSONA,APP_REL_PER_PDM)	)	 ' ; 	

		
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_CODIGO_PREPARACION_NUSE	is ''Código identificador de la preparación			'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_CODIGO_PROPIETARIO		is ''Código que indica la entidad propietaria de la cartera (ej. Bankia, SAREB, otros)		'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_CODIGO_PERSONA			is ''Código interno de la Entidad, que identifique la persona de forma única, con independencia de los otros campos, si lo hubiera. Debe ser único para cada registro de persona	/ Nº de cliente en Bankia.'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_NUMERO_CLIENTE_NUSE	    is ''Identificador de la persona en NUSE.		'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_TIPO_PERSONA			    is ''Física/Jurídica.(Código según Dic. Datos)		•	1:física •	2:jurídica'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_TIPO_DOCUMENTO			is ''Tipo de documento identificación de la persona como NIF, CIF u otros. (Código según Dic. Datos)	'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_NIF_CIF_PASAP_NIE	        is ''Nº documento identificativo (con sus letras).'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_NOMBRE					is ''Nombre del cliente / Razón Social completa'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_NOM_COMPLETO	            is ''Nombre completo / Razón Social completa del cliente, concatenación de Nombre+apellido1+apellido2.		'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_APELLIDO1				    is ''Primer apellido del cliente.	'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_APELLIDO2			        is ''Segundo apellido del cliente.	'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_FECHA_PROCESO			    is ''Fecha en que se genera el dato'' ' ;
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS.APP_REL_PER_PDM	            is '' Relación de la persona con el procedimiento'' ' ;
		

DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.APP_ALTA_PREPARACION_PERSONAS... Tabla CREADA OK');
    
DBMS_OUTPUT.PUT_LINE('[END] Tabla APP_ALTA_PREPARACION_PERSONAS');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		
