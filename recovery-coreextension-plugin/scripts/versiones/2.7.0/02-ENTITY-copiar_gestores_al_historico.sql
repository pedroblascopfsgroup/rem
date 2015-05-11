-- Copia los gestores de la tabla gaa_gestor_adicional_asunto en la tabla de histórico
-- gah_gestor_adicional_historico. Necesario para que se muestren en la pantalla de gestores del asunto.

DELETE FROM gah_gestor_adicional_historico;

INSERT INTO gah_gestor_adicional_historico
   SELECT s_gah_gestor_adic_historico.NEXTVAL, g.usd_id, g.asu_id, g.dd_tge_id,
          NVL2 (g.fechamodificar, g.fechamodificar, g.fechacrear), NULL, 0, 'manuel', SYSDATE, NULL, NULL, NULL,
          NULL, 0
     FROM gaa_gestor_adicional_asunto g;