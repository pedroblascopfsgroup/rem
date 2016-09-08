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
		APR_ID	NUMBER(9) NOT NULL, 
		CORTOR	VARCHAR2(2 CHAR),
		ACT_NUMERO_UVEM	NUMBER(9) NOT NULL,
		COENGP	VARCHAR2(5 CHAR),
		COSPAT	VARCHAR2(5 CHAR),
		COTSIN	VARCHAR2(4 CHAR),
		NUINMU	VARCHAR2(9 CHAR),
		FEC_FORMALIZACION	DATE,
		COD_ENTRADA_ACTIVO	VARCHAR2(2 CHAR) NOT NULL,
		COESEN	VARCHAR2(2 CHAR),
		COD_ESTADO_VENTA_ACTIVO	VARCHAR2(2 CHAR) NOT NULL,
		FEC_BAJA_ACTIVO	DATE NOT NULL,
		PORCENTAJE_PROPIEDAD	NUMBER(6,3) NOT NULL,
		GRADO_PROPIEDAD	NUMBER(2) NOT NULL,
		CONIAP	VARCHAR2(2 CHAR),
		COENOR	VARCHAR2(5 CHAR),
		IDCOEQ	VARCHAR2(7 CHAR),
		XCOEMP	VARCHAR2(5 CHAR),
		COPSER	VARCHAR2(5 CHAR),
		IDPRIG	VARCHAR2(15 CHAR),
		IDCOEC	VARCHAR2(17 CHAR),
		COPRDW	VARCHAR2(15 CHAR),
		FETASA	VARCHAR2(8 CHAR),
		IMVATA	VARCHAR2(15 CHAR),
		COFITA	VARCHAR2(5 CHAR),
		COMOTA	VARCHAR2(2 CHAR),
		IMRESU	VARCHAR2(15 CHAR),
		IMCONS	VARCHAR2(15 CHAR),
		BINECO	VARCHAR2(1 CHAR),
		FETECO	VARCHAR2(8 CHAR),
		IMVECO	VARCHAR2(15 CHAR),
		COTECO	VARCHAR2(5 CHAR),
		CO1ECO	VARCHAR2(2 CHAR),
		TIPO_RIESGO	NUMBER(5) NOT NULL,
		NUM_EXP_RIESGO	VARCHAR2(20 CHAR) NOT NULL,
		COSTIT	VARCHAR2(2 CHAR),
		COREAE	VARCHAR2(5 CHAR),
		FEREAI	VARCHAR2(8 CHAR),
		FEC_PRESENTACION_HACIENDA	DATE NOT NULL,
		FEC_PRESENTACION_REGISTRO	DATE NOT NULL,
		FEC_INSCRIPCION_TITULO	DATE NOT NULL,
		FEADAC	VARCHAR2(8 CHAR),
		FETIFI	VARCHAR2(8 CHAR),
		BIPOPO	VARCHAR2(1 CHAR),
		INDICADOR_NECES_LANZAMIENTO	NUMBER(1) NOT NULL,
		FESEPO	VARCHAR2(8 CHAR),
		FEC_REALIZADA_POSESION	DATE NOT NULL,
		FESELA	VARCHAR2(8 CHAR),
		FERELA	VARCHAR2(8 CHAR),
		CODISC	VARCHAR2(2 CHAR),
		NUM_LIBRO_ESCRITURA	NUMBER(6) NOT NULL,
		NUM_TOMO_ESCRITURA	NUMBER(6) NOT NULL,
		NUM_FOLIO_ESCRITURA	NUMBER(6) NOT NULL,
		NUM_INSCRIPCION_REGISTRO	NUMBER(8) NOT NULL,
		COPRDI	VARCHAR2(12 CHAR),
		IMPORTE_ADJUDICACION	NUMBER(16,3) NOT NULL,
		BINOCU	VARCHAR2(1 CHAR),
		FEC_ENTREGA_TITULO_GESTOR	DATE NOT NULL,
		FEC_ENVIO_AUTO_ADICCION	DATE NOT NULL,
		FEC_SEGUNDA_PRESEN_REG	DATE NOT NULL,
		FEC_SUBASTA	DATE NOT NULL,
		RESULTADO_SUBASTA	VARCHAR2(1 CHAR) NOT NULL,
		FEC_RECEP_ACTA_SUBASTA	DATE NOT NULL,
		VALOR_JUDICIAL	NUMBER(16,3) NOT NULL,
		COSOCU	VARCHAR2(2 CHAR),
		FEC_INICIO_CONTRATO	DATE NOT NULL,
		NOMBRE_ARRENDATARIO	VARCHAR2(35 CHAR) NOT NULL,
		BIPOLA	VARCHAR2(1 CHAR),
		FESOLA	VARCHAR2(8 CHAR),
		QAVDAH	VARCHAR2(1 CHAR),
		QANFZP	VARCHAR2(1 CHAR),
		QAOCPV	VARCHAR2(1 CHAR),
		FEC_SOLICITUD_MORATORIA	DATE NOT NULL,
		COD_RESOL_MORATORIA	VARCHAR2(1 CHAR) NOT NULL,
		FEC_RESOL_MORATORIA	DATE NOT NULL,
		FESOPO	VARCHAR2(8 CHAR),
		QAEVPS	VARCHAR2(1 CHAR),
		LLAVES_NECESARIAS	VARCHAR2(1 CHAR) NOT NULL,
		FEC_RECEP_LLAVES	DATE NOT NULL,
		FEC_ENVIO_LLAVES_GESTOR	DATE NOT NULL,
		IMREMA	VARCHAR2(15 CHAR),
		IMVACE	VARCHAR2(15 CHAR),
		COSIAU	VARCHAR2(1 CHAR),
		BIEXMU	VARCHAR2(1 CHAR),
		BIDEMU	VARCHAR2(1 CHAR),
		FECESI	VARCHAR2(8 CHAR),
		NORESP	VARCHAR2(30 CHAR),
		CODIJU	VARCHAR2(2 CHAR),
		BIREAR	VARCHAR2(1 CHAR),
		NUM_AUTOS_JUZGADO	VARCHAR2(10 CHAR) NOT NULL,
		NOMBRE_PROCURADOR	VARCHAR2(40 CHAR) NOT NULL,
		OBRECO	VARCHAR2(6 CHAR),
		NUM_JUZGADO	NUMBER(2) NOT NULL,
		TIPO_JUZGADO	VARCHAR2(3 CHAR) NOT NULL,
		NOM_LOCALIDAD_JUZGADO	VARCHAR2(30 CHAR) NOT NULL,
		SALA_JUZGADO	VARCHAR2(20 CHAR) NOT NULL,
		NOM_NOTARIO_ESCRITURA	VARCHAR2(50 CHAR) NOT NULL,
		NUM_PROTOCOLO	VARCHAR2(8 CHAR) NOT NULL,
		IMDEMA	VARCHAR2(15 CHAR),
		FEDEMA	VARCHAR2(8 CHAR),
		FEC_RESOLUCION	DATE NOT NULL,
		COTICO	VARCHAR2(2 CHAR),
		COSBIC	VARCHAR2(2 CHAR),
		POICOM	VARCHAR2(5 CHAR),
		QCIVAC	VARCHAR2(3 CHAR),
		BIREXE	VARCHAR2(1 CHAR),
		TIPO_VIA	VARCHAR2(2 CHAR) NOT NULL,
		NOMBRE_VIA	VARCHAR2(60 CHAR) NOT NULL,
		PORTAL_PUNTO_KM	VARCHAR2(17 CHAR) NOT NULL,
		ESCALERA	VARCHAR2(5 CHAR) NOT NULL,
		PISO	VARCHAR2(11 CHAR) NOT NULL,
		NUM_PUERTA	VARCHAR2(17 CHAR) NOT NULL,
		COD_POSTAL	NUMBER(5) NOT NULL,
		COD_MUNICIPIO	VARCHAR2(50 CHAR) NOT NULL,
		COD_PROVINCIA	NUMBER(2) NOT NULL,
		NUMFIN	VARCHAR2(14 CHAR),
		NUREGP	VARCHAR2(3 CHAR),
		COMUIX	VARCHAR2(50 CHAR),
		COEXCA	VARCHAR2(2 CHAR),
		COD_MUNICIPIO_REGISTRO	VARCHAR2(50 CHAR) NOT NULL,
		OBRA_NUEVA	VARCHAR2(1 CHAR) NOT NULL,
		PORCENTAJE_OBRA	NUMBER(6,3) NOT NULL,
		PORCENTAJE_PROPIEDAD_COMUNI	NUMBER(6,3) NOT NULL,
		REFERENCIA_CATASTRAL	VARCHAR2(20 CHAR) NOT NULL,
		ACTIVO_SINGULAR	VARCHAR2(1 CHAR) NOT NULL,
		SIGNO_LONGITUD	VARCHAR2(1 CHAR) NOT NULL,
		LONGITUD	VARCHAR2(17 CHAR) NOT NULL,
		SIGNO_LATITUD	VARCHAR2(1 CHAR) NOT NULL,
		LATITUD	VARCHAR2(17 CHAR) NOT NULL,
		CASUTR	VARCHAR2(11 CHAR),
		SUP_TOTAL_REGISTRAL_UTIL	NUMBER(11,2) NOT NULL,
		CASUTC	VARCHAR2(11 CHAR),
		DORMITORIOS_ACTIVO	NUMBER(4) NOT NULL,
		BANIOS_ACTIVO	NUMBER(4) NOT NULL,
		GARAJE	VARCHAR2(1 CHAR) NOT NULL,
		NUM_PLAZAS_GARAJE	NUMBER(5) NOT NULL,
		INMUEBLE_ARRENDADO	VARCHAR2(1 CHAR) NOT NULL,
		ASCENSOR_ACTIVO	VARCHAR2(1 CHAR) NOT NULL,
		TRASTERO_ACTIVO	VARCHAR2(1 CHAR) NOT NULL,
		TIPO_VENTA	VARCHAR2(1 CHAR) NOT NULL,
		NUM_TERRAZAS_DESCUBIERTAS	NUMBER(4) NOT NULL,
		REGIMEN_PROTECCION	NUMBER(2) NOT NULL,
		FEC_ANIO_CONSTRUCCION	DATE NOT NULL,
		FEC_ANIO_REHABILITACION	DATE NOT NULL,
		FEC_PUBLICACION_ACT_ENTIDAD	DATE NOT NULL,
		IMPORTE_APROBADO_OFERTA	NUMBER(15) NOT NULL,
		FEC_ALTA_FASE_DEFINITIVA	DATE NOT NULL,
		FEC_ULTIMA_VISITA	DATE NOT NULL,
		OBTTEX	VARCHAR2(110 CHAR),
		NUM_PROYECTOS_SINGULARES	VARCHAR2(5 CHAR) NOT NULL,
		FFCOAR	VARCHAR2(8 CHAR),
		APRESH	VARCHAR2(1 CHAR),
		BIACSU	VARCHAR2(1 CHAR),
		GETEIN	VARCHAR2(40 CHAR),
		COD_CALIF_EFICI_ENERGETICA	NUMBER(8) NOT NULL,
		FEC_EMISION_CERTIFI_ENERG	DATE NOT NULL,
		FEC_CADUCIDAD_CERTIFI_ENERG	DATE NOT NULL,
		MOTIVO_OCULTACION	VARCHAR2(1 CHAR) NOT NULL,
		SUBMOTIVO_OCULTACION	VARCHAR2(1 CHAR) NOT NULL,
		INDICADOR_ACTIVO_PUBLICADO	VARCHAR2(1 CHAR) NOT NULL,
		INDICADOR_NUM_VISITAS	NUMBER(8) NOT NULL,
		NUM_OFERTAS_RECIBIDAS	NUMBER(8) NOT NULL,
		FEC_ULTIMA_OFERTA_REALIZADA	DATE NOT NULL,
		IMPORTE_ULTIMA_OFERTA	NUMBER(15,2) NOT NULL,
		NUM_OFERTAS_DENEGADAS	NUMBER(9) NOT NULL,
		IMPORTE_OFERTA_MAXIMO	NUMBER(15,2) NOT NULL,
		TIPO_INMUEBLE_REM	VARCHAR2(30 CHAR) NOT NULL,
		IMPORTE_VALOR_COMERCIAL	NUMBER(15,2) NOT NULL,
		FEVACO	VARCHAR2(8 CHAR),
		PRECIO_REFERENCIA	NUMBER(15,2) NOT NULL,
		QFRIRP	VARCHAR2(8 CHAR),
		IMALRE	VARCHAR2(15 CHAR),
		IMORAL	VARCHAR2(15 CHAR),
		IMVAPR	VARCHAR2(15 CHAR),
		IMPINE	VARCHAR2(15 CHAR),
		IMPORTE_VENTA	NUMBER(15,2) NOT NULL,
		FEC_VENTA	DATE NOT NULL,
		TEXTO_EXPLICATIVO_COD_RE	VARCHAR2(40 CHAR) NOT NULL,
		FILLER	VARCHAR2(250 CHAR),
		FECHA_EXTRACCION	DATE,
		REM	NUMBER(1),
		ACT_ID	NUMBER(16),
		BIE_ID	NUMBER(16)		
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

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CORTOR IS ''RETURN_UPDATE''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COENGP IS ''COD_ENTIDAD_PROP''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COSPAT IS ''COD_SOC_PATRIMONIAL''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COTSIN IS ''COD_TIPO_ACTIVO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.NUINMU IS ''NUM_FICHA_CONTABILIDAD''';
	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COESEN IS ''COD_ESTADO_ACTIVO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CONIAP IS ''PROCEDENCIA_ACTIVO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COENOR IS ''EMPRESA_ORIGEN_ACTIVO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IDCOEQ IS ''COD_SOC_PROPIETARIA_ANT''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.XCOEMP IS ''EMPRESA''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COPSER IS ''CLASE_PRODUCTO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IDPRIG IS ''ID_PRODUCTO_BK''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IDCOEC IS ''ID_CONTRATO_BK''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COPRDW IS ''PRC_RECOVERY''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FETASA IS ''FEC_TASACION''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IMVATA IS ''IMPORTE_VALOR_TASACION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COFITA IS ''COD_FIRMA_TASADORA''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COMOTA IS ''TIPO_TASACION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IMRESU IS ''VALOR_REPER_SUELO_CONS''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IMCONS IS ''COSTE_CONSTRUCCION_CONS''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BINECO IS ''CUMPLE_NORMA_ECO_TAS''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FETECO IS ''FEC_TASACION_NORMA_ECO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IMVECO IS ''IMPORTE_VALOR_TASACION_ECO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COTECO IS ''COD_FIRMA_TASADORA_ECO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CO1ECO IS ''TIPO_TASACION_ECO''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COSTIT IS ''SITUACION_TITULO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COREAE IS ''COD_GESTORIA_ADJUDICACION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FEREAI IS ''FEC_RECEPCION_TITULO_INSCR''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FEADAC IS ''FEC_ADJUDICACION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FETIFI IS ''FEC_TITULO_FIRME''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIPOPO IS ''POSIBILIDAD_POSESION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FESEPO IS ''FEC_SENIALADA_POSESION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FESELA IS ''FEC_SENIALADO_LANZAMIENTO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FERELA IS ''FEC_REALIZADO_LANZAMIENTO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CODISC IS ''COD_COMERCIALIZACION''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COPRDI IS ''ID_PROCEDIMIENTO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BINOCU IS ''OCUPADO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COSOCU IS ''COD_SITUACION_OCUPACIONAL''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIPOLA IS ''POSIBLE_LANZAMIENTO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FESOLA IS ''FEC_SOLICITUD_LANZAMIENTO''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.QAVDAH IS ''VIVIENDA_HABITUAL''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.QANFZP IS ''NECESARIA_FUERZA_PUBLICA''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.QAOCPV IS ''OCUPANTES_VIVIENDA''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FESOPO IS ''FEC_SOLICITUD_POSESION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.QAEVPS IS ''ENTREGA_VOLUNTARIA_POSESION''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IMREMA IS ''IMPORTE_REMATE''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IMVACE IS ''IMPORTE_CESION_TERCEROS''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COSIAU IS ''SITUACION_AUTO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIEXMU IS ''EXISTEN_MUEBLES''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIDEMU IS ''MUEBLES_DESTRUIDOS''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECESI IS ''FEC_CESION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.NORESP IS ''NOM_COMPLETO_RESPONSABLE''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CODIJU IS ''DISPONIBILIDAD_JURIDICA''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIREAR IS ''RECURRIDO_ARRENDA''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.OBRECO IS ''REF_PROCURADOR''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IMDEMA IS ''IMPORTE_DEMANDA''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FEDEMA IS ''FEC_DEMANDA''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COTICO IS ''TIPO_IMPUESTO_COMPRA''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COSBIC IS ''SUBTIPO_IMPUESTO_COMPRA''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.POICOM IS ''PORCENTAJE_IMPUESTO_COMPRA''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.QCIVAC IS ''COD_TP_IVA_COMPRA''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIREXE IS ''RENUNCIA_EXENCION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.NUMFIN IS ''NUM_FINCA_REGISTRAL''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.NUREGP IS ''NUM_REGISTRO_PROPIEDAD''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COMUIX IS ''COD_MUN_REGISTRO_PROPIEDAD''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COEXCA IS ''EXISTEN_CARGAS_RECOVERY''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CASUTR IS ''SUP_TOTAL_REAL_UTIL''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CASUTC IS ''SUP_TOTAL_REAL_CONSTRUIDA''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.OBTTEX IS ''LINEA_TEXTO_COMENTARIO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FFCOAR IS ''FEC_FIN_CONTRATO''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.APRESH IS ''RESIDENCIA_HABITUAL''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIACSU IS ''ACTIVO_COMERCIALIZADO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.GETEIN IS ''GESTOR_TECNICO_INTERNO''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FEVACO IS ''FEC_VALOR_CONTABLE''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.QFRIRP IS ''FEC_REV_IMPORTE_REF_PLATA''';
	
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IMALRE IS ''IMPORTE_ORIENTATIVO_REFEREN''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IMORAL IS ''IMPORTE_ORIENTATIVO_ALQUILER''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IMVAPR IS ''PRECIO_MINIMO_DELEG''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IMPINE IS ''PRECIO_INE_MUNICIPIO''';
	
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