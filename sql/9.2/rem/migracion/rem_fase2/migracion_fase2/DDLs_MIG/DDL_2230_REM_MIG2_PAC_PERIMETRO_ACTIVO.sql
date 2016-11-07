--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20160927
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_PAC_PERIMETRO_ACTIVO'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_PAC_PERIMETRO_ACTIVO';

BEGIN

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

        IF TABLE_COUNT > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

                EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
                
        END IF;

        EXECUTE IMMEDIATE '
        CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
        (
                PAC_NUMERO_ACTIVO                                       NUMBER(16)                      NOT NULL,
                PAC_IND_INCLUIDO                                        NUMBER(1)                       NOT NULL,
                PAC_IND_CHECK_TRA_ADMISION                      NUMBER(1),
                PAC_FECHA_TRA_ADMISION                          DATE,
                PAC_MOTIVO_TRA_ADMISION                         VARCHAR2(255 CHAR),
                PAC_IND_CHECK_GESTIONAR                         NUMBER(1),
                PAC_FECHA_GESTIONAR                                     DATE,
                PAC_MOTIVO_GESTIONAR                            VARCHAR2(255 CHAR),
                PAC_IND_CHECK_ASIG_MEDIA                        NUMBER(1),
                PAC_FECHA_ASIGNAR_MEDIADOR                      DATE,
                PAC_MOTIVO_ASIGNAR_MEDIADOR                     VARCHAR(255 CHAR),
                PAC_IND_CHECK_COMERCIALIZAR                     NUMBER(1),
                PAC_FECHA_COMERCIALIZAR                         DATE,
                PAC_COD_MOTIVO_COMERCIAL                        VARCHAR(20 CHAR),
                PAC_COD_MOTIVO_NOCOMERCIAL                      VARCHAR(20 CHAR),
                PAC_IND_CHECK_FORMALIZAR                        NUMBER(1),
                PAC_FECHA_FORMALIZAR                            DATE,
                PAC_MOTIVO_FORMALIZAR                           VARCHAR(255 CHAR)
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
