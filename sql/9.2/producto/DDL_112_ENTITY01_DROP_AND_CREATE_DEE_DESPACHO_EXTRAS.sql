--/*
--##########################################
--## AUTOR=RAFAEL ARACIL  
--## FECHA_CREACION=20160616
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1963
--## PRODUCTO=SI
--## Finalidad: DDL Creación de la tabla DEE_DESPACHO_EXTRAS
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_DDNAME VARCHAR2(50 CHAR):= 'DEE_DESPACHO_EXTRAS';
   --Valores a insertar
    TYPE T_TIPO IS TABLE OF VARCHAR2(4000 CHAR);
    TYPE T_ARRAY IS TABLE OF T_TIPO;
    V_TIPO T_ARRAY := T_ARRAY(
      T_TIPO('DD_DCV_ID','DD_DCV_DESPACHO_CNT_VIGOR')
     ,T_TIPO('DD_DCP_ID','DD_DCP_DESPACHO_CLASI_PERFIL')
     ,T_TIPO('DD_DRE_ID','DD_DRE_DESPACHO_REL_ENTIDAD')
     ,T_TIPO('DD_DCE_ID','DD_DCE_DESPACHO_COD_ESTADO')
     ,T_TIPO('DD_DID_ID','DD_DID_DESPACHO_IVA_DES')
     ,T_TIPO('DES_ID','DES_DESPACHO_EXTERNO')
    ); 
 V_TMP_TIPO T_TIPO;

    V_ENTIDAD_ID NUMBER(16);
    BEGIN

    -- ******** DEE_DESPACHO_EXTRAS *******
    DBMS_OUTPUT.PUT_LINE('******** DEE_DESPACHO_EXTRAS ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS... Comprobaciones previas'); 
    
    -- Creacion Tabla DEE_DESPACHO_EXTRAS
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DEE_DESPACHO_EXTRAS'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS... Tabla YA EXISTE, BORRAMOS');   
            V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS';
	        	EXECUTE IMMEDIATE V_MSQL;
    END IF;  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS
               (
               DEE_ID	NUMBER(16,0)	,
DES_ID	NUMBER(16,0) NOT NULL	,
DD_DCV_ID	NUMBER(16,0)	,
DEE_SERVICIO_INTEGRAL	NUMBER(1,0) DEFAULT 0	,
DEE_FECHA_SERVICIO_INTEGRAL	TIMESTAMP(6)	,
DEE_CLASIF_CONCURSOS	NUMBER(1,0)	DEFAULT 0,
DD_DCP_ID	NUMBER(16,0)	,
DD_DRE_ID	NUMBER(16,0)	,
DEE_FAX	VARCHAR2(100 CHAR)	,
DEE_COD_AGENTE	NUMBER(3,0)	,
DD_DCE_ID	NUMBER(16,0)	,
DEE_OFICINA_CONTACTO	VARCHAR2(5 CHAR)	,
DEE_ENTIDAD_CONTACTO	VARCHAR2(5 CHAR)	,
DEE_FECHA_ALTA	TIMESTAMP(6)	,
DEE_ENTIDAD_LIQUIDACION	VARCHAR2(4 CHAR)	,
DEE_OFICINA_LIQUIDACION	VARCHAR2(4 CHAR)	,
DEE_DIGCON_LIQUIDACION	VARCHAR2(2 CHAR)	,
DEE_CUENTA_LIQUIDACION	VARCHAR2(10 CHAR)	,
DEE_ENTIDAD_PROVISIONES	VARCHAR2(4 CHAR)	,
DEE_OFICINA_PROVISIONES	VARCHAR2(4 CHAR)	,
DEE_DIGCON_PROVISIONES	VARCHAR2(2 CHAR)	,
DEE_CUENTA_PROVISIONES	VARCHAR2(10 CHAR)	,
DEE_ENTIDAD_ENTREGAS	VARCHAR2(4 CHAR)	,
DEE_OFICINA_ENTREGAS	VARCHAR2(4 CHAR)	,
DEE_DIGCON_ENTREGAS	VARCHAR2(2 CHAR)	,
DEE_CUENTA_ENTREGAS	VARCHAR2(10 CHAR)	,
DEE_CENTRO_RECUP	VARCHAR2(60 CHAR)	,
DEE_CORREO_ELECTRONICO	VARCHAR2(100 CHAR)	,
DEE_ACEPTACION_ACCESO	NUMBER(1,0)	DEFAULT 0,
DD_TDI_ID	NUMBER(16,0)	,
DEE_DOCUMENTO	VARCHAR2(10 CHAR)	,
DEE_ASESORIA	NUMBER(1,0)	,
DEE_IVA_APL	NUMBER(5,2)	,
DD_DID_ID	NUMBER(16,0)	,
DEE_IRPF_APL	NUMBER(5,2)	,
DEE_TIPO_CONTRATO	VARCHAR2(4 CHAR)	,
DEE_SUBTIPO_CONTRATO	VARCHAR2(4 CHAR)	,
VERSION	NUMBER(38,0)	NOT NULL,
USUARIOCREAR	VARCHAR2(50 CHAR)	NOT NULL,
FECHACREAR	TIMESTAMP(6)	NOT NULL,
USUARIOMODIFICAR	VARCHAR2(50 CHAR)	,
FECHAMODIFICAR	TIMESTAMP(6)	,
USUARIOBORRAR	VARCHAR2(50 CHAR)	,
FECHABORRAR	TIMESTAMP(6)	,
BORRADO	NUMBER(1,0)	NOT NULL

			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DEE_DESPACHO_EXTRAS... Tabla creada');
		
    
    
		V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.DEE_DESPACHO_EXTRAS ADD CONSTRAINT PK_DEE_ID PRIMARY KEY (DEE_ID)';
  		EXECUTE IMMEDIATE V_MSQL;

      
  		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.PK_DEE_ID... PK creada');
		
    SELECT COUNT(1) INTO V_NUM_TABLAS FROM ALL_SEQUENCES WHERE UPPER(SEQUENCE_NAME) = 'S_DEE_DESPACHO_EXTRAS'  and UPPER(SEQUENCE_owner) = '' || V_ESQUEMA || '';
		
		        IF V_NUM_TABLAS = 0 THEN
    			  
            DBMS_OUTPUT.PUT_LINE('[INFO] Creamos SECUENCIA');
    
  	    execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_DEE_DESPACHO_EXTRAS  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DEE_DESPACHO_EXTRAS... Secuencia creada correctamente.');
		
    END IF;
    
      FOR I IN V_TIPO.FIRST .. V_TIPO.LAST
   
       LOOP
            V_TMP_TIPO := V_TIPO(I);
    
            SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_constraints WHERE UPPER(constraint_name) = 'FK_DEE_'||V_TMP_TIPO(1)||''  and UPPER(owner) = '' || V_ESQUEMA || '';
		
		        IF V_NUM_TABLAS = 0 THEN
    			  
            DBMS_OUTPUT.PUT_LINE('[INFO] Creamos FK  FK_DEE_'||V_TMP_TIPO(1)||'');

			      EXECUTE IMMEDIATE 'alter table ' || V_ESQUEMA || '.' || V_DDNAME|| ' ADD constraint FK_DEE_'||V_TMP_TIPO(1)||'
            FOREIGN KEY ('||V_TMP_TIPO(1)||')
            REFERENCES '||V_TMP_TIPO(2)||'('||V_TMP_TIPO(1)||')';
			      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || V_DDNAME|| ' modificado: FK  FK_DEE_'||V_TMP_TIPO(1)||' CREADA');

    V_MSQL := 'CREATE  INDEX ' || V_ESQUEMA || '.IDX_DEE_'||V_TMP_TIPO(1)||' ON ' || V_ESQUEMA || '.' || V_DDNAME|| '
					('||V_TMP_TIPO(1)||')  TABLESPACE ' || V_TS_INDEX;
		EXECUTE IMMEDIATE V_MSQL;
		
            END IF;	
       
       END LOOP;
    
    
    
    
    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;
