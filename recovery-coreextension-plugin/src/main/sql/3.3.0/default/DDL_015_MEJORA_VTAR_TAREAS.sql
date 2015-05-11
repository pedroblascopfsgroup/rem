--/*
--##########################################
--## Author: Gonzalo
--## Mejora de la bÃºsqueda de tareas pendientes
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- N?mero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= 'BANK01'; -- Configuracion Esquemas
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

  DBMS_OUTPUT.PUT_LINE('CREATE MATERIALIZED VIEW '|| V_ESQUEMA ||'.VTAR_ASU_VS_USU...');
  EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.VTAR_ASU_VS_USU (USU_ID, DES_ID, "DD_TGE_ID", "USU_ID_ORIGINAL", "ASU_ID", "GAS_ID", "DD_EST_ID", "ASU_FECHA_EST_ID", "ASU_PROCESS_BPM", "ASU_NOMBRE", "EXP_ID", "VERSION", "USUARIOCREAR", "FECHACREAR", "USUARIOMODIFICAR", "FECHAMODIFICAR", "USUARIOBORRAR", "FECHABORRAR", "BORRADO", "DD_EAS_ID", "ASU_ASU_ID", "ASU_OBSERVACION", "SUP_ID", "SUP_COM_ID", "COM_ID", "DCO_ID", "ASU_FECHA_RECEP_DOC", "USD_ID", "DTYPE", "DD_UCL_ID", "REF_ASESORIA", "LOTE", "DD_TAS_ID", "ASU_ID_EXTERNO", "DD_PAS_ID", "DD_GES_ID")
  ORGANIZATION HEAP PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
  NOCOMPRESS LOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) 
  BUILD IMMEDIATE
  USING INDEX 
  REFRESH COMPLETE ON DEMAND START WITH sysdate+0 NEXT sysdate+1
  USING DEFAULT LOCAL ROLLBACK SEGMENT
  USING ENFORCED CONSTRAINTS DISABLE QUERY REWRITE
  AS SELECT DISTINCT usd.usu_id,
                usd.des_id, ges.dd_tge_id, usd.usu_id usu_id_original, asu."ASU_ID",asu."GAS_ID",asu."DD_EST_ID",asu."ASU_FECHA_EST_ID",asu."ASU_PROCESS_BPM",asu."ASU_NOMBRE",asu."EXP_ID",asu."VERSION",asu."USUARIOCREAR",asu."FECHACREAR",asu."USUARIOMODIFICAR",asu."FECHAMODIFICAR",asu."USUARIOBORRAR",asu."FECHABORRAR",asu."BORRADO",asu."DD_EAS_ID",asu."ASU_ASU_ID",asu."ASU_OBSERVACION",asu."SUP_ID",asu."SUP_COM_ID",asu."COM_ID",asu."DCO_ID",asu."ASU_FECHA_RECEP_DOC",asu."USD_ID",asu."DTYPE",asu."DD_UCL_ID",asu."REF_ASESORIA",asu."LOTE",asu."DD_TAS_ID",asu."ASU_ID_EXTERNO",asu."DD_PAS_ID",asu."DD_GES_ID"
           FROM asu_asuntos asu
                JOIN
                (SELECT asu_id, usd_id, 4 dd_tge_id
                   FROM asu_asuntos
                  WHERE usd_id IS NOT NULL
                 UNION ALL
                 SELECT asu_id, usd_id, dd_tge_id
                   FROM gaa_gestor_adicional_asunto
                where borrado = 0 ) ges ON asu.asu_id = ges.asu_id
                JOIN usd_usuarios_despachos usd ON ges.usd_id = usd.usd_id';
  DBMS_OUTPUT.PUT_LINE('CREATE MATERIALIZED VIEW '|| V_ESQUEMA ||'.VTAR_ASU_VS_USU...Creada OK');
  
END;
/

EXIT;