--/*
--##########################################
--## AUTOR=LUIS RUIZ
--## FECHA_CREACION=20160504
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2.2
--## INCIDENCIA_LINK=PRODUCTO-801
--## PRODUCTO=SI
--##
--## Finalidad: DDL
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Se agrega DD_TPX_CODIGO
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
 V_ESQUEMA    VARCHAR2(25 CHAR):= '#ESQUEMA#';
 V_ESQUEMA_M  VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
 TABLA        VARCHAR(30 CHAR) := 'TMP_BATCH_SV_BPM_INSTANCE';
 ITABLE_SPACE VARCHAR(25 CHAR) := '#TABLESPACE_INDEX#';
 ERR_NUM      NUMBER;
 ERR_MSG      VARCHAR2(2048 CHAR);
 V_MSQL       VARCHAR2(8500 CHAR);
 V_EXISTE     NUMBER (1);

BEGIN

--Validamos si la tabla existe antes de crearla
  SELECT COUNT(*) INTO V_EXISTE  FROM ALL_TABLES WHERE TABLE_NAME = ''||TABLA;

  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||TABLA||'
            (
              EXP_ID           NUMBER(16)                   NOT NULL,
              PROCESSINSTANCE  INTEGER,
              TOKEN            INTEGER,
              MODULEINSTANCE   INTEGER,
              VARIABLEMAP      INTEGER,
              DD_TPX_CODIGO    VARCHAR2 (20 CHAR)
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
