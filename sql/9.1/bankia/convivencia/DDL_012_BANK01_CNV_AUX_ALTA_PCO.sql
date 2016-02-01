/*
--##########################################
--## AUTOR=Alejandro I?igo
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


    /*  tabla CNV_AUX_ALTA_PCO <-- ELIMINAR*/

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla CNV_AUX_ALTA_PCO');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'CNV_AUX_ALTA_PCO';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.CNV_AUX_ALTA_PCO CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.CNV_AUX_ALTA_PCO... Tabla borrada OK');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.CNV_AUX_ALTA_PCO
      (
       CODIGO_PROCEDIMIENTO_NUSE NUMBER(16) not null,
       COD_PREPARADORDOC         VARCHAR2(15 CHAR),
       PRETURNADO                NUMBER(1) default 1,
       TIPO_PREPARACION          VARCHAR2(2 CHAR) default ''CO'',
       CONSTRAINT PK_COD_PROC_NUSE_ALTA_PCO  PRIMARY KEY (CODIGO_PROCEDIMIENTO_NUSE)		 )	' ; 	

DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.CNV_AUX_ALTA_PCO... Tabla CREADA OK');
    
DBMS_OUTPUT.PUT_LINE('[END] Tabla CNV_AUX_ALTA_PCO');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		



