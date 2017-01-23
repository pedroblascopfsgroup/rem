--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20160927
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_ACT_ACTIVO'
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
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := '#TABLESPACE_INDEX#';
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
                ACT_COD_SUBCARTERA_ANTERIOR                             VARCHAR2(20 CHAR),
                ACT_COD_TIPO_COMERCIALIZACION                   		VARCHAR2(20 CHAR),
                ACT_COD_TIPO_ALQUILER                                   VARCHAR2(20 CHAR),
                ACT_FECHA_VENTA                                         DATE,
                ACT_IMPORTE_VENTA                                       NUMBER(16,2),
                ACT_COD_PROPIETARIO_UVEM_ANT                    		NUMBER(16,0),
                ACT_BLOQUEO_PRECIO_FECHA_INI                    		DATE,
                ACT_BLOQUEO_PRECIO_USU_ID                               VARCHAR2(50 CHAR),
                ACT_COD_TIPO_PUBLICACION                                VARCHAR2(20 CHAR),
                ACT_COD_ESTADO_PUBLICACION                              VARCHAR2(20 CHAR),
                ACT_FECHA_IND_PRECIAR                                   DATE,
                ACT_FECHA_IND_REPRECIAR                                 DATE,
                ACT_FECHA_IND_DESCUENTO                                 DATE,
                ACT_GESTOR_COMERCIAL									VARCHAR2(40 CHAR),
                ACT_GESTORIA_COMERCIAL									VARCHAR2(40 CHAR),
                ACT_GESTOR_FORMALIZACION								VARCHAR2(40 CHAR),
                ACT_GESTORIA_FORMALIZACION								VARCHAR2(40 CHAR)
        )'
        ;

        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

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
