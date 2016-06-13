--/*
--##########################################
--## AUTOR=DANIEL ALBERT PEREZ 
--## FECHA_CREACION=20160429
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HR-2196
--## PRODUCTO=NO
--## 
--## Finalidad: Borrado contratos Migración PCO
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
  V_ESQUEMA VARCHAR2(25 CHAR) := '#ESQUEMA#';                 -- Configuracion Esquema
  V_ESQUEMA_MASTER VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';         -- Configuracion Esquema Master
  TABLA VARCHAR(30) := 'BATCH_JOB_VALIDATION';
  err_num NUMBER;
  err_msg VARCHAR2(2048 CHAR);
  V_MSQL VARCHAR2(200 CHAR);
  V_BORRAR VARCHAR2(200 CHAR);
  V_BORRAR2 VARCHAR2(200 CHAR);
  V_EXISTE  NUMBER;
  V_EXISTE2  NUMBER;
  KEY_INDICE VARCHAR2(100 CHAR) := 'UK_BATCH_JOB_VALIDATION';

BEGIN
    
--Validamos si la tabla ya tiene clave única antes de crearla  
  SELECT COUNT(*) INTO V_EXISTE FROM ALL_CONSTRAINTS WHERE OWNER = ''||V_ESQUEMA_MASTER||'' AND TABLE_NAME = ''||TABLA||'' AND CONSTRAINT_NAME = ''||KEY_INDICE;
  SELECT COUNT(*) INTO V_EXISTE2 FROM ALL_INDEXES WHERE OWNER = ''||V_ESQUEMA_MASTER||'' AND TABLE_NAME = ''||TABLA||'' AND INDEX_NAME = ''||KEY_INDICE;
  
  V_MSQL := 'ALTER TABLE '||V_ESQUEMA_MASTER||'.'||TABLA||' ADD CONSTRAINT '||KEY_INDICE||' UNIQUE (JOB_VAL_CODIGO, JOB_VAL_ENTITY)';
  V_BORRAR := 'ALTER TABLE '||V_ESQUEMA_MASTER||'.'||TABLA||' DROP CONSTRAINT '||KEY_INDICE;
  V_BORRAR2 := 'DROP INDEX '||V_ESQUEMA_MASTER||'.'||KEY_INDICE;
  
  IF
    V_EXISTE = 1
    THEN
      EXECUTE IMMEDIATE V_BORRAR;
      EXECUTE IMMEDIATE V_MSQL;
      DBMS_OUTPUT.PUT_LINE('Existe la clave única. Se borrará y creará de nuevo.');
    ELSE IF
      V_EXISTE = 0 AND V_EXISTE2 = 1
      THEN
        EXECUTE IMMEDIATE V_BORRAR2;
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('No existe la clave única, pero sí el índice asociado. Se borrará el índice y se creará la clave única.');
      ELSE
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('No existe la clave única. Se creará.');
    END IF;
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
EXIT
