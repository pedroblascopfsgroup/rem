--/*
--##########################################
--## AUTOR=Sergio Hernández
--## FECHA_CREACION=20180720
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para la carga masiva
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(2400 CHAR) := 'GPL_GASTOS_PRINEX_LBK'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(100 CHAR):= 'Tabla para datos auxiliares de gastos para convivencia con PRINEX'; -- Vble. para los comentarios de las tablas

BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. La borramos');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' ';
		
	END IF; 
		
		
		-- Creamos la tabla
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA||'...');
		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TABLA||'
                (
                  GPV_NUM_GASTO_HAYA      NUMBER(16,0) NOT NULL,
                  GPL_FECHA_CONTABLE      DATE,
                  GPL_DIARIO_CONTB        VARCHAR2(20 CHAR),
                  GPL_D347                VARCHAR2(20 CHAR),
                  GPL_DELEGACION          VARCHAR2(20 CHAR),
                  GPL_BASE_RETENCION      NUMBER(16,2),
                  GPL_PROCENTAJE_RETEN    NUMBER(5,2),
                  GPL_IMPORTE_RENTE       NUMBER(16,2),
                  GPL_APLICAR_RETENCION   VARCHAR2(20 CHAR),
                  GPL_BASE_IRPF           NUMBER(16,2),
                  GPL_PROCENTAJE_IRPF     NUMBER(5,2),
                  GPL_IMPORTE_IRPF        NUMBER(16,2),
                  GPL_CLAVE_IRPF          VARCHAR2(20 CHAR),
                  GPL_SUBCLAVE_IRPF       VARCHAR2(20 CHAR),
                  GPL_CEUTA               VARCHAR2(20 CHAR),
                  GPL_CTA_IVAD            VARCHAR2(20 CHAR),
                  GPL_SCTA_IVAD           VARCHAR2(20 CHAR),
                  GPL_CONDICIONES         VARCHAR2(20 CHAR),
                  GPL_CTA_BANCO           VARCHAR2(20 CHAR),
                  GPL_SCTA_BANCO          VARCHAR2(20 CHAR),
                  GPL_CTA_EFECTOS         VARCHAR2(20 CHAR),
                  GPL_SCTA_EFECTOS        VARCHAR2(20 CHAR),
                  GPL_APUNTE              VARCHAR2(20 CHAR),
                  GPL_CENTRODESTINO       VARCHAR2(20 CHAR),
                  GPL_TIPO_FRA_SII        VARCHAR2(20 CHAR),
                  GPL_CLAVE_RE            VARCHAR2(20 CHAR),
                  GPL_CLAVE_RE_AD1        VARCHAR2(20 CHAR),
                  GPL_CLAVE_RE_AD2        VARCHAR2(20 CHAR),
                  GPL_TIPO_OP_INTRA       VARCHAR2(20 CHAR),
                  GPL_DESC_BIENES         VARCHAR2(200 CHAR),
                  GPL_DESCRIPCION_OP      VARCHAR2(200 CHAR),
                  GPL_SIMPLIFICADA        VARCHAR2(20 CHAR),
                  GPL_FRA_SIMPLI_IDEN     VARCHAR2(20 CHAR),
                  GPL_DIARIO1             VARCHAR2(20 CHAR),
                  GPL_DIARIO2             VARCHAR2(20 CHAR),
                  GPL_TIPO_PARTIDA        VARCHAR2(20 CHAR),
                  GPL_APARTADO            VARCHAR2(20 CHAR),
                  GPL_CAPITULO            VARCHAR2(20 CHAR),
                  GPL_PARTIDA             VARCHAR2(20 CHAR),
                  GPL_CTA_GASTO           VARCHAR2(20 CHAR),
                  GPL_SCTA_GASTO          VARCHAR2(20 CHAR),
                  GPL_REPERCUTIR          VARCHAR2(20 CHAR),
                  GPL_CONCEPTO_FAC        VARCHAR2(20 CHAR),
                  GPL_FECHA_FAC           DATE,
                  GPL_COD_COEF            VARCHAR2(20 CHAR),
                  GPL_CODI_DIAR_IVA_V     VARCHAR2(20 CHAR),
                  GPL_PCTJE_IVA_V         NUMBER(5,2),
                  GPL_NOMBRE              VARCHAR2(20 CHAR),
                  GPL_CARACTERISTICA      VARCHAR2(20 CHAR),
                  VERSION                 NUMBER(38,0)        DEFAULT 0 NOT NULL ENABLE, 
                  USUARIOCREAR            VARCHAR2(10 CHAR)       NOT NULL ENABLE, 
                  FECHACREAR              TIMESTAMP (6)         NOT NULL ENABLE, 
                  USUARIOMODIFICAR        VARCHAR2(10 CHAR), 
                  FECHAMODIFICAR          TIMESTAMP (6), 
                  USUARIOBORRAR           VARCHAR2(10 CHAR), 
                  FECHABORRAR             TIMESTAMP (6), 
                  BORRADO                 NUMBER(1,0)         DEFAULT 0 NOT NULL ENABLE
                )

		LOGGING 
		NOCOMPRESS 
		NOCACHE
		NOPARALLEL
		NOMONITORING
		';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');
		
		V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.GPV_NUM_GASTO_HAYA IS ''PK de la tabla. Enlaza con GPV_GASTOS_PROVEEDOR''';
		EXECUTE IMMEDIATE V_MSQL;


		-- Creamos primary key
		V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (GPV_NUM_GASTO_HAYA) USING INDEX)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'_PK... PK creada.');
		

		
		-- Creamos comentario	
		V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');
		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');

	
	COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
