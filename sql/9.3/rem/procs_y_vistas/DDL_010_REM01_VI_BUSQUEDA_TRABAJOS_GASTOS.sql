--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20210426
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12580
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--## 		0.2 Añadir condición - REMVIP-8892
--## 		0.3 Añadir condición - REMVIP-9036
--## 		0.4 Modificar condición - REMVIP-9566
--## 		0.5 Modificar condición - REMVIP-9573
--#########################################
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
			tbj.tbj_cubre_seguro, 
			tbj.tbj_importe_total, 
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
			tbj.TBJ_IMPORTE_PRESUPUESTO,
			tga.dd_tga_codigo

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
			LEFT  JOIN ' || V_ESQUEMA || '.dd_ire_identificador_ream ire 			ON (ire.dd_ire_id = tbj.dd_ire_id AND ire.borrado = 0)
			INNER JOIN ' || V_ESQUEMA || '.act_sgt_subtipo_gpv_tbj sgt            	ON (str.dd_str_id = sgt.dd_str_id AND sgt.borrado = 0)
			INNER JOIN ' || V_ESQUEMA || '.dd_stg_subtipos_gasto stg            	ON (sgt.dd_stg_id = stg.dd_stg_id AND stg.borrado = 0)
			INNER JOIN ' || V_ESQUEMA || '.dd_tga_tipos_gasto tga            		ON (stg.dd_tga_id = tga.dd_tga_id AND tga.borrado = 0)
          WHERE tbj.borrado = 0
          	and (
                ((NVL(TBJ.TBJ_IMPORTE_TOTAL, 0) <> 0
                    AND NVL(TBJ.TBJ_IMPORTE_PRESUPUESTO, 0) <> 0) 
					OR (NVL(TBJ.TBJ_IMPORTE_TOTAL, 0) = 0
                    AND NVL(TBJ.TBJ_IMPORTE_PRESUPUESTO, 0) <> 0)
					OR (NVL(TBJ.TBJ_IMPORTE_TOTAL, 0) <> 0
                    AND NVL(TBJ.TBJ_IMPORTE_PRESUPUESTO, 0) = 0))
                OR EXISTS (
                    SELECT 1
                    FROM (
                        SELECT PSU.TBJ_ID, SUM(
                                CASE
                                    WHEN TAD.DD_TAD_CODIGO = ''01''
                                        THEN -NVL(PSU.PSU_IMPORTE, 0)
                                    WHEN TAD.DD_TAD_CODIGO = ''02''
                                        THEN NVL(PSU.PSU_IMPORTE, 0)
                                END
                            ) IMPORTE_PROV_SUPL
                        FROM ' || V_ESQUEMA || '.ACT_PSU_PROVISION_SUPLIDO PSU
                        JOIN ' || V_ESQUEMA || '.DD_TAD_TIPO_ADELANTO TAD ON TAD.DD_TAD_ID = PSU.DD_TAD_ID
                            AND TAD.BORRADO = 0
                        WHERE PSU.BORRADO = 0
                        GROUP BY PSU.TBJ_ID
                    ) PSU
                    WHERE PSU.TBJ_ID = TBJ.TBJ_ID
                        AND PSU.IMPORTE_PROV_SUPL <> 0
                )
            )
          	and est.dd_est_codigo in (''05'',''13'')
			and (ire.dd_ire_codigo = ''04'' or tbj.dd_ire_id is null)
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
