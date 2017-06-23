  --/*
--##########################################
--## AUTOR=JOSEVI JIMENEZ
--## FECHA_CREACION=20161121
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1062
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
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_STATS_CARTERA_MEDIADORES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_STATS_CARTERA_MEDIADORES...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_STATS_CARTERA_MEDIADORES';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_STATS_CARTERA_MEDIADORES... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_STATS_CARTERA_MEDIADORES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_STATS_CARTERA_MEDIADORES...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_STATS_CARTERA_MEDIADORES';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_STATS_CARTERA_MEDIADORES... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_STATS_CARTERA_MEDIADORES...');
  EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW ' || V_ESQUEMA || '.V_STATS_CARTERA_MEDIADORES 
		
	AS	
		SELECT PVE.PVE_ID AS ID_MEDIADOR,
		  (
		    SELECT COUNT(ICO1.ACT_ID) AS NUM_ACTIVOS
		    FROM '|| V_ESQUEMA ||'.ACT_activo act
		    inner join '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO1
		    on ico1.act_id = act.act_id
		    WHERE ICO1.ICO_MEDIADOR_ID = PVE.PVE_ID
		    and act.borrado = 0
		    -- ACTIVOS (como mediador del informe comercial de los activos)
		  ) AS NUM_ACTIVOS,
		  (
		    SELECT COUNT(VIS1.VIS_ID)
		    FROM '|| V_ESQUEMA ||'.ACT_activo act
		    inner join '|| V_ESQUEMA ||'.VIS_VISITAS VIS1
		    on vis1.act_id = act.act_id
		    WHERE VIS1.PVE_ID_PVE_VISITA = PVE.PVE_ID
		    and act.borrado = 0
		    -- VISITAS (realizadas)
		  ) AS NUM_VISITAS,
		  (
		    SELECT COUNT(OFR1.OFR_ID) AS NUM_OFERTAS
		    FROM '|| V_ESQUEMA ||'.OFR_OFERTAS OFR1
		    WHERE OFR1.PVE_ID_API_RESPONSABLE = PVE.PVE_ID
		    -- OFERTAS (como responsable)
		  ) AS NUM_OFERTAS,
		  (
		    SELECT COUNT(ECO1.ECO_ID) AS RESERVAS
		    FROM '||V_ESQUEMA||'.act_activo act
		    inner join '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO1 on ico1.act_id = act.act_id
		    INNER JOIN '|| V_ESQUEMA ||'.ACT_OFR AOF1 ON ICO1.ICO_MEDIADOR_ID = AOF1.OFR_ID
		    INNER JOIN '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO1 ON AOF1.OFR_ID = ECO1.OFR_ID
		    INNER JOIN '|| V_ESQUEMA ||'.DD_EEC_EST_EXP_COMERCIAL EEC1 ON ECO1.DD_EEC_ID          = EEC1.DD_EEC_ID
		    WHERE act.borrado = 0
		    and ICO1.ICO_MEDIADOR_ID = PVE.PVE_ID
		    AND EEC1.DD_EEC_CODIGO     = ''06'' -- RESERVADO
		    -- RESERVAS
		  ) AS NUM_RESERVAS,
		  (
		    SELECT COUNT(ECO1.ECO_ID) AS VENTAS
		    FROM '||V_ESQUEMA||'.act_activo act
		    inner join '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO1 on ico1.act_id = act.act_id
		    INNER JOIN '|| V_ESQUEMA ||'.ACT_OFR AOF1 ON ICO1.ICO_MEDIADOR_ID = AOF1.OFR_ID
		    INNER JOIN '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO1 ON AOF1.OFR_ID = ECO1.OFR_ID
		    INNER JOIN '|| V_ESQUEMA ||'.DD_EEC_EST_EXP_COMERCIAL EEC1 ON ECO1.DD_EEC_ID          = EEC1.DD_EEC_ID
		    WHERE act.borrado = 0
		    and ICO1.ICO_MEDIADOR_ID = PVE.PVE_ID
		    AND EEC1.DD_EEC_CODIGO     = ''08'' -- VENDIDO
		    -- ACTIVOS VENDIDOS (VENTAS)
		  ) AS NUM_VENTAS,
		  DD_CPR_CODIGO      AS COD_CALIFICACION_VIGENTE,
		  DD_CPR_DESCRIPCION AS DES_CALIFICACION_VIGENTE,
		  PVE_TOP            AS TOP_150_VIGENTE
		FROM '|| V_ESQUEMA ||'.ACT_PVE_PROVEEDOR PVE
		INNER JOIN '|| V_ESQUEMA ||'.DD_TPR_TIPO_PROVEEDOR TPR ON PVE.DD_TPR_ID = TPR.DD_TPR_ID AND TPR.DD_TPR_CODIGO = ''04''
		LEFT OUTER JOIN '|| V_ESQUEMA ||'.DD_CPR_CALIFICACION_PROVEEDOR CPR ON PVE.DD_CPR_ID = CPR.DD_CPR_ID
';

      	
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_STATS_CARTERA_MEDIADORES...Creada OK');
  
END;
/

EXIT;