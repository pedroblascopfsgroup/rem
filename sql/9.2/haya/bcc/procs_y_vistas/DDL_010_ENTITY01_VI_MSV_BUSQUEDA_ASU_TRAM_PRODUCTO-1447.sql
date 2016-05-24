--/*
--##########################################
--## AUTOR=Vicente Lozano
--## FECHA_CREACION=201600517
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1447
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Modificacion de la vista V_MSV_BUSQUEDA_ASU_TRAM
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
  

BEGIN

	V_MSQL := '
			  CREATE OR REPLACE FORCE VIEW '|| V_ESQUEMA||'.V_MSV_BUSQUEDA_ASU_TRAM (ID_, ASU_ID, PRC_ID, ASU_NOMBRE, PLAZA, JUZGADO, AUTO, TIPO_PRC, PRINCIPAL, TEX_ID, COD_ESTADO_PRC, DES_ESTADO_PRC, PRC_SALDO_RECUPERACION, PRC_FECHA_CREAR, TAR_TAREA) AS 
			  (SELECT DISTINCT ROWNUM id_, asu.asu_id ASU_ID, prc.prc_id PRC_ID,
			                    asu.asu_nombre ASU_NOMBRE,
			                    pla.dd_pla_descripcion PLAZA,
			                    juz.dd_juz_descripcion JUZGADO,
			                    prc.prc_cod_proc_en_juzgado AUTO,
			                    tpo.dd_tpo_descripcion TIPO_PRC,
			                    prc.prc_saldo_recuperacion PRINCIPAL,
			                    tex.tex_id TEX_ID, epr.dd_epr_codigo COD_ESTADO_PRC,
			                    epr.dd_epr_descripcion DES_ESTADO_PRC,
			                    prc.prc_saldo_recuperacion, prc.fechacrear, tar.tar_tarea
			               FROM ' ||V_ESQUEMA||'.asu_asuntos asu INNER JOIN '||V_ESQUEMA||'.prc_procedimientos prc
			                    ON asu.asu_id = prc.asu_id AND prc.borrado = 0
			                    LEFT JOIN '|| V_ESQUEMA||'.dd_juz_juzgados_plaza juz
			                    ON prc.dd_juz_id = juz.dd_juz_id
			                  AND (juz.borrado = 0 OR juz.borrado IS NULL)
			                    LEFT JOIN '||V_ESQUEMA||'.dd_pla_plazas pla
			                    ON pla.dd_pla_id = juz.dd_pla_id
			                  AND (pla.borrado = 0 OR pla.borrado IS NULL)
			                    INNER JOIN '|| V_ESQUEMA||'.dd_tj_tipo_juicio tj
			                    ON prc.dd_tpo_id = tj.dd_tpo_id
			                    INNER JOIN '|| V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo
			                    ON prc.dd_tpo_id = tpo.dd_tpo_id
			                  AND (tpo.dd_tac_id = (SELECT dd_tac_id
			                                          FROM '|| V_ESQUEMA ||'.dd_tac_tipo_actuacion tac
			                                         WHERE tac.dd_tac_codigo = ''TR''))
			                    INNER JOIN '|| V_ESQUEMA||'.tar_tareas_notificaciones tar
			                    ON prc.prc_id = tar.prc_id
			                  AND (   tar.tar_tarea_finalizada = 0
			                       OR tar.tar_tarea_finalizada IS NULL
			                      )
			                    INNER JOIN ' ||V_ESQUEMA||'.tex_tarea_externa tex ON tex.tar_id =
			                                                                    tar.tar_id
			                    INNER JOIN '|| V_ESQUEMA_M||'.dd_epr_estado_procedimiento epr
			                    ON prc.dd_epr_id = epr.dd_epr_id
			                    JOIN ' ||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base sta ON sta.dd_sta_id = tar.dd_sta_id and sta.dd_sta_codigo IN (''CJ-814'',''814'')
			              WHERE asu.borrado = 0 AND prc.prc_paralizado = 0)';
 

 EXECUTE IMMEDIATE V_MSQL;
 DBMS_OUTPUT.PUT_LINE('[INFO] V_MSV_BUSQUEDA_ASU_TRAM  Creada o reemplazada');     

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