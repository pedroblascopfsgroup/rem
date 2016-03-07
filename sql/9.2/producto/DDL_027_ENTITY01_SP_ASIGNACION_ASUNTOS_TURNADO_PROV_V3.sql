--/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20160307
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-881
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Solo se ha añadido un update para ASUNTOS y su nueva columna DD_PRV_ID, que al turnar, le asignamos dicha columna.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

create or replace PROCEDURE asignacion_asuntos_turnado (
   p_asu_id       #ESQUEMA#.asu_asuntos.asu_id%TYPE,
   p_username     #ESQUEMA_MASTER#.usu_usuarios.usu_username%TYPE,
   p_tge_codigo   #ESQUEMA_MASTER#.dd_tge_tipo_gestor.dd_tge_codigo%TYPE := 'GEXT'
)
AUTHID CURRENT_USER IS
   CURSOR crs_datos_asunto (p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE)
   IS
      SELECT tas.dd_tas_codigo
        FROM #ESQUEMA#.asu_asuntos asu, #ESQUEMA_MASTER#.dd_tas_tipos_asunto tas
       WHERE asu.asu_id = p_asu_id AND asu.dd_tas_id = tas.dd_tas_id;

   CURSOR crs_filtro_tipo_asunto (p_tas_codigo #ESQUEMA_MASTER#.dd_tas_tipos_asunto.dd_tas_codigo%TYPE)
   IS
      SELECT des.des_id
        FROM #ESQUEMA#.des_despacho_externo des
       WHERE (p_tas_codigo = '01' AND des.etc_lit_codigo_calidad IS NOT NULL AND des.etc_lit_codigo_importe IS NOT NULL)
          OR (p_tas_codigo = '02' AND des.etc_con_codigo_calidad IS NOT NULL AND des.etc_con_codigo_importe IS NOT NULL);

   CURSOR crs_filtro_stock (p_tas_codigo #ESQUEMA_MASTER#.dd_tas_tipos_asunto.dd_tas_codigo%TYPE)
   IS
      SELECT aat.des_id
        FROM #ESQUEMA#.tmp_aat_asig_turnado_letrados aat,
             (SELECT CASE
                        WHEN p_tas_codigo = '01'
                           THEN etu.etu_lit_stock_anual
                        ELSE etu.etu_con_stock_anual
                     END AS etu_stock_anual
                FROM #ESQUEMA#.etu_esquema_turnado etu, #ESQUEMA#.dd_eet_estado_esquema_turnado eet
               WHERE eet.dd_eet_codigo = 'VIG' AND eet.dd_eet_id = etu.dd_eet_id) etu
       WHERE aat.porcentaje_interanual <= etu.etu_stock_anual;

   CURSOR crs_filtro_conexionadas (p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE, p_tge_codigo #ESQUEMA_MASTER#.dd_tge_tipo_gestor.dd_tge_codigo%TYPE)
   IS
      SELECT DISTINCT FIRST_VALUE (usd.des_id) OVER (ORDER BY prc.prc_saldo_recuperacion DESC) AS des_id
                 FROM (SELECT DISTINCT per_id
                                  FROM #ESQUEMA#.prc_procedimientos prc, #ESQUEMA#.prc_per pp
                                 WHERE prc.asu_id = p_asu_id AND prc.prc_id = pp.prc_id) per,
                      #ESQUEMA#.prc_per pp,
                      #ESQUEMA#.prc_procedimientos prc,
                      #ESQUEMA#.asu_asuntos asu,
                      #ESQUEMA_MASTER#.dd_eas_estado_asuntos eas,
                      #ESQUEMA#.usd_usuarios_despachos usd,
                      #ESQUEMA#.tmp_aat_asig_turnado_letrados aat,
                      #ESQUEMA#.gaa_gestor_adicional_asunto gaa,
                      #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge
                WHERE per.per_id = pp.per_id
                  AND pp.prc_id NOT IN (SELECT prc_id
                                          FROM #ESQUEMA#.prc_procedimientos
                                         WHERE asu_id = p_asu_id)
                  AND pp.prc_id = prc.prc_id
                  AND prc.asu_id = asu.asu_id
                  AND asu.dd_eas_id = eas.dd_eas_id
                  AND eas.dd_eas_codigo = '03'
                  AND asu.asu_id = gaa.asu_id
                  AND gaa.dd_tge_id = tge.dd_tge_id
                  AND tge.dd_tge_codigo = p_tge_codigo
                  AND gaa.usd_id = usd.usd_id
                  AND usd.des_id = aat.des_id;

  -- PRODUCTO-582 - 4 CURSORES PARA ELEGIR LA PROVINCIA DEL ASUNTO crs_filtro_situacion, nuevas restricciones para elegir la provincia.
   -- Opcion Garantia = 1. Numero de garantias(bienes) asociados a un contrato con provincia != null; si hay 1 solo, nos quedamos con su provincia.
   CURSOR crs_filtro_prov_bien_contrato (p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE)
   IS
	SELECT DISTINCT bil.dd_prv_id
		FROM #ESQUEMA#.asu_asuntos asu
			JOIN #ESQUEMA#.exp_expedientes exp ON asu.exp_id=exp.exp_id
			JOIN #ESQUEMA#.cex_contratos_expediente cex ON exp.exp_id=cex.EXP_ID
			JOIN #ESQUEMA#.cnt_contratos cnt ON cex.cnt_id=cnt.cnt_id
			JOIN #ESQUEMA#.bie_cnt bic ON cnt.cnt_id=bic.cnt_id
			JOIN #ESQUEMA#.bie_localizacion bil ON bic.bie_id=bil.bie_id AND bil.dd_prv_id IS NOT NULL
		WHERE asu.asu_id = p_asu_id
			AND asu.borrado=0 AND exp.borrado=0 AND cex.borrado=0 AND cnt.borrado=0 AND bic.borrado=0 AND bil.borrado=0;	

    -- Garantias=0 entonces -> Provincia del domicilio del titular de menor orden
    -- Si no tiene provincia asignada, aplicamos el cursor: crs_filtro_prov_oficina
   CURSOR crs_filtro_prov_bien_menor (p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE)
   IS			
	SELECT DISTINCT FIRST_VALUE (dir.dd_prv_id) OVER (ORDER BY cnt.cnt_dispuesto DESC, cpe.cpe_orden ASC)
		FROM #ESQUEMA#.asu_asuntos asu
			JOIN #ESQUEMA#.exp_expedientes exp ON asu.exp_id=exp.exp_id
			JOIN #ESQUEMA#.cex_contratos_expediente cex ON exp.exp_id=cex.EXP_ID
			JOIN #ESQUEMA#.cnt_contratos cnt ON cex.cnt_id=cnt.cnt_id
			JOIN #ESQUEMA#.cpe_contratos_personas cpe ON cnt.cnt_id=cpe.cnt_id
			JOIN #ESQUEMA#.dir_per dip ON cpe.per_id=dip.per_id
			JOIN #ESQUEMA#.dir_direcciones dir ON dip.dir_id=dir.dir_id AND dir.dd_prv_id IS NOT NULL
		WHERE asu.asu_id = p_asu_id
			AND asu.borrado=0 AND exp.borrado=0 AND cex.borrado=0 AND cnt.borrado=0 AND cpe.borrado=0 AND dip.borrado=0 AND dir.borrado=0;
        
    -- Si crs_filtro_bienes_titular_menor no devuelve resultado, aplicamos esta
	-- Opcion Garantias=0 entocnes -> provincia de la oficina de mayor importe 
	CURSOR crs_filtro_prov_oficina (p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE)
   	IS
   		SELECT DISTINCT FIRST_VALUE (ofi.dd_prv_id) OVER (ORDER BY cnt.cnt_dispuesto DESC)
			FROM #ESQUEMA#.asu_asuntos asu
				JOIN #ESQUEMA#.exp_expedientes exp ON asu.exp_id=exp.exp_id
				JOIN #ESQUEMA#.cex_contratos_expediente cex ON exp.exp_id=cex.EXP_ID
				JOIN #ESQUEMA#.cnt_contratos cnt ON cex.cnt_id=cnt.cnt_id
				JOIN #ESQUEMA#.ofi_oficinas ofi ON cnt.ofi_id=ofi.ofi_id
			WHERE asu.asu_id = p_asu_id
				AND asu.borrado=0 AND exp.borrado=0 AND cex.borrado=0 AND cnt.borrado=0 AND ofi.borrado=0;
        
        -- Opcion Garantias > 1, entonces cogemos del contrato de mayor importe, la garantia(bien) con mayor tasacion, y de esta su provincia
	CURSOR crs_filtro_prov_bien_tas (p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE)
   	IS
		SELECT DISTINCT FIRST_VALUE (bil.dd_prv_id) OVER (ORDER BY cnt.cnt_dispuesto DESC, val.BIE_IMPORTE_VALOR_TASACION DESC )
			FROM #ESQUEMA#.asu_asuntos asu
				JOIN #ESQUEMA#.exp_expedientes exp ON asu.exp_id=exp.exp_id
				JOIN #ESQUEMA#.cex_contratos_expediente cex ON exp.exp_id=cex.EXP_ID
				JOIN #ESQUEMA#.cnt_contratos cnt ON cex.cnt_id=cnt.cnt_id
				JOIN #ESQUEMA#.bie_cnt bic ON cnt.cnt_id=bic.cnt_id
				JOIN #ESQUEMA#.bie_localizacion bil ON bic.bie_id=bil.bie_id AND bil.dd_prv_id is not null
				JOIN #ESQUEMA#.bie_valoraciones val ON val.bie_id=bic.bie_id
			WHERE asu.asu_id=p_asu_id AND asu.borrado=0 AND exp.borrado=0 AND cex.borrado=0 AND cnt.borrado=0 AND bic.borrado=0 AND bil.borrado=0 AND val.borrado=0;
      
      -- Cursor para elegir despacho segun la provincia elegida  y segun la calidad(litigio/concursal) de la provincia del despacho
	CURSOR crs_filtro_despacho_prov (
      p_asu_id       #ESQUEMA#.asu_asuntos.asu_id%TYPE,
      p_dd_prv_id	 #ESQUEMA_MASTER#.dd_prv_provincia.dd_prv_id%TYPE)
	IS
	    SELECT des_id FROM (
	      SELECT DISTINCT daa.des_id, etc.etc_porcentaje
	           FROM   #ESQUEMA_MASTER#.dd_prv_provincia prv
	              JOIN #ESQUEMA#.daa_despacho_ambito_actuacion daa ON daa.dd_prv_id = prv.dd_prv_id
	              JOIN #ESQUEMA#.des_despacho_externo des ON daa.des_id = des.des_id
	              JOIN #ESQUEMA#.asu_asuntos asu ON asu.asu_id = p_asu_id
	              JOIN #ESQUEMA_MASTER#.dd_tas_tipos_asunto tas ON asu.dd_tas_id = tas.dd_tas_id
				  JOIN #ESQUEMA#.etc_esquema_turnado_config etc ON (daa.etc_id_litigio = etc.etc_id OR daa.etc_id_concurso = etc.etc_id)      
				  JOIN #ESQUEMA#.etu_esquema_turnado etu ON etc.etu_id= etu.etu_id
				  JOIN #ESQUEMA#.dd_eet_estado_esquema_turnado eet ON etu.dd_eet_id = eet.dd_eet_id AND eet.dd_eet_codigo = 'VIG'
	            WHERE prv.dd_prv_id = p_dd_prv_id
	              AND ((tas.dd_tas_codigo='01' and etc.etc_tipo='LC' and daa.etc_id_litigio IS NOT NULL) OR (tas.dd_tas_codigo='02' and etc.etc_tipo='CC' AND daa.etc_id_concurso IS NOT NULL))
	              AND prv.borrado=0 AND daa.borrado=0 AND des.borrado=0 AND tas.borrado=0 AND etc.borrado=0
	              ORDER BY etc.etc_porcentaje DESC);

   CURSOR crs_filtro_situacion (p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE)
   IS
      SELECT DISTINCT daa.des_id
                 FROM (SELECT DISTINCT FIRST_VALUE (cnt.ofi_id) OVER (ORDER BY mov.mov_pos_viva_vencida + mov.mov_pos_viva_no_vencida DESC) AS ofi_id
                                  FROM #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.exp_expedientes EXP, #ESQUEMA#.cex_contratos_expediente cex, #ESQUEMA#.cnt_contratos cnt, #ESQUEMA#.mov_movimientos mov
                                 WHERE asu.asu_id = p_asu_id AND asu.exp_id = EXP.exp_id AND EXP.exp_id = cex.exp_id AND cex.cnt_id = cnt.cnt_id AND cnt.cnt_id = mov.cnt_id) cnt,
                      #ESQUEMA#.ofi_oficinas ofi,
                      #ESQUEMA_MASTER#.dd_prv_provincia prv,
                      #ESQUEMA#.daa_despacho_ambito_actuacion daa,
                      #ESQUEMA#.tmp_aat_asig_turnado_letrados aat
                WHERE cnt.ofi_id = ofi.ofi_id AND ofi.dd_prv_id = prv.dd_prv_id AND (prv.dd_prv_id = daa.dd_prv_id OR prv.dd_cca_id = daa.dd_cca_id) AND daa.des_id = aat.des_id;

   CURSOR crs_filtro_codigo_importe (p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE)
   IS
      SELECT des.des_id
        FROM (SELECT etc.etc_codigo, etc.etc_tipo
                FROM #ESQUEMA#.etu_esquema_turnado etu,
                     #ESQUEMA#.dd_eet_estado_esquema_turnado eet,
                     #ESQUEMA#.etc_esquema_turnado_config etc,
                     #ESQUEMA#.asu_asuntos asu,
                     #ESQUEMA_MASTER#.dd_tas_tipos_asunto tas,
                     (SELECT DISTINCT FIRST_VALUE (prc.prc_saldo_recuperacion) OVER (ORDER BY prc.prc_saldo_recuperacion DESC) AS prc_saldo_recuperacion
                                 FROM #ESQUEMA#.prc_procedimientos prc
                                WHERE prc.asu_id = p_asu_id) prc
               WHERE etu.dd_eet_id = eet.dd_eet_id
                 AND eet.dd_eet_codigo = 'VIG'
                 AND etu.etu_id = etc.etu_id
                 AND asu.asu_id = p_asu_id
                 AND asu.dd_tas_id = tas.dd_tas_id
                 AND ((tas.dd_tas_codigo = '01' AND etc.etc_tipo = 'LI') OR etc.etc_tipo = 'CI')
                 AND prc.prc_saldo_recuperacion BETWEEN etc.etc_importe_desde AND etc.etc_importe_hasta) etc,
             #ESQUEMA#.des_despacho_externo des
       WHERE (etc.etc_tipo = 'LI' AND etc.etc_codigo = des.etc_lit_codigo_importe) OR etc.etc_codigo = des.etc_con_codigo_importe;

   CURSOR crs_calificaciones_candidatos (p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE)
   IS
      SELECT DISTINCT aat.codigo_calidad
                 FROM #ESQUEMA#.tmp_aat_asig_turnado_letrados aat
             ORDER BY aat.codigo_calidad DESC;

   CURSOR crs_porcentaje_asuntos (
      p_asu_id       #ESQUEMA#.asu_asuntos.asu_id%TYPE,
      p_codigo       #ESQUEMA#.etc_esquema_turnado_config.etc_codigo%TYPE,
      p_tas_codigo   #ESQUEMA_MASTER#.dd_tas_tipos_asunto.dd_tas_codigo%TYPE,
      p_tge_codigo   #ESQUEMA_MASTER#.dd_tge_tipo_gestor.dd_tge_codigo%TYPE
   )
   IS
      SELECT CASE
                WHEN totales.n_asuntos = 0
                   THEN 0
                ELSE asignados.n_asuntos / totales.n_asuntos * 100
             END AS porcentaje
        FROM (SELECT COUNT (DISTINCT asu.asu_id) AS n_asuntos
                FROM #ESQUEMA#.asu_asuntos asu,
                     #ESQUEMA#.usd_usuarios_despachos usd,
                     #ESQUEMA#.des_despacho_externo des,
                     (SELECT asu.dd_tas_id
                        FROM #ESQUEMA#.asu_asuntos asu
                       WHERE asu.asu_id = p_asu_id) tas,
                     #ESQUEMA#.gaa_gestor_adicional_asunto gaa,
                     #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge
               WHERE EXTRACT (MONTH FROM SYSDATE) = EXTRACT (MONTH FROM asu.fechacrear)
                 AND EXTRACT (YEAR FROM SYSDATE) = EXTRACT (YEAR FROM asu.fechacrear)
                 AND asu.dd_tas_id = tas.dd_tas_id
                 AND asu.asu_id = gaa.asu_id
                 AND gaa.dd_tge_id = tge.dd_tge_id
                 AND tge.dd_tge_codigo = p_tge_codigo
                 AND gaa.usd_id = usd.usd_id
                 AND usd.des_id = des.des_id
                 AND ((p_tas_codigo = '01' AND des.etc_lit_codigo_calidad = p_codigo) OR des.etc_con_codigo_calidad = p_codigo)) asignados,
             (SELECT COUNT (DISTINCT asu.asu_id) AS n_asuntos
                FROM #ESQUEMA#.asu_asuntos asu,
                     #ESQUEMA#.usd_usuarios_despachos usd,
                     (SELECT asu.dd_tas_id
                        FROM #ESQUEMA#.asu_asuntos asu
                       WHERE asu.asu_id = p_asu_id) tas,
                     #ESQUEMA#.gaa_gestor_adicional_asunto gaa,
                     #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge
               WHERE EXTRACT (MONTH FROM SYSDATE) = EXTRACT (MONTH FROM asu.fechacrear)
                 AND EXTRACT (YEAR FROM SYSDATE) = EXTRACT (YEAR FROM asu.fechacrear)
                 AND asu.dd_tas_id = tas.dd_tas_id
                 AND asu.asu_id = gaa.asu_id
                 AND gaa.dd_tge_id = tge.dd_tge_id
                 AND tge.dd_tge_codigo = p_tge_codigo
                 AND gaa.usd_id = usd.usd_id) totales;

   CURSOR crs_porcentaje_esquema (p_tas_codigo #ESQUEMA_MASTER#.dd_tas_tipos_asunto.dd_tas_codigo%TYPE, p_etc_codigo #ESQUEMA#.etc_esquema_turnado_config.etc_codigo%TYPE)
   IS
      SELECT etc.etc_porcentaje
        FROM #ESQUEMA#.etc_esquema_turnado_config etc, #ESQUEMA#.etu_esquema_turnado etu, #ESQUEMA#.dd_eet_estado_esquema_turnado eet
       WHERE ((p_tas_codigo = '01' AND etc.etc_tipo = 'LC') OR etc.etc_tipo = 'CC')
         AND etc.etc_codigo = p_etc_codigo
         AND etc.etu_id = etu.etu_id
         AND etu.dd_eet_id = eet.dd_eet_id
         AND eet.dd_eet_codigo = 'VIG';

   CURSOR crs_despacho_elegido
   IS
      SELECT FIRST_VALUE (aat.des_id) OVER (ORDER BY aat.l_provincia DESC, aat.porcentaje_interanual ASC)
        FROM #ESQUEMA#.tmp_aat_asig_turnado_letrados aat;

   CURSOR crs_gestores_activos (p_tge_codigo #ESQUEMA_MASTER#.dd_tge_tipo_gestor.dd_tge_codigo%TYPE, p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE)
   IS
      SELECT gaa.gaa_id, gaa.usd_id, gaa.fechacrear
        FROM #ESQUEMA#.gaa_gestor_adicional_asunto gaa, #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge
       WHERE tge.dd_tge_codigo = p_tge_codigo AND tge.dd_tge_id = gaa.dd_tge_id AND gaa.asu_id = p_asu_id AND gaa.borrado = 0;
       
    CURSOR crs_relacion_existente (p_tge_codigo #ESQUEMA_MASTER#.dd_tge_tipo_gestor.dd_tge_codigo%TYPE, p_asu_id #ESQUEMA#.asu_asuntos.asu_id%TYPE, v_des_id #ESQUEMA#.des_despacho_externo.des_id%TYPE)
    IS
      SELECT distinct FIRST_VALUE (gah_id) OVER (ORDER BY gah_fecha_desde ASC)
      FROM #ESQUEMA#.gah_gestor_adicional_historico 
              WHERE gah_fecha_hasta is null AND gah_gestor_id = 
                  (SELECT DISTINCT FIRST_VALUE (usd.usd_id) OVER (ORDER BY usd.usd_gestor_defecto DESC) FROM #ESQUEMA#.usd_usuarios_despachos usd WHERE usd.des_id = v_des_id)
                AND gah_tipo_gestor_id = (SELECT tge.dd_tge_id  FROM #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge  WHERE tge.dd_tge_codigo = p_tge_codigo)
                AND gah_asu_id = p_asu_id;
                

   v_des_id                  #ESQUEMA#.des_despacho_externo.des_id%TYPE;
   v_datos_asunto            crs_datos_asunto%ROWTYPE;
   v_filtro_tipo_asunto      SYS.odcinumberlist;
   v_filtro_stock            SYS.odcinumberlist;
   v_filtro_conexionadas     crs_filtro_conexionadas%ROWTYPE;
   v_filtro_situacion        SYS.odcinumberlist;
   v_filtro_provincia        SYS.odcinumberlist;
   v_filtro_codigo_importe   SYS.odcinumberlist;
   v_porcentaje_asuntos      NUMBER;
   v_porcentaje_esquema      NUMBER;
   v_enc                     VARCHAR2 (1)                              := 'N';
   v_primera_calificacion    VARCHAR2 (2);
   v_dd_prv_id				 #ESQUEMA_MASTER#.DD_PRV_PROVINCIA.dd_prv_id%TYPE;
   v_gah_existente           #ESQUEMA#.gah_gestor_adicional_historico.gah_id%TYPE;
BEGIN
   -- Se recuperan los datos del asunto
   OPEN crs_datos_asunto (p_asu_id);

   FETCH crs_datos_asunto
    INTO v_datos_asunto;

   CLOSE crs_datos_asunto;

   -- Se rellena la tabla temporal
   INSERT INTO #ESQUEMA#.tmp_aat_asig_turnado_letrados
      SELECT des.des_id, CASE
                WHEN v_datos_asunto.dd_tas_codigo = '01'
                   THEN des.etc_lit_codigo_importe
                ELSE des.etc_con_codigo_importe
             END, CASE
                WHEN v_datos_asunto.dd_tas_codigo = '01'
                   THEN des.etc_lit_codigo_calidad
                ELSE des.etc_con_codigo_calidad
             END,
               (  (SELECT COUNT (DISTINCT asu.asu_id) AS n_asuntos
                     FROM #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.gaa_gestor_adicional_asunto gaa, #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge, #ESQUEMA#.usd_usuarios_despachos usd
                    WHERE asu.asu_id = gaa.asu_id
                      AND gaa.dd_tge_id = tge.dd_tge_id
                      AND tge.dd_tge_codigo = p_tge_codigo
                      AND gaa.usd_id = usd.usd_id
                      AND usd.des_id = des.des_id
                      AND asu.fechacrear BETWEEN ADD_MONTHS (SYSDATE, -12) AND SYSDATE)
                / DECODE ((SELECT COUNT (DISTINCT asu.asu_id) AS n_asuntos
                             FROM #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.gaa_gestor_adicional_asunto gaa, #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge, #ESQUEMA#.usd_usuarios_despachos usd
                            WHERE asu.asu_id = gaa.asu_id
                              AND gaa.dd_tge_id = tge.dd_tge_id
                              AND tge.dd_tge_codigo = p_tge_codigo
                              AND gaa.usd_id = usd.usd_id
                              AND asu.fechacrear BETWEEN ADD_MONTHS (SYSDATE, -12) AND SYSDATE),
                          0, 1,
                          (SELECT COUNT (DISTINCT asu.asu_id) AS n_asuntos
                             FROM #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.gaa_gestor_adicional_asunto gaa, #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge, #ESQUEMA#.usd_usuarios_despachos usd
                            WHERE asu.asu_id = gaa.asu_id
                              AND gaa.dd_tge_id = tge.dd_tge_id
                              AND tge.dd_tge_codigo = p_tge_codigo
                              AND gaa.usd_id = usd.usd_id
                              AND asu.fechacrear BETWEEN ADD_MONTHS (SYSDATE, -12) AND SYSDATE)
                         )
               )
             * 100,
             CASE
                WHEN EXISTS (
                       SELECT 1
                         FROM #ESQUEMA#.daa_despacho_ambito_actuacion daa,
                              (SELECT DISTINCT FIRST_VALUE (cnt.ofi_id) OVER (ORDER BY mov.mov_pos_viva_vencida + mov.mov_pos_viva_no_vencida DESC) AS ofi_id
                                          FROM #ESQUEMA#.asu_asuntos asu, #ESQUEMA#.exp_expedientes EXP, #ESQUEMA#.cex_contratos_expediente cex, #ESQUEMA#.cnt_contratos cnt, #ESQUEMA#.mov_movimientos mov
                                         WHERE asu.asu_id = p_asu_id AND asu.exp_id = EXP.exp_id AND EXP.exp_id = cex.exp_id AND cex.cnt_id = cnt.cnt_id AND cnt.cnt_id = mov.cnt_id) cnt,
                              #ESQUEMA#.ofi_oficinas ofi
                        WHERE daa.des_id = des.des_id AND daa.dd_prv_id = ofi.dd_prv_id AND ofi.ofi_id = cnt.ofi_id)
                   THEN 'S'
                ELSE 'N'
             END
        FROM #ESQUEMA#.des_despacho_externo des, #ESQUEMA#.daa_despacho_ambito_actuacion daa
       WHERE des.des_id = daa.des_id AND des.borrado = 0;

   -- Se descartan los letrados que superan el stock interanual
   OPEN crs_filtro_stock (v_datos_asunto.dd_tas_codigo);

   LOOP
      FETCH crs_filtro_stock
      BULK COLLECT INTO v_filtro_stock;

      EXIT WHEN crs_filtro_stock%NOTFOUND;
   END LOOP;
   
   IF v_filtro_stock.COUNT = 1
   THEN
      v_des_id := v_filtro_stock (1);
   ELSE
      IF v_filtro_stock.COUNT > 0
      THEN
         DELETE FROM #ESQUEMA#.tmp_aat_asig_turnado_letrados aat
               WHERE aat.des_id NOT IN (SELECT COLUMN_VALUE
                                          FROM TABLE (v_filtro_stock));
      END IF;

      -- Se filtran los letrados dependiendo del tipo de asunto
      OPEN crs_filtro_tipo_asunto (v_datos_asunto.dd_tas_codigo);

      LOOP
         FETCH crs_filtro_tipo_asunto
         BULK COLLECT INTO v_filtro_tipo_asunto;

         EXIT WHEN crs_filtro_tipo_asunto%NOTFOUND;
      END LOOP;
      
      IF v_filtro_tipo_asunto.COUNT = 1
      THEN
         v_des_id := v_filtro_tipo_asunto (1);
      ELSE
         IF v_filtro_tipo_asunto.COUNT > 0
         THEN
            DELETE FROM #ESQUEMA#.tmp_aat_asig_turnado_letrados aat
                  WHERE aat.des_id NOT IN (SELECT COLUMN_VALUE
                                             FROM TABLE (v_filtro_tipo_asunto));
         END IF;

         -- Si algún letrado ha sido asignado anteriormente a un asunto relacionado con alguno de los deudores del asunto actual, se asigna el asunto al mismo letrado
         OPEN crs_filtro_conexionadas (p_asu_id, p_tge_codigo);

         FETCH crs_filtro_conexionadas
          INTO v_filtro_conexionadas;
          
         IF crs_filtro_conexionadas%FOUND
         THEN
            CLOSE crs_filtro_conexionadas;

            v_des_id := v_filtro_conexionadas.des_id;
            
         -- En caso contrario seguimos filtrando los posibles letrados
         ELSE
            CLOSE crs_filtro_conexionadas;

          --  Buscamos garantias(bienes) de un contrato con la provincia informada
           OPEN crs_filtro_prov_bien_contrato (p_asu_id);
           LOOP
           		FETCH crs_filtro_prov_bien_contrato 
            	BULK COLLECT INTO v_filtro_provincia;
              EXIT WHEN crs_filtro_prov_bien_contrato%NOTFOUND;
           END LOOP;
       		CLOSE crs_filtro_prov_bien_contrato;

            IF v_filtro_provincia.COUNT = 1
             THEN
                v_dd_prv_id := v_filtro_provincia (1);
             ELSE
                IF v_filtro_provincia.COUNT = 0
                  THEN
                      -- Si con el cursor crs_filtro_prov_bien_contrato no se ha encontrado provincia, buscamos en
                      -- el titular de menor orden del contrado y nos quedamos con la provincia de su docimicilio si la tiene informada
                      OPEN crs_filtro_prov_bien_menor (p_asu_id);
                        FETCH crs_filtro_prov_bien_menor into v_dd_prv_id;

                      IF v_dd_prv_id IS NOT NULL
                      THEN
                        CLOSE crs_filtro_prov_bien_menor;
                      ELSE
                        CLOSE crs_filtro_prov_bien_menor;
                        -- Si con el cursor crs_filtro_prov_bien_menor no se encontro provincia, buscamos en
                        -- la provincia de la oficina del contrato de mayor importe
                        OPEN crs_filtro_prov_oficina (p_asu_id);
                          FETCH crs_filtro_prov_oficina INTO v_dd_prv_id;
                          CLOSE crs_filtro_prov_oficina;
                      END IF;
                ELSE
                    -- Si con el cursor crs_filtro_prov_bien_contrato se encontraron varias garantias, buscamos en:
                    -- el contrato de mayor importe, y de este, la garantia con un mayor valor de tasacion, y de ella su provincia.
                    OPEN crs_filtro_prov_bien_tas (p_asu_id);
                        FETCH crs_filtro_prov_bien_tas INTO v_dd_prv_id;
                        CLOSE crs_filtro_prov_bien_tas;  
                END IF;
            END IF;
          
          
         IF v_dd_prv_id IS NOT NULL
       		THEN
            -- Si se ha encontrado una provincia, veamos que despacho trabaja en esa provincia, y el de 
            -- mayor calidad será el despacho elegido para este asunto.
       			OPEN crs_filtro_despacho_prov(p_asu_id, v_dd_prv_id);       			
       			LOOP
       				FETCH crs_filtro_despacho_prov
       				BULK COLLECT INTO v_filtro_situacion;
             		EXIT WHEN crs_filtro_despacho_prov%NOTFOUND;
            	END LOOP;
       			
       			IF v_filtro_situacion.COUNT > 0
	            THEN
	               	v_des_id := v_filtro_situacion (1);
                	CLOSE crs_filtro_despacho_prov;
	            ELSE
                	CLOSE crs_filtro_despacho_prov;
            	END IF;
        END IF;          
        
        IF v_des_id IS NULL	
        THEN
            -- Filto antiguo para la provincia: Se filtran los letrados por provincia, Comunidad Autónoma o nacionales
            -- Se usará si en los filtros anteriores no encuentra provincia.
            OPEN crs_filtro_situacion (p_asu_id);

            LOOP
               FETCH crs_filtro_situacion
               BULK COLLECT INTO v_filtro_situacion;

               EXIT WHEN crs_filtro_situacion%NOTFOUND;
            END LOOP;

            IF v_filtro_situacion.COUNT = 1
            THEN
               v_des_id := v_filtro_situacion (1);
            ELSE
               IF v_filtro_situacion.COUNT > 0
               THEN
                  DELETE FROM #ESQUEMA#.tmp_aat_asig_turnado_letrados aat
                        WHERE aat.des_id NOT IN (SELECT COLUMN_VALUE
                                                   FROM TABLE (v_filtro_situacion));
               END IF;

               -- Se filtran los letrados por tipo de importe
               OPEN crs_filtro_codigo_importe (p_asu_id);

               LOOP
                  FETCH crs_filtro_codigo_importe
                  BULK COLLECT INTO v_filtro_codigo_importe;

                  EXIT WHEN crs_filtro_codigo_importe%NOTFOUND;
               END LOOP;

               IF v_filtro_codigo_importe.COUNT = 1
               THEN
                  v_des_id := v_filtro_codigo_importe (1);
               ELSE
                  IF v_filtro_codigo_importe.COUNT > 0
                  THEN
                     DELETE FROM #ESQUEMA#.tmp_aat_asig_turnado_letrados aat
                           WHERE aat.des_id NOT IN (SELECT COLUMN_VALUE
                                                      FROM TABLE (v_filtro_codigo_importe));
                  END IF;

                  -- Se filtran los letrados por calificación
                  -- Se obtienen las calificaciones de los letrados que aún quedan
                  FOR calificacion IN crs_calificaciones_candidatos (p_asu_id)
                  LOOP
                     -- Se obtiene el porcentaje de asuntos asignados a despachos con esta calificación durante el mes actual
                     OPEN crs_porcentaje_asuntos (p_asu_id, calificacion.codigo_calidad, v_datos_asunto.dd_tas_codigo, p_tge_codigo);

                     FETCH crs_porcentaje_asuntos
                      INTO v_porcentaje_asuntos;

                     CLOSE crs_porcentaje_asuntos;

                     -- Se obtiene el porcentaje para esa calificación según el esquema actual
                     OPEN crs_porcentaje_esquema (v_datos_asunto.dd_tas_codigo, calificacion.codigo_calidad);

                     FETCH crs_porcentaje_esquema
                      INTO v_porcentaje_esquema;

                     CLOSE crs_porcentaje_esquema;

                     -- Si el porcentaje permitido por el esquema para la calificación es mayor que el porcentaje de asuntos asignados a la calificación actualmente
                     -- nos quedamos con los letrados que tengan esta calificación y finalizamos el bucle
                     IF v_porcentaje_esquema > v_porcentaje_asuntos
                     THEN
                        DELETE FROM tmp_aat_asig_turnado_letrados aat
                              WHERE aat.codigo_calidad <> calificacion.codigo_calidad;

                        v_enc := 'S';
                        EXIT;
                     -- En otro caso, nos quedamos con la calificación si es la primera y continuamos el bucle
                     ELSE
                        IF v_primera_calificacion IS NULL
                        THEN
                           v_primera_calificacion := calificacion.codigo_calidad;
                        END IF;
                     END IF;
                  END LOOP;

                  -- Si no se ha encontrado ninguna calificación cuyo porcentaje de asuntos sea menor que el definido en el esquema nos quedamos con los letrados del primer tipo de calificación
                  IF v_enc = 'N'
                  THEN
                     DELETE FROM #ESQUEMA#.tmp_aat_asig_turnado_letrados aat
                           WHERE aat.codigo_calidad <> v_primera_calificacion;
                  END IF;

                  -- Se selecciona un despacho de los restantes, dando preferencia a los de la misma provincia y menor porcentaje interanual
                  OPEN crs_despacho_elegido;

                  FETCH crs_despacho_elegido
                   INTO v_des_id;

                  CLOSE crs_despacho_elegido;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
END IF;
   -- Si se ha encontrado un despacho para asignar
   IF v_des_id IS NOT NULL
   THEN
   
	-- Actualizamos ASU_ASUNTOS, para añadir la provincia que tiene asignada
      IF v_dd_prv_id IS NOT NULL     
      THEN
      DBMS_OUTPUT.put_line ('prv_id: '|| v_dd_prv_id);
        UPDATE #ESQUEMA#.ASU_ASUNTOS asu
        SET asu.DD_PRV_ID = v_dd_prv_id
        where asu.asu_id = p_asu_id;
      END IF;	
   
      -- Si existe algún gestor activo del tipo indicado para el asunto, se añade al histórico y se borra la relación
      FOR relacion IN crs_gestores_activos (p_tge_codigo, p_asu_id)
      LOOP
         DELETE FROM #ESQUEMA#.gaa_gestor_adicional_asunto gaa
               WHERE gaa.gaa_id = relacion.gaa_id;
      END LOOP;

      -- Se añade la relación entre el despacho elegido y el asunto
      INSERT INTO #ESQUEMA#.gaa_gestor_adicional_asunto
                  (gaa_id, asu_id, usd_id, dd_tge_id, VERSION,
                   usuariocrear, fechacrear, borrado
                  )
           VALUES (#ESQUEMA#.s_gaa_gestor_adicional_asunto.NEXTVAL, p_asu_id, 
           		(SELECT DISTINCT FIRST_VALUE (usd.usd_id) OVER (ORDER BY usd.usd_gestor_defecto DESC)
                      FROM #ESQUEMA#.usd_usuarios_despachos usd
                      WHERE usd.des_id = v_des_id) 
               ,(SELECT tge.dd_tge_id
                      FROM #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge
                      WHERE tge.dd_tge_codigo = p_tge_codigo)
                      , 0,  p_username, SYSDATE, 0
              );
                 
        -- Si quedan rastros en GAH_GESTOR_ADICIONAL_HISTORICO para el mismo asunto, y mismo tipo de gestor, le asignamos una fecha hasta para evitar conflictos
        UPDATE #ESQUEMA#.gah_gestor_adicional_historico gah
          SET gah.gah_fecha_hasta = SYSDATE
          WHERE gah.gah_asu_id = p_asu_id
            AND gah.gah_tipo_gestor_id = (SELECT tge.dd_tge_id  FROM #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge  WHERE tge.dd_tge_codigo = p_tge_codigo)
            AND gah.gah_fecha_hasta is null
            AND gah.gah_gestor_id <> (SELECT DISTINCT FIRST_VALUE (usd.usd_id) OVER (ORDER BY usd.usd_gestor_defecto DESC) FROM #ESQUEMA#.usd_usuarios_despachos usd WHERE usd.des_id = v_des_id);

 		-- Ahora insertamos la relacion asunto-despacho, con el nuevo letrado seleccionado, y lo insertamos en el historico, pero sin la fecha HASTA, para que recovery lo recoja como el activo.
        OPEN crs_relacion_existente (p_tge_codigo, p_asu_id, v_des_id);
        FETCH crs_relacion_existente
          INTO v_gah_existente;
                
        IF v_gah_existente is null
        THEN
          INSERT INTO #ESQUEMA#.gah_gestor_adicional_historico
                       (gah_id, gah_gestor_id, gah_asu_id, gah_tipo_gestor_id, gah_fecha_desde, VERSION, usuariocrear, fechacrear, borrado)
              (SELECT #ESQUEMA#.s_gah_gestor_adic_historico.NEXTVAL
              , (SELECT DISTINCT FIRST_VALUE (usd.usd_id) OVER (ORDER BY usd.usd_gestor_defecto DESC) FROM #ESQUEMA#.usd_usuarios_despachos usd WHERE usd.des_id = v_des_id)
              , p_asu_id, tge.dd_tge_id, SYSDATE, 0, p_username, SYSDATE, 0
                 FROM #ESQUEMA_MASTER#.dd_tge_tipo_gestor tge
                WHERE tge.dd_tge_codigo = p_tge_codigo);
        END IF;
        CLOSE crs_relacion_existente;
   END IF;

   COMMIT;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END asignacion_asuntos_turnado;
/
EXIT;
