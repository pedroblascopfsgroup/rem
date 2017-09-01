--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170901
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=p2.0.6-170728
--## INCIDENCIA_LINK=HREOS-2719
--## PRODUCTO=NO
--##
--## Finalidad: Crear tablas nuevas y secuencias nuevas
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  ITABLE_SPACE VARCHAR(25 CHAR) :='#TABLESPACE_INDEX#';
  V_TABLA VARCHAR(30) :='ACTIVOS_A_BORRAR';
  err_num NUMBER;
  err_msg VARCHAR2(2048);
  V_EXISTE NUMBER (1);
  V_MSQL VARCHAR2(4000 CHAR);

BEGIN

  --TABLA ACTIVOS_A_BORRAR
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' ';
  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

  IF V_EXISTE = 1 THEN
    V_MSQL := 'DROP TABLE '||V_TABLA||' PURGE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('TABLA '||V_TABLA||' BORRADA.');
  END IF;

  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
    ( "ID" NUMBER(16),
      "TABLA" VARCHAR2(200 CHAR), 
      "CLAVE_TABLA" VARCHAR2(4000 CHAR), 
      "ORDEN_TABLA" NUMBER, 
      "TABLA_REF" VARCHAR2(200 CHAR), 
      "CLAVE_REF" VARCHAR2(4000 CHAR), 
      "ORDEN_TABLA_REF" NUMBER
    ) TABLESPACE '||ITABLE_SPACE||' ';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('TABLA '||V_TABLA||' CREADA.');

--DAMOS GRANTS
  V_MSQL := 'SELECT COUNT(1) FROM ALL_USERS WHERE USERNAME = ''PFSREM'' ';
  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;
  IF V_EXISTE = 1 THEN
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||V_TABLA||' TO PFSREM';
  END IF;

  --SECUENCIA TABLA ACTIVOS_A_BORRAR
  V_TABLA := 'S_ACTIVOS_A_BORRAR'
  V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' ';
  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

  IF V_EXISTE = 1 THEN
    V_MSQL := 'DROP SEQUENCE '||V_TABLA;
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('SECUENCIA '||V_TABLA||' BORRADA.');
  END IF;

  V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.'||V_TABLA||' MINVALUE 0 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 0 CACHE 20 NOORDER  NOCYCLE ';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('SECUENCIA '||V_TABLA||' CREADA.');

  --TABLA ACTIVOS_A_BORRAR_2
  V_TABLA := 'ACTIVOS_A_BORRAR_2';
  V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||''' ';
  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;

  IF V_EXISTE = 1 THEN
    V_MSQL := 'DROP TABLE '||V_TABLA||' PURGE';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('TABLA '||V_TABLA||' BORRADA.');
  END IF;

  V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
    ( "TABLA" VARCHAR2(200 CHAR), 
      "ORDEN_TABLA" NUMBER
    ) TABLESPACE '||ITABLE_SPACE||'';
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('TABLA '||V_TABLA||' CREADA.');

--DAMOS GRANTS
  V_MSQL := 'SELECT COUNT(1) FROM ALL_USERS WHERE USERNAME = ''PFSREM'' ';
  EXECUTE IMMEDIATE V_MSQL INTO V_EXISTE;
  IF V_EXISTE = 1 THEN
    EXECUTE IMMEDIATE 'GRANT SELECT, INSERT, UPDATE, DELETE ON '||V_TABLA||' TO PFSREM';
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    err_num := SQLCODE;
    err_msg := SQLERRM;
    DBMS_OUTPUT.put_line('Error:'||TO_CHAR(err_num));
    DBMS_OUTPUT.put_line(err_msg);
    ROLLBACK;
    RAISE;
END;
/
EXIT
