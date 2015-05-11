/* Formatted on 2015/02/24 11:01 (Formatter Plus v4.8.8) */
--/*

--##########################################

--## Author: Óscar

--## Finalidad: DDL de los_lote_subasta

--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE

--## VERSIONES:

--##        0.1 Versi?n inicial

--##########################################

--*/

--Para permitir la visualizaci?n de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;

DECLARE
   seq_count            NUMBER (3);                                                                                                              -- Vble. para validar la existencia de las Secuencias.
   table_count          NUMBER (3);                                                                                                                  -- Vble. para validar la existencia de las Tablas.
   v_column_count       NUMBER (3);                                                                                                                -- Vble. para validar la existencia de las Columnas.
   v_constraint_count   NUMBER (3);                                                                                                             -- Vble. para validar la existencia de las Constraints.
   err_num              NUMBER;                                                                                                                                                    -- N?mero de errores
   err_msg              VARCHAR2 (2048);                                                                                                                                            -- Mensaje de error
   v_esquema            VARCHAR2 (25 CHAR)   := 'HAYA01';                                                                                                                     -- Configuracion Esquemas
   v_msql               VARCHAR2 (4000 CHAR);
BEGIN
   DBMS_OUTPUT.put_line ('[START] Modificar tabla LOS_LOTE_SUBASTA');

   SELECT COUNT (1)
     INTO table_count
     FROM all_tables
    WHERE table_name = 'LOS_LOTE_SUBASTA';

   IF table_count = 1
   THEN
      DBMS_OUTPUT.put_line ('[INFO] ' || v_esquema || '.LOS_LOTE_SUBASTA... Existe');

      -- Crear la nueva columna BIE_ADJ_REQ_SUBSANACION
      SELECT COUNT (1)
        INTO v_column_count
        FROM user_tab_cols
       WHERE UPPER (table_name) = 'LOS_LOTE_SUBASTA' AND UPPER (column_name) = 'LOS_NUM_LOTE';

      IF v_column_count = 0
      THEN
         EXECUTE IMMEDIATE 'ALTER TABLE ' || v_esquema || '.LOS_LOTE_SUBASTA ADD (LOS_NUM_LOTE  NUMBER(16))';

         DBMS_OUTPUT.put_line ('[INFO] ' || v_esquema || '.LOS_LOTE_SUBASTA... Columna LOS_NUM_LOTE Añadida');
      ELSE
         DBMS_OUTPUT.put_line ('[INFO] ' || v_esquema || '.LOS_LOTE_SUBASTA... La Columna LOS_NUM_LOTE ya existe');
      END IF;

      DBMS_OUTPUT.put_line ('[INFO] ' || v_esquema || '.LOS_LOTE_SUBASTA... FIN');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      err_num := SQLCODE;
      err_msg := SQLERRM;
      DBMS_OUTPUT.put_line ('[ERROR] Se ha producido un error en la ejecución:' || TO_CHAR (err_num));
      DBMS_OUTPUT.put_line ('-----------------------------------------------------------');
      DBMS_OUTPUT.put_line (err_msg);
      ROLLBACK;
      RAISE;
END;
/

EXIT;
