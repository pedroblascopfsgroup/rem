  --/*
--##########################################
--## AUTOR=DANIEL GUTIERREZ
--## FECHA_CREACION=20160725
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_ACTIVOS_TRABAJO' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_TRABAJO...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS_TRABAJO';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_TRABAJO... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_BUSQUEDA_ACTIVOS_TRABAJO' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_TRABAJO...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS_TRABAJO';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_TRABAJO... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_TRABAJO...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_BUSQUEDA_ACTIVOS_TRABAJO 
		
	AS	
		SELECT
			ROWNUM as VAT_ID,
			TBJ.TBJ_ID,
			EST.DD_EST_CODIGO,
			EST.DD_EST_DESCRIPCION,
			EST.DD_EST_ESTADO_CONTABLE,
		  	ACT.ACT_ID,
      		NVL(INICIAL,0) INICIAL,
      		NVL(INCREMENTOS,0) INCREMENTOS,
      		NVL(IMPORTES_TRABAJOS,0) IMPORTES_TRABAJOS,
	  		NVL(TBJ.TBJ_IMPORTE_TOTAL * ACTTBJ.ACT_TBJ_PARTICIPACION / 100 ,0) IMPORTE_PARTICIPA,
      		INICIAL + INCREMENTOS - NVL(IMPORTES_TRABAJOS,0) SALDO_DISPONIBLE,
			ACTTBJ.ACT_TBJ_PARTICIPACION AS PORCENTAJE_PARTICIPACION,
      		CASE	WHEN (INICIAL + INCREMENTOS - NVL(IMPORTES_TRABAJOS,0)) < 0 THEN NVL(TBJ.TBJ_IMPORTE_TOTAL * ACTTBJ.ACT_TBJ_PARTICIPACION / 100 ,0)
              		WHEN (INICIAL + INCREMENTOS - NVL(IMPORTES_TRABAJOS,0)) > 0 AND (NVL(TBJ.TBJ_IMPORTE_TOTAL * ACTTBJ.ACT_TBJ_PARTICIPACION / 100 ,0)) > (INICIAL + INCREMENTOS - NVL(IMPORTES_TRABAJOS,0)) THEN (NVL(TBJ.TBJ_IMPORTE_TOTAL * ACTTBJ.ACT_TBJ_PARTICIPACION / 100 ,0)) - (INICIAL + INCREMENTOS - NVL(IMPORTES_TRABAJOS,0)) 
            		ELSE 0
      		END AS SALDO_NECESARIO,
			ACT.ACT_NUM_ACTIVO,
		  	ACT.ACT_NUM_ACTIVO_REM,
      		BIE_LOC.BIE_LOC_NOMBRE_VIA,
	   	 	STA.DD_SAC_DESCRIPCION AS SUBTIPO_ACTIVO_DESCRIPCION,
	    	CRA.DD_CRA_DESCRIPCION AS ENTIDAD_PROPIETARIA_DESC,
	    	LOC.DD_LOC_DESCRIPCION AS LOCALIDAD_DESCRIPCION,
	    	PRV.DD_PRV_DESCRIPCION AS PROVINCIA_DESCRIPCION,
	    	TPA.DD_TPA_DESCRIPCION AS TIPO_ACTIVO_DESCRIPCION,
	  SPS.SPS_OCUPADO,
	  SPS.SPS_CON_TITULO,
			DD_SCM_DESCRIPCION AS SITUACION_COMERCIAL,
      EJE.EJE_ANYO,
      PTO.PTO_ID
	    FROM ' || V_ESQUEMA || '.ACT_TBJ ACTTBJ
      	INNER JOIN ' || V_ESQUEMA || '.ACT_TBJ_TRABAJO TBJ ON ACTTBJ.TBJ_ID = TBJ.TBJ_ID AND TBJ.BORRADO = 0 
      	INNER JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACTTBJ.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0
      	LEFT JOIN ' || V_ESQUEMA || '.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID
      	INNER JOIN ' || V_ESQUEMA || '.BIE_BIEN BIE ON ACT.BIE_ID = BIE.BIE_ID
      	LEFT JOIN ' || V_ESQUEMA || '.BIE_LOCALIZACION BIE_LOC ON ACT.BIE_ID = BIE_LOC.BIE_ID
      	LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_ID = BIE_LOC.DD_LOC_ID
      	LEFT JOIN ' || V_ESQUEMA || '.DD_SAC_SUBTIPO_ACTIVO STA ON STA.DD_SAC_ID = ACT.DD_SAC_ID
      	LEFT JOIN ' || V_ESQUEMA || '.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
      	LEFT JOIN ' || V_ESQUEMA_MASTER || '.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_ID = LOC.DD_PRV_ID
      	LEFT JOIN ' || V_ESQUEMA || '.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = STA.DD_TPA_ID
        LEFT JOIN ' || V_ESQUEMA || '.DD_SCM_SITUACION_COMERCIAL SCM ON SCM.DD_SCM_ID = ACT.DD_SCM_ID
      	LEFT JOIN ' || V_ESQUEMA || '.DD_EST_ESTADO_TRABAJO EST ON EST.DD_EST_ID = TBJ.DD_EST_ID
        LEFT JOIN ' || V_ESQUEMA || '.ACT_PTO_PRESUPUESTO PTO ON PTO.ACT_ID =  ACT.ACT_ID
        LEFT JOIN ' || V_ESQUEMA || '.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = PTO.EJE_ID AND EJE.BORRADO = 0
              	LEFT JOIN (
        	SELECT PTO.ACT_ID ACT1, SUM(NVL(INC.INP_IMPORTE_INCREMENTO,0)) INCREMENTOS, PTO.PTO_IMPORTE_INICIAL INICIAL, EJE_ANYO ANYO
      		FROM ' || V_ESQUEMA || '.ACT_PTO_PRESUPUESTO PTO 
        	LEFT JOIN ' || V_ESQUEMA || '.ACT_INP_INC_PRESUPUESTO INC ON PTO.PTO_ID = INC.PTO_ID AND INC.BORRADO = 0
        	INNER JOIN ' || V_ESQUEMA || '.ACT_EJE_EJERCICIO EJE ON EJE.EJE_ID = PTO.EJE_ID AND EJE.BORRADO = 0
        	WHERE PTO.BORRADO = 0
        	GROUP BY PTO.ACT_ID, PTO.PTO_IMPORTE_INICIAL, EJE_ANYO
      	) ON ACT.ACT_ID = ACT1 AND ANYO = EJE.EJE_ANYO
      	LEFT JOIN (
        	SELECT ACTTBJ.ACT_ID ACT2, SUM(NVL(TBJ.TBJ_IMPORTE_TOTAL * ACTTBJ.ACT_TBJ_PARTICIPACION / 100 ,0)) IMPORTES_TRABAJOS, TO_CHAR(TBJ.TBJ_FECHA_SOLICITUD,''YYYY'') ANYO2
        	FROM ACT_TBJ ACTTBJ
        	INNER JOIN ACT_TBJ_TRABAJO TBJ ON ACTTBJ.TBJ_ID = TBJ.TBJ_ID AND TBJ.BORRADO = 0 AND TBJ.DD_EST_ID IN(SELECT DD_EST_ID FROM ' || V_ESQUEMA || '.DD_EST_ESTADO_TRABAJO WHERE DD_EST_ESTADO_CONTABLE = 1)
        	INNER JOIN DD_EST_ESTADO_TRABAJO EST ON TBJ.DD_EST_ID = EST.DD_EST_ID
        	INNER JOIN ACT_ACTIVO ACT ON ACTTBJ.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0
        	GROUP BY ACTTBJ.ACT_ID, TO_CHAR(TBJ.TBJ_FECHA_SOLICITUD,''YYYY'')  
      	) ON ACT.ACT_ID = ACT2 AND ANYO2 = EJE.EJE_ANYO';
        --WHERE TO_CHAR(TBJ.TBJ_FECHA_SOLICITUD,''YYYY'') = EJE.EJE_ANYO';
      	
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_BUSQUEDA_ACTIVOS_TRABAJO...Creada OK');
  
END;
/

EXIT;