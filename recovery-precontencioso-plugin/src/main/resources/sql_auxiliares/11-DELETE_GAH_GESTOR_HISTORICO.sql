delete from GAH_GESTOR_ADICIONAL_HISTORICO where gah_gestor_id in (
SELECT distinct gah.GAH_GESTOR_ID FROM GAH_GESTOR_ADICIONAL_HISTORICO gah LEFT JOIN usd_usuarios_despachos usu on gah.GAH_GESTOR_ID = usu.usd_id WHERE usu.USD_ID is null);

commit;