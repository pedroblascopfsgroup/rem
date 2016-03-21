--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20160304
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.37
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
 TABLA        VARCHAR(30 CHAR) := 'BATCH_VEN_DATOS_SALIDA_TIT';
 ITABLE_SPACE VARCHAR(25 CHAR) := '#TABLESPACE_INDEX#';
 ERR_NUM      NUMBER;
 ERR_MSG      VARCHAR2(2048 CHAR);
 V_MSQL       VARCHAR2(8500 CHAR);
 V_EXISTE     NUMBER (1);

BEGIN

--Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_EXISTE  FROM ALL_TABLES WHERE TABLE_NAME = ''||TABLA;

  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||'
            ( EXP_ID           NUMBER(16),
              EXP_DESCRIPCION  VARCHAR2(310 CHAR),
              DD_AEX_CODIGO    VARCHAR2(25 CHAR)            NOT NULL,
              OFI_ID           NUMBER(16)                   NOT NULL,
              IMP_PIVOTE       NUMBER(14,2),
              CNT_ID           NUMBER(16)                   NOT NULL,
              PER_ID           NUMBER(16)                   NOT NULL,
              CPE_ORDEN        NUMBER,
              ARQ_ID           NUMBER(16),
              CEX_PASE         NUMBER,
              PEX_PASE         NUMBER,
              DD_TIT_CODIGO    VARCHAR2(50 CHAR)            NOT NULL,
              ARRASTRE         NUMBER
            ) NOLOGGING';

  IF V_EXISTE = 0 THEN
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
  ELSE
     EXECUTE IMMEDIATE ('DROP TABLE '||V_ESQUEMA||'.'||TABLA||' CASCADE CONSTRAINTS ');
     DBMS_OUTPUT.PUT_LINE(TABLA||' BORRADA');
     EXECUTE IMMEDIATE V_MSQL;
     DBMS_OUTPUT.PUT_LINE(TABLA||' CREADA');
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
