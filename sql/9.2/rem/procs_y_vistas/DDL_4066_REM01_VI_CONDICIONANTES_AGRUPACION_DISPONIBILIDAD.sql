--/*
--##########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=20180614
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4085
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
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
  EXECUTE IMMEDIATE '  CREATE OR REPLACE FORCE VIEW '|| V_ESQUEMA ||'."V_COND_AGR_DISPONIBILIDAD" ("AGR_ID", "SIN_TOMA_POSESION_INICIAL", 
		"OCUPADO_CONTITULO", "PENDIENTE_INSCRIPCION", "PROINDIVISO", "TAPIADO", "OBRANUEVA_SINDECLARAR", "OBRANUEVA_ENCONSTRUCCION", 
		"DIVHORIZONTAL_NOINSCRITA", "RUINA", "VANDALIZADO", "OTRO", "SIN_INFORME_APROBADO", "REVISION", "PROCEDIMIENTO_JUDICIAL", 
		"CON_CARGAS", "OCUPADO_SINTITULO", "ESTADO_PORTAL_EXTERNO", "ES_CONDICIONADO", "EST_DISP_COM_CODIGO", "BORRADO") AS 
  		SELECT
		    agr_id,
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
		    max(case when aga_principal = 1 then
		    otro
		    end) as otro,
		    max(sin_informe_aprobado) as sin_informe_aprobado,
		    max(revision) as revision,
		    max(procedimiento_judicial) as procedimiento_judicial,
		    max(con_cargas) as con_cargas,
		    max(ocupado_sintitulo) as ocupado_sintitulo,
		    max(estado_portal_externo) as estado_portal_externo,
		    max(es_condicionado) as es_condicionado,
		    max(est_disp_com_codigo)AS est_disp_com_codigo,
		    min(vcond.borrado) borrado
		FROM '||V_ESQUEMA||'.V_Cond_Disponibilidad vcond
		INNER JOIN Act_Aga_Agrupacion_Activo aga on aga.act_id = vcond.act_id
		GROUP BY agr_id';

    -- Creamos comentarios     
    
	V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.V_COND_AGR_DISPONIBILIDAD.AGR_ID IS ''ID de la agrupación'' ';      
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
  
END;
/

EXIT;