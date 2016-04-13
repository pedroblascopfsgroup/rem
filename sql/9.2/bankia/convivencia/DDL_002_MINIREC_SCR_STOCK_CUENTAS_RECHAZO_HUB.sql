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

    /*  tabla SCR_STOCK_CUENTAS_RECHAZO_HUB <-- ELIMINAR */

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla SCR_STOCK_CUENTAS_RECHAZO_HUB');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'SCR_STOCK_CUENTAS_RECHAZO_HUB';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB... Tabla borrada OK');
	else
	  DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB... No existe');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB (
	    SCR_CODIGO_REGISTRO_ENLACE      VARCHAR2(1 CHAR)            ,
		SCR_CODIGO_PROPIETARIO          NUMBER(5)	      NOT NULL  ,
		SCR_TIPO_PRODUCTO	          	NUMBER(5)	      NOT NULL  ,
		SCR_NUMERO_CONTRATO	          	NUMBER(17)	      NOT NULL  ,
		SCR_NUMERO_ESPEC	          	NUMBER(15)	      NOT NULL  ,
		SCR_LITIGIO_PRELITIGIO			VARCHAR2(1 CHAR)  			,
		SCR_CONCURSO	                VARCHAR2(1 CHAR)  			,
		SCR_FECHA_PROCESO 				NUMBER(8)         NOT NULL  ,
		SCR_RECHAZO_DESC                VARCHAR2(40 CHAR)  			,
		SCR_AUX                         VARCHAR2(132 CHAR) 			,
		USUARIOCREAR      				VARCHAR2(50 CHAR) 			,
		FECHACREAR        				TIMESTAMP(6)      			,
		USUARIOMODIFICAR  				VARCHAR2(50 CHAR)           ,
		FECHAMODIFICAR    				TIMESTAMP(6)                ,		
		VERSION           				INTEGER DEFAULT 0 NOT NULL  , 
		USUARIOBORRAR     				VARCHAR2(50 CHAR)		    ,
		FECHABORRAR       				TIMESTAMP(6)                ,
		BORRADO           				NUMBER(1) DEFAULT 0 NOT NULL	) ' ;    		
  		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MIN || '.SCR_STOCK_CUENTAS_RECHAZO_HUB... Tabla creada');	
		
		EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA_MIN || '.IDX_SCR_STOCK_CUENTAS_RECHAZOS ON ' || V_ESQUEMA_MIN || '.SCR_STOCK_CUENTAS_RECHAZO_HUB (SCR_CODIGO_PROPIETARIO,SCR_TIPO_PRODUCTO,SCR_NUMERO_CONTRATO,SCR_NUMERO_ESPEC) ' ;		
		
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MIN || '.IDX_SCR_STOCK_CUENTAS_RECHAZOS... Indice creado');								
		
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB.SCR_CODIGO_REGISTRO_ENLACE  is ''SIEMPRE 2                                                                                                    '' ';       
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB.SCR_CODIGO_PROPIETARIO      is ''Código que indica la entidad propietaria de la cartera (ej. Bankia, SAREB, otros)                            '' ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB.SCR_TIPO_PRODUCTO	      	  is ''Catalogación del producto en la entidad.(Código según Dic. Datos)	Informar PRODUCTO URSUS BANKIA (COTIPP) '' ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB.SCR_NUMERO_CONTRATO	      is ''Identificador de la operación                                                                                '' ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB.SCR_NUMERO_ESPEC	      	  is ''Identificador de condiciones especiales de contratación                                                      '' ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB.SCR_LITIGIO_PRELITIGIO	  is ''VALORES POSIBLES :		L (LITIGIO)P (PRELITIGIO)                                                           '' ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB.SCR_CONCURSO	          	  is ''“BLANCO /X”	 X CONCURSO O SEGMENTO G ´ ´ SIN CONCURSO                                                        '' ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB.SCR_FECHA_PROCESO 		  is ''	                                                                                                            '' ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB.SCR_RECHAZO_DESC            is ''Texto libre con lo que indique la aplicación operativa 	VARCHAR2 (40)		                                '' ';
		EXECUTE IMMEDIATE  'comment on column '|| V_ESQUEMA_MIN ||'.SCR_STOCK_CUENTAS_RECHAZO_HUB.SCR_AUX                     is ''                                                                                                             '' ';		
		
		BEGIN
		
          EXECUTE IMMEDIATE ('GRANT SELECT ON ' || V_ESQUEMA_MIN || '.SCR_STOCK_CUENTAS_RECHAZO_HUB TO RECUPACAD');
          EXECUTE IMMEDIATE ('GRANT SELECT ON ' || V_ESQUEMA_MIN || '.SCR_STOCK_CUENTAS_RECHAZO_HUB TO SV00450');      				
    
		EXCEPTION
		WHEN OTHERS THEN
		  NULL ;
		END ;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit