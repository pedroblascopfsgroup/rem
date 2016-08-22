--/*
--##########################################
--## AUTOR=Manuel Rodriguez
--## FECHA_CREACION=20160418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla auxiliar para almacenar la información generada para PRINEX sobre los activos.
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_ACT_PRINEX'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla auxiliar para almacenar la información generada para PRINEX sobre los activos.'; -- Vble. para los comentarios de las tablas

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;

	-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		
	END IF; 
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
    APR_ID                                       NUMBER(16,0)                    NOT NULL,
    NUMERO_PRINEX                        NUMBER(16,0)                    NOT NULL,
    PROYECTO                                 NUMBER(4,0),
    TIPO                                         VARCHAR2(2 CHAR),   
    CLAVE1                                        VARCHAR2(3 CHAR),   
    CLAVE2                                    VARCHAR2(3 CHAR),   
    CLAVE3                                       VARCHAR2(3 CHAR),   
    CLAVE4                                        VARCHAR2(3 CHAR),
    DESCRIPCION                               VARCHAR2(60 CHAR),
    PROPANTERIOR                            VARCHAR2(80 CHAR),
    F_COMPRA_ADJ                              VARCHAR2(10 CHAR),
    PAIS                                              NUMBER(2,0),
    CAUTONOMA                                 NUMBER(2,0),
    PROVINCIA                                  NUMBER(2,0),
    COD_POBLACION                          NUMBER(9,0),
    SIGLA                                           VARCHAR2(2 CHAR),
    VIAPUBLICA                                 VARCHAR2(50 CHAR),
    NUMERO                                         NUMBER(5,0),
    BLOQUE                                        VARCHAR2(3 CHAR),
    PORTAL                                     VARCHAR2(3 CHAR),
    ESCALERA                                   VARCHAR2(3 CHAR),
    PISO                                            VARCHAR2(3 CHAR),
    PUERTA                                       VARCHAR2(3 CHAR),
    CODPOSTAL                               VARCHAR2(10 CHAR),
    POBLACION                                 VARCHAR2(50 CHAR), 
    OTROS                                             VARCHAR2(60 CHAR),
    GOOGLEMAP                                 VARCHAR2(100 CHAR),
    M2CONST                                      NUMBER(9,3),
    M2UTILES                                      NUMBER(9,3),
    M2ZONCOM                                   NUMBER(9,3),
    NDORMITORIOS                              NUMBER(4,0),
    NBANOS                                       NUMBER(4,0),
    ORIENTACION                               VARCHAR2(15 CHAR),
    TENDEDERO                                  VARCHAR2(1 CHAR),
    NPLANTAS                                      NUMBER(5,0),
    NBALCONES                                       NUMBER(5,0),
    NTERRAZAS                                    NUMBER(5,0),
    M2TERRAZA                                     NUMBER(9,3),
    M2JARDIN                                       NUMBER(9,3),
    PARCELA                                        VARCHAR2(10 CHAR),
    CUOTABLOQUE                                       NUMBER(7,4),
    CUOTAURBAN                                   NUMBER(7,4),  
    NFINCADH                                            NUMBER(10,0),
    LETRAFINCADH                                  VARCHAR2(1 CHAR),
    LUGARREG                                          VARCHAR2(30 CHAR),
    NUMREGPROP                                     NUMBER(4,0),
    FECHAINC                                         VARCHAR2(10 CHAR),
    SECCION                                          VARCHAR2(7 CHAR),
    FOLIO                                               VARCHAR2(7 CHAR),
    LIBRO                                                 VARCHAR2(7 CHAR),
    TOMO                                                 VARCHAR2(7 CHAR),
    FINCA                                              VARCHAR2(10 CHAR),
    INSCRIPCION                                      VARCHAR2(7 CHAR),
    NATURALEZA                                      VARCHAR2(1 CHAR),
    REF_CATASTRAL                                  VARCHAR2(25 CHAR),
    VALOR_CATASTRAL                             NUMBER(13,2),
    VALOR_CSUELO                                     NUMBER(13,2),
    VALOR_CVUELO                                  NUMBER(13,2),
    FECHA_ACTUALIZACION                        VARCHAR2(10 CHAR),
    TASACION_TOTAL                                 NUMBER(13,2),
    VALOR_MERCADO                                  NUMBER(13,2),
    VALOR_SUELO                                          NUMBER(13,2),
    VALOR_SEGURO                                       NUMBER(13,2),
    VALOR_LIQUIDATIVO                                 NUMBER(13,2),
    VALOR_OBRA_TERMINADA                          NUMBER(13,2), 
    PORCENTAJE_OBRA_EJECUTADA               NUMBER(5,2),
    POR_AJUSTE                                            NUMBER(5,2),
    TASACION_MODIFICADA                           NUMBER(13,2),  
    CIF_TASADORA                                        VARCHAR2(15 CHAR),
    EMP_TASADORA                                      VARCHAR2(50 CHAR),
    FECHA_TASAC                                         VARCHAR2(10 CHAR),
    EXPEDIENTE                                            VARCHAR2(30 CHAR),
    TASADOR                                               VARCHAR2(50 CHAR),
    TIPO_TASACION                                       VARCHAR2(10 CHAR),
    FECHA_CADUCIDAD                                 VARCHAR2(10 CHAR),
    TASACION_ACTIVA                                   VARCHAR2(1 CHAR),
    F_VIGENCIA_D                                          VARCHAR2(10 CHAR),
    F_VIGENCIA_H                                         VARCHAR2(10 CHAR),
    CONDICIONANTES                                    VARCHAR2(1 CHAR),
    OBSERV_COND                                         VARCHAR2(128 CHAR), 
    ORDEN_ECO                                             VARCHAR2(1 CHAR),
    OBSERV_ORDEN                                      VARCHAR2(128 CHAR), 
    ADVERTENCIAS                                        VARCHAR2(1 CHAR),
    OBSERV_ADVER                                       VARCHAR2(128 CHAR), 
    CODIGO_1                                                   VARCHAR2(15 CHAR),
    VALOR_1                                                   VARCHAR2(40 CHAR),
    CODIGO_2                                                   VARCHAR2(15 CHAR),
    VALOR_2                                                   VARCHAR2(40 CHAR),
    CODIGO_3                                                   VARCHAR2(15 CHAR),
    VALOR_3                                                   VARCHAR2(40 CHAR),
    CODIGO_4                                                   VARCHAR2(15 CHAR),
    VALOR_4                                                  VARCHAR2(40 CHAR),
    CODIGO_5                                                   VARCHAR2(15 CHAR),
    VALOR_5                                                   VARCHAR2(40 CHAR),
    CODIGO_6                                                   VARCHAR2(15 CHAR),
    VALOR_6                                                   VARCHAR2(40 CHAR),
    CODIGO_7                                                   VARCHAR2(15 CHAR),
    VALOR_7                                                   VARCHAR2(40 CHAR),
    CODIGO_8                                                  VARCHAR2(15 CHAR),
    VALOR_8                                                   VARCHAR2(40 CHAR),
    CODIGO_9                                                   VARCHAR2(15 CHAR),
    VALOR_9                                                   VARCHAR2(40 CHAR),
    CODIGO_10                                                VARCHAR2(15 CHAR),
    VALOR_10                                                  VARCHAR2(40 CHAR),
    TIPO_CONTRATO                                        VARCHAR2(2 CHAR),
    CONTRATO_DEUDA                                    VARCHAR2(24 CHAR),
    OFICINA_DEUDA                                          VARCHAR2(4 CHAR),
    IMPORTE_DEUDA                                       NUMBER(13,2),
    NOMBRE_DEUDOR                                     VARCHAR2(30 CHAR),
    APELLIDOS_DEUDOR                                    VARCHAR2(80 CHAR),
    TIPO_DOCUMENTO_DEUDOR                       VARCHAR2(1 CHAR),
    DOCUMENTO_DEUDOR                              VARCHAR2(15 CHAR)
	)    
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	

	-- Creamos indice	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(APR_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');
	
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (APR_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
	
	
	-- Creamos sequence
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
	
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');
	
COMMIT;



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
