--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20160824
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_TRABAJOS' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_TRABAJOS 

	AS
		SELECT
			TBJ.TBJ_ID,
			TBJ.ACT_ID AS IDACTIVO,
			TBJ.TBJ_NUM_TRABAJO,
			TBJ.TBJ_WEBCOM_ID,
			NVL2(ACT.ACT_NUM_ACTIVO, ACT.ACT_NUM_ACTIVO, AGR.AGR_NUM_AGRUP_REM) AS NUM_ACTIVO_AGRUPACION,
			NVL2(ACT.ACT_NUM_ACTIVO, ''activo'', ''agrupaciones'') AS TIPO_ENTIDAD, 
			TTR.DD_TTR_CODIGO,
			TTR.DD_TTR_DESCRIPCION,
			STR.DD_STR_CODIGO,
			STR.DD_STR_DESCRIPCION, 
			TBJ.TBJ_FECHA_SOLICITUD, 
			EST.DD_EST_CODIGO, 
			EST.DD_EST_DESCRIPCION, 
			PVE.PVE_NOMBRE AS PROVEEDOR, 
			INITCAP(SOLIC.USU_NOMBRE) || NVL2(SOLIC.USU_APELLIDO1, '' '' || INITCAP(SOLIC.USU_APELLIDO1), '''') || NVL2(SOLIC.USU_APELLIDO2, '' '' || INITCAP(SOLIC.USU_APELLIDO2), '''') AS SOLICITANTE ,
			DDLOC.DD_LOC_DESCRIPCION AS POBLACION,
			DDPRV.DD_PRV_CODIGO,
			DDPRV.DD_PRV_DESCRIPCION AS PROVINCIA,
			BIELOC.BIE_LOC_COD_POST AS CODPOSTAL,
  			ACT.ACT_NUM_ACTIVO AS NUMACTIVO,
			AGR.AGR_NUM_AGRUP_REM AS NUMAGRUPACION,
			CRA.DD_CRA_CODIGO AS CARTERA,
			USU.USU_USERNAME AS GESTOR_ACTIVO,
			ACTTBJ.ACTIVOS

		FROM ' || V_ESQUEMA || '.ACT_TBJ_TRABAJO TBJ
		LEFT JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACT.ACT_ID = TBJ.ACT_ID 
		LEFT JOIN ' || V_ESQUEMA || '.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = TBJ.AGR_ID
	 	LEFT JOIN ' || V_ESQUEMA || '.GAC_GESTOR_ADD_ACTIVO GAC ON GAC.ACT_ID = TBJ.ACT_ID
		LEFT JOIN ' || V_ESQUEMA || '.GEE_GESTOR_ENTIDAD GEE ON GAC.GEE_ID = GEE.GEE_ID
		JOIN  ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR TGE ON TGE.DD_TGE_ID = GEE.DD_TGE_ID AND GEE.DD_TGE_ID = (SELECT DD_TGE_ID FROM  ' || V_ESQUEMA_MASTER || '.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GACT'')
		LEFT JOIN ' || V_ESQUEMA_MASTER || '.USU_USUARIOS USU ON GEE.USU_ID = USU.USU_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_LOC_LOCALIZACION LOC ON (LOC.ACT_ID = NVL(TBJ.ACT_ID,AGR.AGR_ACT_PRINCIPAL)) 
		LEFT JOIN ' || V_ESQUEMA || '.BIE_LOCALIZACION BIELOC ON LOC.BIE_LOC_ID = BIELOC.BIE_LOC_ID
		LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_LOC_LOCALIDAD DDLOC ON  BIELOC.DD_LOC_ID = DDLOC.DD_LOC_ID 
    	LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_PRV_PROVINCIA DDPRV ON BIELOC.DD_PRV_ID = DDPRV.DD_PRV_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_TTR_TIPO_TRABAJO TTR ON TTR.DD_TTR_ID = TBJ.DD_TTR_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_STR_SUBTIPO_TRABAJO STR ON STR.DD_STR_ID = TBJ.DD_STR_ID
		LEFT JOIN ' || V_ESQUEMA || '.DD_EST_ESTADO_TRABAJO EST ON TBJ.DD_EST_ID = EST.DD_EST_ID
		INNER JOIN ' || V_ESQUEMA || '.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_PVC_PROVEEDOR_CONTACTO PVC ON PVC.PVC_ID = TBJ.PVC_ID
		LEFT JOIN ' || V_ESQUEMA || '.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_ID = PVC.PVE_ID
		LEFT JOIN ' || V_ESQUEMA_MASTER || '.USU_USUARIOS SOLIC ON SOLIC.USU_ID = TBJ.USU_ID
    	LEFT JOIN (SELECT ATJ.TBJ_ID, LISTAGG(''''''''||ACT.ACT_NUM_ACTIVO||'''''''','','') WITHIN GROUP (ORDER BY TBJ_ID) AS ACTIVOS FROM REM01.ACT_TBJ ATJ JOIN ACT_ACTIVO ACT ON ACT.ACT_ID = ATJ.ACT_ID GROUP BY ATJ.TBJ_ID) ACTTBJ ON ACTTBJ.TBJ_ID = TBJ.TBJ_ID';


  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_TRABAJOS...Creada OK');
  
END;
/

EXIT;