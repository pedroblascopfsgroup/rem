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


    /*  tabla APR_ALTA_PREPARACION <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla APR_ALTA_PREPARACION');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'APR_ALTA_PREPARACION';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION... Tabla borrada OK');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION
      (
		APR_CODIGO_PREPARACION_NUSE	NUMBER(16)	 not null,
        APR_CODIGO_EXPEDIENTE_NUSE	NUMBER(16)	 not null,
        APR_FECHA_PASE_A_PRELITIGIO	DATE         not null,
        APR_TIPO_PROCEDIMIENTO		VARCHAR2(16) not null, 
        APR_COD_LETRADO				VARCHAR2(15)	     ,
        APR_COD_PROCURADOR			VARCHAR2(15)         ,
        APR_GESTOR					VARCHAR2(15) not null,
        APR_NUMERO_EXP_NUSE			VARCHAR2(50) not null,
        APR_FECHA_PROCESO			DATE         not null,
        APR_PRIORIDAD				VARCHAR2(20) not null,
        APR_TIPO_PREPARACION		VARCHAR2(20) not null,
        APR_TIPO_TURNADO			VARCHAR2(20) not null,
        APR_SUPERVISOR				VARCHAR2(15) not null,
        USUARIOCREAR        		VARCHAR2(10) not null,
        FECHACREAR          		TIMESTAMP(6) not null,
        USUARIOMODIFICAR    		VARCHAR2(10)		 ,
        FECHAMODIFICAR      		TIMESTAMP(6)		 ,						
		VERSION                   	INTEGER DEFAULT 0  NOT NULL,
		USUARIOBORRAR             	VARCHAR2(50)         ,
		FECHABORRAR               	TIMESTAMP(6)         ,
		BORRADO                  	NUMBER(1) DEFAULT 0  NOT NULL,
	    CONSTRAINT PK_APR_ALTA_PREPARACION    PRIMARY KEY (APR_CODIGO_PREPARACION_NUSE)		)	' ; 	

		
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_CODIGO_PREPARACION_NUSE	    is ''Código identificador de la preparación '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_CODIGO_EXPEDIENTE_NUSE	        is ''Código del expediente de NUSE.	'' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_FECHA_PASE_A_PRELITIGIO	    is ''Fecha en la que se crea el expediente de prelitigio. Fecha en que se da la información a Recovery para que inicie la preparación '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_TIPO_PROCEDIMIENTO		        is ''Código del tipo de procedimiento (Según diccionario de la entidad) Mismo diccionario de datos que en la interfase actual de alta de litigios '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_COD_LETRADO				    is ''Código de letrado según diccionario de letrados. Viaja en blanco, ya que lo asigna Recovery.	Viaja en blanco, ya que lo asigna Recovery '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_COD_PROCURADOR			        is ''Código del procurador según diccionario de letrados. Viaja en blanco, ya que lo asigna Recovery	Viaja en blanco, ya que lo asigna Recovery '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_GESTOR					        is ''Código de usuario del gestor del expediente. Sería el preparador del expediente	De momento rellenar con A000000 '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_NUMERO_EXP_NUSE			    is ''Identificador de expediente NUSE por los gestores.		 '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_FECHA_PROCESO			        is ''Fecha en que se genera el dato	Fecha en que se genera el dato '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_PRIORIDAD				        is ''Alta – AL ; Media – ME ; Baja – BA	De momento rellenar con el valor ‘ME’ '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_TIPO_PREPARACION		        is ''Compleja – CO ; Sencillo – SE	De momento rellenar con el valor ‘SE’ '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_TIPO_TURNADO			        is ''Ordinario – 0 ; Preturnar letrado  – 1	De momento rellenar con el valor ‘0’ '' ';
EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION.APR_SUPERVISOR				        is ''Código AXXXXX del supervisor	De momento rellenar con A000000 '' ';
		

DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.APR_ALTA_PREPARACION... Tabla CREADA OK');
    
DBMS_OUTPUT.PUT_LINE('[END] Tabla APR_ALTA_PREPARACION');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		
