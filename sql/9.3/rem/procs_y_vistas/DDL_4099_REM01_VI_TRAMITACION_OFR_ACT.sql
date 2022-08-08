--/*
--##########################################
--## AUTOR=Julian Dolz Moncho
--## FECHA_CREACION=20190805
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7185
--## PRODUCTO=NO
--## Finalidad: Vista que indica si el activo ha superado los 7 dias de margen para la publicación de oferas.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 20190805 Versión inicial
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
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_TINDEX VARCHAR2(500 CHAR) := 'VI_OFR_ACT_IDX1';
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_TRAMITACION_OFR_ACT'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Vista que indica si el activo ha superado los 7 dias de margen para la publicación de oferas.'; -- Vble. para los comentarios de las tablas
    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
  V_MSQL:= '  CREATE VIEW '||V_ESQUEMA||'.'||V_TEXT_VISTA||' AS 
    SELECT DISTINCT APU.ACT_ID, APU.APU_FECHA_CAMB_PUBL_VENTA 
    FROM '|| V_ESQUEMA ||'.ACT_APU_ACTIVO_PUBLICACION APU
    JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON APU.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
    JOIN '|| V_ESQUEMA ||'.ACT_OFR ACT_OFR ON ACT_OFR.ACT_ID = ACT.ACT_ID
    JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID AND OFR.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID = APU.DD_EPV_ID AND EPV.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.ACT_ATR_AUTO_TRAM_OFERTAS ATR ON ATR.ACT_ID = ACT.ACT_ID AND ATR.BORRADO = 0
    LEFT JOIN '|| V_ESQUEMA ||'.CON_CONCURRENCIA CON ON CON.ACT_ID = ACT.ACT_ID
    WHERE EOF.DD_EOF_CODIGO IN (''03'',''04'')
    AND APU.ACT_ID NOT IN (
        SELECT ACT_OFR.ACT_ID 
        FROM '|| V_ESQUEMA ||'.ACT_OFR
        JOIN '|| V_ESQUEMA ||'.OFR_OFERTAS OFR ON OFR.OFR_ID = ACT_OFR.OFR_ID AND OFR.BORRADO = 0
        LEFT JOIN '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0
        WHERE EOF.DD_EOF_CODIGO = ''01'')
    AND CRA.DD_CRA_CODIGO = ''03''
    AND EPV.DD_EPV_CODIGO = ''03''
    AND (CON.CON_ID IS NULL OR (CON.CON_ID IS NOT NULL AND NOT EXISTS (
    	SELECT (1) 
    	FROM '|| V_ESQUEMA ||'.CON_CONCURRENCIA CON2
    	JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_ID = CON2.ACT_ID
    WHERE TRUNC(SYSDATE) BETWEEN TRUNC(CON.CON_FECHA_INI) AND TRUNC(CON.CON_FECHA_FIN) AND CON2.CON_ID = CON.CON_ID AND ACT2.ACT_ID = ACT.ACT_ID)))
    AND TRUNC(SYSDATE) - TRUNC(APU.APU_FECHA_CAMB_PUBL_VENTA) <= 7
    AND (ATR.FECHA_INI_BLOQUEO IS NULL OR TRUNC(ATR.FECHA_INI_BLOQUEO) < TRUNC(APU.APU_FECHA_CAMB_PUBL_VENTA))';

    EXECUTE IMMEDIATE V_MSQL;
  	DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
  
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
