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


    /*  tabla APB_ALTA_PREPARACION_BIENES <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla APB_ALTA_PREPARACION_BIENES');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'APB_ALTA_PREPARACION_BIENES';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES... Tabla borrada OK');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES
      (
	   APB_CODIGO_PREPARACION_NUSE	NUMBER(16)	 NOT NULL  ,
	   APB_ID_BIEN_NUSE	            NUMBER (16)	 NOT NULL  ,
	   APB_CD_BIEN	                NUMBER(16)	  		   ,
	   APB_NUMERO_FINCA	            VARCHAR2(10)  		   ,
	   APB_COD_POSTAL	            VARCHAR2(5)	  		   ,
	   APB_LOCALIDAD	            VARCHAR2(50)  		   ,
	   APB_NUMERO_REGISTRO	        VARCHAR2(3)	  		   ,
	   APB_PLAZA_REGISTRO	        VARCHAR2(50)  		   ,
	   APB_DESCRIPCION	            VARCHAR (300) 		   ,
	   APB_CODIGO_SITUACION_BIEN    VARCHAR2(6)	  		   ,
	   APB_FECHA_PROCESO	        DATE          NOT NULL ,
	   APB_BIE_CODIGO_BIEN	        VARCHAR2(50)  		   ,
       USUARIOCREAR        	        VARCHAR2(10) not null  ,
       FECHACREAR          	        TIMESTAMP(6) not null  ,
       USUARIOMODIFICAR    	        VARCHAR2(10)		   ,
       FECHAMODIFICAR      	        TIMESTAMP(6)		   ,	   
		VERSION                   	INTEGER DEFAULT 0  NOT NULL,
		USUARIOBORRAR             	VARCHAR2(50)         ,
		FECHABORRAR               	TIMESTAMP(6)         ,
		BORRADO                  	NUMBER(1) DEFAULT 0  NOT NULL,	   
	   CONSTRAINT PK_APB_ALTA_PREPARACION_BIE PRIMARY KEY (APB_CODIGO_PREPARACION_NUSE,APB_ID_BIEN_NUSE)	)	 ' ; 	
		
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES.APB_CODIGO_PREPARACION_NUSE   is ''Código identificador de la preparación '' ';		
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES.APB_ID_BIEN_NUSE	          is ''Identificador del bien en NUSE	 '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES.APB_CD_BIEN	                  is ''Código identificador único del bien. El mismo identificador que en aprovisionamiento. '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES.APB_NUMERO_FINCA	          is ''Numero de finca	 '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES.APB_COD_POSTAL	              is ''Código postal		 '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES.APB_LOCALIDAD	              is ''Localidad de la finca	 '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES.APB_NUMERO_REGISTRO	          is ''Numero registro	 '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES.APB_PLAZA_REGISTRO	          is ''Plaza registro	 '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES.APB_DESCRIPCION	              is ''Descripción del bien.	 '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES.APB_CODIGO_SITUACION_BIEN     is ''Código de situación del bien según diccionario de la entidad.  '' '; 
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES.APB_FECHA_PROCESO	          is ''Fecha en que se genera el dato '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES.APB_BIE_CODIGO_BIEN	          is ''Identificador del bien en la aplicación de garantías	 '' ';


DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.APB_ALTA_PREPARACION_BIENES... Tabla CREADA OK');
    
DBMS_OUTPUT.PUT_LINE('[END] Tabla APB_ALTA_PREPARACION_BIENES');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		
