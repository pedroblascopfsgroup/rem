--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20160927
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla de migración 'MIG2_GIC_GASTOS_INFO_CONTABI'
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
V_TABLA VARCHAR2(40 CHAR) := 'MIG2_GIC_GASTOS_INFO_CONTABI';

BEGIN

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

        IF TABLE_COUNT > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');
                EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'';
                
        END IF;

        EXECUTE IMMEDIATE '
        CREATE TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'
        (
                GIC_COD_GASTO_PROVEEDOR                                         NUMBER(16),
                GIC_EJERCICIO                                                   VARCHAR2(4 CHAR)                  NOT NULL,
                GIC_COD_PARTIDA_PRESUPUES                                       VARCHAR2(20 CHAR),
                GIC_COD_CUENTA_CONTABLE                                         VARCHAR2(20 CHAR),
                GIC_FECHA_CONTABILIZACION                                       DATE,
                GIC_COD_DESTINA_CONTABILIZA                                     VARCHAR2(20 CHAR),
                GIC_FECHA_DEVENGO_ESPECIAL                                      DATE,
                GIC_COD_PERIODICIDAD_ESPECIAL                           		VARCHAR2(20 CHAR),
                GIC_COD_PAR_PRESUP_ESPECIAL                                     VARCHAR2(20 CHAR),
                GIC_COD_CUENTA_CONT_ESPECIAL                            		VARCHAR2(20 CHAR),
                GIC_GPV_ID                                                      NUMBER(16)                        NOT NULL
        , VALIDACION NUMBER(1) DEFAULT 0 NOT NULL )'
        ;

        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  

 
  EXECUTE IMMEDIATE 'CREATE INDEX "REM01"."IDX_GIC_GPV_ID" ON "REM01"."MIG2_GIC_GASTOS_INFO_CONTABI" ("GIC_GPV_ID")
              PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
          STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
          PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
          BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
          TABLESPACE '||V_TABLESPACE_IDX;

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
