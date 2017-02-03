--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20170203
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1478
--## PRODUCTO=NO
--## Finalidad: DDL con vista del anterior precio por activo.
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
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'V_PIVOT_PRECIOS_ACTIVOS_ANT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||' 
	AS
  		WITH PIVOT_DATA AS (
			SELECT * FROM (
				SELECT HVAL.ACT_ID, DD.DD_TPC_CODIGO, HVAL.HVA_FECHA_INICIO, HVAL.HVA_FECHA_FIN, HVAL.HVA_IMPORTE,
				ROW_NUMBER() OVER (PARTITION BY HVAL.ACT_ID, HVAL.DD_TPC_ID ORDER BY HVAL.HVA_ID DESC) ORDEN
				FROM '||V_ESQUEMA||'.ACT_HVA_HIST_VALORACIONES HVAL
		        LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO DD ON DD.DD_TPC_ID = HVAL.DD_TPC_ID
		        WHERE HVAL.BORRADO = 0) AUX
			WHERE AUX.ORDEN = 1
		)
		SELECT * FROM PIVOT_DATA
		PIVOT (MAX(HVA_FECHA_INICIO)						AS F_INI,
		MAX(HVA_FECHA_FIN) 									AS F_FIN,
		MAX(HVA_IMPORTE) FOR DD_TPC_CODIGO IN (	
			''01'' AS "VNC",
			''02'' AS "APROBADO_VENTA_WEB",
			''03'' AS "APROBADO_RENTA_WEB",
			''04'' AS "MINIMO_AUTORIZADO",
			''07'' AS "DESCUENTO_APROBADO",
			''09'' AS "VALOR_VPO",
			''11'' AS "VALOR_ESTIMADO_VENTA",
			''12'' AS "VALOR_ESTIMADO_RENTA",
			''13'' AS "DESCUENTO_PUBLICADO",
			''14'' AS "VALOR_REF",
			''15'' AS "PT",
			''16'' AS "VALOR_ASESORADO_LIQ",
			''17'' AS "VACBE",
			''18'' AS "COSTE_ADIQUISICION",
			''19'' AS "FSV_VENTA",
			''20'' AS "FSV_RENTA"))';
				

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
  
EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT;