--/*
--##########################################
--## AUTOR=G Estellés
--## FECHA_CREACION=20150505
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.5.12
--## INCIDENCIA_LINK=FASE-1171
--## PRODUCTO=SI
--##
--## Finalidad: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################

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
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VTAR_ASU_VS_USU' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VTAR_ASU_VS_USU...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.VTAR_ASU_VS_USU';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.VTAR_ASU_VS_USU... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'VTAR_ASU_VS_USU' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VTAR_ASU_VS_USU...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.VTAR_ASU_VS_USU';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.VTAR_ASU_VS_USU... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VTAR_ASU_VS_USU...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.VTAR_ASU_VS_USU 
	AS
		SELECT usd.usu_id,
		  usd.des_id,
		  ges.dd_tge_id,
		  usd.usu_id usu_id_original,
		  asu.ASU_ID,
		  asu.GAS_ID,
		  asu.DD_EST_ID,
		  asu.ASU_FECHA_EST_ID,
		  asu.ASU_PROCESS_BPM,
		  asu.ASU_NOMBRE,
		  asu.EXP_ID,
		  asu.VERSION,
		  asu.USUARIOCREAR,
		  asu.FECHACREAR,
		  asu.USUARIOMODIFICAR,
		  asu.FECHAMODIFICAR,
		  asu.USUARIOBORRAR,
		  asu.FECHABORRAR,
		  asu.BORRADO,
		  asu.DD_EAS_ID,
		  asu.ASU_ASU_ID,
		  asu.ASU_OBSERVACION,
		  asu.SUP_ID,
		  asu.SUP_COM_ID,
		  asu.COM_ID,
		  asu.DCO_ID,
		  asu.ASU_FECHA_RECEP_DOC,
		  asu.USD_ID,
		  asu.DTYPE,
		  asu.DD_UCL_ID,
		  asu.REF_ASESORIA,
		  asu.LOTE,
		  asu.DD_TAS_ID,
		  asu.ASU_ID_EXTERNO,
		  asu.DD_PAS_ID,
		  asu.DD_GES_ID
		FROM asu_asuntos asu
		JOIN
		  (SELECT asu_id, usd_id, 4 dd_tge_id FROM  ' || V_ESQUEMA || '.asu_asuntos WHERE usd_id IS NOT NULL
		  UNION ALL
		  SELECT asu_id, usd_id, dd_tge_id
		  FROM  ' || V_ESQUEMA || '.gaa_gestor_adicional_asunto
		  WHERE borrado = 0
		  ) ges
		ON asu.asu_id = ges.asu_id
		JOIN  ' || V_ESQUEMA || '.usd_usuarios_despachos usd
		ON ges.usd_id = usd.usd_id';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.VTAR_ASU_VS_USU...Creada OK');
  
END;
/

EXIT;