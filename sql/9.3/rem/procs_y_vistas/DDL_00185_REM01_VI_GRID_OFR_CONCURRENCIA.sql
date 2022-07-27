--/*
--##########################################
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20220727
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18445
--## PRODUCTO=NO
--## Finalidad: VI_GRID_OFR_CONCURRENCIA
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##         0.1 Versión inicial (HREOS-17991)
--##         0.2 Juan Jose Sanjuan - añadir importe Oferta 
--##         0.3 Alejandro Valverde (HREOS-18405) - Añadir datos Expediente Comercial
--##         0.4 Alejandro Valverde (HREOS-18445) - Añadir campos EST_CODIGO_C4C y FECHA_ENT_CRM_SF
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
    V_MSQL VARCHAR2(32000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_GRID_OFR_CONCURRENCIA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_CONCURRENCIA...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_CONCURRENCIA... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VI_GRID_OFR_CONCURRENCIA' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_CONCURRENCIA...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_CONCURRENCIA... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_CONCURRENCIA...');
  V_MSQL := 'CREATE VIEW ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA
	AS
		SELECT ofr.OFR_ID AS ID
    ,NVL2(AGR.AGR_NUM_AGRUP_REM, AGR.AGR_NUM_AGRUP_REM, ACT.ACT_NUM_ACTIVO) AS NUM_ACTIVO_AGRUPACION
		,ofr.OFR_NUM_OFERTA AS NUMOFERTA
    ,ofr.OFR_IMPORTE AS IMPORTEOFERTA
		,CLC.CLC_NOMBRE || '' '' ||  CLC.CLC_APELLIDOS AS OFERTANTE
		,TOF.DD_TOF_codigo AS TIPOOFERTACODIGO		
		,TOF.DD_TOF_DESCRIPCION AS TIPOOFERTA
		,EOF.DD_EOF_CODIGO AS ESTADOOFERTACODIGO
		,EOF.DD_EOF_DESCRIPCION AS ESTADOOFERTA
		,EDP.DD_EDP_CODIGO AS ESTADODEPOSITOCODIGO
		,EDP.DD_EDP_DESCRIPCION AS ESTADODEPOSITO
		,ofr.OFR_FECHA_ALTA AS FECHAALTA
		,ROUND(CON_FECHA_FIN-CON_FECHA_INI, 0) AS DIASCONCURRENCIA
		,act.ACT_ID		
		,act.ACT_NUM_ACTIVO
		,cnc.CON_ID
		,ECO.ECO_NUM_EXPEDIENTE
		,ECO.ECO_ID
		,EEC.DD_EEC_DESCRIPCION
		,C4C.DD_ECC_CODIGO AS EST_CODIGO_C4C
		,OFR.FECHA_ENT_CRM_SF
		FROM '|| V_ESQUEMA ||'.ofr_ofertas ofr
		INNER JOIN '|| V_ESQUEMA ||'.DD_TOF_TIPOS_OFERTA TOF ON TOF.DD_TOF_ID = OFR.DD_TOF_ID
		INNER JOIN '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID
		join '|| V_ESQUEMA ||'.act_ofr aof on ofr.ofr_id = aof.ofr_id 
		join '|| V_ESQUEMA ||'.act_Activo act on act.act_id = aof.act_id
		join '|| V_ESQUEMA ||'.con_concurrencia cnc on act.act_id = cnc.act_id
		JOIN '|| V_ESQUEMA ||'.CLC_CLIENTE_COMERCIAL CLC ON CLC.CLC_ID = OFR.CLC_ID
    LEFT JOIN ' || V_ESQUEMA || '.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = cnc.AGR_ID AND AGR.BORRADO = 0
		LEFT JOIN '|| V_ESQUEMA ||'.DEP_DEPOSITO DEP ON DEP.OFR_ID = OFR.OFR_ID and DEP.borrado = 0
		LEFT JOIN '|| V_ESQUEMA ||'.DD_EDP_EST_DEPOSITO EDP ON EDP.DD_EDP_ID = DEP.DD_EDP_ID
		LEFT JOIN ' || V_ESQUEMA || '.ECO_EXPEDIENTE_COMERCIAL ECO ON ECO.OFR_ID = OFR.OFR_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID
		LEFT JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS_CAIXA CBX ON OFR.OFR_ID = CBX.OFR_ID 
		LEFT JOIN '|| V_ESQUEMA ||'.DD_ECC_ESTADO_COMUNICACION_C4C C4C ON CBX.DD_ECC_ID = C4C.DD_ECC_ID
		WHERE ofr.ofr_concurrencia  = 1  and ofr.borrado = 0';

  EXECUTE IMMEDIATE	V_MSQL;
    
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_CONCURRENCIA...Creada OK');
  EXECUTE IMMEDIATE 'COMMENT ON TABLE ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA IS ''VISTA PARA RECOGER LAS OFERTAS DE CONCURRENCIA DE ACTIVOS''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.ID IS ''Identificador de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.NUMOFERTA IS ''Número de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.OFERTANTE IS ''Nombre y apellidos del Cliente comercial que realiza la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.TIPOOFERTACODIGO IS ''Códgio del tipo de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.TIPOOFERTA IS ''Descripción del tipo de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.ESTADOOFERTACODIGO IS ''Códgio del estado de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.ESTADOOFERTA IS ''Descripción del estado de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.ESTADODEPOSITOCODIGO IS ''Códgio del estado del depósito''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.ESTADODEPOSITO IS ''Descripción del estado del depósito.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.FECHAALTA IS ''Fecha alta de la oferta.''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.DIASCONCURRENCIA IS ''Periodo en días de la concurrencia''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.ACT_ID IS ''Identificador del activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.ACT_NUM_ACTIVO IS ''Número del activo''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.CON_ID IS ''Código identificador único de la concurrencia relacionado con el activo de la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.ECO_NUM_EXPEDIENTE IS ''Número del expediente comercial relacionado con la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.ECO_ID IS ''Código identificador único del expediente comercial relacionado con la oferta''';
  EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.VI_GRID_OFR_CONCURRENCIA.DD_EEC_DESCRIPCION IS ''Estado del expediente comercial relacionado con la oferta''';

  
  DBMS_OUTPUT.PUT_LINE('Creados los comentarios en CREATE VIEW '|| V_ESQUEMA ||'.VI_GRID_OFR_CONCURRENCIA...Creada OK');
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
