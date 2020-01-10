--/*
--##########################################
--## AUTOR=Mª José Ponce
--## FECHA_CREACION=20200110
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-8911
--## PRODUCTO=NO
--## Finalidad: vista para devolver la primera y última fecha en canal minorista y mayorista para activos.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
-- 0.1
DECLARE
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    ERR_NUM NUMBER; -- N?mero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas
    V_MSQL VARCHAR2(4000 CHAR); 

    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_FECHAS_PUB_CANALES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_FECHAS_PUB_CANALES...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_FECHAS_PUB_CANALES';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_FECHAS_PUB_CANALES... borrada OK'); 
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_FECHAS_PUB_CANALES' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_FECHAS_PUB_CANALES...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_FECHAS_PUB_CANALES';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_FECHAS_PUB_CANALES... borrada OK');
  END IF;  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_FECHAS_PUB_CANALES...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_FECHAS_PUB_CANALES 
  AS
    SELECT DISTINCT
    AHP.ACT_ID,
    (SELECT MIN(HIST.AHP_FECHA_INI_VENTA) FROM '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION HIST 
    LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EST ON EST.DD_EPV_ID=HIST.DD_EPV_ID 
    WHERE HIST.ACT_ID=AHP.ACT_ID AND EST.DD_EPV_CODIGO IN (''03'',''04'') AND HIST.BORRADO=0 AND HIST.DD_POR_ID=(SELECT DD_POR_ID FROM '|| V_ESQUEMA ||'.DD_POR_PORTAL WHERE DD_POR_CODIGO IN (''01'') )) FECHA_PRIMERA_PUBLICACION_MIN,
    (SELECT MAX(HIST.AHP_FECHA_INI_VENTA) FROM '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION HIST 
    LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EST ON EST.DD_EPV_ID=HIST.DD_EPV_ID 
    WHERE HIST.ACT_ID=AHP.ACT_ID AND EST.DD_EPV_CODIGO IN (''03'',''04'') AND HIST.BORRADO=0 AND HIST.DD_POR_ID=(SELECT DD_POR_ID FROM '|| V_ESQUEMA ||'.DD_POR_PORTAL WHERE DD_POR_CODIGO IN (''01'') )) FECHA_ULTIMA_PUBLICACION_MIN,
    (SELECT MIN(HIST.AHP_FECHA_INI_VENTA) FROM '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION HIST 
    LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EST ON EST.DD_EPV_ID=HIST.DD_EPV_ID 
    WHERE HIST.ACT_ID=AHP.ACT_ID AND EST.DD_EPV_CODIGO IN (''03'',''04'') AND HIST.BORRADO=0 AND HIST.DD_POR_ID=(SELECT DD_POR_ID FROM '|| V_ESQUEMA ||'.DD_POR_PORTAL WHERE DD_POR_CODIGO IN (''02'') )) FECHA_PRIMERA_PUBLICACION_MAY,
    (SELECT MAX(HIST.AHP_FECHA_INI_VENTA) FROM '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION HIST 
    LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EST ON EST.DD_EPV_ID=HIST.DD_EPV_ID 
    WHERE HIST.ACT_ID=AHP.ACT_ID AND EST.DD_EPV_CODIGO IN (''03'',''04'') AND HIST.BORRADO=0 AND HIST.DD_POR_ID=(SELECT DD_POR_ID FROM '|| V_ESQUEMA ||'.DD_POR_PORTAL WHERE DD_POR_CODIGO IN (''02'') )) FECHA_ULTIMA_PUBLICACION_MAY               
    FROM '|| V_ESQUEMA ||'.ACT_AHP_HIST_PUBLICACION AHP    
    LEFT JOIN '|| V_ESQUEMA ||'.DD_EPV_ESTADO_PUB_VENTA EPV ON EPV.DD_EPV_ID=AHP.DD_EPV_ID
    WHERE EPV.DD_EPV_CODIGO IN (''03'', ''04'') 
    AND AHP.DD_POR_ID IS NOT NULL 
    AND AHP.AHP_FECHA_INI_VENTA IS NOT NULL 
    AND AHP.BORRADO=0';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_FECHAS_PUB_CANALES...Creada OK');
  
  EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        ERR_NUM := SQLCODE;
        ERR_MSG := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(ERR_MSG);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
