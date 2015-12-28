/*
--##########################################
--## AUTOR=PEDROBLASCO
--## FECHA_CREACION=20150827
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-130
--## PRODUCTO=SI
--##
--## Finalidad: Inserción de datos de configuración de las tareas especiales de Precontencioso
--## INSTRUCCIONES:  Ejecutar y definir las variables
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON
SET DEFINE OFF
set timing ON
set linesize 2000

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    VAR_TABLENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear
    VAR_SEQUENCENAME VARCHAR2(50 CHAR); -- Nombre de la tabla a crear

    VAR_TIPOACTUACION VARCHAR2(50 CHAR); -- Tipo de actuación a insertar

    TYPE T_LINEA IS TABLE OF VARCHAR2(4000);
    TYPE T_ARRAY_LINEA IS TABLE OF T_LINEA;
    V_TIPO_LINEA T_ARRAY_LINEA := T_ARRAY_LINEA(
      T_LINEA('PCO_SolicitarDoc','CREAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join ' || V_ESQUEMA_MASTER || '.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''PS'') and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_SolicitarDoc'' and tex.borrado=0) and ta.dd_tas_codigo=''01'' and pco.prc_id=?'),
      T_LINEA('PCO_SolicitarDoc','CANCELAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join ' || V_ESQUEMA_MASTER || '.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''PS'') and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_SolicitarDoc'' and tex.borrado=0) and ta.dd_tas_codigo=''01'' and pco.prc_id=?'),
      T_LINEA('PCO_RegResultadoExped','CREAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''SO'' and tactor.dd_pco_dsa_trat_exp=1) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_RegResultadoExped'' and tex.borrado=0) and pco.prc_id=?'),
      T_LINEA('PCO_RegResultadoExped','CANCELAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''SO'' and tactor.dd_pco_dsa_trat_exp=1) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_RegResultadoExped'' and tex.borrado=0) and pco.prc_id=?'),
      T_LINEA('PCO_RecepcionExped','CREAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''EN'' and tactor.dd_pco_dsa_trat_exp=1) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_RecepcionExped'' and tex.borrado=0) and pco.prc_id=?'),
      T_LINEA('PCO_RecepcionExped','CANCELAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''EN'' and tactor.dd_pco_dsa_trat_exp=1) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_RecepcionExped'' and tex.borrado=0) and pco.prc_id=?'),
      T_LINEA('PCO_RegResultadoDoc','CREAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''SO'' and tactor.dd_pco_dsa_trat_exp=0 and s.pco_doc_dso_fecha_resultado is null) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_RegResultadoDoc'' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and tactor2.dd_pco_dsa_codigo=''PREDOC'')) and pco.prc_id=?'),
      T_LINEA('PCO_RegResultadoDoc','CANCELAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''SO'' and tactor.dd_pco_dsa_trat_exp=0 and s.pco_doc_dso_fecha_resultado is null) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_RegResultadoDoc'' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and tactor2.dd_pco_dsa_codigo=''PREDOC'')) and pco.prc_id=?'),
      T_LINEA('PCO_RegEnvioDoc','CREAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''SO'' and tactor.dd_pco_dsa_codigo=''GEST'' and s.pco_doc_dso_fecha_envio is null) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_RegEnvioDoc'' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and tactor2.dd_pco_dsa_codigo=''GEST'')) and pco.prc_id=?'),
      T_LINEA('PCO_RegEnvioDoc','CANCELAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor on tactor.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''SO'' and tactor.dd_pco_dsa_codigo=''GEST'' and s.pco_doc_dso_fecha_envio is null) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_RegEnvioDoc'' and tex.borrado=0 and exists (select 1 from pco_doc_documentos d inner join pco_doc_solicitudes s on s.pco_doc_pdd_id=d.pco_doc_pdd_id inner join dd_pco_doc_solicit_tipoactor tactor2 on tactor2.dd_pco_dsa_id=s.dd_pco_dsa_id where d.pco_prc_id=pco.pco_prc_id and tactor2.dd_pco_dsa_codigo=''GEST'')) and pco.prc_id=?'),
      T_LINEA('PCO_RecepcionDoc','CREAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''EN'') and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_RecepcionDoc'' and tex.borrado=0) and pco.prc_id=?'),
      T_LINEA('PCO_RecepcionDoc','CANCELAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_doc_documentos d inner join dd_pco_doc_estado e on e.dd_pco_ded_id=d.dd_pco_ded_id where d.pco_prc_id=pco.pco_prc_id and e.dd_pco_ded_codigo=''EN'') and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_RecepcionDoc'' and tex.borrado=0) and pco.prc_id=?'),
      T_LINEA('PCO_AdjuntarDoc','CREAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join ' || V_ESQUEMA_MASTER || '.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_doc_documentos d where d.pco_prc_id=pco.pco_prc_id and d.pco_doc_pdd_adjunto=0) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_AdjuntarDoc'' and tex.borrado=0) and ta.dd_tas_codigo=''02'' and pco.prc_id=?'),
      T_LINEA('PCO_AdjuntarDoc','CANCELAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join ' || V_ESQUEMA_MASTER || '.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where not exists (select 1 from pco_doc_documentos d where d.pco_prc_id=pco.pco_prc_id and d.pco_doc_pdd_adjunto=0) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_AdjuntarDoc'' and tex.borrado=0) and ta.dd_tas_codigo=''02'' and pco.prc_id=?'),
      T_LINEA('PCO_GenerarLiq','CREAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_liq_liquidaciones liq inner join dd_pco_liq_estado el on el.dd_pco_liq_id=liq.dd_pco_liq_id where liq.pco_prc_id= pco.pco_prc_id and el.dd_pco_liq_codigo=''PEN'') and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_GenerarLiq'' and tex.borrado=0) and pco.prc_id=?'),
      T_LINEA('PCO_GenerarLiq','CANCELAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_liq_liquidaciones liq inner join dd_pco_liq_estado el on el.dd_pco_liq_id=liq.dd_pco_liq_id where liq.pco_prc_id= pco.pco_prc_id and el.dd_pco_liq_codigo=''PEN'') and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_GenerarLiq'' and tex.borrado=0) and pco.prc_id=?'),
      T_LINEA('PCO_ConfirmarLiq','CREAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where exists (select 1 from pco_liq_liquidaciones liq inner join dd_pco_liq_estado el on el.dd_pco_liq_id=liq.dd_pco_liq_id where liq.pco_prc_id= pco.pco_prc_id and el.dd_pco_liq_codigo=''CAL'') and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_ConfirmarLiq'' and tex.borrado=0) and pco.prc_id=?'),
      T_LINEA('PCO_ConfirmarLiq','CANCELAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id where not exists (select 1 from pco_liq_liquidaciones liq inner join dd_pco_liq_estado el on el.dd_pco_liq_id=liq.dd_pco_liq_id where liq.pco_prc_id= pco.pco_prc_id and el.dd_pco_liq_codigo=''CAL'') and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_ConfirmarLiq'' and tex.borrado=0) and pco.prc_id=?'),
      T_LINEA('PCO_EnviarBurofax','CREAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join ' || V_ESQUEMA_MASTER || '.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_bur_burofax bf  inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is null) and exists (select 1 from pco_liq_liquidaciones lq inner join dd_pco_liq_estado le on le.dd_pco_liq_id= lq.dd_pco_liq_id where pco.pco_prc_id=lq.pco_prc_id and le.dd_pco_liq_codigo=''CON'') and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_EnviarBurofax'' and tex.borrado=0) and ta.dd_tas_codigo=''01'' and pco.prc_id=?'),
      T_LINEA('PCO_EnviarBurofax','CANCELAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join ' || V_ESQUEMA_MASTER || '.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where (not exists (select 1 from pco_bur_burofax bf inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is null) or not exists (select 1 from pco_liq_liquidaciones lq inner join dd_pco_liq_estado le on le.dd_pco_liq_id= lq.dd_pco_liq_id where pco.pco_prc_id=lq.pco_prc_id and le.dd_pco_liq_codigo=''CON'')) and exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_EnviarBurofax'' and tex.borrado=0) and ta.dd_tas_codigo=''01'' and pco.prc_id=?'),
      T_LINEA('PCO_AcuseReciboBurofax','CREAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join ' || V_ESQUEMA_MASTER || '.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_bur_burofax bf inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is not null and bfe.pco_bur_envio_fecha_acuso is null) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_AcuseReciboBurofax'' and tex.borrado=0) and ta.dd_tas_codigo=''01'' and pco.prc_id=?'),
      T_LINEA('PCO_AcuseReciboBurofax','CANCELAR','select count(1) from pco_prc_procedimientos pco inner join prc_procedimientos p on p.prc_id=pco.prc_id inner join asu_asuntos a on a.asu_id=p.asu_id inner join ' || V_ESQUEMA_MASTER || '.dd_tas_tipos_asunto ta on ta.dd_tas_id=a.dd_tas_id where exists (select 1 from pco_bur_burofax bf inner join pco_bur_envio bfe on bfe.pco_bur_burofax_id=bf.pco_bur_burofax_id where pco.pco_prc_id=bf.pco_prc_id and bfe.pco_bur_envio_fecha_envio is not null and bfe.pco_bur_envio_fecha_acuso is null) and not exists (select 1 from tar_tareas_notificaciones tar inner join tex_tarea_externa tex on tex.tar_id=tar.tar_id inner join tap_tarea_procedimiento tap on tap.tap_id= tex.tap_id where tar.prc_id=p.prc_id and tap.tap_codigo=''PCO_AcuseReciboBurofax'' and tex.borrado=0) and ta.dd_tas_codigo=''01'' and pco.prc_id=?')
    ); 
    V_TMP_TIPO_LINEA T_LINEA;
    
BEGIN	

    VAR_TABLENAME := 'PCO_LCT_LINEA_CONFIG_TAREA';
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Limpieza previa de la tabla');
	V_SQL := 'DELETE FROM '||V_ESQUEMA||'.' || VAR_TABLENAME;
	EXECUTE IMMEDIATE V_SQL;
	COMMIT;
	
    -- Inserción de valores en PCO_LCT_LINEA_CONFIG_TAREA
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.' || VAR_TABLENAME || '... Empezando a insertar valores');
    FOR I IN V_TIPO_LINEA.FIRST .. V_TIPO_LINEA.LAST
      LOOP
        V_TMP_TIPO_LINEA := V_TIPO_LINEA(I);
        V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.' || VAR_TABLENAME || ' WHERE PCO_LCT_CODIGO_TAREA = '''||TRIM(V_TMP_TIPO_LINEA(1))||''' AND PCO_LCT_CODIGO_ACCION = '''||TRIM(V_TMP_TIPO_LINEA(2))||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			
        IF V_NUM_TABLAS > 0 THEN				
          DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.' || VAR_TABLENAME || ' ya existe PCO_LCT_CODIGO_TAREA = '''||TRIM(V_TMP_TIPO_LINEA(1))||''' , PCO_LCT_CODIGO_ACCION = '''||TRIM(V_TMP_TIPO_LINEA(2))||'''');
        ELSE
          V_MSQL := 'INSERT INTO '|| V_ESQUEMA ||'.' || VAR_TABLENAME || ' (' ||
                    'PCO_LCT_ID,PCO_LCT_CODIGO_TAREA,PCO_LCT_CODIGO_ACCION,PCO_LCT_HQL,' ||
                    'VERSION,USUARIOCREAR,' ||
                    'FECHACREAR,BORRADO) ' ||
                    'SELECT '||V_ESQUEMA||'.' || 'S_' || VAR_TABLENAME || '.NEXTVAL, ' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_LINEA(1)),'''','''''') || ''',''' || REPLACE(TRIM(V_TMP_TIPO_LINEA(2)),'''','''''') || ''',' ||
                    '''' || REPLACE(TRIM(V_TMP_TIPO_LINEA(3)),'''','''''') || ''', 0,''INICIAL'',sysdate,0 FROM DUAL'; 
            DBMS_OUTPUT.PUT_LINE('INSERTANDO: '''  || V_TMP_TIPO_LINEA(1) ||''','''||TRIM(V_TMP_TIPO_LINEA(2))||'''');
            DBMS_OUTPUT.PUT_LINE(V_MSQL);
            EXECUTE IMMEDIATE V_MSQL;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'.' || VAR_TABLENAME || '.');
    
	COMMIT;
	 
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
