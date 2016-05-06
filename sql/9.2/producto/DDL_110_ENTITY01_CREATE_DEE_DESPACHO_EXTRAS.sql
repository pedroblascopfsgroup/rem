--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160502
--## ARTEFACTO=produc
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1272
--## PRODUCTO=SI
--##
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

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
BEGIN

    -- ******** DEE_DESPACHO_EXTRAS *******
    DBMS_OUTPUT.PUT_LINE('******** DEE_DESPACHO_EXTRAS ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DEE_DESPACHO_EXTRAS'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.DEE_DESPACHO_EXTRAS
               	(DES_ID							NUMBER(16) 		 	NOT NULL ENABLE  
				,DEE_CONTRATO_VIGOR				NUMBER(5,0)
				,DEE_SERVICIO_INTEGRAL			NUMBER(1,0)   		DEFAULT 0
				,DEE_FECHA_SERVICIO_INTEGRAL	TIMESTAMP(6)
				,DEE_CLASIF_CONCURSOS			NUMBER(1)			DEFAULT 0
				,DEE_CLASIF_PERFIL				NUMBER(5,0) 
				,DEE_REL_BANKIA					NUMBER(5,0)
				,DEE_FAX						VARCHAR2(100 CHAR)
				,DEE_COD_AGENTE					NUMBER(3,0)
				,DEE_COD_EST_ASE				VARCHAR2(1 CHAR)
				,DEE_OFICINA_CONTACTO			VARCHAR2(5 CHAR)
				,DEE_ENTIDAD_CONTACTO			VARCHAR2(5 CHAR)
				,DEE_FECHA_ALTA					TIMESTAMP(6)
				,DEE_ENTIDAD_LIQUIDACION		VARCHAR2(4 CHAR)
				,DEE_OFICINA_LIQUIDACION		VARCHAR2(4 CHAR)
				,DEE_DIGCON_LIQUIDACION			VARCHAR2(2 CHAR)
				,DEE_CUENTA_LIQUIDACION			VARCHAR2(10 CHAR)
				,DEE_ENTIDAD_PROVISIONES		VARCHAR2(4 CHAR)
				,DEE_OFICINA_PROVISIONES		VARCHAR2(4 CHAR)
				,DEE_DIGCON_PROVISIONES			VARCHAR2(2 CHAR)
				,DEE_CUENTA_PROVISIONES			VARCHAR2(10 CHAR)
				,DEE_ENTIDAD_ENTREGAS			VARCHAR2(4 CHAR)
				,DEE_OFICINA_ENTREGAS			VARCHAR2(4 CHAR)
				,DEE_DIGCON_ENTREGAS			VARCHAR2(2 CHAR)
				,DEE_CUENTA_ENTREGAS			VARCHAR2(10 CHAR)
				,DEE_CENTRO_RECUP				VARCHAR2(60 CHAR)
				,DEE_CORREO_ELECTRONICO			VARCHAR2(100 CHAR)
				,DEE_ACEPTACION_ACCESO			NUMBER(1)			DEFAULT 0
				,DEE_TIPO_DOC					VARCHAR2(1 CHAR)
				,DEE_DOCUMENTO					VARCHAR2(10 CHAR)
				,DEE_ASESORIA					NUMBER(1)			DEFAULT 0
				,DEE_IVA_APL					NUMBER(5,2)
				,DEE_IVA_DES					NUMBER(5,0) 
				,DEE_IRPF_APL					NUMBER(5,2)
				,DEE_TIPO_CONTRATO				VARCHAR2(4 CHAR)
				,DEE_SUBTIPO_CONTRATO			VARCHAR2(4 CHAR)
 				,VERSION 				  	  	INTEGER DEFAULT 0   NOT NULL
  			   	,USUARIOCREAR              	  	VARCHAR2(50 CHAR)   NOT NULL
  			   	,FECHACREAR                	  	TIMESTAMP(6)        NOT NULL
  			   	,USUARIOMODIFICAR          	  	VARCHAR2(50 CHAR)
  			   	,FECHAMODIFICAR            	  	TIMESTAMP(6)
  			   	,USUARIOBORRAR             	  	VARCHAR2(50 CHAR)
  			   	,FECHABORRAR               	  	TIMESTAMP(6)
  			   	,BORRADO                   	  	NUMBER(1)           DEFAULT 0  NOT NULL
			   	,CONSTRAINT PK_DEE_DESPACHO_EXTRAS_ID PRIMARY KEY (DES_ID)
				,CONSTRAINT FK_DEE_DES FOREIGN KEY (DES_ID) REFERENCES '|| V_ESQUEMA ||'.DES_DESPACHO_EXTERNO (DES_ID)
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DEE_DESPACHO_EXTRAS... Tabla creada');
		
		-- No creo secuencia, ya que la PK de esta tabla es el DES_ID de DES_DESPACHO_EXTERNO.
		
		--COMENTARIOS ANYADIDOS A LA TABLA PARA ENTENDER MEJOR ALGUNAS COLUMNAS DE FORMA DIRECTA
		V_MSQL := 'comment on column '||v_esquema||'.DEE_DESPACHO_EXTRAS.DEE_CONTRATO_VIGOR IS ''Valores posibles:[0/1/2/3] --> [Historico Caja / Acuerdo 2011 / 2014 / 2015] - MAPEADOS en recovery''';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'comment on column '||v_esquema||'.DEE_DESPACHO_EXTRAS.DEE_CLASIF_CONCURSOS IS ''Indica si el despacho puede llevar o no concursos''';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'comment on column '||v_esquema||'.DEE_DESPACHO_EXTRAS.DEE_CLASIF_PERFIL IS ''Tipo de perfil del despacho. Valores posibles:[0/1/2] --> [A/B/C] - MAPEADOS en recovery''';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'comment on column '||v_esquema||'.DEE_DESPACHO_EXTRAS.DEE_REL_BANKIA IS ''Relacion Bankia. Valores posibles:[0/1/2/3/4] --> [En devinculacion/Sin turno/Sin acceso/Turno Activo/Historico] - MAPEADOS en recovery''';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'comment on column '||v_esquema||'.DEE_DESPACHO_EXTRAS.DEE_FECHA_ALTA IS ''Fecha en la que se dio de alta el despacho en los sistemas Bankia''';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'comment on column '||v_esquema||'.DEE_DESPACHO_EXTRAS.DEE_TIPO_DOC IS ''Es el tipo de documento (Tipo CIF) del despacho''';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'comment on column '||v_esquema||'.DEE_DESPACHO_EXTRAS.DEE_DOCUMENTO IS ''CIF del despacho''';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'comment on column '||v_esquema||'.DEE_DESPACHO_EXTRAS.DEE_IVA_DES IS ''Descripcion impuesto. Valores posibles:[0/1] --> [IGIC/IVA] - MAPEADOS en recovery''';
		EXECUTE IMMEDIATE V_MSQL;
		V_MSQL := 'comment on column '||v_esquema||'.DEE_DESPACHO_EXTRAS.DEE_COD_EST_ASE IS ''Estado del letrado/procurador a nivel operativo. Valores posibles:[0/1] --> [Alta/Baja] - MAPEADOS en recovery (Si esta de Alta en recovery o se le ha dado de Baja)''';
		EXECUTE IMMEDIATE V_MSQL;
		
		COMMIT;
    END IF;
    
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