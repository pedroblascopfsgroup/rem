--/*
--##########################################
--## Author: Óscar
--## Finalidad: DDL que añade nuevas vistas para buscador de tareas
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'BANKMASTER'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script. 
    v_column_count     NUMBER(3);                    -- Vble. para validar la existencia de las Columnas.

BEGIN

	 SELECT COUNT(1)
    INTO v_column_count
    FROM user_tab_cols
    WHERE LOWER(table_name) = 'bie_adj_adjudicacion'
    AND UPPER(column_name)  = 'BIE_ADJ_CESION_REMATE';
    
    IF v_column_count       = 0 THEN

      execute immediate 'ALTER TABLE  ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_CESION_REMATE  NUMBER(1))';
	  execute immediate 'ALTER TABLE  ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION ADD (BIE_ADJ_CESION_REMATE_IMP  NUMBER(16,2))';
	  
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Columna BIE_ADJ_CESION_REMATE añadida.');
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Columna BIE_ADJ_CESION_REMATE_IMP añadida.');
    ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_ADJ_ADJUDICACION... Columna BIE_ADJ_CESION_REMATE ya existe.');
    END IF;
     
	 DBMS_OUTPUT.PUT_LINE('[INFO] FIN MODIFICACIÓN DEL MODELO DE BIENES');


EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT	
	 