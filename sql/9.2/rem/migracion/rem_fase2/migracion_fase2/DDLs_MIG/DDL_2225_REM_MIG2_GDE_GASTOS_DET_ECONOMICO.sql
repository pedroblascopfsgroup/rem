--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20160927
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_GDE_GASTOS_DET_ECONOMICO'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_GDE_GASTOS_DET_ECONOMICO';

BEGIN

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

        IF TABLE_COUNT > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

                EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
                
        END IF;

        EXECUTE IMMEDIATE '
        CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
        (
                GDE_COD_GASTO_PROVEEDOR                                         NUMBER(16),
                GDE_GPV_ID                                                                      NUMBER(16)                              NOT NULL,
                GDE_PRINCIPAL_SUJETO                                            NUMBER(16,2),
                GDE_PRINCIPAL_NO_SUJETO                                         NUMBER(16,2),
                GDE_RECARGO                                                                     NUMBER(16,2),
                GDE_INTERES_DEMORA                                                      NUMBER(16,2),
                GDE_COSTAS                                                                      NUMBER(16,2),
                GDE_OTROS_INCREMENTOS                                           NUMBER(16,2),
                GDE_PROVISIONES_SUPLIDOS                                        NUMBER(16,2),
                GDE_COD_TIPO_IMPUESTO                                           VARCHAR2(20 CHAR),
                GDE_IND_IMP_INDIRECTO_EXENTO                            NUMBER(1),
                GDE_IND_IMP_INDIR_RENUN_EXENC                           NUMBER(1),
                GDE_IMP_INDIR_TIPO_IMPOSITIVO                           NUMBER(5,2),
                GDE_IMP_IND_CUOTA                                                       NUMBER(16,2),
                GDE_IRPF_TIPO_IMPOSITIVO                                        NUMBER(5,2),
                GDE_IRPF_CUOTA                                                          NUMBER(16,2),
                GDE_IMPORTE_TOTAL                                                       NUMBER(16,2),
                GDE_FECHA_TOPE_PAGO                                                     DATE,
                GDE_IND_REPERCUTIBLE_INQUILINO                          NUMBER(1),
                GDE_IMPORTE_PAGADO                                                      NUMBER(16,2),
                GDE_FECHA_PAGO                                                          DATE,
                GDE_COD_TIPO_PAGADOR                                            VARCHAR2(20 CHAR),
                GDE_COD_TIPO_PAGO                                                       VARCHAR2(20 CHAR),
                GDE_COD_RESP_PAGO_FUERA_PLAZO                           VARCHAR2(20 CHAR),
                GDE_REEMBOLSO_TERCERO                                           NUMBER(1,0),
                GDE_INCLUIR_PAGO_PROVISION                                      NUMBER(1,0),
                GDE_ABONO_CUENTA                                                        NUMBER(1,0),
                GDE_IBAN                                                                        VARCHAR2(50 CHAR),
                GDE_TITULAR_CUENTA                                                      VARCHAR2(256 CHAR),
                GDE_NIF_TITULAR_CUENTA                                          VARCHAR2(10 CHAR),
                GDE_PAGADO_CONEXION_BANKIA                                      NUMBER(1,0),
                GDE_NUMERO_CONEXION                                                     VARCHAR2(12 CHAR),
                GDE_OFICINA_BANKIA                                                      VARCHAR2(4 CHAR)
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
