--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210317
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-13501
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
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN
	
-- Modificación de la vista V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES de Fase1.

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES...');
  EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES
      AS
	WITH CAMBIO_ACTIVO AS (
		SELECT 
		AGA.AGR_ID
		, 1 ESTADO
		FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA 
		JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
		JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
		JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID AND SPS.BORRADO = 0
		WHERE CRA.DD_CRA_CODIGO = ''03''
		AND (SPS.SPS_FECHA_ULT_CAMBIO_TIT IS NOT NULL AND TRUNC(SPS.SPS_FECHA_ULT_CAMBIO_TIT) >= TRUNC(SYSDATE-7)
		OR SPS.SPS_FECHA_ULT_CAMBIO_POS IS NOT NULL AND TRUNC(SPS.SPS_FECHA_ULT_CAMBIO_POS) >= TRUNC(SYSDATE-7)
		OR SPS.SPS_FECHA_ULT_CAMBIO_TAPIADO IS NOT NULL AND TRUNC(SPS.SPS_FECHA_ULT_CAMBIO_TAPIADO) >= TRUNC(SYSDATE-7)
		OR ACT.ACT_FECHA_CAMBIO_TIPO_ACT IS NOT NULL AND TRUNC(ACT.ACT_FECHA_CAMBIO_TIPO_ACT) >= TRUNC(SYSDATE-7))
		GROUP BY AGA.AGR_ID
	),
	CAMBIO_PRECIO AS (
		SELECT  
		AGA.AGR_ID
		, 1 ESTADO
		FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA 
		JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
		JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
		JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID AND APU.BORRADO = 0
		WHERE CRA.DD_CRA_CODIGO = ''03''
		AND (APU.APU_FECHA_CAMB_PREC_VENTA IS NOT NULL AND TRUNC(APU.APU_FECHA_CAMB_PREC_VENTA) >= TRUNC(SYSDATE-7)
		OR APU.APU_FECHA_CAMB_PREC_ALQ IS NOT NULL AND TRUNC(APU.APU_FECHA_CAMB_PREC_ALQ) >= TRUNC(SYSDATE-7))
		GROUP BY AGA.AGR_ID
	),
	CAMBIO_PUBLICACION AS (
		SELECT  
		AGA.AGR_ID
		, 1 ESTADO
		FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA 
		JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
		JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
		JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID AND APU.BORRADO = 0
		WHERE CRA.DD_CRA_CODIGO = ''03''
		AND (APU.APU_FECHA_CAMB_PUBL_VENTA IS NOT NULL AND TRUNC(APU.APU_FECHA_CAMB_PUBL_VENTA) >= TRUNC(SYSDATE-7)
		OR APU.APU_FECHA_CAMB_PUBL_ALQ IS NOT NULL AND TRUNC(APU.APU_FECHA_CAMB_PUBL_ALQ) >= TRUNC(SYSDATE-7))
		GROUP BY AGA.AGR_ID
	)
	SELECT 
	AGR.AGR_ID
	, CASE WHEN ACT.AGR_ID IS NOT NULL THEN 1 ELSE 0 END CAMBIO_ESTADO_ACTIVO
	, CASE WHEN PRE.AGR_ID IS NOT NULL THEN 1 ELSE 0 END CAMBIO_ESTADO_PRECIO
	, CASE WHEN PUB.AGR_ID IS NOT NULL THEN 1 ELSE 0 END CAMBIO_ESTADO_PUBLICACION
	FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR 
	LEFT JOIN CAMBIO_ACTIVO ACT ON AGR.AGR_ID = ACT.AGR_ID AND ACT.ESTADO = 1
	LEFT JOIN CAMBIO_PRECIO PRE ON AGR.AGR_ID = PRE.AGR_ID AND PRE.ESTADO = 1
	LEFT JOIN CAMBIO_PUBLICACION PUB ON AGR.AGR_ID = PUB.AGR_ID AND PUB.ESTADO = 1
	WHERE AGR.BORRADO = 0';  

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_CAMBIO_ACT_PRE_PUB_AGRUPACIONES...Creada OK');

  COMMIT;
  
EXCEPTION
	WHEN OTHERS THEN
      err_num := SQLCODE;
      err_msg := SQLERRM;

      DBMS_OUTPUT.PUT_LINE('KO no modificada');
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
      DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
      DBMS_OUTPUT.put_line(err_msg);

      ROLLBACK;
      RAISE;          

END;
/

EXIT;
