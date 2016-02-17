--/*
--##########################################
--## AUTOR=FRAN G
--## FECHA_CREACION=20160126
--## ARTEFACTO=ETL
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=BKREC-1628
--## PRODUCTO=NO
--## Finalidad: Añadir Fecha de inicio de situación en tabla propuestas
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_SQL VARCHAR2(4000 CHAR);

    -- Otras variables
    V_ESQUEMA_MINIREC VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- Configuracion Esquema minirec

 BEGIN

    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''RCV_GEST_PROPUESTA'' and owner = '''||V_ESQUEMA_MINIREC||'''';
    EXECUTE IMMEDIATE V_SQL INTO table_count;
    -- Si existe la tabla procedemos a modificarla
    IF table_count = 1 THEN
    		V_SQL := 'SELECT COUNT(1) FROM all_tab_columns WHERE TABLE_NAME = ''RCV_GEST_PROPUESTA'' and owner = '''||V_ESQUEMA_MINIREC||''' and column_name = ''FECHA_INICIO_SITUACION''';
    		EXECUTE IMMEDIATE V_SQL INTO v_column_count;
    		--si no existe la columna la creamos
    		IF v_column_count = 0 THEN
	            V_SQL := 'ALTER TABLE '||V_ESQUEMA_MINIREC||'.RCV_GEST_PROPUESTA ADD FECHA_INICIO_SITUACION DATE';
	            EXECUTE IMMEDIATE V_SQL;
	            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MINIREC || '.RCV_GEST_PROPUESTA columna FECHA_INICIO_SITUACION añadida');
	        ELSE
	        	DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MINIREC || '.RCV_GEST_PROPUESTA columna FECHA_INICIO_SITUACION ya existe');
	        END IF;	
    ELSE	
		    DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_MINIREC || '.RCV_GEST_PROPUESTA... La tabla NO existe.');
    END IF;

 EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END;
/

EXIT;
