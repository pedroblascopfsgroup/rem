--/*
--##########################################
--## Author: Gonzalo
--## Finalidad: Columna CD_NUITE en la valoracion de un bien para almacenar el código devuelto por el servicio de Tasacion UVEM
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
    WHERE LOWER(table_name) = 'BIE_VALORACIONES'
    AND UPPER(column_name)  = 'BIE_CD_NUITA';
    
    IF v_column_count       = 0 THEN
      execute immediate 'ALTER TABLE  ' || V_ESQUEMA || '.BIE_VALORACIONES ADD (BIE_CD_NUITA  NUMBER(16,0))';
    ELSE
      DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.BIE_VALORACIONES... Columna BIE_CD_NUITA ya existe.');
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
	 