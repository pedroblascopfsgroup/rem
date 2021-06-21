--/*
--##########################################
--## AUTOR=Javier Pons Ruiz
--## FECHA_CREACION=20210607
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-9845
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Cambio para agrupación restringida(HREOS-6318) -JSL
--##        0.3 Juan Bautista Alfonso [REMVIP-9845] Modificacion para nuevas vistas V_COND_DISPONIBILIDAD
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    err_num NUMBER; -- Vble. número de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_COND_AGR_DISPONIBILIDAD' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_COND_AGR_DISPONIBILIDAD...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_COND_AGR_DISPONIBILIDAD';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_COND_AGR_DISPONIBILIDAD... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_COND_AGR_DISPONIBILIDAD...');
  EXECUTE IMMEDIATE '  CREATE OR REPLACE FORCE VIEW '|| V_ESQUEMA ||'."V_COND_AGR_DISPONIBILIDAD" ("AGR_ID", "DD_TAG_CODIGO","SIN_TOMA_POSESION_INICIAL", 
		"OCUPADO_CONTITULO", "PENDIENTE_INSCRIPCION", "PROINDIVISO", "TAPIADO", "OBRANUEVA_SINDECLARAR", "OBRANUEVA_ENCONSTRUCCION", 
		"DIVHORIZONTAL_NOINSCRITA", "RUINA", "VANDALIZADO", "OTRO", "SIN_INFORME_APROBADO", "REVISION", "PROCEDIMIENTO_JUDICIAL", 
		"CON_CARGAS", "OCUPADO_SINTITULO", "ESTADO_PORTAL_EXTERNO", "ES_CONDICIONADO", "EST_DISP_COM_CODIGO", "BORRADO") AS 
  		SELECT
		    aga.agr_id,
			tag.dd_tag_codigo,
		    max(sin_toma_posesion_inicial) as sin_toma_posesion_inicial,
		    max(ocupado_contitulo) as ocupado_contitulo,
		    max(pendiente_inscripcion) as pendiente_inscripcion,
		    max(proindiviso) as proindiviso,
		    max(tapiado) as tapiado,
		    max(obranueva_sindeclarar) as obranueva_sindeclarar,
		    max(obranueva_enconstruccion) as obranueva_enconstruccion,
		    max(divhorizontal_noinscrita) as divhorizontal_noinscrita,
		    max(ruina) as ruina,
		    max(vandalizado) as vandalizado,
		    max(case when agr_act_principal = vcond.act_id then
		    otro
		    end) as otro,
		    max(SININF.sin_informe_aprobado_REM) as sin_informe_aprobado,
		    max(revision) as revision,
		    max(procedimiento_judicial) as procedimiento_judicial,
		    max(con_cargas) as con_cargas,
		    max(ocupado_sintitulo) as ocupado_sintitulo,
		    max(estado_portal_externo) as estado_portal_externo,
		    max(ESCOND.es_condicionado) as es_condicionado,
		    (case 
             	when tag.dd_tag_codigo=''02'' then min(est_disp_com_codigo)
                else max(est_disp_com_codigo)
            end) as est_disp_com_codigo,
		    min(vcond.borrado) borrado
		FROM '||V_ESQUEMA||'.V_Cond_Disponibilidad vcond
		INNER JOIN '||V_ESQUEMA||'.V_ES_CONDICIONADO ESCOND ON ESCOND.ACT_ID=VCOND.ACT_ID
		INNER JOIN '||V_ESQUEMA||'.V_SIN_INFORME_APROBADO_REM SININF ON SININF.ACT_ID=VCOND.ACT_ID
		INNER JOIN '||V_ESQUEMA||'.Act_Aga_Agrupacion_Activo aga on aga.act_id = vcond.act_id
		INNER JOIN '||V_ESQUEMA||'.Act_Agr_Agrupacion agr on agr.agr_id = aga.agr_id
		INNER JOIN '||V_ESQUEMA||'.dd_tag_tipo_agrupacion tag on tag.dd_tag_id = agr.dd_tag_id 
		GROUP BY aga.agr_id, tag.dd_tag_codigo';

    -- Creamos comentarios     
    
	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.AGR_ID IS ''ID de la agrupación'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.DD_TAG_CODIGO IS ''Codigo de la agrupación'' ';      
    EXECUTE IMMEDIATE V_MSQL;    
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.SIN_TOMA_POSESION_INICIAL IS ''Condicionante de agrupación con activos sin toma de posesión inicial'' ';      
    EXECUTE IMMEDIATE V_MSQL;
 
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.OCUPADO_CONTITULO IS ''Condicionante de agrupación con activos ocupados'' ';      
    EXECUTE IMMEDIATE V_MSQL;
        
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.PENDIENTE_INSCRIPCION IS ''Condicionante de agrupación con activos pendiente de inscripción'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.PROINDIVISO IS ''Condicionante de agrupación con activos proindiviso'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.TAPIADO IS ''Condicionante de agrupación con activos tapiados'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.OBRANUEVA_SINDECLARAR IS ''Condicionante de agrupación con activos de obra nueva sin declarar'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.OBRANUEVA_ENCONSTRUCCION IS ''Condicionante de agrupación con activos de obra nueva en construcción'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.DIVHORIZONTAL_NOINSCRITA IS ''Condicionante de agrupación con activos en división horizontal no inscrita'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.RUINA IS ''Condicionante de agrupación con activos en ruina'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.VANDALIZADO IS ''Condicionante de agrupación con activos vanzadolizados'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.OTRO IS ''Condicionante de agrupación con activos otros condicionantes'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.SIN_INFORME_APROBADO IS ''Condicionante  de agrupación con activos sin informe aprobado'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.REVISION IS ''Condicionante de agrupación con activos con revision'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.PROCEDIMIENTO_JUDICIAL IS ''Condicionante de agrupación con activos con procedimiento judicial'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.CON_CARGAS IS ''Condicionante agrupación de agrupación con activos con cargas'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.OCUPADO_SINTITULO IS ''Condicionante de agrupación con activos ocupados sin titulo'' ';      
    EXECUTE IMMEDIATE V_MSQL;

    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.ESTADO_PORTAL_EXTERNO IS ''Condicionate de agrupación con activos con estado del portal externo'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.ES_CONDICIONADO IS ''Condicionante de agrupación si es condicionado'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.EST_DISP_COM_CODIGO IS ''Estado disponibilidad comercial de la agrupación'' ';      
    EXECUTE IMMEDIATE V_MSQL;
    
    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.BORRADO IS ''Borrado de agrupación'' ';      
    EXECUTE IMMEDIATE V_MSQL;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_COND_AGR_DISPONIBILIDAD...Creada OK');

  COMMIT;

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
