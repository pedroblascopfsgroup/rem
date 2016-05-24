--/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20150706
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-X
--## INCIDENCIA_LINK=MITCDD-2068
--## PRODUCTO=SI
--##
--## Finalidad: Vista V_MSV_BUSQUEDA_ASU_TRAM
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(5000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    table_count2 number(3);
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('******** V_MSV_BUSQUEDA_ASU_TRAM ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASU_TRAM... Comprobaciones previas');
	

	-- Comprobamos si existe la vista
	V_MSQL := 'SELECT COUNT(1) FROM ALL_VIEWS WHERE VIEW_NAME = ''V_MSV_BUSQUEDA_ASU_TRAM'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO table_count;
	
	IF table_count = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.V_MSV_BUSQUEDA_ASU_TRAM... ya existe, se reemplazará');
		EXECUTE IMMEDIATE 'DROP VIEW V_MSV_BUSQUEDA_ASU_TRAM';
		V_MSQL := 'CREATE OR REPLACE VIEW ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASU_TRAM
		("ID_", "ASU_ID", "PRC_ID", "ASU_NOMBRE", "PLAZA", "JUZGADO", "AUTO", "TIPO_PRC", "PRINCIPAL", "TEX_ID", "COD_ESTADO_PRC", "DES_ESTADO_PRC", "PRC_SALDO_RECUPERACION", "PRC_FECHA_CREAR", "TAR_TAREA") AS 
  		(SELECT DISTINCT ROWNUM id_, asu.asu_id "ASU_ID", prc.prc_id "PRC_ID",
                    asu.asu_nombre "ASU_NOMBRE",
                    pla.dd_pla_descripcion "PLAZA",
                    juz.dd_juz_descripcion "JUZGADO",
                    prc.prc_cod_proc_en_juzgado "AUTO",
                    tpo.dd_tpo_descripcion "TIPO_PRC",
                    prc.prc_saldo_recuperacion "PRINCIPAL",
                    tex.tex_id "TEX_ID", epr.dd_epr_codigo "COD_ESTADO_PRC",
                    epr.dd_epr_descripcion "DES_ESTADO_PRC",
                    prc.prc_saldo_recuperacion, prc.fechacrear, tar.tar_tarea
               FROM asu_asuntos asu INNER JOIN prc_procedimientos prc
                    ON asu.asu_id = prc.asu_id AND prc.borrado = 0
                    LEFT JOIN dd_juz_juzgados_plaza juz
                    ON prc.dd_juz_id = juz.dd_juz_id
                  AND (juz.borrado = 0 OR juz.borrado IS NULL)
                    LEFT JOIN dd_pla_plazas pla
                    ON pla.dd_pla_id = juz.dd_pla_id
                  AND (pla.borrado = 0 OR pla.borrado IS NULL)
                    INNER JOIN dd_tj_tipo_juicio tj
                    ON prc.dd_tpo_id = tj.dd_tpo_id
                    INNER JOIN dd_tpo_tipo_procedimiento tpo
                    ON prc.dd_tpo_id = tpo.dd_tpo_id
                  AND (tpo.dd_tac_id = (SELECT dd_tac_id
                                          FROM dd_tac_tipo_actuacion tac
                                         WHERE tac.dd_tac_codigo = ''TR''))
                    INNER JOIN tar_tareas_notificaciones tar
                    ON prc.prc_id = tar.prc_id
                  AND (   tar.tar_tarea_finalizada = 0
                       OR tar.tar_tarea_finalizada IS NULL
                      )
                    INNER JOIN tex_tarea_externa tex ON tex.tar_id =
                                                                    tar.tar_id
                    INNER JOIN '||V_ESQUEMA_M||'.dd_epr_estado_procedimiento epr
                    ON prc.dd_epr_id = epr.dd_epr_id
                    JOIN '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base sta ON sta.dd_sta_id = tar.dd_sta_id and sta.dd_sta_codigo = ''814''
              WHERE asu.borrado = 0 AND prc.prc_paralizado = 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASU_TRAM... Creando vista');
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASU_TRAM... OK');
			
		ELSE
			V_MSQL := 'CREATE OR REPLACE VIEW ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASU_TRAM 
		("ID_", "ASU_ID", "PRC_ID", "ASU_NOMBRE", "PLAZA", "JUZGADO", "AUTO", "TIPO_PRC", "PRINCIPAL", "TEX_ID", "COD_ESTADO_PRC", "DES_ESTADO_PRC", "PRC_SALDO_RECUPERACION", "PRC_FECHA_CREAR", "TAR_TAREA") AS 
  		(SELECT DISTINCT ROWNUM id_, asu.asu_id "ASU_ID", prc.prc_id "PRC_ID",
                    asu.asu_nombre "ASU_NOMBRE",
                    pla.dd_pla_descripcion "PLAZA",
                    juz.dd_juz_descripcion "JUZGADO",
                    prc.prc_cod_proc_en_juzgado "AUTO",
                    tpo.dd_tpo_descripcion "TIPO_PRC",
                    prc.prc_saldo_recuperacion "PRINCIPAL",
                    tex.tex_id "TEX_ID", epr.dd_epr_codigo "COD_ESTADO_PRC",
                    epr.dd_epr_descripcion "DES_ESTADO_PRC",
                    prc.prc_saldo_recuperacion, prc.fechacrear, tar.tar_tarea
               FROM asu_asuntos asu INNER JOIN prc_procedimientos prc
                    ON asu.asu_id = prc.asu_id AND prc.borrado = 0
                    LEFT JOIN dd_juz_juzgados_plaza juz
                    ON prc.dd_juz_id = juz.dd_juz_id
                  AND (juz.borrado = 0 OR juz.borrado IS NULL)
                    LEFT JOIN dd_pla_plazas pla
                    ON pla.dd_pla_id = juz.dd_pla_id
                  AND (pla.borrado = 0 OR pla.borrado IS NULL)
                    INNER JOIN dd_tj_tipo_juicio tj
                    ON prc.dd_tpo_id = tj.dd_tpo_id
                    INNER JOIN dd_tpo_tipo_procedimiento tpo
                    ON prc.dd_tpo_id = tpo.dd_tpo_id
                  AND (tpo.dd_tac_id = (SELECT dd_tac_id
                                          FROM dd_tac_tipo_actuacion tac
                                         WHERE tac.dd_tac_codigo = ''TR''))
                    INNER JOIN tar_tareas_notificaciones tar
                    ON prc.prc_id = tar.prc_id
                  AND (   tar.tar_tarea_finalizada = 0
                       OR tar.tar_tarea_finalizada IS NULL
                      )
                    INNER JOIN tex_tarea_externa tex ON tex.tar_id =
                                                                    tar.tar_id
                    INNER JOIN '||V_ESQUEMA_M||'.dd_epr_estado_procedimiento epr
                    ON prc.dd_epr_id = epr.dd_epr_id
                    JOIN '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base sta ON sta.dd_sta_id = tar.dd_sta_id and sta.dd_sta_codigo = ''814''
              WHERE asu.borrado = 0 AND prc.prc_paralizado = 0)';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASU_TRAM... Creando vista');
			DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.V_MSV_BUSQUEDA_ASU_TRAM... OK');
	END IF;

	COMMIT;
	
EXCEPTION


	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SQLERRM);
		ROLLBACK;
		RAISE;
END;
/

EXIT;