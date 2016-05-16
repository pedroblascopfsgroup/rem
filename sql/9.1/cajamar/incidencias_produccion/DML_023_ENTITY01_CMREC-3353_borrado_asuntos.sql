--##########################################
--## AUTOR=Pepe Tamarit
--## FECHA_CREACION=20160516
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=CMREC-3353
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar asuntos con borrado lógico
--## INSTRUCCIONES:  
--## VERSIONES:
--##            0.1 Versión inicial
--##########################################
--*/
/***************************************/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
set timing ON
set linesize 2000
SET VERIFY OFF
set feedback on

DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

  DBMS_OUTPUT.PUT_LINE('[INICIO] CMREC-3353');
    
 -- CMREC-3353
 -- Borrado selectivo de Asuntos - Mantiene los expedientes
delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136937);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136937);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136937);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136937);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136937);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136937);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136937;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136937;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136937;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136937;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136937;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136937;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136938);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136938);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136938);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136938);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136938);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136938);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136938;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136938;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136938;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136938;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136938;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136938;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136939);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136939);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136939);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136939);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136939);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136939);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136939;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136939;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136939;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136939;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136939;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136939;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136940);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136940);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136940);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136940);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136940);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136940);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136940;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136940;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136940;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136940;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136940;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136940;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136941);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136941);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136941);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136941);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136941);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136941);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136941;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136941;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136941;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136941;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136941;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136941;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136942);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136942);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136942);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136942);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136942);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136942);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136942;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136942;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136942;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136942;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136942;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136942;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136943);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136943);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136943);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136943);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136943);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136943);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136943;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136943;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136943;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136943;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136943;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136943;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136944);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136944);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136944);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136944);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136944);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136944);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136944;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136944;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136944;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136944;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136944;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136944;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136945);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136945);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136945);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136945);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136945);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136945);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136945;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136945;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136945;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136945;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136945;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136945;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136946);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136946);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136946);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136946);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136946);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136946);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136946;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136946;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136946;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136946;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136946;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136946;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136947);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136947);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136947);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136947);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136947);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136947);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136947;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136947;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136947;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136947;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136947;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136947;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136948);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136948);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136948);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136948);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136948);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136948);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136948;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136948;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136948;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136948;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136948;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136948;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136949);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136949);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136949);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136949);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136949);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136949);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136949;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136949;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136949;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136949;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136949;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136949;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136950);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136950);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136950);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136950);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136950);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136950);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136950;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136950;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136950;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136950;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136950;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136950;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136951);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136951);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136951);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136951);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136951);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136951);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136951;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136951;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136951;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136951;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136951;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136951;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136952);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136952);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136952);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136952);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136952);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136952);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136952;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136952;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136952;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136952;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136952;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136952;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136953);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136953);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136953);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136953);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136953);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136953);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136953;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136953;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136953;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136953;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136953;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136953;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136954);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136954);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136954);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136954);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136954);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136954);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136954;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136954;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136954;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136954;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136954;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136954;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136955);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136955);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136955);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136955);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136955);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136955);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136955;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136955;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136955;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136955;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136955;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136955;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136956);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136956);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136956);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136956);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136956);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136956);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136956;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136956;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136956;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136956;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136956;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136956;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136957);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136957);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136957);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136957);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136957);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136957);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136957;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136957;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136957;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136957;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136957;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136957;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136958);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136958);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136958);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136958);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136958);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136958);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136958;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136958;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136958;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136958;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136958;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136958;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136959);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136959);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136959);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136959);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136959);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136959);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136959;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136959;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136959;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136959;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136959;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136959;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136960);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136960);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136960);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136960);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136960);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136960);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136960;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136960;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136960;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136960;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136960;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136960;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136961);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136961);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136961);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136961);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136961);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136961);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136961;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136961;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136961;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136961;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136961;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136961;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136962);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136962);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136962);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136962);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136962);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136962);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136962;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136962;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136962;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136962;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136962;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136962;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136963);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136963);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136963);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136963);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136963);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136963);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136963;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136963;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136963;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136963;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136963;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136963;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136964);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136964);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136964);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136964);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136964);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136964);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136964;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136964;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136964;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136964;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136964;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136964;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136900);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136900);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136900);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136900);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136900);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136900);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136900;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136900;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136900;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136900;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136900;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136900;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136901);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136901);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136901);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136901);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136901);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136901);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136901;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136901;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136901;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136901;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136901;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136901;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136902);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136902);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136902);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136902);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136902);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136902);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136902;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136902;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136902;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136902;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136902;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136902;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136903);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136903);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136903);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136903);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136903);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136903);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136903;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136903;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136903;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136903;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136903;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136903;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136904);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136904);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136904);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136904);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136904);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136904);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136904;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136904;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136904;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136904;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136904;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136904;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136905);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136905);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136905);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136905);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136905);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136905);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136905;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136905;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136905;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136905;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136905;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136905;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136906);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136906);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136906);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136906);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136906);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136906);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136906;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136906;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136906;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136906;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136906;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136906;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136907);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136907);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136907);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136907);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136907);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136907);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136907;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136907;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136907;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136907;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136907;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136907;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136908);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136908);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136908);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136908);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136908);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136908);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136908;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136908;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136908;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136908;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136908;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136908;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136909);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136909);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136909);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136909);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136909);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136909);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136909;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136909;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136909;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136909;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136909;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136909;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136910);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136910);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136910);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136910);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136910);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136910);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136910;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136910;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136910;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136910;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136910;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136910;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136911);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136911);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136911);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136911);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136911);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136911);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136911;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136911;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136911;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136911;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136911;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136911;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136912);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136912);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136912);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136912);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136912);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136912);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136912;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136912;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136912;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136912;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136912;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136912;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136913);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136913);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136913);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136913);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136913);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136913);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136913;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136913;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136913;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136913;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136913;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136913;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136914);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136914);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136914);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136914);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136914);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136914);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136914;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136914;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136914;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136914;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136914;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136914;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136915);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136915);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136915);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136915);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136915);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136915);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136915;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136915;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136915;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136915;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136915;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136915;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136916);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136916);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136916);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136916);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136916);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136916);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136916;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136916;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136916;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136916;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136916;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136916;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136917);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136917);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136917);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136917);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136917);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136917);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136917;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136917;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136917;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136917;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136917;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136917;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136918);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136918);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136918);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136918);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136918);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136918);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136918;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136918;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136918;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136918;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136918;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136918;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136919);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136919);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136919);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136919);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136919);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136919);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136919;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136919;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136919;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136919;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136919;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136919;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136920);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136920);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136920);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136920);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136920);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136920);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136920;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136920;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136920;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136920;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136920;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136920;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136921);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136921);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136921);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136921);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136921);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136921);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136921;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136921;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136921;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136921;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136921;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136921;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136922);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136922);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136922);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136922);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136922);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136922);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136922;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136922;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136922;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136922;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136922;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136922;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136923);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136923);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136923);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136923);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136923);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136923);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136923;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136923;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136923;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136923;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136923;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136923;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136924);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136924);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136924);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136924);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136924);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136924);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136924;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136924;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136924;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136924;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136924;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136924;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136925);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136925);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136925);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136925);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136925);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136925);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136925;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136925;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136925;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136925;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136925;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136925;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136926);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136926);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136926);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136926);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136926);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136926);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136926;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136926;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136926;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136926;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136926;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136926;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136927);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136927);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136927);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136927);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136927);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136927);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136927;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136927;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136927;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136927;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136927;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136927;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136928);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136928);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136928);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136928);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136928);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136928);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136928;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136928;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136928;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136928;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136928;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136928;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136929);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136929);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136929);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136929);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136929);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136929);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136929;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136929;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136929;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136929;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136929;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136929;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136930);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136930);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136930);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136930);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136930);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136930);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136930;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136930;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136930;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136930;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136930;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136930;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136931);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136931);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136931);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136931);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136931);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136931);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136931;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136931;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136931;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136931;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136931;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136931;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136932);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136932);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136932);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136932);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136932);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136932);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136932;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136932;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136932;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136932;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136932;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136932;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136933);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136933);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136933);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136933);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136933);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136933);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136933;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136933;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136933;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136933;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136933;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136933;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136934);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136934);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136934);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136934);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136934);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136934);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136934;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136934;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136934;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136934;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136934;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136934;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136935);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136935);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136935);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136935);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136935);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136935);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136935;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136935;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136935;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136935;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136935;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136935;


delete from #ESQUEMA#.prb_prc_bie where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136936);
delete from #ESQUEMA#.prc_cex where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136936);
delete from #ESQUEMA#.prc_per where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136936);
delete from #ESQUEMA#.pco_prc_hep_histor_est_prep where pco_prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136936);
delete from #ESQUEMA#.pco_prc_procedimientos where prc_id in (select prc_id from #ESQUEMA#.prc_procedimientos where asu_id = 100136936);
delete from #ESQUEMA#.tex_tarea_externa where tar_id in (select tar_id from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136936);
delete from #ESQUEMA#.tar_tareas_notificaciones where asu_id = 100136936;
delete from #ESQUEMA#.prc_procedimientos where asu_id = 100136936;
delete from #ESQUEMA#.hac_historico_accesos where asu_id = 100136936;
delete from #ESQUEMA#.gaa_gestor_adicional_asunto where asu_id = 100136936;
delete from #ESQUEMA#.gah_gestor_adicional_historico where gah_asu_id = 100136936;
delete from #ESQUEMA#.asu_asuntos where asu_id = 100136936;

commit;

  DBMS_OUTPUT.PUT_LINE('[FIN] CMREC-3353');        
   
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(V_SQL);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
