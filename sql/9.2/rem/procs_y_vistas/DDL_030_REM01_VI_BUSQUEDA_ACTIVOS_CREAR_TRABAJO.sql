  --/*
--##########################################
--## AUTOR=JORGE ROS
--## FECHA_CREACION=20161020
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1026
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_ACTIVOS_CREAR_TBJ' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_CREAR_TBJ...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS_CREAR_TBJ';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_CREAR_TBJ... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_ACTIVOS_CREAR_TBJ' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_CREAR_TBJ...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS_CREAR_TBJ';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_CREAR_TBJ... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_CREAR_TBJ...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS_CREAR_TBJ 
		
	AS	
		SELECT
			ACT_ID,
			ACT.ACT_NUM_ACTIVO,
		  	ACT.ACT_NUM_ACTIVO_REM,
			CRA.DD_CRA_DESCRIPCION AS CARTERA,
			TPA.DD_TPA_DESCRIPCION AS TIPO_ACTIVO,
			STA.DD_SAC_DESCRIPCION AS SUBTIPO_ACTIVO,
			SCM.DD_SCM_DESCRIPCION AS SITUACION_COMERCIAL,
			BDR.BIE_DREG_NUM_FINCA AS NUM_FINCA_REGISTRAL
			
	    FROM ' || V_ESQUEMA || '.ACT_ACTIVO ACT
      	LEFT JOIN ' || V_ESQUEMA || '.DD_SAC_SUBTIPO_ACTIVO STA ON STA.DD_SAC_ID = ACT.DD_SAC_ID
      	LEFT JOIN ' || V_ESQUEMA || '.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
      	LEFT JOIN ' || V_ESQUEMA || '.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = STA.DD_TPA_ID
        LEFT JOIN ' || V_ESQUEMA || '.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_REG_INFO_REGISTRAL ARIR ON ACT.ACT_ID = ARIR.ACT_ID
		LEFT JOIN ' || V_ESQUEMA || '.BIE_DATOS_REGISTRALES BDR ON ARIR.BIE_DREG_ID = BDR.BIE_DREG_ID
';

      	
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_CREAR_TBJ...Creada OK');
  
END;
/

EXIT;