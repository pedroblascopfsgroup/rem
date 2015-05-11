/*
--##########################################
--## Author: Carlos Pérez
--## Finalidad: Limpieza BD
--## VERSIONES:
--## 0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
	V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
	V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
	V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
	ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
	ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  
BEGIN

dbms_output.put_line('[INFO] - Inicialización tablas...');

/* Formatted on 2014/10/14 16:53 (Formatter Plus v4.8.8) */



DELETE FROM BANK01.tfi_tareas_form_items;

DELETE FROM BANK01.dd_ptp_plazos_tareas_plazas;

--DELETE FROM BANK01.tev_tarea_externa_valor;

--DELETE FROM BANK01.ter_tarea_externa_recuperacion;

--DELETE FROM BANK01.tex_tarea_externa;

/*

DELETE
FROM BANK01.tar_tareas_notificaciones
WHERE prc_id IN
  (SELECT prc_id
  FROM BANK01.prc_procedimientos
  WHERE dd_tpo_id IN
    (SELECT dd_tpo_id
    FROM dd_tpo_tipo_procedimiento
    )
  );
*/
DELETE FROM BANK01.tap_tarea_procedimiento;

--DELETE FROM BANK01.prc_cex;

--DELETE FROM BANK01.prc_per;

--DELETE FROM BANK01.prd_procedimientos_derivados;

--DELETE FROM BANK01.hac_historico_accesos;

--DELETE FROM BANK01.dpr_decisiones_procedimientos;

--DELETE FROM BANK01.prb_prc_bie;

--DELETE FROM BANK01.bie_sui_subasta_instrucciones;

--DELETE FROM BANK01.lob_lote_bien;

--DELETE FROM BANK01.los_lote_subasta;

--DELETE FROM BANK01.sub_subasta;

--DELETE FROM BANK01.prc_procedimientos;

--DELETE FROM BANK01.EMP_EMBARGOS_PROCEDIMIENTOS; 

DELETE FROM BANK01.dd_tpo_tipo_procedimiento;

DELETE FROM BANK01.DD_TFA_FICHERO_ADJUNTO;

DELETE FROM BANK01.DD_TAC_TIPO_ACTUACION;

--DELETE FROM BANK01.asu_asuntos;

COMMIT;

dbms_output.put_line('[INFO] - FIN Inicialización tablas');

EXCEPTION
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