--/*
--##########################################
--## AUTOR=Juan Angel Sánchez
--## FECHA_CREACION=20201002
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10590
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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

  	DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS_GASTOS...');
 	
 	V_MSQL := ( 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS_GASTOS

		AS
		SELECT /*+ leading(rn act agr) use_hash(act) use_hash(agr) */
			DISTINCT
			tbj.tbj_id, 
			tbj.tbj_num_trabajo, 
			tbj.tbj_webcom_id, 
			tbj.tbj_cubre_seguro, 
			tbj.tbj_importe_total, 
			tbj.tbj_fecha_ejecutado,
			ttr.dd_ttr_codigo, 
			ttr.dd_ttr_descripcion, 
			str.dd_str_codigo, 
			str.dd_str_descripcion,
          	tbj.tbj_fecha_solicitud, 
			est.dd_est_codigo, 
			est.dd_est_descripcion, 
			pve.pve_nombre AS proveedor, 
			actpro.pro_id AS propietario,
			pve.pve_id,
			DECODE (tbj.tbj_fecha_cierre_economico, NULL, 0, 1) AS con_cierre_economico,
          	tbj.tbj_fecha_cierre_economico, 
			DECODE (tbj.TBJ_FECHA_EMISION_FACTURA , NULL, DECODE(tbj.TBJ_IMPORTE_TOTAL, NULL, 1, 0, 1, 0), 1) AS facturado, 
			ttr.dd_ttr_filtrar,
			tbj.TBJ_IMPORTE_PRESUPUESTO

     	FROM ' || V_ESQUEMA || '.act_tbj_trabajo tbj 
			INNER JOIN ' || V_ESQUEMA || '.act_tbj atj 								ON atj.tbj_id = tbj.tbj_id
			INNER JOIN ' || V_ESQUEMA || '.act_activo act 							ON (act.act_id = atj.act_id AND act.borrado = 0)
			INNER JOIN ' || V_ESQUEMA || '.act_pac_propietario_activo actpro 		ON (act.act_id = actpro.act_id AND actpro.borrado = 0)
			INNER JOIN ' || V_ESQUEMA || '.act_pro_propietario pro					ON (pro.pro_id = actpro.pro_id AND pro.borrado = 0)
			INNER JOIN ' || V_ESQUEMA || '.act_pvc_proveedor_contacto pvc 			ON (pvc.pvc_id = tbj.pvc_id AND pvc.borrado = 0)
			INNER JOIN ' || V_ESQUEMA || '.act_pve_proveedor pve 					ON (pve.pve_id = pvc.pve_id AND pve.borrado = 0)
			INNER JOIN ' || V_ESQUEMA || '.dd_est_estado_trabajo est 				ON (tbj.dd_est_id = est.dd_est_id AND est.borrado=0)
			INNER JOIN ' || V_ESQUEMA || '.dd_ttr_tipo_trabajo ttr 					ON (ttr.dd_ttr_id = tbj.dd_ttr_id AND ttr.borrado = 0 AND ttr.dd_ttr_filtrar IS NULL)
			INNER JOIN ' || V_ESQUEMA || '.dd_str_subtipo_trabajo str 				ON (str.dd_str_id = tbj.dd_str_id AND str.borrado = 0)
          WHERE tbj.borrado = 0
          	and nvl(tbj.tbj_importe_total, 0) <> 0
          	and nvl(tbj.TBJ_IMPORTE_PRESUPUESTO, 0) <> 0
          	and est.dd_est_codigo in (''05'',''13'')
       	  AND NOT EXISTS (
           	SELECT 1
           	FROM ' || V_ESQUEMA || '.gpv_gastos_proveedor gpv
          	INNER JOIN ' || V_ESQUEMA || '.gld_gastos_linea_detalle gld ON gld.gpv_id = gpv.gpv_id AND gld.borrado = 0
           	INNER JOIN ' || V_ESQUEMA || '.gld_tbj gtb ON gtb.gld_id = gld.gld_id AND gtb.borrado = 0
           	INNER JOIN ' || V_ESQUEMA || '.dd_ega_estados_gasto ega ON ega.dd_ega_id = gpv.dd_ega_id AND ega.borrado = 0
          	WHERE gtb.tbj_id = tbj.tbj_id
               AND gpv.borrado = 0
               AND ega.dd_ega_codigo <> ''06''
       )
          ');

	execute immediate V_MSQL;

  	DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS_GASTOS...Creada OK');

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
