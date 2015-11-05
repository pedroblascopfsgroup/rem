--/*
--##########################################
--## AUTOR=Alberto b.
--## FECHA_CREACION=20151105
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.1.14-
--## INCIDENCIA_LINK=PRODUCTO-399	
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL         VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA      VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M    VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL          VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS   NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM        NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG        VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1        VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    TYPE T_ESQUEMA IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
    V_ESQUEMA_GRANT T_ESQUEMA;

BEGIN
    

V_MSQL := 'CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.VINFSUBASTALETRADO (SUB_ID, NUMERO_AUTO, NUMERO_JUZ, PROV_JUZ, NUM_OPERACION, CENTRO, TITULAR, FIADORES, TPO_PROCEDI, LETRADO, PROCURADOR, FDEMANDA, FSUBASTA, TPO_SUBASTA, PRINCIPAL_DEMANDA, INT_MORATORIOS, MINUTA_LETRADO, MINUTA_PROCURADOR, ENTREGAS_CUENTA, COMENTARIOS, CERTCARGAS, EDICTO, AVALUO) AS 
  SELECT distinct sub.sub_id, prc.prc_cod_proc_en_juzgado numero_auto, dd_juz.dd_juz_descripcion numero_juz, dd_pla.dd_pla_descripcion prov_juz,
       SUBSTR (cnt.cnt_contrato, 11, 17) || ''/'' || ddapo.dd_apo_descripcion num_operacion, ofi.ofi_nombre centro, tit.per_nom50 titular,
       CASE
           WHEN tin.dd_tin_id IS NOT NULL
             THEN 1
          ELSE 0
       END fiadores, tprocedi.dd_tpo_descripcion tpo_procedi, DECODE (desp.codigo, ''GEXT'', desp.des_despacho) letrado, DECODE (desp.codigo, ''PROC'', desp.des_despacho) procurador,
       demanda.tev_valor fdemanda, sub.sub_fecha_senyalamiento fsubasta, tposub.tipo_subasta tpo_subasta, prc.prc_saldo_recuperacion principal_demanda,
       CASE
          WHEN valores_senyalamiento.tev_nombre = ''INTERESES''
             THEN valores_senyalamiento.tev_valor
          ELSE ''0''
       END int_moratorios, CASE
          WHEN valores_senyalamiento.tev_nombre = ''COSTASLETRADO''
             THEN valores_senyalamiento.tev_valor
          ELSE ''0''
       END minuta_letrado, CASE
          WHEN valores_senyalamiento.tev_nombre = ''COSTASPROCURADOR''
             THEN valores_senyalamiento.tev_valor
          ELSE ''0''
       END minuta_procurador, CASE
          WHEN mov.mov_entregas_a_cuenta IS NULL
             THEN 0
          ELSE mov.mov_entregas_a_cuenta
       END entregas_cuenta, asu.asu_observacion comentarios, CASE
          WHEN adjuntos.codigo IN (''CCB'', ''CCH'')
             THEN 1
          ELSE 0
       END certcargas, CASE
          WHEN adjuntos.codigo = ''ESRAS''
             THEN 1
          ELSE 0
       END edicto, CASE
          WHEN adjuntos.codigo = ''AVPR''
             THEN 1
          ELSE 0
       END avaluo
  FROM '||V_ESQUEMA||'.sub_subasta sub 
       LEFT JOIN '||V_ESQUEMA||'.dd_tsu_tipo_subasta dd_tsu ON sub.dd_tsu_id = dd_tsu.dd_tsu_id
       LEFT JOIN '||V_ESQUEMA||'.asu_asuntos asu ON sub.asu_id = asu.asu_id
       LEFT JOIN
       (SELECT   /*+ MATERIALIZE */
                 ada.asu_id, tfa.dd_tfa_codigo codigo
            FROM '||V_ESQUEMA||'.ada_adjuntos_asuntos ada LEFT JOIN '||V_ESQUEMA||'.dd_tfa_fichero_adjunto tfa ON ada.dd_tfa_id = tfa.dd_tfa_id
        GROUP BY ada.asu_id, tfa.dd_tfa_codigo) adjuntos ON asu.asu_id = adjuntos.asu_id
       LEFT JOIN '||V_ESQUEMA||'.prc_procedimientos prc ON sub.prc_id = prc.prc_id
       LEFT JOIN '||V_ESQUEMA||'.dd_juz_juzgados_plaza dd_juz ON prc.dd_juz_id = dd_juz.dd_juz_id
       LEFT JOIN '||V_ESQUEMA||'.dd_pla_plazas dd_pla ON dd_juz.dd_pla_id = dd_pla.dd_pla_id
       LEFT JOIN
       (SELECT   /*+ MATERIALIEZE */
                 los.sub_id, SUM (bie.bie_tipo_subasta) tipo_subasta
            FROM '||V_ESQUEMA||'.los_lote_subasta los LEFT JOIN '||V_ESQUEMA||'.lob_lote_bien loblote ON los.los_id = loblote.los_id
                 LEFT JOIN '||V_ESQUEMA||'.bie_bien bie ON loblote.bie_id = bie.bie_id
        GROUP BY los.sub_id) tposub ON tposub.sub_id = sub.sub_id
       LEFT JOIN
       (SELECT DISTINCT gaa.asu_id, des.des_id, des.des_despacho, dd_tge_codigo codigo
                   FROM '||V_ESQUEMA||'.gaa_gestor_adicional_asunto gaa INNER JOIN CMMASTER.dd_tge_tipo_gestor tge ON gaa.dd_tge_id = tge.dd_tge_id AND dd_tge_codigo IN (''GEXT'', ''PROC'')
                        INNER JOIN '||V_ESQUEMA||'.usd_usuarios_despachos usd ON gaa.usd_id = usd.usd_id
                        INNER JOIN '||V_ESQUEMA||'.des_despacho_externo des ON usd.des_id = des.des_id
                        ) desp ON asu.asu_id = desp.asu_id
       LEFT JOIN
       (SELECT /*+ MATERIALIZE */
               asu_id, dd_tpo_descripcion
          FROM (SELECT prc.prc_id, prc.asu_id, ddtpo.dd_tpo_descripcion, ROW_NUMBER () OVER (PARTITION BY prc.asu_id ORDER BY prc.prc_id DESC) num
                  FROM '||V_ESQUEMA||'.prc_procedimientos prc INNER JOIN '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento ddtpo ON prc.dd_tpo_id = ddtpo.dd_tpo_id
                  WHERE ddtpo.dd_tpo_codigo IN (''H001'',''H022'', ''H024''))
         WHERE num = 1) tprocedi ON asu.asu_id = tprocedi.asu_id
       LEFT JOIN
       (SELECT /*+ MATERIALIZE */
              distinct(tev.tev_valor), tar.prc_id
          FROM '||V_ESQUEMA||'.tar_tareas_notificaciones tar INNER JOIN tex_tarea_externa tex ON tex.tar_id = tar.tar_id
               INNER JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
               INNER JOIN '||V_ESQUEMA||'.tfi_tareas_form_items tfi ON tap.tap_id = tfi.tap_id
               INNER JOIN '||V_ESQUEMA||'.tev_tarea_externa_valor tev ON tev.tex_id = tex.tex_id AND UPPER (tev_nombre) IN (''FECHASOLICITUD'', ''FECHADEMANDA'')      --AND UPPER (tfi.tfi_nombre) = UPPER (tev.tev_nombre)
         WHERE NOT tev.tev_valor IS NULL
          	AND tap.tap_codigo IN
                  (''H001_DemandaCertificacionCargas'', ''H022_InterposicionDemanda'', ''H024_InterposicionDemanda'')) demanda ON prc.prc_id = demanda.prc_id
       LEFT JOIN
       (SELECT /*+ MATERIALIZE */
               prc_id, cnt_id, cnt_num
          FROM (SELECT /*+ MATERIALIZE */
                       prc_id, cnt_id, ROW_NUMBER () OVER (PARTITION BY prc_id ORDER BY suma DESC) cnt_num
                  FROM (SELECT /*+ MATERIALIZE */
                               (mov.mov_pos_viva_no_vencida + mov.mov_pos_viva_vencida) suma, mov.cnt_id, prccex.prc_id
                          FROM '||V_ESQUEMA||'.prc_cex prccex INNER JOIN '||V_ESQUEMA||'.cex_contratos_expediente cex ON prccex.cex_id = cex.cex_id
                               INNER JOIN '||V_ESQUEMA||'.mov_movimientos mov ON cex.cnt_id = mov.cnt_id AND mov.mov_fecha_extraccion = (SELECT MAX (mov_fecha_extraccion)
                                                                                                                           FROM '||V_ESQUEMA||'.mov_movimientos)
                               ))
         WHERE cnt_num = 1) cntmay ON prc.prc_id = cntmay.prc_id
       LEFT JOIN '||V_ESQUEMA||'.cnt_contratos cnt ON cntmay.cnt_id = cnt.cnt_id
       LEFT JOIN '||V_ESQUEMA||'.mov_movimientos mov ON cntmay.cnt_id = mov.cnt_id
       LEFT JOIN '||V_ESQUEMA||'.dd_apo_aplicativo_origen ddapo ON cnt.dd_apo_id = ddapo.dd_apo_id
       LEFT JOIN '||V_ESQUEMA||'.ofi_oficinas ofi ON cnt.ofi_id = ofi.ofi_id
       LEFT JOIN '||V_ESQUEMA||'.cpe_contratos_personas cpe ON cntmay.cnt_id = cpe.cnt_id
       LEFT JOIN '||V_ESQUEMA||'.dd_tin_tipo_intervencion tin ON cpe.dd_tin_id = tin.dd_tin_id AND tin.dd_tin_codigo IN (30, 31)
       LEFT JOIN
       (SELECT /*+ MATERIALIZE */
               cnt_id, per_nom50
          FROM (SELECT cpe.cnt_id, per.per_nom50, ROW_NUMBER () OVER (PARTITION BY cpe.cnt_id ORDER BY cpe.cpe_orden) num
                  FROM '||V_ESQUEMA||'.cpe_contratos_personas cpe JOIN '||V_ESQUEMA||'.dd_tin_tipo_intervencion tin ON cpe.dd_tin_id = tin.dd_tin_id AND tin.dd_tin_codigo = 20
                       JOIN '||V_ESQUEMA||'.per_personas per ON cpe.per_id = per.per_id
                       )
         WHERE num = 1) tit ON cnt.cnt_id = tit.cnt_id
       LEFT JOIN
       (SELECT /*+ MATERIALIZE */
               UPPER (tev.tev_nombre) tev_nombre, tev.tev_valor, tar.prc_id
          FROM '||V_ESQUEMA||'.tar_tareas_notificaciones tar INNER JOIN tex_tarea_externa tex ON tex.tar_id = tar.tar_id
               INNER JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
               INNER JOIN '||V_ESQUEMA||'.tfi_tareas_form_items tfi ON tap.tap_id = tfi.tap_id
               INNER JOIN '||V_ESQUEMA||'.tev_tarea_externa_valor tev ON tev.tex_id = tex.tex_id AND UPPER (tfi.tfi_nombre) = UPPER (tev.tev_nombre)
         WHERE NOT tev.tev_valor IS NULL AND tap.tap_codigo IN (''P401_SenyalamientoSubasta'', ''P409_SenyalamientoSubasta'')) valores_senyalamiento ON prc.prc_id = valores_senyalamiento.prc_id
         ';
    DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL;     
    DBMS_OUTPUT.PUT_LINE('[INFO] Vista modificada');
    
    
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
