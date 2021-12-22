--/*
--##########################################
--## AUTOR=Juan José Sanjuan
--## FECHA_CREACION=20211215
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16677
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Corrección activos publicados (módulo de publicaciones)
--##		0.3 Contador activos UAs
--##		0.4 Hacer que recoja agrupaciones que no estén registradas en la AGA
--##		0.5 Hacer que diferencia los activos de venta o alquiler y su estado de publicacion
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
	
-- Modificación de la vista V_CALCULO_ACTIVO_AGRUPACION de Fase1.

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_CALCULO_ACTIVO_AGRUPACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_CALCULO_ACTIVO_AGRUPACION...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_CALCULO_ACTIVO_AGRUPACION';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_CALCULO_ACTIVO_AGRUPACION... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_CALCULO_ACTIVO_AGRUPACION' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_CALCULO_ACTIVO_AGRUPACION...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_CALCULO_ACTIVO_AGRUPACION';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_CALCULO_ACTIVO_AGRUPACION... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_CALCULO_ACTIVO_AGRUPACION...');
  EXECUTE IMMEDIATE 'CREATE VIEW '|| V_ESQUEMA ||'.V_CALCULO_ACTIVO_AGRUPACION
      AS
      WITH AUX_NUM_ACTIVOS AS (
          SELECT AGR.AGR_ID, COUNT(AGA.ACT_ID) AS NUM_ACTIVOS
          FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR
          JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0
		  JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
		  WHERE (CASE WHEN TAG.DD_TAG_CODIGO = ''16'' AND AGA.AGA_PRINCIPAL = 1 THEN 0
        			  ELSE 1
   				END) = 1
          GROUP BY AGR.AGR_ID
      ),
      AUX_ACT_PUBLICADOS AS (
          SELECT AGR.AGR_ID, COUNT(ACT.ACT_ID) AS ACT_PUBLICADOS
          FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR
		  JOIN '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
          JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0
          JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON AGA.ACT_ID = ACT.ACT_ID
          JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
          LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID
          LEFT JOIN '|| V_ESQUEMA ||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = APU.DD_EPA_ID
          LEFT JOIN '|| V_ESQUEMA ||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = ACT.DD_TCO_ID
          WHERE ((TCO.DD_TCO_CODIGO IN (''01'',''02'') AND EPV.DD_EPV_CODIGO = ''03'' ) OR (TCO.DD_TCO_CODIGO IN (''02'',''03'') AND EPA.DD_EPA_CODIGO = ''03''))
		  AND (CASE WHEN TAG.DD_TAG_CODIGO = ''16'' AND AGA.AGA_PRINCIPAL = 1 THEN 0
        			ELSE 1
   			   END) = 1
          GROUP BY AGR.AGR_ID
      )
      SELECT DISTINCT AGR.AGR_ID AS AGR_ID, NVL(ANUM.NUM_ACTIVOS, 0) AS NUM_ACTIVOS,
      NVL(APUB.ACT_PUBLICADOS, 0) AS ACT_PUBLICADOS
      FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR
      LEFT JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID
      LEFT JOIN AUX_NUM_ACTIVOS ANUM ON AGR.AGR_ID = ANUM.AGR_ID
      LEFT JOIN AUX_ACT_PUBLICADOS APUB ON AGR.AGR_ID = APUB.AGR_ID';  

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_CALCULO_ACTIVO_AGRUPACION...Creada OK');

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