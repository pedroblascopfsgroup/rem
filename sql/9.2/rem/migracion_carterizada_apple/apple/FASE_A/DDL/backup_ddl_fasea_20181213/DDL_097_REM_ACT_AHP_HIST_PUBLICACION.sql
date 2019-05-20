--/*
--######################################### 
--## AUTOR=Marco Muñoz / Miguel Sanchez
--## FECHA_CREACION=20181126
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-4793
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG_ACA_CABECERA'
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- #TABLESPACE_INDEX# Configuracion Tablespace de Indices
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.



BEGIN
    
	-----------------------
	---     TABLA       ---
	-----------------------

	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME =''MIG2_ACT_AHP_HIST_PUBLICACION'' AND OWNER='''||V_ESQUEMA||''''
	INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION';
    
	END IF;
	

	DBMS_OUTPUT.PUT_LINE('Creamos la tabla MIG2_ACT_AHP_HIST_PUBLICACION');
	
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'."MIG2_ACT_AHP_HIST_PUBLICACION" 
	           (
				"AHP_CODIGO_ACTIVO"					NUMBER(16,0) 			NOT NULL ENABLE	,
				"DD_EPV_COD"						VARCHAR2(20 CHAR)	    NOT NULL ENABLE	,
				"DD_EPA_COD"						VARCHAR2(20 CHAR) 		NOT NULL ENABLE	,
				"DD_TCO_COD"						VARCHAR2(20 CHAR) 		NOT NULL ENABLE ,
				"DD_MTO_V_CODIGO"					VARCHAR2(20 CHAR)  ,
				"AHP_MOT_OCULTACION_MANUAL_V"		VARCHAR2(250 CHAR) ,
				"AHP_CHECK_PUBLICAR_V"				NUMBER(1,0) ,
				"AHP_CHECK_OCULTAR_V"				NUMBER(1,0) ,		
				"AHP_CHECK_OCULTAR_PRECIO_V"		NUMBER(1,0)	,
				"AHP_CHECK_PUB_SIN_PRECIO_V"		NUMBER(1,0)	,
				"DD_MTO_A_CODIGO"					VARCHAR2(20 CHAR) ,
				"AHP_MOT_OCULTACION_MANUAL_A"		VARCHAR2(250 CHAR) ,
				"AHP_CHECK_PUBLICAR_A"				NUMBER(1,0)	,
				"AHP_CHECK_OCULTAR_A"				NUMBER(1,0)	,
				"AHP_CHECK_OCULTAR_PRECIO_A"		NUMBER(1,0)	,
				"AHP_CHECK_PUB_SIN_PRECIO_A"		NUMBER(1,0)	,
				"AHP_FECHA_INI_VENTA"				DATE ,
				"AHP_FECHA_FIN_VENTA"				DATE ,
				"AHP_FECHA_INI_ALQUILER"			DATE ,	
				"AHP_FECHA_FIN_ALQUILER"			DATE ,
				"DD_TPU_V_CODIGO"					VARCHAR2(20 CHAR) ,
				"DD_TPU_A_CODIGO"					VARCHAR2(20 CHAR) ,
				"VALIDACION" 				NUMBER(1) 			DEFAULT 0 	NOT NULL
			   )';
		
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('MIG2_ACT_AHP_HIST_PUBLICACION creada');


	--------------------------
	-- COMENTARIOS COLUMNAS --
	--------------------------

	DBMS_OUTPUT.PUT_LINE('Creando comentarios de las columnas');

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.AHP_CODIGO_ACTIVO IS ''Código identificador único del activo.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.DD_EPV_COD IS ''Estado de la venta. Diccionario DD_EPV_ESTADO_PUB_VENTA''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.DD_EPA_COD IS ''Estado del alquiler. Diccionario DD_EPA_ESTADO_PUB_ALQUILER''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.DD_TCO_COD IS ''Código identificador único de la comercialización.DD_TCO_TIPO_COMERCIALIZACION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.DD_MTO_V_CODIGO IS ''Código identificador único del motivo de la ocultación(venta).DD_MTO_MOTIVOS_OCULTACION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.AHP_MOT_OCULTACION_MANUAL_V IS ''Descripción del motivo de la ocultación. Sólo para ocultaciones de tipo manual (12)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.AHP_CHECK_OCULTAR_PRECIO_V IS ''Check manual de publicar precio de la venta.(0:no 1:si)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.AHP_CHECK_PUB_SIN_PRECIO_V IS ''Check manual de publicación sin precio de la venta.(0:no 1:si)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.DD_MTO_A_CODIGO IS ''Código identificador único del motivo de la ocultación(alquiler).DD_MTO_MOTIVOS_OCULTACION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.AHP_MOT_OCULTACION_MANUAL_A IS ''Descripción del motivo de la ocultación. Sólo para ocultaciones de tipo manual (12)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.AHP_CHECK_OCULTAR_PRECIO_A IS ''Check manual de publicar precio del alquilera.(0:no 1:si)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.AHP_CHECK_PUB_SIN_PRECIO_A IS ''Check manual de publicación sin precio del alquiler.(0:no 1:si)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.AHP_FECHA_INI_VENTA IS ''Indica la fecha de inicio del estado de publicación venta.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.AHP_FECHA_FIN_VENTA IS ''Indica la fecha de finalización del estado de publicación venta.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.AHP_FECHA_INI_ALQUILER IS ''Indica la fecha de inicio del estado de publicación alquiler.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.AHP_FECHA_FIN_ALQUILER IS ''Indica la fecha de finalización del estado de publicación alquiler.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.DD_TPU_V_CODIGO IS ''Indica el tipo de publicación realizada para venta.DD_TPU_TIPO_PUBLICACION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.DD_TPU_A_CODIGO IS ''Indica el tipo de publicación realizada para alquiler.DD_TPU_TIPO_PUBLICACION''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.MIG2_ACT_AHP_HIST_PUBLICACION.VALIDACION IS ''Validación''';



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

EXIT;
