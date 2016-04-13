/*
--##########################################
--## AUTOR=Alejandro I�igo
--## FECHA_CREACION=20160310
--## ARTEFACTO=ETL
--## VERSION_ARTEFACTO=1.00
--## INCIDENCIA_LINK=BKREC-1907
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

    /*  tabla SCM_STOCK_CUENTAS_MARCADO_HUB <-- ELIMINAR */

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla SCM_STOCK_CUENTAS_MARCADO_HUB');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'SCM_STOCK_CUENTAS_MARCADO_HUB' and owner = 'MINIREC';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB... Tabla borrada OK');
	else
	  DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB... No existe');
    end if;	
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB (		
		SCM_CODIGO_PROPIETARIO          NUMBER(5)	     NOT NULL ,
		SCM_TIPO_PRODUCTO	          	NUMBER(5)	     NOT NULL ,
		SCM_NUMERO_CONTRATO	          	NUMBER(17)	     NOT NULL ,
		SCM_NUMERO_ESPEC	          	NUMBER(15)	     NOT NULL ,
		SCM_LITIGIO_PRELITIGIO			VARCHAR2(1 CHAR) NOT NULL ,
		SCM_CONCURSO	                VARCHAR2(1 CHAR)          ,
		SCM_GENERAL_LITIGIO_PRELITIGIO	VARCHAR2(1 CHAR) NOT NULL ,
		SCM_FECHA_MIN_PRESENT_DEMAND	NUMBER(8) DEFAULT 0       ,		
		SCM_FECHA_MIN_AUTO_PROC_VIVOS   NUMBER(8) DEFAULT 0       ,		
		SCM_FECHA_MIN_ADMISION_DEMANDA 	NUMBER(8) DEFAULT 0       ,		
		SCM_FECHA_PROCESO 				NUMBER(8) NOT NULL        ,
		USUARIOCREAR      				VARCHAR2(50 CHAR) NOT NULL,
		FECHACREAR        				TIMESTAMP(6)      NOT NULL,
		USUARIOMODIFICAR  				VARCHAR2(50 CHAR)         ,
		FECHAMODIFICAR    				TIMESTAMP(6)              ,		
		VERSION           				INTEGER DEFAULT 0 NOT NULL,
		USUARIOBORRAR     				VARCHAR2(50 CHAR)		  ,
		FECHABORRAR       				TIMESTAMP(6)              ,
		BORRADO           				NUMBER(1) DEFAULT 0 NOT NULL ) ' ;    		
  		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MIN || '.SCM_STOCK_CUENTAS_MARCADO_HUB... Tabla creada');				
		
		EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA_MIN || '.IDX_SCM_STOCK_CUENTAS_MARCADO ON ' || V_ESQUEMA_MIN || '.SCM_STOCK_CUENTAS_MARCADO_HUB (SCM_CODIGO_PROPIETARIO,SCM_TIPO_PRODUCTO,SCM_NUMERO_CONTRATO,SCM_NUMERO_ESPEC) ' ;
  		
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MIN || '.IDX_SCM_STOCK_CUENTAS_MARCADO... Indice creado');						
		
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB.SCM_CODIGO_PROPIETARIO                is ''Código que indica la entidad propietaria de la cartera (ej. Bankia, SAREB, otros)'' ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB.SCM_TIPO_PRODUCTO	          	        is ''Catalogación del producto en la entidad. (Código según Dic. Datos) / Informar PRODUCTO URSUS BANKIA (COTIPP)''  ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB.SCM_NUMERO_CONTRATO	          	    is ''Identificador de la operación''  ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB.SCM_NUMERO_ESPEC	          	        is ''Identificador de condiciones especiales de contratación''  ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB.SCM_LITIGIO_PRELITIGIO			    is ''Indica si la operación está en litigio o prelitigio, independientemente de si es un concurso o un litigio / VALORES POSIBLES :L (LITIGIO)P (PRELITIGIO)''  ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB.SCM_CONCURSO	                        is ''Indica si la operación está en concurso. Para ello, se buscan todos los titulares del contrato, y si alguno de ellos tiene la marca de concurso, se pone la ‘X’ en este registro (la marca a nivel de persona viene en el FLAG_EXTRA1 de aprovisionamiento) / `X´ CONCURSO ` ´ SIN CONCURSO''  ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB.SCM_GENERAL_LITIGIO_PRELITIGIO	    is ''Si MARCA CONCURSO=’X’•	Si MARCA LITIGIO/PRELITIGIO =’L’ ? ‘D’•	Si MARCA LITIGIO/PRELITIGIO =’P’ ? ‘C’Si MARCA CONCURSO=’ ’ ? mismo valor que MARCA LITIGIO/PRELITIGIO	/ VALORES POSIBLES:L (LITIGIO)P (PRELITIGIO)D (LITIGIO CONCURSAL)C (PRELITIGIO CONCURSAL)''  ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB.SCM_FECHA_MIN_PRESENT_DEMAND	        is ''CORRESPONDE A MINIMA  FECHA PRESENTACION DEMANDA PARA PROCEDIMIENTOS VIVOS  DONDE ESTE ESA OPERACIÓN / Ver punto 8 de este funcional	/ ES POSIBLE QUE LA OPERACIÓN TENGA MARCA L o P PERO LA FECHA VENGA CON 0''  ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB.SCM_FECHA_MIN_AUTO_PROC_VIVOS         is ''CORRESPONDE A MINIMA FECHA  AUTO PARA PROCEDIMIENTOS VIVOS 	Ver punto 8 de este funcional	/ ES POSIBLE QUE LA OPERACIÓN TENGA MARCA C o D PERO LA FECHA VENGA CON 0''  ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB.SCM_FECHA_MIN_ADMISION_DEMANDA 	    is ''PARA PROCEDIMIENTOS VIVOS  DONDE ESTE ESA OPERACIÓN	Ver punto 8 de este funcional	/  ES POSIBLE QUE LA OPERACIÓN TENGA MARCA PERO LA FECHA VENGA CON 0''  ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCM_STOCK_CUENTAS_MARCADO_HUB.SCM_FECHA_MIN_ADMISION_DEMANDA 	    is ''COINCIDIRÁ CON VARIABLE OPC &OYMD''  ';
		
		BEGIN
		  
          EXECUTE IMMEDIATE ('GRANT SELECT ON ' || V_ESQUEMA_MIN || '.SCM_STOCK_CUENTAS_MARCADO_HUB TO RECUPACAD');
          EXECUTE IMMEDIATE ('GRANT SELECT ON ' || V_ESQUEMA_MIN || '.SCM_STOCK_CUENTAS_MARCADO_HUB TO SV00450');      		
		  
		EXCEPTION
		WHEN OTHERS THEN
		  NULL ;
		END ;
	
		DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON ÉXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit