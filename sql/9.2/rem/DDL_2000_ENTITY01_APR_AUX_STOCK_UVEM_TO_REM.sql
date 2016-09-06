--/*
--##########################################
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20160902
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=HREOS-788
--## PRODUCTO=NO
--## Finalidad: Interfax Stock UVEM-REM
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_STOCK_UVEM_TO_REM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla auxiliar para almacenar la información de alta de activos procedentes de fichero.'; -- Vble. para los comentarios de las tablas

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
		APR_ID 							NUMBER(9) NOT NULL, 
		ACT_NUMERO_UVEM					NUMBER(9) NOT NULL,
		FEC_FORMALIZACION 				DATE,
		COD_ENTRADA_ACTIVO 				VARCHAR2(2 CHAR) NOT NULL,
		COD_ESTADO_VENTA_ACTIVO 		VARCHAR2(2 CHAR) NOT NULL,
		FEC_BAJA_ACTIVO 				DATE NOT NULL,
		PORCENTAJE_PROPIEDAD 			NUMBER(6,3) NOT NULL,
		GRADO_PROPIEDAD 				NUMBER(2) NOT NULL,
		TIPO_RIESGO 					NUMBER(5) NOT NULL,
		NUM_EXP_RIESGO 					VARCHAR2(20 CHAR) NOT NULL,
		FEC_PRESENTACION_HACIENDA 		DATE NOT NULL,
		FEC_PRESENTACION_REGISTRO 		DATE NOT NULL,
		FEC_INSCRIPCION_TITULO 			DATE NOT NULL,
		INDICADOR_NECES_LANZAMIENTO 	NUMBER(1) NOT NULL,
		FEC_REALIZADA_POSESION 			DATE NOT NULL,
		NUM_LIBRO_ESCRITURA 			NUMBER(6) NOT NULL,
		NUM_TOMO_ESCRITURA 				NUMBER(6) NOT NULL,
		NUM_FOLIO_ESCRITURA 			NUMBER(6) NOT NULL,
		NUM_INSCRIPCION_REGISTRO 		NUMBER(8) NOT NULL,
		IMPORTE_ADJUDICACION 			NUMBER(16,3) NOT NULL,
		FEC_ENTREGA_TITULO_GESTOR 		DATE NOT NULL,
		FEC_ENVIO_AUTO_ADICCION 		DATE NOT NULL,
		FEC_SEGUNDA_PRESEN_REG 			DATE NOT NULL,
		FEC_SUBASTA 					DATE NOT NULL,
		RESULTADO_SUBASTA 				VARCHAR2(1 CHAR) NOT NULL,
		FEC_RECEP_ACTA_SUBASTA 			DATE NOT NULL,
		VALOR_JUDICIAL 					NUMBER(16,3) NOT NULL,
		FEC_INICIO_CONTRATO 			DATE NOT NULL,
		NOMBRE_ARRENDATARIO 			VARCHAR2(35 CHAR) NOT NULL,
		FEC_SOLICITUD_MORATORIA 		DATE NOT NULL,
		COD_RESOL_MORATORIA 			VARCHAR2(1 CHAR) NOT NULL,
		FEC_RESOL_MORATORIA 			DATE NOT NULL,
		LLAVES_NECESARIAS 				VARCHAR2(1 CHAR) NOT NULL,
		FEC_RECEP_LLAVES 				DATE NOT NULL,
		FEC_ENVIO_LLAVES_GESTOR 		DATE NOT NULL,
		NUM_AUTOS_JUZGADO 				VARCHAR2(10 CHAR) NOT NULL,
		NOMBRE_PROCURADOR 				VARCHAR2(40 CHAR) NOT NULL,
		NUM_JUZGADO 					NUMBER(2) NOT NULL,
		TIPO_JUZGADO 					VARCHAR2(3 CHAR) NOT NULL,
		NOM_LOCALIDAD_JUZGADO 			VARCHAR2(30 CHAR) NOT NULL,
		SALA_JUZGADO 					VARCHAR2(20 CHAR) NOT NULL,
		NOM_NOTARIO_ESCRITURA 			VARCHAR2(50 CHAR) NOT NULL,
		NUM_PROTOCOLO 					VARCHAR2(8 CHAR) NOT NULL,
		FEC_RESOLUCION 					DATE NOT NULL,
		TIPO_VIA 						VARCHAR2(2 CHAR) NOT NULL,
		NOMBRE_VIA 						VARCHAR2(60 CHAR) NOT NULL,
		PORTAL_PUNTO_KM 				VARCHAR2(17 CHAR) NOT NULL,
		ESCALERA 						VARCHAR2(5 CHAR) NOT NULL,
		PISO 							VARCHAR2(11 CHAR) NOT NULL,
		NUM_PUERTA 						VARCHAR2(17 CHAR) NOT NULL,
		COD_POSTAL 						NUMBER(5) NOT NULL,
		COD_POSTAL_MUNICIPIO 			VARCHAR2(50 CHAR) NOT NULL,
		COD_POSTAL_PROVINCIA 			NUMBER(2) NOT NULL,
		COD_MUNICIPIO_REGISTRO 			VARCHAR2(50 CHAR) NOT NULL,
		OBRA_NUEVA 						VARCHAR2(1 CHAR) NOT NULL,
		PORCENTAJE_OBRA 				NUMBER(6,3) NOT NULL,
		PORCENTAJE_PROPIEDAD_COMUNI 	NUMBER(6,3) NOT NULL,
		REFERENCIA_CATASTRAL 			VARCHAR2(20 CHAR) NOT NULL,
		ACTIVO_SINGULAR 				VARCHAR2(1 CHAR) NOT NULL,
		SIGNO_LONGITUD 					VARCHAR2(1 CHAR) NOT NULL,
		LONGITUD 						VARCHAR2(17 CHAR) NOT NULL,
		SIGNO_LATITUD 					VARCHAR2(1 CHAR) NOT NULL,
		LATITUD 						VARCHAR2(17 CHAR) NOT NULL,
		SUP_TOTAL_REGISTRAL_UTIL 		NUMBER(11,2) NOT NULL,
		DORMITORIOS_ACTIVO 				NUMBER(4) NOT NULL,
		BAÑOS_ACTIVO 					NUMBER(4) NOT NULL,
		GARAJE 							VARCHAR2(1 CHAR) NOT NULL,
		NUM_PLAZAS_GARAJE 				NUMBER(5) NOT NULL,
		INMUEBLE_ARRENDADO 				VARCHAR2(1 CHAR) NOT NULL,
		ASCENSOR_ACTIVO 				VARCHAR2(1 CHAR) NOT NULL,
		TRASTERO_ACTIVO 				VARCHAR2(1 CHAR) NOT NULL,
		TIPO_VENTA 						VARCHAR2(1 CHAR) NOT NULL,
		NUM_TERRAZAS_DESCUBIERTAS 		NUMBER(4) NOT NULL,
		REGIMEN_PROTECCION 				NUMBER(2) NOT NULL,
		FEC_ANIO_CONSTRUCCION 			DATE NOT NULL,
		FEC_ANIO_REHABILITACION 		DATE NOT NULL,
		FEC_PUBLICACION_ACT_ENTIDAD 	DATE NOT NULL,
		IMPORTE_APROBADO_OFERTA 		NUMBER(15) NOT NULL,
		FEC_ALTA_FASE_DEFINITIVA 		DATE NOT NULL,
		FEC_ULTIMA_VISITA 				DATE NOT NULL,
		NUM_PROYECTOS_SINGULARES 		VARCHAR2(5 CHAR) NOT NULL,
		COD_CALIF_EFICI_ENERGETICA 		NUMBER(8) NOT NULL,
		FEC_EMISION_CERTIFI_ENERG 		DATE NOT NULL,
		FEC_CADUCIDAD_CERTIFI_ENERG 	DATE NOT NULL,
		MOTIVO_OCULTACION 				VARCHAR2(1 CHAR) NOT NULL,
		SUBMOTIVO_OCULTACION 			VARCHAR2(1 CHAR) NOT NULL,
		INDICADOR_ACTIVO_PUBLICADO 		VARCHAR2(1 CHAR) NOT NULL,
		INDICADOR_NUM_VISITAS 			NUMBER(8) NOT NULL,
		NUM_OFERTAS_RECIBIDAS 			NUMBER(8) NOT NULL,
		FEC_ULTIMA_OFERTA_REALIZADA 	DATE NOT NULL,
		IMPORTE_ULTIMA_OFERTA 			NUMBER(15,2) NOT NULL,
		NUM_OFERTAS_DENEGADAS 			NUMBER(9) NOT NULL,
		IMPORTE_OFERTA_MAXIMO 			NUMBER(15,2) NOT NULL,
		TIPO_INMUEBLE_REM 				VARCHAR2(30 CHAR) NOT NULL,
		IMPORTE_VALOR_COMERCIAL 		NUMBER(15,2) NOT NULL,
		PRECIO_REFERENCIA 				NUMBER(15,2) NOT NULL,
		IMPORTE_VENTA 					NUMBER(15,2) NOT NULL,
		FEC_VENTA 						DATE NOT NULL,
		TEXTO_EXPLICATIVO_COD_RE 		VARCHAR2(40 CHAR) NOT NULL,
		FILLER 							VARCHAR2(250 CHAR),
		FECHA_EXTRACCION				DATE		
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