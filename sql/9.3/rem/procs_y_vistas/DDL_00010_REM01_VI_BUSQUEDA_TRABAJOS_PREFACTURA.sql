--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211202
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16593
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - Pablo Garcia Pallás (HREOS-10987)
--## 		0.2 Añadir campo anyo_trabajo
--##		0.3 Añadir nueva tabla de prefacturas - HREOS-16576
--##		0.4 Añadir columna propietario y ordenador por dicha y número de trabajo - HREOS-16593
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
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  /*SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS... borrada OK');
  END IF;
*/
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS_PREFACTURAS...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS_PREFACTURAS 

	AS
		select 
			tbj.tbj_id,
			PTG.PFA_ID,
		    tbj.tbj_num_trabajo,
		    NVL(tbj.tbj_importe_total,0.0) as importe_cliente,
		    NVL(tbj.tbj_importe_presupuesto,0.0) as importe_total,
		    tbj.tbj_descripcion,
		    tbj.tbj_fecha_solicitud,
		    ttr.dd_ttr_descripcion,
			ttr.dd_ttr_codigo,
		    est.dd_est_descripcion,
			est.dd_est_codigo,
		    str.dd_str_descripcion,
			str.dd_str_codigo,
			TO_CHAR(TBJ.TBJ_FECHA_SOLICITUD,''YYYY'') ANYO_TRABAJO,
			1 CHECK_TBJ,
			PRO.PRO_NOMBRE

		from ' || V_ESQUEMA || '.act_tbj_trabajo tbj
			join ' || V_ESQUEMA || '.dd_ttr_tipo_trabajo ttr on tbj.dd_ttr_id = ttr.dd_ttr_id
			join ' || V_ESQUEMA || '.dd_est_estado_trabajo est on tbj.dd_est_id = est.dd_est_id
			join ' || V_ESQUEMA || '.dd_str_subtipo_trabajo str on tbj.dd_str_id = str.dd_str_id
			JOIN ' || V_ESQUEMA ||'.PTG_PREFACTURAS PTG ON PTG.tbj_id = tbj.tbj_id AND PTG.BORRADO = 0
			JOIN ' || V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PTG.PRO_ID = PRO.PRO_ID AND PRO.BORRADO = 0
		where tbj.borrado = 0
		ORDER BY 16, 3
		';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS_PREFACTURAS...Creada OK');

  COMMIT;

  EXCEPTION
	     WHEN OTHERS THEN
	          err_num := SQLCODE;
	          err_msg := SQLERRM;
	
	          DBMS_OUTPUT.PUT_LINE('KO no modificada');
	          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
	          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
	          DBMS_OUTPUT.put_line(err_msg);
	
	          ROLLBACK;
	          RAISE;   
  
END;
/

EXIT;
