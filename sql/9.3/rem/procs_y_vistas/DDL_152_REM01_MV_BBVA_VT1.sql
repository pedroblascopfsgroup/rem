--/*
--##########################################
--## AUTOR=Joaquin Arnal
--## FECHA_CREACION=20200901
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10975
--## PRODUCTO=NO
--## Finalidad: Vista para filtrar por los activos BBVA
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
    select
       ACT_BBVA_ACTIVOS.BBVA_CEXPER as CEXPER_MORA
       , ''null'' as SOCIEDAD
       , ACT_ACTIVO.ACT_NUM_ACTIVO as ACT_NUM_ACTIVO
       , BIE_LOCALIZACION.BIE_LOC_COD_POST as CP_PROMOCION
       , ''null'' as DEPURADO_JURID
       , ACT_AJD_ADJJUDICIAL.AJD_FECHA_ADJUDICACION as FECHA_DESP_JURID
       , ACT_AJD_ADJJUDICIAL.AJD_NUM_AUTO as NUM_AUTOS
       , ''null'' as NUM_JUZGADO
       , ACT_CAT_CATASTRO.CAT_REF_CATASTRAL as REF_CATASTRAL
       , ACT_CAT_CATASTRO.CAT_SUPERFICIE_CONSTRUIDA as SUPERFICIE_CONSTRUIDA
       , ''null'' as OFICINA_VENDEDORA
       , ''null'' as SUM_COMISIONES
       , ''null'' as PRECIO_CONTRATO_TOTAL
       , ACT_ACTIVO.ACT_VENTA_EXTERNA_FECHA as FECHA_ESCRITURA
       , ''null'' as TIPO_CONTRATO
       , ''null'' as PORC_PROINDIVISO
       , ''null'' as POLIVALENTE
       , ''null'' as IUC
       , ACT_ACTIVO.DD_SCM_ID as SITUACION_COMERCIAL
    FROM '||V_ESQUEMA||'.ACT_ACTIVO
       JOIN '||V_ESQUEMA||'.ACT_BBVA_ACTIVOS ON ACT_BBVA_ACTIVOS.ACT_ID = ACT_ACTIVO.ACT_ID
       JOIN '||V_ESQUEMA||'.ACT_CAT_CATASTRO ON ACT_CAT_CATASTRO.ACT_ID = ACT_ACTIVO.ACT_ID
       JOIN '||V_ESQUEMA||'.ACT_AJD_ADJJUDICIAL ON ACT_AJD_ADJJUDICIAL.ACT_ID = ACT_ACTIVO.ACT_ID
       JOIN '||V_ESQUEMA||'.BIE_BIEN ON BIE_BIEN.BIE_ID = ACT_ACTIVO.BIE_ID
       JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION ON BIE_LOCALIZACION.BIE_ID = BIE_BIEN.BIE_ID
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
