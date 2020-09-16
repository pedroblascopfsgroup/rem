--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190225
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3417
--## PRODUCTO=NO
--## Finalidad: DDL
--##            
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
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
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';
    V_MSQL VARCHAR2(4000 CHAR); 
    V_NOM_VISTA VARCHAR2(20 CHAR):= 'V_GESTOR_VENTA'; -- Configuracion Esquemas

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_NOM_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA || '.' || V_NOM_VISTA || '...' );
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.' || V_NOM_VISTA ;  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA || '.' || V_NOM_VISTA || '... borrada OK' ) ;
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA || '.' || V_NOM_VISTA || '...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.' || V_NOM_VISTA || ' AS  
	WITH expedientes_fir_ven as (
	select ao.act_id, eco.ofr_id, eco.eco_fecha_venta from ' || V_ESQUEMA || '.eco_expediente_comercial eco
	join ' || V_ESQUEMA || '.DD_EEC_EST_EXP_COMERCIAL eec on eec.dd_eec_id = eco.dd_eec_id and eec.dd_eec_codigo IN (''03'',''08'')
	join ' || V_ESQUEMA || '.OFR_OFERTAS ofr on ofr.ofr_id = eco.ofr_id
	join ' || V_ESQUEMA || '.act_ofr ao on ao.ofr_id = ofr.ofr_id
	),
	fechas_venta AS (
	select act.act_id, act.act_num_activo, scm.dd_scm_descripcion, act.act_venta_externa_fecha, eco.eco_fecha_venta from rem01.act_activo act
	join ' || V_ESQUEMA || '.DD_SCM_SITUACION_COMERCIAL scm on scm.dd_scm_id = act.dd_scm_id
	left join expedientes_fir_ven eco on eco.act_id = act.act_id
	where scm.dd_scm_codigo = ''05''
	),
	gestores_comerciales AS (
	select gah.act_id, geh.GEH_FECHA_DESDE, geh.GEH_FECHA_hasta, usu.usu_username from fechas_venta fv
	join ' || V_ESQUEMA || '.GAH_GESTOR_ACTIVO_HISTORICO gah on gah.act_id = fv.act_id
	join ' || V_ESQUEMA || '.GEH_GESTOR_ENTIDAD_HIST geh on geh.geh_id = gah.geh_id
	join ' || V_ESQUEMA_M || '.DD_TGE_TIPO_GESTOR tge on tge.dd_tge_id = geh.dd_tge_id
	join ' || V_ESQUEMA_M || '.usu_usuarios usu on usu.usu_id = geh.usu_id
	where tge.dd_tge_codigo = ''GCOM''
	)
	select fv.act_num_activo, nvl(fv.eco_fecha_venta, fv.act_venta_externa_fecha) as fecha_venta, gcom.usu_username, gcom.geh_fecha_desde, gcom.geh_fecha_hasta from fechas_venta fv
	join gestores_comerciales gcom on gcom.act_id = fv.act_id
	where (nvl(fv.eco_fecha_venta, fv.act_venta_externa_fecha) between gcom.GEH_FECHA_DESDE and gcom.geh_fecha_hasta
	or (gcom.geh_fecha_hasta is null and nvl(fv.eco_fecha_venta, fv.act_venta_externa_fecha) >= gcom.geh_fecha_desde)
	)
	and nvl(fv.eco_fecha_venta, fv.act_venta_externa_fecha) > to_date(''01/01/19'',''DD/MM/YY'')
	';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA || '.' || V_NOM_VISTA || '...Creada OK');
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
