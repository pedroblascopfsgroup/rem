--/*
--##########################################
--## AUTOR=ALBERTO CAMPOS
--## FECHA_CREACION=20151014
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.1.13
--## INCIDENCIA_LINK=BKREC-901
--## PRODUCTO=SI
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

create or replace PROCEDURE        asignacion_asuntos_turnado (
   p_asu_id       bank01.asu_asuntos.asu_id%TYPE,
   p_username     bankmaster.usu_usuarios.usu_username%TYPE,
   p_tge_codigo   bankmaster.dd_tge_tipo_gestor.dd_tge_codigo%TYPE := 'GEXT'
)
IS
   CURSOR crs_datos_asunto (p_asu_id bank01.asu_asuntos.asu_id%TYPE)
   IS
      SELECT tas.dd_tas_codigo
        FROM bank01.asu_asuntos asu, bankmaster.dd_tas_tipos_asunto tas
       WHERE asu.asu_id = p_asu_id AND asu.dd_tas_id = tas.dd_tas_id;

   CURSOR crs_filtro_tipo_asunto (p_tas_codigo bankmaster.dd_tas_tipos_asunto.dd_tas_codigo%TYPE)
   IS
      SELECT des.des_id
        FROM bank01.des_despacho_externo des
       WHERE (p_tas_codigo = '01' AND des.etc_lit_codigo_calidad IS NOT NULL AND des.etc_lit_codigo_importe IS NOT NULL)
          OR (p_tas_codigo = '02' AND des.etc_con_codigo_calidad IS NOT NULL AND des.etc_con_codigo_importe IS NOT NULL);

   CURSOR crs_filtro_stock (p_tas_codigo bankmaster.dd_tas_tipos_asunto.dd_tas_codigo%TYPE)
   IS
      SELECT aat.des_id
        FROM bank01.tmp_aat_asig_turnado_letrados aat,
             (SELECT CASE
                        WHEN p_tas_codigo = '01'
                           THEN etu.etu_lit_stock_anual
                        ELSE etu.etu_con_stock_anual
                     END AS etu_stock_anual
                FROM bank01.etu_esquema_turnado etu, bank01.dd_eet_estado_esquema_turnado eet
               WHERE eet.dd_eet_codigo = 'VIG' AND eet.dd_eet_id = etu.dd_eet_id) etu
       WHERE aat.porcentaje_interanual <= etu.etu_stock_anual;

   CURSOR crs_filtro_conexionadas (p_asu_id bank01.asu_asuntos.asu_id%TYPE, p_tge_codigo bankmaster.dd_tge_tipo_gestor.dd_tge_codigo%TYPE)
   IS
      SELECT DISTINCT FIRST_VALUE (usd.des_id) OVER (ORDER BY prc.prc_saldo_recuperacion DESC) AS des_id
                 FROM (SELECT DISTINCT per_id
                                  FROM bank01.prc_procedimientos prc, bank01.prc_per pp
                                 WHERE prc.asu_id = p_asu_id AND prc.prc_id = pp.prc_id) per,
                      bank01.prc_per pp,
                      bank01.prc_procedimientos prc,
                      bank01.asu_asuntos asu,
                      bankmaster.dd_eas_estado_asuntos eas,
                      bank01.usd_usuarios_despachos usd,
                      bank01.tmp_aat_asig_turnado_letrados aat,
                      bank01.gaa_gestor_adicional_asunto gaa,
                      bankmaster.dd_tge_tipo_gestor tge
                WHERE per.per_id = pp.per_id
                  AND pp.prc_id NOT IN (SELECT prc_id
                                          FROM bank01.prc_procedimientos
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

   CURSOR crs_filtro_situacion (p_asu_id bank01.asu_asuntos.asu_id%TYPE)
   IS
      SELECT DISTINCT daa.des_id
                 FROM (SELECT DISTINCT FIRST_VALUE (cnt.ofi_id) OVER (ORDER BY mov.mov_pos_viva_vencida + mov.mov_pos_viva_no_vencida DESC) AS ofi_id
                                  FROM bank01.asu_asuntos asu, bank01.exp_expedientes EXP, bank01.cex_contratos_expediente cex, bank01.cnt_contratos cnt, bank01.mov_movimientos mov
                                 WHERE asu.asu_id = p_asu_id AND asu.exp_id = EXP.exp_id AND EXP.exp_id = cex.exp_id AND cex.cnt_id = cnt.cnt_id AND cnt.cnt_id = mov.cnt_id) cnt,
                      bank01.ofi_oficinas ofi,
                      bankmaster.dd_prv_provincia prv,
                      bank01.daa_despacho_ambito_actuacion daa,
                      bank01.tmp_aat_asig_turnado_letrados aat
                WHERE cnt.ofi_id = ofi.ofi_id AND ofi.dd_prv_id = prv.dd_prv_id AND (prv.dd_prv_id = daa.dd_prv_id OR prv.dd_cca_id = daa.dd_cca_id) AND daa.des_id = aat.des_id;

   CURSOR crs_filtro_codigo_importe (p_asu_id bank01.asu_asuntos.asu_id%TYPE)
   IS
      SELECT des.des_id
        FROM (SELECT etc.etc_codigo, etc.etc_tipo
                FROM bank01.etu_esquema_turnado etu,
                     bank01.dd_eet_estado_esquema_turnado eet,
                     bank01.etc_esquema_turnado_config etc,
                     bank01.asu_asuntos asu,
                     bankmaster.dd_tas_tipos_asunto tas,
                     (SELECT DISTINCT FIRST_VALUE (prc.prc_saldo_recuperacion) OVER (ORDER BY prc.prc_saldo_recuperacion DESC) AS prc_saldo_recuperacion
                                 FROM bank01.prc_procedimientos prc
                                WHERE prc.asu_id = p_asu_id) prc
               WHERE etu.dd_eet_id = eet.dd_eet_id
                 AND eet.dd_eet_codigo = 'VIG'
                 AND etu.etu_id = etc.etu_id
                 AND asu.asu_id = p_asu_id
                 AND asu.dd_tas_id = tas.dd_tas_id
                 AND ((tas.dd_tas_codigo = '01' AND etc.etc_tipo = 'LI') OR etc.etc_tipo = 'CI')
                 AND prc.prc_saldo_recuperacion BETWEEN etc.etc_importe_desde AND etc.etc_importe_hasta) etc,
             bank01.des_despacho_externo des
       WHERE (etc.etc_tipo = 'LI' AND etc.etc_codigo = des.etc_lit_codigo_importe) OR etc.etc_codigo = des.etc_con_codigo_importe;

   CURSOR crs_calificaciones_candidatos (p_asu_id bank01.asu_asuntos.asu_id%TYPE)
   IS
      SELECT DISTINCT aat.codigo_calidad
                 FROM bank01.tmp_aat_asig_turnado_letrados aat
             ORDER BY aat.codigo_calidad DESC;

   CURSOR crs_porcentaje_asuntos (
      p_asu_id       bank01.asu_asuntos.asu_id%TYPE,
      p_codigo       bank01.etc_esquema_turnado_config.etc_codigo%TYPE,
      p_tas_codigo   bankmaster.dd_tas_tipos_asunto.dd_tas_codigo%TYPE,
      p_tge_codigo   bankmaster.dd_tge_tipo_gestor.dd_tge_codigo%TYPE
   )
   IS
      SELECT CASE
                WHEN totales.n_asuntos = 0
                   THEN 0
                ELSE asignados.n_asuntos / totales.n_asuntos * 100
             END AS porcentaje
        FROM (SELECT COUNT (DISTINCT asu.asu_id) AS n_asuntos
                FROM bank01.asu_asuntos asu,
                     bank01.usd_usuarios_despachos usd,
                     bank01.des_despacho_externo des,
                     (SELECT asu.dd_tas_id
                        FROM bank01.asu_asuntos asu
                       WHERE asu.asu_id = p_asu_id) tas,
                     bank01.gaa_gestor_adicional_asunto gaa,
                     bankmaster.dd_tge_tipo_gestor tge
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
                FROM bank01.asu_asuntos asu,
                     bank01.usd_usuarios_despachos usd,
                     (SELECT asu.dd_tas_id
                        FROM bank01.asu_asuntos asu
                       WHERE asu.asu_id = p_asu_id) tas,
                     bank01.gaa_gestor_adicional_asunto gaa,
                     bankmaster.dd_tge_tipo_gestor tge
               WHERE EXTRACT (MONTH FROM SYSDATE) = EXTRACT (MONTH FROM asu.fechacrear)
                 AND EXTRACT (YEAR FROM SYSDATE) = EXTRACT (YEAR FROM asu.fechacrear)
                 AND asu.dd_tas_id = tas.dd_tas_id
                 AND asu.asu_id = gaa.asu_id
                 AND gaa.dd_tge_id = tge.dd_tge_id
                 AND tge.dd_tge_codigo = p_tge_codigo
                 AND gaa.usd_id = usd.usd_id) totales;

   CURSOR crs_porcentaje_esquema (p_tas_codigo bankmaster.dd_tas_tipos_asunto.dd_tas_codigo%TYPE, p_etc_codigo bank01.etc_esquema_turnado_config.etc_codigo%TYPE)
   IS
      SELECT etc.etc_porcentaje
        FROM bank01.etc_esquema_turnado_config etc, bank01.etu_esquema_turnado etu, bank01.dd_eet_estado_esquema_turnado eet
       WHERE ((p_tas_codigo = '01' AND etc.etc_tipo = 'LC') OR etc.etc_tipo = 'CC')
         AND etc.etc_codigo = p_etc_codigo
         AND etc.etu_id = etu.etu_id
         AND etu.dd_eet_id = eet.dd_eet_id
         AND eet.dd_eet_codigo = 'VIG';

   CURSOR crs_despacho_elegido
   IS
      SELECT FIRST_VALUE (aat.des_id) OVER (ORDER BY aat.l_provincia DESC, aat.porcentaje_interanual ASC)
        FROM bank01.tmp_aat_asig_turnado_letrados aat;

   CURSOR crs_gestores_activos (p_tge_codigo bankmaster.dd_tge_tipo_gestor.dd_tge_codigo%TYPE, p_asu_id bank01.asu_asuntos.asu_id%TYPE)
   IS
      SELECT gaa.gaa_id, gaa.usd_id, gaa.fechacrear
        FROM bank01.gaa_gestor_adicional_asunto gaa, bankmaster.dd_tge_tipo_gestor tge
       WHERE tge.dd_tge_codigo = p_tge_codigo AND tge.dd_tge_id = gaa.dd_tge_id AND gaa.asu_id = p_asu_id AND gaa.borrado = 0;

   v_des_id                  bank01.des_despacho_externo.des_id%TYPE;
   v_datos_asunto            crs_datos_asunto%ROWTYPE;
   v_filtro_tipo_asunto      SYS.odcinumberlist;
   v_filtro_stock            SYS.odcinumberlist;
   v_filtro_conexionadas     crs_filtro_conexionadas%ROWTYPE;
   v_filtro_situacion        SYS.odcinumberlist;
   v_filtro_codigo_importe   SYS.odcinumberlist;
   v_porcentaje_asuntos      NUMBER;
   v_porcentaje_esquema      NUMBER;
   v_enc                     VARCHAR2 (1)                              := 'N';
   v_primera_calificacion    VARCHAR2 (2);
BEGIN
   -- Se recuperan los datos del asunto
   OPEN crs_datos_asunto (p_asu_id);

   FETCH crs_datos_asunto
    INTO v_datos_asunto;

   CLOSE crs_datos_asunto;

   -- Se rellena la tabla temporal
   INSERT INTO bank01.tmp_aat_asig_turnado_letrados
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
                     FROM bank01.asu_asuntos asu, bank01.gaa_gestor_adicional_asunto gaa, bankmaster.dd_tge_tipo_gestor tge, bank01.usd_usuarios_despachos usd
                    WHERE asu.asu_id = gaa.asu_id
                      AND gaa.dd_tge_id = tge.dd_tge_id
                      AND tge.dd_tge_codigo = p_tge_codigo
                      AND gaa.usd_id = usd.usd_id
                      AND usd.des_id = des.des_id
                      AND asu.fechacrear BETWEEN ADD_MONTHS (SYSDATE, -12) AND SYSDATE)
                / DECODE ((SELECT COUNT (DISTINCT asu.asu_id) AS n_asuntos
                             FROM bank01.asu_asuntos asu, bank01.gaa_gestor_adicional_asunto gaa, bankmaster.dd_tge_tipo_gestor tge, bank01.usd_usuarios_despachos usd
                            WHERE asu.asu_id = gaa.asu_id
                              AND gaa.dd_tge_id = tge.dd_tge_id
                              AND tge.dd_tge_codigo = p_tge_codigo
                              AND gaa.usd_id = usd.usd_id
                              AND asu.fechacrear BETWEEN ADD_MONTHS (SYSDATE, -12) AND SYSDATE),
                          0, 1,
                          (SELECT COUNT (DISTINCT asu.asu_id) AS n_asuntos
                             FROM bank01.asu_asuntos asu, bank01.gaa_gestor_adicional_asunto gaa, bankmaster.dd_tge_tipo_gestor tge, bank01.usd_usuarios_despachos usd
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
                         FROM bank01.daa_despacho_ambito_actuacion daa,
                              (SELECT DISTINCT FIRST_VALUE (cnt.ofi_id) OVER (ORDER BY mov.mov_pos_viva_vencida + mov.mov_pos_viva_no_vencida DESC) AS ofi_id
                                          FROM bank01.asu_asuntos asu, bank01.exp_expedientes EXP, bank01.cex_contratos_expediente cex, bank01.cnt_contratos cnt, bank01.mov_movimientos mov
                                         WHERE asu.asu_id = p_asu_id AND asu.exp_id = EXP.exp_id AND EXP.exp_id = cex.exp_id AND cex.cnt_id = cnt.cnt_id AND cnt.cnt_id = mov.cnt_id) cnt,
                              bank01.ofi_oficinas ofi
                        WHERE daa.des_id = des.des_id AND daa.dd_prv_id = ofi.dd_prv_id AND ofi.ofi_id = cnt.ofi_id)
                   THEN 'S'
                ELSE 'N'
             END
        FROM bank01.des_despacho_externo des, bank01.daa_despacho_ambito_actuacion daa
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
         DELETE FROM bank01.tmp_aat_asig_turnado_letrados aat
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
            DELETE FROM bank01.tmp_aat_asig_turnado_letrados aat
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

            -- Se filtran los letrados por provincia, Comunidad Autónoma o nacionales
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
                  DELETE FROM bank01.tmp_aat_asig_turnado_letrados aat
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
                     DELETE FROM bank01.tmp_aat_asig_turnado_letrados aat
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
                     DELETE FROM bank01.tmp_aat_asig_turnado_letrados aat
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

   -- Si se ha encontrado un despacho para asignar
   IF v_des_id IS NOT NULL
   THEN
      -- Si existe algún gestor activo del tipo indicado para el asunto, se añade al histórico y se borra la relación
      FOR relacion IN crs_gestores_activos (p_tge_codigo, p_asu_id)
      LOOP
         INSERT INTO bank01.gah_gestor_adicional_historico
                     (gah_id, gah_gestor_id, gah_asu_id, gah_tipo_gestor_id, gah_fecha_desde, gah_fecha_hasta, VERSION, usuariocrear, fechacrear, borrado)
            (SELECT bank01.s_gah_gestor_adic_historico.NEXTVAL, relacion.usd_id, p_asu_id, tge.dd_tge_id, relacion.fechacrear, SYSDATE, 0, p_username, SYSDATE, 0
               FROM bankmaster.dd_tge_tipo_gestor tge
              WHERE tge.dd_tge_codigo = p_tge_codigo);

         DELETE FROM bank01.gaa_gestor_adicional_asunto gaa
               WHERE gaa.gaa_id = relacion.gaa_id;
      END LOOP;
      
      -- Se añade la relación entre el despacho elegido y el asunto
      INSERT INTO bank01.gaa_gestor_adicional_asunto
                  (gaa_id, asu_id, usd_id, dd_tge_id, VERSION,
                   usuariocrear, fechacrear, borrado
                  )
           VALUES (bank01.s_gaa_gestor_adicional_asunto.NEXTVAL, p_asu_id, (SELECT DISTINCT FIRST_VALUE (usd.usd_id) OVER (ORDER BY usd.usd_gestor_defecto DESC)
                                                                              FROM bank01.usd_usuarios_despachos usd
                                                                             WHERE usd.des_id = v_des_id), (SELECT tge.dd_tge_id
                                                                                                              FROM bankmaster.dd_tge_tipo_gestor tge
                                                                                                             WHERE tge.dd_tge_codigo = p_tge_codigo), 0,
                   p_username, SYSDATE, 0
                  );
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