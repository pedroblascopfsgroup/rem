--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20150717
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.12-bk
--## INCIDENCIA_LINK=BCFI-514
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    TYPE T_ESQUEMA IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
    V_ESQUEMA_GRANT T_ESQUEMA;

BEGIN
    
    v_esquema_grant(1) := '#ESQUEMA_MASTER#';  --'BANKMASTER';
    v_esquema_grant(2) := '#ESQUEMA_MINIREC#'; --'MINIREC';
    v_esquema_grant(3) := '#ESQUEMA_DWH#';     --'RECOVERY_BANKIA_DWH';
    v_esquema_grant(4) := '#ESQUEMA_STG#';     --'RECOVERY_BANKIA_DATASTAGE';

    ------------------
    --   BI_FACTU   --
    ------------------   
    
    --** Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''BI_FACTU'' and owner = '''||v_esquema||'''';
    EXECUTE IMMEDIATE v_sql INTO v_num_tablas;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
            V_MSQL := 'DROP TABLE '||v_esquema||'.BI_FACTU CASCADE CONSTRAINTS';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BI_FACTU... Tabla borrada');  
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BI_FACTU... Comprobaciones previas FIN');
    
   
    --** Creamos la tabla
    V_MSQL := 'CREATE TABLE '||v_esquema||'.BI_FACTU 
               (
                FECHA_EXTRACCION                 DATE             NOT NULL, 
                IDFACTURACION                    NUMBER(16,0)     NOT NULL, 
                NOMBRE_FACTURACION               NVARCHAR2(50), 
                FECHA_DESDE_FAC                  DATE             NOT NULL, 
                FECHA_HASTA_FAC                  DATE, 
                FECHA_LIBERACION_FAC             DATE             NOT NULL, 
                FECHA_ANULACION_FAC              DATE, 
                CODIGO_COBRO                     NVARCHAR2(20), 
                FECHA_VALOR                      DATE, 
                FECHA_MOVIMIENTO                 DATE, 
                TIPO_COBRO                       NVARCHAR2(20)    NOT NULL, 
                DS_TIPO_COBRO                    NVARCHAR2(100), 
                CONCEPTO_COBRO                   NVARCHAR2(250), 
                IMPORTE_COBRO                    NUMBER(14,2), 
                CODIGO_ENTIDAD                   NUMBER(4,0)      NOT NULL, 
                CODIGO_PROPIETARIO               NUMBER(5,0)      NOT NULL, 
                TIPO_PRODUCTO                    NVARCHAR2(100)   NOT NULL, 
                NUMERO_CONTRATO                  NUMBER(17,0)     NOT NULL, 
                NUMERO_ESPEC                     NUMBER(15,0)     NOT NULL, 
                IDEXPEDIENTE                     NUMBER(16,0)     NOT NULL, 
                TIPO_EXP                         NVARCHAR2(50)    NOT NULL, 
                DS_TIPO_EXP                      NVARCHAR2(100), 
                FECHA_CREACION_EXP               DATE             NOT NULL, 
                FECHA_ARQUETIPACION              DATE             NOT NULL, 
                ID_CARTERA                       NUMBER(16,0)     NOT NULL, 
                NOMBRE_CARTERA                   NVARCHAR2(50)    NOT NULL, 
                ID_SUBCARTERA                    NUMBER(16,0)     NOT NULL, 
                SUBCARTERA                       NVARCHAR2(50)    NOT NULL, 
                CODIGO_AGENCIA                   NUMBER(3,0)      NOT NULL, 
                NOMBRE_AGENCIA                   NVARCHAR2(100)   NOT NULL, 
                FECHA_ALTA_AGENCIA               DATE             NOT NULL, 
                IDENVIO                          NUMBER(24,0)     NOT NULL, 
                ID_MODELO_FACTURACION_ESQUEMA    NUMBER(16,0)     NOT NULL, 
                MODELO_FACTURACION_ESQUEMA       NVARCHAR2(50)    NOT NULL, 
                ID_MODELO_FACTURACION_APLICADO   NUMBER(16,0)     NOT NULL, 
                MODELO_FACTURACION_APLICADO      NVARCHAR2(50)    NOT NULL, 
                IMPORTE_FACTURA                  NUMBER(14,2), 
                TARIFA                           NUMBER(16,2)     NOT NULL, 
                CORRECTOR                        NUMBER(2,5), 
                CODIGO_ENTIDAD_OFICINA_CONT      NUMBER(5,0), 
                CODIGO_OFICINA_CONT              NUMBER(5,0), 
                CODIGO_SUBSECC_OFICINA_CONT      NUMBER(2,0), 
                CODIGO_ENTIDAD_OFICINA_ADMIN     NUMBER(5,0), 
                CODIGO_OFICINA_ADMIN             NUMBER(5,0), 
                CODIGO_SUBSECC_OFICINA_ADMIN     NUMBER(2,0)
               )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.BI_FACTU... Tabla creada');
  
    
    --** Creamos Indices
    V_MSQL := 'CREATE INDEX IDX_BIFACTU_IDFACTU ON '||v_esquema||'.BI_FACTU (IDFACTURACION)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.IDX_BIFACTU_IDFACTU... Indice creado');
    V_MSQL := 'CREATE INDEX IDX_BIFACTU_IDFACTU_FCEXTRC ON '||v_esquema||'.BI_FACTU (IDFACTURACION, FECHA_EXTRACCION)';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.IDX_BIFACTU_IDFACTU_FCEXTRC... Indice creado');
    
    
    --** Creamos claves ajenas
    -- prf_proceso_facturacion
    V_MSQL := 'ALTER TABLE '||v_esquema||'.BI_FACTU
                 ADD (CONSTRAINT FK_IDFACTU_BIFACTU FOREIGN KEY (IDFACTURACION) 
                      REFERENCES '||v_esquema||'.PRF_PROCESO_FACTURACION (PRF_ID) )';
    EXECUTE IMMEDIATE V_MSQL;     
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.PRF_PROCESO_FACTURACION ... FK Creada');

    -- exp_expedientes
    V_MSQL := 'ALTER TABLE '||v_esquema||'.BI_FACTU
                 ADD (CONSTRAINT FK_EXP_BIFACTU FOREIGN KEY (IDEXPEDIENTE)
                      REFERENCES '||v_esquema||'.EXP_EXPEDIENTES (EXP_ID) )';
    EXECUTE IMMEDIATE V_MSQL;     
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.EXP_EXPEDIENTES ... FK Creada');
    
    -- rcf_car_cartera
    V_MSQL := 'ALTER TABLE '||v_esquema||'.BI_FACTU
                 ADD (CONSTRAINT FK_CAR_BIFACTU FOREIGN KEY (ID_CARTERA) 
                      REFERENCES '||v_esquema||'.RCF_CAR_CARTERA (RCF_CAR_ID))';
    EXECUTE IMMEDIATE V_MSQL;     
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.RCF_CAR_CARTERA ... FK Creada');
    
    -- rcf_sca_subcartera
    V_MSQL := 'ALTER TABLE '||v_esquema||'.BI_FACTU
                 ADD (CONSTRAINT FK_SCA_BIFACTU FOREIGN KEY (ID_SUBCARTERA) 
                      REFERENCES '||v_esquema||'.RCF_SCA_SUBCARTERA (RCF_SCA_ID) )';
    EXECUTE IMMEDIATE V_MSQL;     
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.RCF_SCA_SUBCARTERA ... FK Creada');
    
    -- rcf_mfa_modelos_facturacion
    V_MSQL := 'ALTER TABLE '||v_esquema||'.BI_FACTU
                 ADD (CONSTRAINT FK_MFA_BIFACTU FOREIGN KEY (ID_MODELO_FACTURACION_ESQUEMA)
                      REFERENCES '||v_esquema||'.RCF_MFA_MODELOS_FACTURACION (RCF_MFA_ID))';
    EXECUTE IMMEDIATE V_MSQL;     
    DBMS_OUTPUT.PUT_LINE('[INFO] '||v_esquema||'.RCF_MFA_MODELOS_FACTURACION ... FK Creada');
    
    
    --** Damos permisos a otros esquemas
    IF v_esquema_grant.count = 0 THEN
    DBMS_OUTPUT.PUT_LINE('No existen esquemas para Grants.');
      ELSE
        FOR i IN v_esquema_grant.FIRST .. v_esquema_grant.LAST
         LOOP
          v_num_tablas := 0;
          v_sql := 'select count(1) from all_users
                     where username='''||v_esquema_grant(i)||'''';
          execute immediate v_sql into v_num_tablas;
                 
          if v_num_tablas > 0 then
            v_sql := 'grant select, update, delete, insert
                         on '||v_esquema||'.BI_FACTU
                         to '||v_esquema_grant(i);
            DBMS_OUTPUT.PUT_LINE('[INFO]: ' || v_sql);
            execute immediate v_sql;
          else
            DBMS_OUTPUT.PUT_LINE('[INFO]: Esquema '||v_esquema_grant(i)||' NO EXISTE');
          end if;
                 
         END LOOP;
    END IF;

    
EXCEPTION
  WHEN OTHERS THEN
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);
    ROLLBACK;
    RAISE;   
END;
/
EXIT;
