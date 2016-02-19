--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20160218
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.19
--## INCIDENCIA_LINK=PRODUCTO-673
--## PRODUCTO=SI
--##
--## Finalidad: DDL
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
 V_ESQUEMA    VARCHAR2(25 CHAR):= '#ESQUEMA#';
 V_ESQUEMA_M  VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
 TABLA        VARCHAR(30 CHAR) := 'BATCH_SV_CLIENTES';
 ITABLE_SPACE VARCHAR(25 CHAR) := '#TABLESPACE_INDEX#';
 ERR_NUM      NUMBER;
 ERR_MSG      VARCHAR2(2048 CHAR);
 V_MSQL       VARCHAR2(8500 CHAR);
 V_EXISTE     NUMBER (1);

BEGIN

--Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_EXISTE  FROM ALL_TABLES WHERE TABLE_NAME = ''||TABLA;

  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||'
            ( CLI_ID         NUMBER(16)                     NOT NULL,
              PER_ID         NUMBER(16),
              ARQ_ID         NUMBER(16),
              ARQ_PRIORIDAD  NUMBER(16),
              PER_NOMBRE     VARCHAR2(100 CHAR)             NOT NULL,
              PER_APELLIDO1  VARCHAR2(100 CHAR),
              PER_APELLIDO2  VARCHAR2(100 CHAR),
              DD_AEX_CODIGO  VARCHAR2(25 CHAR)              NOT NULL,
              ITI_NOMBRE     VARCHAR2(100 CHAR),
              DD_TIT_CODIGO  VARCHAR2(50 CHAR)              NOT NULL
            ) NOLOGGING';

  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
     EXECUTE IMMEDIATE ('Create unique index IDX_BATCH_SV_CLIENTES on '||V_ESQUEMA||'.'||TABLA||' (cli_id, per_id) nologging');
     DBMS_OUTPUT.PUT_LINE(TABLA||' INDICE CREADO');
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
