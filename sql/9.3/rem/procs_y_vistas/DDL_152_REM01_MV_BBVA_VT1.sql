--/*
--##########################################
--## AUTOR=Joaquin Arnal
--## FECHA_CREACION=20210805
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10975
--## PRODUCTO=NO
--## Finalidad: Vista para filtrar por los activos BBVA
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 REMVIP-8960 - VRO - se pone LEFT en dd_eca_estado_carga_activos y se mete tabla BIE_DATOS_REGISTRALES en vista vi_nor_bbva_vt1
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

    V_REFRESCO VARCHAR2(1024 CHAR); -- Variable 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'MV_BBVA_VT1' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.MV_BBVA_VT1...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.MV_BBVA_VT1';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.MV_BBVA_VT1... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'MV_BBVA_VT1' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.MV_BBVA_VT1...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.MV_BBVA_VT1';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.MV_BBVA_VT1... borrada OK');
  END IF;

  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.MV_BBVA_VT1...');
  EXECUTE IMMEDIATE 'CREATE MATERIALIZED VIEW ' || V_ESQUEMA || '.MV_BBVA_VT1 
    REFRESH ON DEMAND
	AS
        SELECT
    act_id,
    cexper_mora,
    sociedad,
    numero_activo_sap,
    subnumero_activo_sap,
    num_interno,
    clase,
    tipo_inmueble,
    calle_inmueble,
    numero_inmueble,
    calle_inmueble_2,
    numero_inmueble_2,
    localidad,
    provincia,
    codigo_postal,
    pais,
    dep_juridicamente,
    fecha_dep_juridica,
    num_autos,
    calle_juzgado,
    numero_juzgado,
    num_finca_registral,
    catastro,
    referencia_catastral,
    superficie,
    oficina_vendedora,
    comision_externa,
    precio_venta,
    nombre_cliente,
    apellido_1,
    apellido_2,
    tipo_identificador,
    nif_comprador,
    calle_comprador,
    numero_comprador,
    cp_comprador,
    localidad_comprador,
    provincia_comprador,
    pais_comprador,
    fecha_venta,
    tipo_contrato, RESTO_FINCAS,
    proindiviso,
    polivalente,
    cod_empresa_titulizadora,
    nif_empresa_titulizadora,
    iuc,
    idufir,
    rest_idufir,
    procedencia_leasing,
    sit_comercial,
    precio_tarifa, FECHA_INICIO_TARIFA,
    promocion,
    obra
FROM
    vi_nor_bbva_vt1
    ';
		

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.MV_BBVA_VT1...Creada OK');
  
  EXCEPTION
     
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
