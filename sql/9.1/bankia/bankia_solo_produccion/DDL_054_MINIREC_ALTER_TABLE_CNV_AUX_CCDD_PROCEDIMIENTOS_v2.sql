
--/*
--##########################################
--## Author: Alejandro Iñigo
--## Finalidad: Modificar tabla tipo de la columna CNV_AUX_CCDD_PROCEDIMIENTOS.NUMERO_AUTOS
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES: 0.1 Version inicial
--## OBSERV: 
--## 
--##########################################
--*/

--Para permitir la visualizacion de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'MINIREC'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
	
BEGIN    

    DBMS_OUTPUT.PUT_LINE('[START] Modificamos la tabla CNV_AUX_CCDD_PROCEDIMIENTOS');
	
	EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || V_ESQUEMA || '.CNV_AUX_CCDD_PROCEDIMIENTOS ';

    SELECT COUNT(1) INTO V_NUM_TABLAS FROM all_tab_cols 
    WHERE UPPER(table_name) = 'CNV_AUX_CCDD_PROCEDIMIENTOS' and UPPER(column_name) = 'NUMERO_AUTOS' and UPPER(owner)='MINIREC';
	
    IF V_NUM_TABLAS = 1 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE ' || V_ESQUEMA || '.CNV_AUX_CCDD_PROCEDIMIENTOS MODIFY NUMERO_AUTOS VARCHAR2(15 CHAR)';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.CNV_AUX_CCDD_PROCEDIMIENTOS... NUMERO_AUTOS modificada');
    END IF;	
		

DBMS_OUTPUT.PUT_LINE('TABLE '|| V_ESQUEMA ||'.CNV_AUX_CCDD_PROCEDIMIENTOS... Tabla MODIFICADA OK');
    
DBMS_OUTPUT.PUT_LINE('[INFO] EJECUCION TERMINADA CON EXITO');

EXCEPTION
     WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion: '|| TO_CHAR(SQLCODE) || ' ' || SQLERRM );
    RAISE;
END;
/
exit		
	
