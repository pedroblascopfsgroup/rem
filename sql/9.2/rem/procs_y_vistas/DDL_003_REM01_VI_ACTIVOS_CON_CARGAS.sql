--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20181002
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1868
--## PRODUCTO=NO
--## Finalidad: Vista que indica si un activo tiene cargas o no.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 20161006 Versión inicial
--##		0.2 20171212 HREOS-3334 Disclaimer con cargas aparece sin que el activo tenga cargas HREOS-3334
--##        0.3 - Se añaden validaciones nuevas dependiendo del campo "Cargas Propias"
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
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_TEXT_VISTA VARCHAR2(2400 CHAR) := 'VI_ACTIVOS_CON_CARGAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_MSQL VARCHAR2(4000 CHAR); 
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Vista que indica si un activo tiene cargas o no.'; -- Vble. para los comentarios de las tablas
    
    CUENTA NUMBER;
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.'|| V_TEXT_VISTA ||'';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'... borrada OK');
  END IF;

  DBMS_OUTPUT.PUT_LINE('CREATING VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...');
  EXECUTE IMMEDIATE '  CREATE VIEW '||V_ESQUEMA||'.'||V_TEXT_VISTA||' ("ACT_ID", "CON_CARGAS") AS 
  WITH CARGAS AS (
          SELECT
              ACT.ACT_ID,
              NVL2(AUX.ACT_ID,1,0) AS CON_CARGAS,
              ACT.DD_CRA_ID,
              ''CAR'' TAG
          FROM
              '||V_ESQUEMA||'.ACT_ACTIVO ACT
              LEFT JOIN (
                  SELECT
                      CRG.CRG_ID,
                      CRG.ACT_ID
                  FROM
                      '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG
                      INNER JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS BCG ON BCG.BIE_CAR_ID = CRG.BIE_CAR_ID
                      INNER JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA DDSIC ON DDSIC.DD_SIC_ID = BCG.DD_SIC_ID
                                                                       AND DDSIC.DD_SIC_CODIGO IN (
                          ''VIG'',
                          ''NCN'',
                          ''SAN''
                      )
                  WHERE
                      CRG.BORRADO = 0
                  UNION
                  SELECT
                      CRG.CRG_ID,
                      CRG.ACT_ID
                  FROM
                      '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG
                      INNER JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS BCG ON BCG.BIE_CAR_ID = CRG.BIE_CAR_ID
                      INNER JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA DDSIC2 ON DDSIC2.DD_SIC_ID = BCG.DD_SIC_ID2
                                                                        AND DDSIC2.DD_SIC_CODIGO IN (
                          ''VIG'',
                          ''NCN'',
                          ''SAN''
                      )
                  WHERE
                      CRG.BORRADO = 0
              ) AUX ON AUX.ACT_ID = ACT.ACT_ID
          WHERE
              ACT.BORRADO = 0
          GROUP BY
              ACT.ACT_ID,
              AUX.ACT_ID,
              ACT.DD_CRA_ID
          )
      , CARGAS_LBK AS (
          SELECT DISTINCT ACT.ACT_ID, 0 CON_CARGAS, ''CAR_LBK'' TAG
          FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
          JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''08''
          JOIN '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG ON CRG.ACT_ID = ACT.ACT_ID AND CRG.BORRADO = 0 AND CRG.CRG_CARGAS_PROPIAS = 1
          JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS BCG ON BCG.BIE_CAR_ID = CRG.BIE_CAR_ID AND BCG.BORRADO = 0
          JOIN '||V_ESQUEMA||'.DD_STC_SUBTIPO_CARGA STC ON CRG.DD_STC_ID = STC.DD_STC_ID AND STC.DD_STC_CODIGO = ''01''
          JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS BCG ON BCG.BIE_CAR_ID = CRG.BIE_CAR_ID
          JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA DDSIC ON DDSIC.DD_SIC_ID = BCG.DD_SIC_ID
            AND DDSIC.DD_SIC_CODIGO IN (''VIG'', ''NCN'', ''SAN'')
          WHERE ACT.BORRADO = 0 AND NOT EXISTS (
                  SELECT 1
                  FROM '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG1
                  JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS BCG1 ON BCG1.BIE_CAR_ID = CRG1.BIE_CAR_ID AND BCG1.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA DDSIC1 ON DDSIC1.DD_SIC_ID = BCG1.DD_SIC_ID
                    AND DDSIC1.DD_SIC_CODIGO IN (''VIG'', ''NCN'', ''SAN'')
                  WHERE CRG1.ACT_ID = ACT.ACT_ID AND CRG1.BORRADO = 0 AND (CRG1.CRG_CARGAS_PROPIAS = 0 
                  OR CRG1.CRG_CARGAS_PROPIAS IS NULL)
                  )
              AND NOT EXISTS (
                  SELECT 1
                  FROM '||V_ESQUEMA||'.ACT_CRG_CARGAS CRG2
                  JOIN '||V_ESQUEMA||'.DD_STC_SUBTIPO_CARGA STC1 ON CRG2.DD_STC_ID = STC1.DD_STC_ID AND STC1.DD_STC_CODIGO <> ''01''
                  JOIN '||V_ESQUEMA||'.BIE_CAR_CARGAS BCG2 ON BCG2.BIE_CAR_ID = CRG2.BIE_CAR_ID AND BCG2.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_SIC_SITUACION_CARGA DDSIC2 ON DDSIC2.DD_SIC_ID = BCG2.DD_SIC_ID
                    AND DDSIC2.DD_SIC_CODIGO IN (''VIG'', ''NCN'', ''SAN'')
                  WHERE CRG2.ACT_ID = ACT.ACT_ID AND CRG2.BORRADO = 0 AND CRG2.CRG_CARGAS_PROPIAS = 1
                  )
          )
      , Q_FINAL AS (
          SELECT
              CAR.ACT_ID
              , CAR.CON_CARGAS CCC
              , CAR.TAG TC
              , CAR_LBK.CON_CARGAS CCL
              , CAR_LBK.TAG TL
          FROM CARGAS CAR
          LEFT JOIN CARGAS_LBK CAR_LBK ON CAR.ACT_ID = CAR_LBK.ACT_ID
          )
      SELECT ACT_ID, COALESCE(CCL,CCC) CON_CARGAS
      FROM Q_FINAL';      
			
			

  	DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.'|| V_TEXT_VISTA ||'...Creada OK');
	  
END;
/

EXIT;
