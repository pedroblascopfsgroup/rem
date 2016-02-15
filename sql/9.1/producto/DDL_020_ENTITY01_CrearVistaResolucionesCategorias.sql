--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150622
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Vista VTAR_RESOLUCIONES_CATEGORIAS
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    table_count2 number(3);
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('******** VTAR_RESOLUCIONES_CATEGORIAS ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.VTAR_RESOLUCIONES_CATEGORIAS... Comprobaciones previas');
	

	-- Comprobamos si existe la vista
	V_MSQL := 'SELECT COUNT(1) FROM ALL_VIEWS WHERE VIEW_NAME = ''VTAR_RESOLUCIONES_CATEGORIAS'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.VTAR_RESOLUCIONES_CATEGORIAS... ya existe, se reemplazará');
		EXECUTE IMMEDIATE 'DROP VIEW VTAR_RESOLUCIONES_CATEGORIAS';
		V_MSQL := 'CREATE OR REPLACE VIEW ' ||V_ESQUEMA||'.VTAR_RESOLUCIONES_CATEGORIAS
		(USU_PENDIENTES, CAT_ID, COUNT)
			AS SELECT   VPROCU.USU_PENDIENTES, VPROCU.CAT_ID, COUNT(*)
    			FROM (SELECT DISTINCT USU_PENDIENTES, CAT_ID, TAR_ID
                   	    FROM VTAR_TAREA_VS_PROCURADORES) VPROCU
   				GROUP BY (VPROCU.CAT_ID, VPROCU.USU_PENDIENTES)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VTAR_RESOLUCIONES_CATEGORIAS... Creando vista');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VTAR_RESOLUCIONES_CATEGORIAS... OK');
			
		ELSE
			V_MSQL := 'CREATE OR REPLACE VIEW ' ||V_ESQUEMA||'.VTAR_RESOLUCIONES_CATEGORIAS
		 	(USU_PENDIENTES, CAT_ID, COUNT)
				AS SELECT   VPROCU.USU_PENDIENTES, VPROCU.CAT_ID, COUNT(*)
       				FROM (SELECT DISTINCT USU_PENDIENTES, CAT_ID, TAR_ID
                    	    FROM VTAR_TAREA_VS_PROCURADORES) VPROCU
   					GROUP BY (VPROCU.CAT_ID, VPROCU.USU_PENDIENTES)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VTAR_RESOLUCIONES_CATEGORIAS... Creando vista');
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.VTAR_RESOLUCIONES_CATEGORIAS... OK');
	END IF;

	COMMIT;
	
EXCEPTION


	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/

EXIT;