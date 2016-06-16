--/*
--##########################################
--## AUTOR=JTD
--## FECHA_CREACION=20160609
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-18
--## PRODUCTO=SI
--##
--## Finalidad: DML Carga MIG_CCO_CONTABILIDAD_COBROS
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'CM01'; -- Configuracion Esquemas  
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'CMMASTER'; -- Configuracion Esquemas  
    V_SQL VARCHAR2(5000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    v_asu_id NUMBER(16);
    v_tar_id NUMBER(16);
    v_fila NUMBER(16);
    v_count NUMBER(16);
    v_sta_id NUMBER(16);
    v_tge_id NUMBER(16);
    v_emisor VARCHAR2(100 CHAR);

BEGIN  

v_count := 0;
for c in
    (select contrato, id_cobro, id_expediente, cierre, nominal, intereses, demoras, gto_abogado, gto_procurador, gto_otros,
            oper_tramite, pase_fallido, quita_nominal, quita_intereses, quita_demoras, num_mandamiento, concepto_mandamiento,
            num_cheque, num_enlace, observaciones, 
            (SELECT dd_ate_id FROM CM01.dd_ate_adj_tpo_entrega WHERE dd_ate_id = tipo_entrega) tipo_entrega,
            empleado, fecha_cobro, fecha_valor, id_proceso, quita_gto_abogado, quita_gto_procurador, quita_gto_otros,
            quita_oper_tramite, enviado, decode(procede_ot, 'SI', 1, 0) procede_ot, iva, quita_iva,
            (SELECT dd_ace_id FROM CM01.dd_ace_adj_concepto_entrega WHERE dd_ace_codigo = concepto_entrega) concepto_entrega,
            nvl(nominal, 0) + nvl(intereses, 0) + nvl(demoras, 0) + nvl(gto_abogado, 0) + nvl(gto_procurador, 0) + nvl(gto_otros, 0) + nvl(oper_tramite, 0) + nvl(iva, 0) cco_total_entrega,
            nvl(quita_nominal, 0) + nvl(quita_intereses, 0) + nvl(quita_demoras, 0) + nvl(quita_iva, 0) + nvl(quita_gto_procurador, 0) + nvl(quita_gto_abogado, 0) + nvl(quita_gto_otros , 0) + nvl(quita_oper_tramite,0) cco_total_quita
       from CM01.mig_cco_contabilidad_cobros m)
loop
   v_sta_id := 0; 
   v_tge_id := 0;
   
   -- Calculamos el asunto
   begin
      -- SELECT asu_id into v_asu_id FROM #ESQUEMA#.asu_asuntos WHERE exp_id = c.id_expediente;
      select Max(a.asu_id) into v_asu_id 
        from cnt_contratos c, cex_contratos_expediente cex, 
            (SELECT asu_id, exp_id, Decode(dd_eas_codigo, '03', 1, '02', 2, '01', 3, 4) estado_asunto
               FROM CM01.asu_asuntos aa, CMMASTER.dd_eas_estado_asuntos eas 
              WHERE aa.dd_eas_id = eas.dd_eas_id
                AND aa.borrado = 0 ORDER BY estado_asunto) a
      WHERE c.cnt_id = cex.cnt_id
        AND cex.exp_id = a.exp_id
        AND c.cnt_contrato = c.contrato;

   exception
      when others then
         v_asu_id := 0; 
   end;
   
   -- calculamoa el tar_emisor
   begin
      SELECT dd_sta_id, dd_tge_id into v_sta_id, v_tge_id FROM CMMASTER.dd_sta_subtipo_tarea_base WHERE dd_sta_codigo = 'CONTACOBR';
      
      SELECT u.usu_nombre into v_emisor
        FROM CMMASTER.usu_usuarios u, CM01.usd_usuarios_despachos usd, CM01.gaa_gestor_adicional_asunto gaa
       WHERE u.usu_id = usd.usu_id
         AND usd.usd_id = gaa.usd_id
         AND gaa.asu_id = v_asu_id 
         AND gaa.dd_tge_id = v_tge_id;
   exception
      when others then
         v_sta_id := null; 
         v_tge_id := null;
         v_emisor := 'CONTACOBR';
   end;
   
   
   if (v_asu_id <> 0) then
      
      -- TAREAS --
      ----------------------------------------------------------
      v_fila := 0;
      begin
         select tar_id into v_fila from CM01.tar_tareas_notificaciones where asu_id = v_asu_id and usuariocrear = 'PRODU-1806';
      exception
      when others then
         v_fila := 0; 
      end;
      
      if (v_fila = 0 ) then
         -- Calculamos el Id de la tarea
         select s_tar_tareas_notificaciones.nextval into v_tar_id from dual;
      
         -- Nueva tarea
         INSERT INTO CM01.tar_tareas_notificaciones
            (tar_id, asu_id, dd_est_id, dd_ein_id, dd_sta_id, tar_codigo, 
             tar_tarea,  tar_descripcion, tar_fecha_ini, tar_en_espera,
             tar_alerta, tar_emisor, version, usuariocrear, fechacrear, borrado, 
             tar_fecha_venc, tar_fecha_venc_real, dtype)
         VALUES
            (v_tar_id, v_asu_id, 
             (SELECT dd_est_id FROM CMMASTER.dd_est_estados_itinerarios WHERE dd_est_codigo = 'AS'), 
             (SELECT dd_ein_id FROM CMMASTER.dd_ein_entidad_informacion WHERE dd_ein_codigo = 3), v_sta_id, 1,
             'Contabilizar Cobros', 'Contabilización de Cobros', null, 0,
             0, v_emisor, 0, 'PRODU-1806', SYSDATE, 0, 
             c.fecha_valor, c.fecha_cobro, 'EXTTareaNotificacion');
      end if;
      
      -- CONTABILIDAD COBROS --
      ----------------------------------------------------------
      v_fila := 0;
      begin
         select cco_id into v_fila from CM01.cco_contabilidad_cobros 
          where asu_id = v_asu_id 
            and usuariocrear = 'PRODU-1806' 
            and SUBSTR(cco_observaciones,0, 19) = 'ID_cobro:' || To_Char(c.id_cobro, '000000000');
      exception
      when others then
         v_fila := 0; 
      end;
      
      if (v_fila = 0 ) then
         -- Nuevo contablidad_cobro
         INSERT INTO CM01.cco_contabilidad_cobros
            (cco_id, cco_fecha_entrega, cco_fecha_valor, cco_importe, dd_ate_id, dd_ace_id, 
             cco_nominal, cco_intereses, cco_demoras, cco_impuestos, cco_gastos_procurador, cco_gastos_letrado, cco_otros_gastos, 
             cco_quita_nominal, cco_quita_intereses, cco_quita_demoras, cco_quita_impuestos, cco_quita_gastos_procurador, cco_quita_gastos_letrado, cco_quita_otros_gastos, 
             cco_total_entrega, cco_num_enlace, cco_num_mandamiento, cco_cheque, cco_observaciones, 
             asu_id,
             usuariocrear, fechacrear, borrado, version, usuariomodificar,
             cco_operaciones_tramite, cco_operaciones_en_tramite, cco_total_quita, cco_quita_operacion_en_tramite, tar_id, cco_contabilizado)
         values (
             s_cco_contabilidad_cobros.NEXTVAL, c.fecha_cobro, c.fecha_valor, NULL, c.tipo_entrega, c.concepto_entrega, 
             c.nominal, c.intereses, c.demoras, c.iva, c.gto_procurador, c.gto_abogado, c.gto_otros, 
             c.quita_nominal, c.quita_intereses, c.quita_demoras, c.quita_iva, c.quita_gto_procurador, c.quita_gto_abogado, c.quita_gto_otros,
             c.cco_total_entrega, c.num_enlace, c.num_mandamiento, c.num_cheque, 'ID_cobro:' || To_Char(c.id_cobro, '000000000') ||'. ' || SUBSTR(c.observaciones, 0, 1950),
             v_asu_id,
             'PRODU-1806', SYSDATE, 0, 0, c.empleado,
             c.procede_ot, c.oper_tramite, c.cco_total_quita, c.quita_oper_tramite, v_tar_id, 1);
       end if;
   end if;
   
   v_count := v_count + 1;
   if (Mod(v_count,1000)= 0) then
       DBMS_OUTPUT.put_line('Contador  ' || v_count);
       commit;
   end if;

end loop; 
commit;

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