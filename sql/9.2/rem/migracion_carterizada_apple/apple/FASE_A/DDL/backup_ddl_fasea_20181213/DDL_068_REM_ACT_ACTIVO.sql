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

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REM01';       --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_ACT_ACTIVO';

BEGIN

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

        IF TABLE_COUNT > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

                EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
                
        END IF;

        EXECUTE IMMEDIATE '
        CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
        (
                ACT_NUMERO_ACTIVO                                       NUMBER(16,0)                    NOT NULL,
                ACT_COD_CARTERA                                         VARCHAR2(20 CHAR)               NOT NULL,
                ACT_COD_SUBCARTERA                                      VARCHAR2(20 CHAR)               NOT NULL,
                ACT_COD_SUBCARTERA_ANTERIOR                             VARCHAR2(20 CHAR)				NOT NULL,
                ACT_COD_TIPO_COMERCIALIZACION                   		VARCHAR2(20 CHAR),
                ACT_COD_TIPO_ALQUILER                                   VARCHAR2(20 CHAR),
                ACT_FECHA_VENTA                                         DATE,
                ACT_IMPORTE_VENTA                                       NUMBER(16,2),
                ACT_COD_PROPIETARIO_ANTERIOR                    		NUMBER(16,0),
                ACT_BLOQUEO_PRECIO_FECHA_INI                    		DATE,
                ACT_BLOQUEO_PRECIO_USU_ID                               VARCHAR2(50 CHAR),
                ACT_COD_TIPO_PUBLICACION                                VARCHAR2(20 CHAR),
                ACT_COD_ESTADO_PUBLICACION                              VARCHAR2(20 CHAR),
                ACT_FECHA_IND_PRECIAR                                   DATE,
                ACT_FECHA_IND_REPRECIAR                                 DATE,
                ACT_FECHA_IND_DESCUENTO                                 DATE,
				ACT_NUMERO_INMOVILIZADO									NUMBER(16,0),
				ACT_CODIGO_ENTRADA		 								VARCHAR2(20 CHAR),
				SELLO_CALIDAD											NUMBER(1,0),
                GESTOR_CALIDAD											VARCHAR2(50 CHAR),
                FECHA_CALIDAD											DATE,
                DD_TCR_ID												VARCHAR2(20 CHAR),
				DD_TAL_ID												VARCHAR2(20 CHAR),
				ACT_VENTA_EXTERNA_FECHA									DATE,
				ACT_VENTA_EXTERNA_OBSERVACION							VARCHAR2(255 CHAR),
				ACT_VENTA_EXTERNA_IMPORTE								NUMBER(16,2),
				ACT_FECHA_IND_PUBLICABLE								DATE,
				ACT_BLOQUEO_TIPO_COMERCIALIZAR							NUMBER(1,0),
				ACT_IBI_EXENTO											NUMBER(1,0),
				OK_TECNICO												NUMBER(1,0),
				ACT_PUJA												NUMBER(1,0)       
        , VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
        ;

        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  
        
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_NUMERO_ACTIVO IS ''Código identificador único del activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_COD_CARTERA IS ''Código de la Cartera del Activo (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_COD_SUBCARTERA IS ''Código de la SubCartera del Activo (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_COD_SUBCARTERA_ANTERIOR IS ''Código de la SubCartera Anterior del Activo (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_COD_TIPO_COMERCIALIZACION IS ''Código del Tipo de Comercialización del Activo (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_COD_TIPO_ALQUILER IS ''Código del Tipo de Alquiler del Activo. Sólo para Activos Alquilados. (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_FECHA_VENTA IS ''Fecha de la Venta del Activo.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_IMPORTE_VENTA IS ''Importe de la Venta del Activo''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_COD_PROPIETARIO_ANTERIOR IS ''Código de Propietario Anterior del Activo. Pensado para Sociedades Patrimoniales Anteriores (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_BLOQUEO_PRECIO_FECHA_INI IS ''Fecha Inicio de Activo bloqueado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_BLOQUEO_PRECIO_USU_ID IS ''USERNAME en REM del Usuario que Bloquea el Activo (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_COD_TIPO_PUBLICACION IS ''Código del Tipo de Publicación del Activo (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_COD_ESTADO_PUBLICACION IS ''Código del Estado de Publicación del Activo (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_FECHA_IND_PRECIAR IS ''Fecha en la que el Activo cumple las Condiciones para ser Preciado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_FECHA_IND_REPRECIAR IS ''Fecha en la que el Activo cumple las Condiciones para ser Repreciado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_FECHA_IND_DESCUENTO IS ''Fecha en la que el Activo cumple las Condiciones para aplicar Precio Descuento.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_NUMERO_INMOVILIZADO IS ''Ficha inmovilizado''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_CODIGO_ENTRADA IS ''Código entrada activo''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.SELLO_CALIDAD IS ''Indicador estado calidad (sello calidad).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.GESTOR_CALIDAD IS ''Usuario relacionado con el check de calidad.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.FECHA_CALIDAD IS ''Fecha de estado de calidad.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.DD_TCR_ID IS ''Código identificador único deL tipo de comercializacion''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.DD_TAL_ID IS ''Código identificador único del tipo de alquiler''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_VENTA_EXTERNA_FECHA IS ''Indica la fecha de venta para una venta externa a REM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_VENTA_EXTERNA_OBSERVACION IS ''Observaciones de una venta externa a REM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_VENTA_EXTERNA_IMPORTE IS ''Indica el importe de venta de una venta externa a REM.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_FECHA_IND_PUBLICABLE IS ''Es un indicador de activo disponible para publicar. Indicara al proceso offline que publique el activo''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_BLOQUEO_TIPO_COMERCIALIZAR IS ''Indicador No Bloqueado(0)/Bloqueado(1) el proceso automático para cambiar el Tipo de Comercialización''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_IBI_EXENTO IS ''Indicador de activo exento de IBI''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.OK_TECNICO IS ''Indicador de si el activo tiene el OK de Gestión''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_ACT_ACTIVO.ACT_PUJA IS ''Indicador de si el activo está en puja(1) o no está en puja(0)''';

        IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

                EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';

                DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

        END IF;

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;

/

EXIT;
