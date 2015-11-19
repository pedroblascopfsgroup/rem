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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; /*  Configuracion Esquema */ Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#';/* Configuracion Indice*/
    V_SQL VARCHAR2(4000 CHAR); /*  Vble. para consulta que valida la existencia de una tabla.*/
    V_NUM_TABLAS NUMBER(16); /* Vble. para validar la existencia de una tabla.*/  
    ERR_NUM NUMBER(25); /*  Vble. auxiliar para registrar errores en el script.*/
    ERR_MSG VARCHAR2(1024 CHAR);/*  Vble. auxiliar para registrar errores en el script.*/

    V_TEXT1 VARCHAR2(2400 CHAR); /*   Vble. auxiliar*/
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; /*  Configuracion Esquema */ minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; /*  Configuracion Esquema */ recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; /*  Configuracion Esquema */ recovery_bankia_datastage
	
BEGIN
    
    V_NUM_TABLAS := 0;

    /*  tabla MINIRECOVERY_CNT_PROC_VIVOS <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla MINIREC_PCO_CNT_PRC_VIVOS_BAJA');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'MINIREC_PCO_CNT_PRC_VIVOS_BAJA';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA_MIN ||'.MINIREC_PCO_CNT_PRC_VIVOS_BAJA CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA_MIN ||'.MINIREC_PCO_CNT_PRC_VIVOS_BAJA... Tabla borrada OK');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA_MIN ||'.MINIREC_PCO_CNT_PRC_VIVOS_BAJA
       (MPB_CNT_ID                 NUMBER(16) NOT NULL,
	     MPB_COD_ENTIDAD           NUMBER(4) NOT NULL,
         MPB_CODIGO_PROPIETARIO    NUMBER(5) NOT NULL,
         MPB_TIPO_PRODUCTO         VARCHAR2(5 CHAR) NOT NULL,
         MPB_NUMERO_CONTRATO       NUMBER(17) NOT NULL,
         MPB_NUMERO_ESPEC          NUMBER(15) NOT NULL,
		 MPB_MOTIVO                VARCHAR2(50 CHAR),
         MPB_FECHA_PROCESO         DATE NOT NULL,
         MPB_PROCESADO             VARCHAR2(2 CHAR),         
         MPB_CD_PROCEDIMIENTO	  NUMBER(16) NOT NULL,
        USUARIOCREAR        		VARCHAR2(10) not null,
        FECHACREAR          		TIMESTAMP(6) not null,
        USUARIOMODIFICAR    		VARCHAR2(10)		 ,
        FECHAMODIFICAR      		TIMESTAMP(6)		 ,						
		VERSION                   	INTEGER DEFAULT 0  NOT NULL,
		USUARIOBORRAR             	VARCHAR2(50)         ,
		FECHABORRAR               	TIMESTAMP(6)         ,
		BORRADO                  	NUMBER(1) DEFAULT 0  NOT NULL
        )     ';  

    EXECUTE IMMEDIATE 
    'CREATE UNIQUE INDEX '|| V_ESQUEMA_MIN ||'.PK_MPB_PCO_CNT_PROC_BAJA ON '|| V_ESQUEMA_MIN ||'.MINIREC_PCO_CNT_PRC_VIVOS_BAJA
        (MPB_CNT_ID, MPB_CD_PROCEDIMIENTO)   ';

EXECUTE IMMEDIATE 
'ALTER TABLE '|| V_ESQUEMA_MIN ||'.MINIREC_PCO_CNT_PRC_VIVOS_BAJA ADD (
     CONSTRAINT PK_MPB_PCO_CNT_PROC_BAJA
     PRIMARY KEY
     (MPB_CNT_ID, MPB_CD_PROCEDIMIENTO) )';
        
DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA_MIN ||'.MINIREC_PCO_CNT_PRC_VIVOS_BAJA... Tabla CREADA OK');
    
DBMS_OUTPUT.PUT_LINE('[END] Tabla MMINIREC_PCO_CNT_PRC_VIVOS_BAJA');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/

exit
