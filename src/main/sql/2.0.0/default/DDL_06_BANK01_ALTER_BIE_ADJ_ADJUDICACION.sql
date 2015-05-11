--/*
--##########################################
--## Author: Roberto
--## Finalidad: DDL de Bienes adjudicados
--##            Alter para ampliar los adjudicados de un bien con el campo "BIE_ADJ_IMPORTE_ADJUDICACION"
--##
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
  seq_count          NUMBER(3);                    -- Vble. para validar la existencia de las Secuencias.
  table_count        NUMBER(3);                    -- Vble. para validar la existencia de las Tablas.
  v_column_count     NUMBER(3);                    -- Vble. para validar la existencia de las Columnas.
  v_constraint_count NUMBER(3);                    -- Vble. para validar la existencia de las Constraints.
  err_num            NUMBER;                       -- Número de errores
  err_msg            VARCHAR2(2048);               -- Mensaje de error
  V_ESQUEMA          VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
  V_MSQL             VARCHAR2(4000 CHAR);
BEGIN
  DBMS_OUTPUT.PUT_LINE('[START] Modificar tabla BIE_ADJ_ADJUDICACION');
  
  SELECT COUNT(1)
  INTO table_count
  FROM all_tables
  WHERE table_name = 'BIE_ADJ_ADJUDICACION';
  
  IF table_count   = 1 THEN
  
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Existe');
    
    -- Crear las nuevas columnas de saneamientos
    SELECT COUNT(1)
    INTO v_column_count
    FROM user_tab_cols
    WHERE LOWER(table_name) = 'bie_adj_adjudicacion'
    AND UPPER(column_name)  = 'BIE_ADJ_IMPORTE_ADJUDICACION';
    
    IF v_column_count       = 0 THEN
      EXECUTE immediate 'ALTER TABLE ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_IMPORTE_ADJUDICACION NUMBER(16,2) )';
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Columna BIE_ADJ_IMPORTE_ADJUDICACION añadida.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Columna BIE_ADJ_IMPORTE_ADJUDICACION ya existe.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... FIN');
  END IF;
EXCEPTION
WHEN OTHERS THEN
  err_num := SQLCODE;
  err_msg := SQLERRM;
  DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(err_num));
  DBMS_OUTPUT.put_line('-----------------------------------------------------------');
  DBMS_OUTPUT.put_line(err_msg);
  ROLLBACK;
  RAISE;
END;
/

EXIT;