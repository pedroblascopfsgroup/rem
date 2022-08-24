--/*
--##########################################
--## AUTOR=Pier Gotta
--## FECHA_CREACION=20220824
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-18494
--## PRODUCTO=NO
--## Finalidad: Vista que indica si la agrupación tiene activos que ha superado los 7 dias de margen para la publicación de oferas.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 20190806 Versión inicial
--##        0.2 20190826 Modificación para agregar la relacion con ACT_ATR_AUTO_TRAM_OFERTAS
--##	    0.3 HREOS-18494 Pier Gotta Añadir concurrencia
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF; 

DECLARE
  V_MSQL VARCHAR2(4000 CHAR); 
  TABLE_COUNT NUMBER(1,0) := 0;  -- Vble. para validar la existencia de las Tablas.
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
  V_COLUMN_COUNT number(3); -- Vble. para validar la existencia de las Columnas.    
  V_COSTRAINT_COUNT number(3); -- Vble. para validar la existencia de las Constraints.
  ERR_NUM NUMBER; -- Numero de errores
  ERR_MSG VARCHAR2(2048); -- Mensaje de error
  V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_TRAMITACION_OFR_AGR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Vista que indica si la agrupación tiene activos que ha superado los 7 dias de margen para la publicación de oferas.'; -- Vble. para los comentarios de las tablas
    
BEGIN
  DBMS_OUTPUT.PUT_LINE('[INICIO] ');
  SELECT COUNT(*) INTO TABLE_COUNT FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER = V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF TABLE_COUNT > 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] BORRANDO VISTA  '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA);
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('[INFO] VISTA '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' BORRADA');
  END IF;

  DBMS_OUTPUT.PUT_LINE('[INFO] CREANDO VISTA '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA);
  V_MSQL:= 'CREATE VIEW '||V_ESQUEMA||'.'||V_TEXT_VISTA||' AS 
    SELECT 
      AGA.AGR_ID, 
      MAX (APU.APU_FECHA_CAMB_PUBL_VENTA) APU_FECHA_CAMB_PUBL_VENTA
    FROM '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA
    JOIN '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = AGA.ACT_ID AND APU.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON AGA.AGR_ID = OFR.AGR_ID AND OFR.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID
    JOIN '|| V_ESQUEMA ||'.VI_TRAMITACION_OFR_ACT VI_TRAM ON VI_TRAM.ACT_ID=AGA.ACT_ID
    LEFT JOIN '|| V_ESQUEMA ||'.ACT_ATR_AUTO_TRAM_OFERTAS ATR ON ATR.AGR_ID = AGA.AGR_ID AND ATR.BORRADO = 0
    WHERE AGA.BORRADO = 0
    AND EOF.DD_EOF_CODIGO IN (''03'', ''04'')
    AND AGA.AGR_ID NOT IN (
      SELECT AGR.AGR_ID
      FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR
      JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON AGR.AGR_ID = OFR.AGR_ID AND OFR.BORRADO = 0
      JOIN '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID
      WHERE EOF.DD_EOF_CODIGO = ''01''
    )
    AND NOT EXISTS (SELECT (1) FROM '|| V_ESQUEMA ||'.OFR_OFERTAS OFR2
    JOIN '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR2.DD_EOF_ID
    WHERE EOF.DD_EOF_CODIGO IN (''04'', ''09'', ''07'', ''05'', ''08'') AND OFR2.OFR_CONCURRENCIA = 1 AND OFR2.OFR_ID = OFR.OFR_ID)
    AND (ATR.FECHA_INI_BLOQUEO IS NULL OR TRUNC(ATR.FECHA_INI_BLOQUEO) < TRUNC(APU.APU_FECHA_CAMB_PUBL_VENTA))
    GROUP BY AGA.AGR_ID';

  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[FIN] VISTA '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||' CREADA');
  
EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------');
    DBMS_OUTPUT.put_line(SQLERRM);
    DBMS_OUTPUT.put_line(V_MSQL);
    ROLLBACK;
    RAISE;        
	  
END;
/

EXIT;
