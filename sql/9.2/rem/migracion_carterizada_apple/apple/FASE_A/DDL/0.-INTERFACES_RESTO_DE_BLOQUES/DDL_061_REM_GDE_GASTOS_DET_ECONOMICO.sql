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
V_ESQUEMA_2 VARCHAR2(20 CHAR) := 'REMMASTER';       --SE CREA UNA SEGUNDA VARIABLE DE ESQUEMA POR SI EN ALGÚN MOMENTO QUEREMOS CREAR LA TABLA EN UN ESQUEMA DIFERENTE AL DEL USUARIO QUE LA ACCEDE O VICEVERSA
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := 'REM_IDX';
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
                GDE_PRINCIPAL_SUJETO                                            NUMBER(16,2),
                GDE_PRINCIPAL_NO_SUJETO                                         NUMBER(16,2),
                GDE_RECARGO                                                     NUMBER(16,2),
                GDE_INTERES_DEMORA                                              NUMBER(16,2),
                GDE_COSTAS                                                      NUMBER(16,2),
                GDE_OTROS_INCREMENTOS                                           NUMBER(16,2),
                GDE_PROVISIONES_SUPLIDOS                                        NUMBER(16,2),
                GDE_COD_TIPO_IMPUESTO                                           VARCHAR2(20 CHAR),
                GDE_IND_IMP_INDIRECTO_EXENTO                            		NUMBER(1),
                GDE_IND_IMP_INDIR_RENUN_EXENC                           		NUMBER(1),
                GDE_IMP_INDIR_TIPO_IMPOSITIVO                           		NUMBER(5,2),
                GDE_IMP_IND_CUOTA                                               NUMBER(16,2),
                GDE_IRPF_TIPO_IMPOSITIVO                                        NUMBER(5,2),
                GDE_IRPF_CUOTA                                                  NUMBER(16,2),
                GDE_IMPORTE_TOTAL                                               NUMBER(16,2),
                GDE_FECHA_TOPE_PAGO                                             DATE,
                GDE_IND_REPERCUTIBLE_INQUILINO                          		NUMBER(1),
                GDE_IMPORTE_PAGADO                                              NUMBER(16,2),
                GDE_FECHA_PAGO                                                  DATE,
                GDE_COD_TIPO_PAGADOR                                            VARCHAR2(20 CHAR),
                GDE_COD_TIPO_PAGO                                               VARCHAR2(20 CHAR),
                GDE_COD_RESP_PAGO_FUERA_PLAZO                           		VARCHAR2(20 CHAR),
                GDE_GPV_ID                                                      NUMBER(16)                          NOT NULL,
                GDE_REEMBOLSO_TERCERO                                           NUMBER(1,0),
                GDE_INCLUIR_PAGO_PROVISION                                      NUMBER(1,0),
                GDE_ABONO_CUENTA                                                NUMBER(1,0),
                GDE_IBAN                                                        VARCHAR2(50 CHAR),
                GDE_TITULAR_CUENTA                                              VARCHAR2(256 CHAR),
                GDE_NIF_TITULAR_CUENTA                                          VARCHAR2(10 CHAR),
                GDE_PAGADO_CONEXION                                      		NUMBER(1,0),
                GDE_NUMERO_CONEXION                                             VARCHAR2(12 CHAR),
                GDE_OFICINA                                              		VARCHAR2(4 CHAR),
                GDE_FECHA_CONEXION												DATE,
				GDE_ANTICIPO													NUMBER(1,0),
				GDE_FECHA_ANTICIPO												DATE,
        , VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
        ;

        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

          EXECUTE IMMEDIATE '
		  CREATE UNIQUE INDEX '||V_ESQUEMA_1||'."PK_MIG2_GDE_GASTOS_DET_ECONO" ON '||V_ESQUEMA_1||'.'||V_TABLA||' ("GDE_GPV_ID") 
		  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
		  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
		  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
		  TABLESPACE '||V_TABLESPACE_IDX;
		  DBMS_OUTPUT.PUT_LINE('ÍNDICE "PK_MIG2_GDE_GASTOS_DET_ECONO" CREADO.');

        IF V_ESQUEMA_2 != V_ESQUEMA_1 THEN

                EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA_1||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_2||'" WITH GRANT OPTION';
                DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_2||''); 

        END IF;
        
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_COD_GASTO_PROVEEDOR IS ''Código identificador único del Gasto del Proveedor.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_PRINCIPAL_SUJETO IS ''Importe principal sujeto a impuestos''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_PRINCIPAL_NO_SUJETO IS ''Importe principal No sujeto a impuestos''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_RECARGO IS ''Importe recargo''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_INTERES_DEMORA IS ''Importe de los Intereses de Demora''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_COSTAS IS ''Importe de las Costas''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_OTROS_INCREMENTOS IS ''Importe de Otros Incrementos''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_PROVISIONES_SUPLIDOS IS ''Importe provisiones y suplidos''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_COD_TIPO_IMPUESTO IS ''Código del Tipo de Impuesto del Gasto (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_IND_IMP_INDIRECTO_EXENTO IS ''Indicador de si es Impuesto Indirecto Exento''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_IND_IMP_INDIR_RENUN_EXENC IS ''Indicador de si es Impuesto Indirecto Renuncia a Exención''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_IMP_INDIR_TIPO_IMPOSITIVO IS ''Tipo impositivo del impuesto indirecto''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_IMP_IND_CUOTA IS ''Importe de la cuota del impuesto indirecto''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_IRPF_TIPO_IMPOSITIVO IS ''Tipo impositivo del IRPF''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_IRPF_CUOTA IS ''Importe de la cuota de IRPF''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_IMPORTE_TOTAL IS ''Importe total del gasto''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_FECHA_TOPE_PAGO IS ''Fecha tope del Pago''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_IND_REPERCUTIBLE_INQUILINO IS ''Indicador de si EL Pago es Repercutible al Inquilino''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_IMPORTE_PAGADO IS ''Importe Pagado''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_FECHA_PAGO IS ''Fecha Real del Pago''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_COD_TIPO_PAGADOR IS ''Código del Tipo de Pagador (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_COD_TIPO_PAGO IS ''Código del Tipo de Pago (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_COD_RESP_PAGO_FUERA_PLAZO IS ''Código del Responsable del Pago Fuera de Plazo (Código según Dic. Datos).''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_GPV_ID IS ''Identificador único autogenerado del gasto''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_REEMBOLSO_TERCERO IS ''Indicador que hay que reembolsar pago a un tercero (pago suplido)''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_INCLUIR_PAGO_PROVISION IS ''Indicador de que el gasto hay que incluirlo en una provisión de fondos de la gestoría''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_ABONO_CUENTA IS ''Indicador de abono en una cuenta de tercero''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_IBAN IS ''IBAN de la cuenta de abono de un tercero''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_TITULAR_CUENTA IS ''Titular de la cuenta de tercero sobre la que se hace el abono''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_NIF_TITULAR_CUENTA IS ''NIF del titular de la cuentaa de tercero sibre la que se hace el abono''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_PAGADO_CONEXION IS ''Indicador que se ha pagado el gasto mediante conexión a cuenta contable''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_NUMERO_CONEXION IS ''Número de cuenta contable de conexión sobre la que se ha imputado el gasto''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_OFICINA IS ''Número de la oficina titular de la cuenta de conexión''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_FECHA_CONEXION IS ''Fecha conexión.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_ANTICIPO IS ''El pago ha sido anticipado.''';
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA_1 || '.MIG2_GDE_GASTOS_DET_ECONOMICO.GDE_FECHA_ANTICIPO IS ''Fecha anticipo.''';

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
