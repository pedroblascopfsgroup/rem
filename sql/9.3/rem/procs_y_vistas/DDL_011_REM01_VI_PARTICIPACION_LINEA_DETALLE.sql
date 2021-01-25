--/*
--##########################################
--## AUTOR= Lara Pablo
--## FECHA_CREACION=20200911
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-11091
--## PRODUCTO=NO
--## Finalidad: Vista para sacar la participacion de una línea de detalle
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
-- 0.1
DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    ERR_NUM NUMBER; -- N?mero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_PARTICIPACION_ELEMENTOS_LINEA_DETALLE' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_PARTICIPACION_ELEMENTOS_LINEA_DETALLE...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_PARTICIPACION_ELEMENTOS_LINEA_DETALLE';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_PARTICIPACION_ELEMENTOS_LINEA_DETALLE... borrada OK'); 
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_PARTICIPACION_ELEMENTOS_LINEA_DETALLE' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_PARTICIPACION_ELEMENTOS_LINEA_DETALLE...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_PARTICIPACION_ELEMENTOS_LINEA_DETALLE';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_PARTICIPACION_ELEMENTOS_LINEA_DETALLE... borrada OK');
  END IF;  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_PARTICIPACION_ELEMENTOS_LINEA_DETALLE...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.VI_PARTICIPACION_ELEMENTOS_LINEA_DETALLE ("GASTO", "LINEA", "PARTICIPACION") AS 
	SELECT 
		
		GPV.GPV_ID AS GASTO, 
		GLD.GLD_ID AS LINEA,
		sum(ENT.gld_participacion_gasto) AS PARTICIPACION

		FROM gld_ent  ENT
		JOIN '|| V_ESQUEMA ||'.gld_gastos_linea_detalle GLD ON ENT.GLD_ID = GLD.GLD_ID 
		JOIN '|| V_ESQUEMA ||'.gpv_gastos_proveedor gpv ON gpv.gpv_id = GLD.gpv_id
		WHERE ENT.BORRADO = 0 AND GLD.BORRADO = 0 AND GPV.BORRADO = 0
		group by ENT.gld_id, GPV.GPV_ID, GLD.GLD_ID';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_PARTICIPACION_ELEMENTOS_LINEA_DETALLE...Creada OK');
  
  EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
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

EXIT;
