--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20220719
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-18229
--## PRODUCTO=NO
--## Finalidad: 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_EAS_08_CONDICIONES (
      PL_OUTPUT       OUT VARCHAR2
)
AS

  V_ESQUEMA VARCHAR2(15 CHAR) := '#ESQUEMA#';
  V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  

  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
        V_SQL := 'TRUNCATE TABLE ' || V_ESQUEMA || '.AUX_APR_CONDICIONES';
   	
   	EXECUTE IMMEDIATE V_SQL;

        V_SQL := 'MERGE INTO ' || V_ESQUEMA || '.AUX_APR_CONDICIONES APR USING(
		     SELECT 9 AS TREGISTRO, 
		     ACT.ACT_NUM_ACTIVO AS ZZEXTERNALID, 
                    ''0001'' AS CONDITION_TYPE,
                    TO_CHAR(val.VAL_FECHA_INICIO,''YYYYMMDD'') AS VALID_FROM,
                    NULL AS VALID_TO,
                    VAL.VAL_IMPORTE AS UNIT_PRICE
		     FROM ' || V_ESQUEMA || '.ACT_AGR_AGRUPACION AGR 
		     JOIN ' || V_ESQUEMA || '.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0
		     JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND ACT.BORRADO = 0 
		     JOIN ' || V_ESQUEMA || '.ACT_VAL_VALORACIONES VAL ON ACT.ACT_ID = VAL.ACT_ID
             JOIN DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.DD_TPC_CODIGO = ''03''
	             WHERE AGR.BORRADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL AND 
		     AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM ' || V_ESQUEMA || '.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''16'') AND AGA.AGA_PRINCIPAL = 0
             UNION ALL
                    SELECT 9 AS TREGISTRO, 
		     ACT.ACT_NUM_ACTIVO AS ZZEXTERNALID, 
                    ''0006'' AS CONDITION_TYPE,
                    TO_CHAR(val.VAL_FECHA_INICIO,''YYYYMMDD'') AS VALID_FROM,
                    NULL AS VALID_TO,
                    VAL.VAL_IMPORTE AS UNIT_PRICE
		     FROM ' || V_ESQUEMA || '.ACT_AGR_AGRUPACION AGR 
		     JOIN ' || V_ESQUEMA || '.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0
		     JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND ACT.BORRADO = 0 
		     JOIN ' || V_ESQUEMA || '.ACT_VAL_VALORACIONES VAL ON ACT.ACT_ID = VAL.ACT_ID
             JOIN ' || V_ESQUEMA || '.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.DD_TPC_CODIGO = ''DAA''
	             WHERE AGR.BORRADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL AND 
		     AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM ' || V_ESQUEMA || '.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''16'') AND AGA.AGA_PRINCIPAL = 0
                          UNION ALL
             SELECT 9 AS TREGISTRO, 
		     ACT.ACT_NUM_ACTIVO AS ZZEXTERNALID, 
                    ''0008'' AS CONDITION_TYPE,
                    TO_CHAR(val.VAL_FECHA_INICIO,''YYYYMMDD'') AS VALID_FROM,
                    NULL AS VALID_TO,
                    VAL.VAL_IMPORTE AS UNIT_PRICE
		     FROM ' || V_ESQUEMA || '.ACT_AGR_AGRUPACION AGR 
		     JOIN ' || V_ESQUEMA || '.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0
		     JOIN ' || V_ESQUEMA || '.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND ACT.BORRADO = 0 
		     JOIN ' || V_ESQUEMA || '.ACT_VAL_VALORACIONES VAL ON ACT.ACT_ID = VAL.ACT_ID
             JOIN ' || V_ESQUEMA || '.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.DD_TPC_CODIGO = ''DPA''
	             WHERE AGR.BORRADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL AND 
		     AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM ' || V_ESQUEMA || '.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''16'') AND AGA.AGA_PRINCIPAL = 0
			) AUX ON (AUX.ZZEXTERNALID = APR.ZZEXTERNALID) 
			WHEN NOT MATCHED THEN INSERT
			(
			APR.TREGISTRO,
			APR.ZZEXTERNALID,
			APR.CONDITION_TYPE,
			APR.VALID_FROM,
			APR.VALID_TO,
			APR.UNIT_PRICE
			) VALUES(
			AUX.TREGISTRO,
			AUX.ZZEXTERNALID,
			AUX.CONDITION_TYPE,
			AUX.VALID_FROM,
			AUX.VALID_TO,
			AUX.UNIT_PRICE)';

        EXECUTE IMMEDIATE V_SQL;

    DBMS_OUTPUT.PUT_LINE('[INFO] FIN UPDATE / INSERT');
    COMMIT;

EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || TO_CHAR (SQLCODE));
      DBMS_OUTPUT.put_line (SQLERRM);
      ROLLBACK;
      RAISE;
END SP_EAS_08_CONDICIONES;
/
EXIT;
