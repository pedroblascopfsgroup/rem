CREATE OR REPLACE VIEW V_MSV_BUSQUEDA_ASUNTOS_USUARIO AS
SELECT DISTINCT ASU.*, USU.USU_ID FROM V_MSV_BUSQUEDA_ASUNTOS ASU
LEFT JOIN vtar_asu_vs_usu USU ON ASU.ASU_ID = USU.ASU_ID;