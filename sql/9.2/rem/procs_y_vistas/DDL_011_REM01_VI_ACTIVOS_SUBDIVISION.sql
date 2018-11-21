--/*
--##########################################
--## AUTOR=Sergio Beleña
--## FECHA_CREACION=20181120
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=0
--## PRODUCTO=SI
--## Finalidad: DDL VISTA PARA LAS SUBDIVISIONES DE AGRUPACION
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial (JOSE VILLEL 20160510)
--##        0.2 Creación columna de Estado de publicación
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN
--v0.2
  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ACTIVOS_SUBDIVISION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_ACTIVOS_SUBDIVISION';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_ACTIVOS_SUBDIVISION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_ACTIVOS_SUBDIVISION';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_ACTIVOS_SUBDIVISION 

	AS
		SELECT act_sd.ID, aga.agr_id, act_sd.act_id, act_sd.act_num_activo, act_sd.bie_dreg_num_finca, act_sd.dd_tpa_descripcion, act_sd.dd_sac_descripcion, act_sd.dd_aic_descripcion,
		(CASE 
       		 WHEN cond.CON_CARGAS= 0
		 AND cond.DIVHORIZONTAL_NOINSCRITA= 0
		 AND cond.ES_CONDICIONADO= 0 
		 AND cond.OBRANUEVA_ENCONSTRUCCION= 0
		 AND cond.OBRANUEVA_SINDECLARAR= 0 
        	 AND cond.OCUPADO_CONTITULO= 0
		 AND cond.OCUPADO_SINTITULO= 0
		 AND cond.PENDIENTE_INSCRIPCION= 0
		 AND cond.ESTADO_PORTAL_EXTERNO= 0
		 AND cond.PROINDIVISO= 0
		 AND cond.RUINA= 0
        	 AND cond.SIN_INFORME_APROBADO= 0
		 AND cond.SIN_TOMA_POSESION_INICIAL= 0
		 AND cond.VANDALIZADO= 0
		 AND cond.TAPIADO= 0
		 THEN 0
       		 ELSE 1 
		END) AS ESTADOPUBLICACION

  FROM (SELECT subd.ID, subd.act_id, subd.act_num_activo, subd.bie_dreg_num_finca, tpa.dd_tpa_descripcion, sac.dd_sac_descripcion, subd.dd_aic_descripcion
          FROM (SELECT   act.act_id, act.act_num_activo, act.dd_tpa_id, act.dd_sac_id, biedreg.bie_dreg_num_finca, aic.dd_aic_descripcion,
                         ORA_HASH (   act.dd_tpa_id
                                   || act.dd_sac_id
                                   || NVL (viv.viv_num_plantas_interior, 0)
                                   || NVL (SUM (DECODE (dis.dd_tph_id, 1, dis.dis_cantidad, NULL)), 0)
                                   || NVL (SUM (DECODE (dis.dd_tph_id, 2, dis.dis_cantidad, NULL)), 0)
                                  ) ID
 

                    FROM act_ico_info_comercial ico JOIN act_activo act ON act.act_id = ico.act_id
                         left JOIN v_max_act_hic_est_inf_com maxhic ON (maxhic.act_id = act.act_id AND maxhic.pos = 1)
                         left JOIN dd_aic_accion_inf_comercial aic ON aic.dd_aic_id = maxhic.dd_aic_id
                         LEFT JOIN bie_datos_registrales biedreg ON act.bie_id = biedreg.bie_id
                         LEFT JOIN act_viv_vivienda viv ON viv.ico_id = ico.ico_id
                         LEFT JOIN act_dis_distribucion dis ON dis.ico_id = viv.ico_id
                   WHERE act.borrado = 0 
                GROUP BY act.act_id, act.act_num_activo, act.dd_tpa_id, act.dd_sac_id, biedreg.bie_dreg_num_finca, aic.dd_aic_descripcion, NVL (viv.viv_num_plantas_interior, 0)) subd
               JOIN
               dd_tpa_tipo_activo tpa ON tpa.dd_tpa_id = subd.dd_tpa_id
               JOIN dd_sac_subtipo_activo sac ON sac.dd_sac_id = subd.dd_sac_id
               ) act_sd
       JOIN
        act_aga_agrupacion_activo aga ON aga.act_id = act_sd.act_id
	JOIN V_COND_DISPONIBILIDAD cond ON  aga.act_id = cond.act_id';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_ACTIVOS_SUBDIVISION...Creada OK');
  
END;
/

EXIT;
