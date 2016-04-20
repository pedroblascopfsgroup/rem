--/*
--##########################################
--## AUTOR=JAIME
--## FECHA_CREACION=20160420
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-3137
--## PRODUCTO=NO
--## Finalidad: DML
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
set timing ON
set linesize 2000
SET VERIFY OFF
set timing on
set feedback on

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN


      SELECT COUNT(1)
      INTO V_NUM_TABLAS
      FROM ALL_TABLES
      WHERE TABLE_NAME = 'TMP_SUB_FECHA_SENYALAMIENTO';
      
      IF V_NUM_TABLAS = 0 THEN
      
         V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_SUB_FECHA_SENYALAMIENTO 
                           (CD_PROCEDIMIENTO NUMBER(16,0), 
                            FECHA_SENYALAMIENTO DATE
                           )';
                           
        EXECUTE IMMEDIATE V_SQL;
        DBMS_OUTPUT.PUT_LINE('TABLA TMP_SUB_FECHA_SENYALAMIENTO CREADA');

      END IF;

EXCEPTION
    WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.put_line(V_SQL);
      DBMS_OUTPUT.put_line('-----------------------------------------------------------');
      DBMS_OUTPUT.put_line(ERR_MSG);
      ROLLBACK;
      RAISE;

END;
/

EXIT;
