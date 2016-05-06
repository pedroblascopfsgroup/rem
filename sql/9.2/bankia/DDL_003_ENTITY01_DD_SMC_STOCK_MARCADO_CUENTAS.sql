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

    /*  tabla DD_SMC_STOCK_MARCADO_CUENTAS <-- ELIMINAR */

    DBMS_OUTPUT.PUT_LINE('[START] DROP TABLE tabla DD_SMC_STOCK_MARCADO_CUENTAS');

    select count(1) into V_NUM_TABLAS from ALL_TABLES where table_name = 'DD_SMC_STOCK_MARCADO_CUENTAS';
    if V_NUM_TABLAS > 0 then
        EXECUTE IMMEDIATE ' DROP TABLE '|| V_ESQUEMA ||'.DD_SMC_STOCK_MARCADO_CUENTAS CASCADE CONSTRAINTS';
            DBMS_OUTPUT.PUT_LINE('DROP TABLE '|| V_ESQUEMA ||'.DD_SMC_STOCK_MARCADO_CUENTAS... Tabla borrada OK');
	else
	  DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.DD_SMC_STOCK_MARCADO_CUENTAS... No existe');
    end if;
            
    EXECUTE IMMEDIATE '    
    CREATE TABLE '|| V_ESQUEMA ||'.DD_SMC_STOCK_MARCADO_CUENTAS (
        DD_SMC_ID                       NUMBER(16,0)      NOT NULL  ,
		DD_SMC_CODIGO                   VARCHAR2(50 CHAR) NOT NULL  ,
		DD_SMC_DESCRIPCION              VARCHAR2(50 CHAR)   		,
		DD_SMC_DESCRIPCION_LARGA        VARCHAR2(250 CHAR)         	,
		USUARIOCREAR      				VARCHAR2(50 CHAR) 			,
		FECHACREAR        				TIMESTAMP(6)      			,
		USUARIOMODIFICAR  				VARCHAR2(50 CHAR)           ,
		FECHAMODIFICAR    				TIMESTAMP(6)                ,		
		VERSION           				INTEGER DEFAULT 0 NOT NULL  , 
		USUARIOBORRAR     				VARCHAR2(50 CHAR)		    ,
		FECHABORRAR       				TIMESTAMP(6)                ,
		BORRADO           				NUMBER(1) DEFAULT 0 NOT NULL	) ' ;    		
  		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_SMC_STOCK_MARCADO_CUENTAS... Tabla creada');	
		
		EXECUTE IMMEDIATE 'CREATE INDEX ' || V_ESQUEMA || '.IDX_DD_SMC_STOCK_MARCA_CUENTAS ON ' || V_ESQUEMA || '.DD_SMC_STOCK_MARCADO_CUENTAS (DD_SMC_ID) ' ;		
		
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.IDX_DD_SMC_STOCK_MARCA_CUENTAS... Indice creado');	
		
		DBMS_OUTPUT.PUT_LINE('[START] CREAMOS SECUENCIA S_DD_SMC_STOCK_MARCADO_CUENTAS');

		    -- Comprobamos si existe la secuencia

			EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_SMC_STOCK_MARCADO_CUENTAS'' 
					 and sequence_owner = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS; 

			-- Si existe secuencia la borramos
			IF V_NUM_TABLAS = 1 THEN
			  EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_DD_SMC_STOCK_MARCADO_CUENTAS';
			  DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_SMC_STOCK_MARCADO_CUENTAS... Secuencia eliminada');    
			END IF; 
			
			EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DD_SMC_STOCK_MARCADO_CUENTAS INCREMENT BY 1 MAXVALUE 999999999999999999999999999 MINVALUE 1 CACHE 20'; 
			DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_SMC_STOCK_MARCADO_CUENTAS... Secuencia creada');					
		
		
		DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit