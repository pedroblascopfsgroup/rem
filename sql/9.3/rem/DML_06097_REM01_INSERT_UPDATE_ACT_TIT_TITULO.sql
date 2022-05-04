--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220504
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17788
--## PRODUCTO=NO
--##
--## Finalidad: Insertar y/o actualizar en la tabla ACT_TIT_TITULO
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_TIT_TITULO';
    V_USUARIO VARCHAR2(30 CHAR) := 'HREOS-17788';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

  V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO T1
                USING (
                  SELECT ACT_ID
                  , TIT_FECHA_PRESENT_REG
                  , TIT_FECHA_INSC_REG
                  , AHT_FECHA_PRES_REGISTRO
                  , AHT_FECHA_INSCRIPCION
                  , AHT_ID
                  FROM (SELECT 
                  ACT.ACT_ID
                  , COALESCE(TIT.TIT_FECHA_PRESENT2_REG, TIT.TIT_FECHA_PRESENT1_REG) TIT_FECHA_PRESENT_REG
                  , TIT.TIT_FECHA_INSC_REG
                  , ESP.DD_ESP_CODIGO
                  , AHT.AHT_FECHA_PRES_REGISTRO
                  , AHT.AHT_FECHA_INSCRIPCION
                  , ROW_NUMBER() OVER (PARTITION BY AHT.TIT_ID ORDER BY AHT.AHT_ID DESC) RN
                  , AHT.AHT_ID
                  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                  JOIN '||V_ESQUEMA||'.'||V_TABLA||' TIT ON ACT.ACT_ID = TIT.ACT_ID AND TIT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO ETI ON TIT.DD_ETI_ID = ETI.DD_ETI_ID AND ETI.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO AHT ON AHT.TIT_ID = TIT.TIT_ID AND AHT.BORRADO = 0
                  LEFT JOIN '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION ESP ON AHT.DD_ESP_ID = ESP.DD_ESP_ID AND ESP.BORRADO = 0
                  WHERE CRA.DD_CRA_CODIGO = ''03''
                  AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                  AND ETI.DD_ETI_CODIGO = ''02''
                  AND TIT.TIT_FECHA_INSC_REG IS NULL) 
                  WHERE RN = 1
                  AND DD_ESP_CODIGO = ''03''
                  AND (AHT_FECHA_PRES_REGISTRO IS NULL OR AHT_FECHA_INSCRIPCION IS NULL)
                ) T2 
                ON (T1.AHT_ID = T2.AHT_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.AHT_FECHA_PRES_REGISTRO = T2.TIT_FECHA_PRESENT_REG,
                    T1.AHT_FECHA_INSCRIPCION = T2.TIT_FECHA_INSC_REG,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                    T1.FECHAMODIFICAR = SYSDATE';   
  EXECUTE IMMEDIATE V_MSQL;

  DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN LA ACT_AHT_HIST_TRAM_TITULO: '||SQL%ROWCOUNT);

  V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_AHT_HIST_TRAM_TITULO 
              (AHT_ID
              , TIT_ID
              , AHT_FECHA_PRES_REGISTRO
              , AHT_FECHA_INSCRIPCION
              , DD_ESP_ID
              , USUARIOCREAR
              , FECHACREAR)
              SELECT 
              '||V_ESQUEMA||'.S_ACT_AHT_HIST_TRAM_TITULO.NEXTVAL AHT_ID
              , TIT.TIT_ID
              , COALESCE(TIT.TIT_FECHA_PRESENT2_REG, TIT.TIT_FECHA_PRESENT1_REG, TO_DATE(''01/01/1900'', ''MM/DD/YYYY'')) AHT_FECHA_PRES_REGISTRO
              , COALESCE(TIT.TIT_FECHA_INSC_REG, TO_DATE(''01/01/1900'', ''MM/DD/YYYY'')) AHT_FECHA_INSCRIPCION
              , (SELECT DD_ESP_ID FROM '||V_ESQUEMA||'.DD_ESP_ESTADO_PRESENTACION WHERE DD_ESP_CODIGO = ''03'') DD_ESP_ID
              , '''||V_USUARIO||'''
              , SYSDATE
              FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
              JOIN '||V_ESQUEMA||'.'||V_TABLA||' TIT ON ACT.ACT_ID = TIT.ACT_ID AND TIT.BORRADO = 0
              JOIN '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO ETI ON TIT.DD_ETI_ID = ETI.DD_ETI_ID AND ETI.BORRADO = 0
              JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
              WHERE CRA.DD_CRA_CODIGO = ''03''
              AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
              AND ETI.DD_ETI_CODIGO = ''02''
              AND TIT.TIT_FECHA_INSC_REG IS NULL
              AND NOT EXISTS (SELECT 1 
              FROM ACT_AHT_HIST_TRAM_TITULO AHT
              WHERE AHT.BORRADO = 0
              AND AHT.TIT_ID = TIT.TIT_ID)';   
  EXECUTE IMMEDIATE V_MSQL;

  DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS INSERTADOS EN LA ACT_AHT_HIST_TRAM_TITULO POR NO EXISTIR PARA ES TÍTULO: '||SQL%ROWCOUNT);

  V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' T1
                USING (
                  SELECT 
                  TIT.TIT_ID
                  , COALESCE(TIT.TIT_FECHA_PRESENT1_REG, TO_DATE(''01/01/1900'', ''MM/DD/YYYY'')) TIT_FECHA_PRESENT1_REG
                  , COALESCE(TIT.TIT_FECHA_INSC_REG, TO_DATE(''01/01/1900'', ''MM/DD/YYYY'')) TIT_FECHA_INSC_REG
                  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
                  JOIN '||V_ESQUEMA||'.'||V_TABLA||' TIT ON ACT.ACT_ID = TIT.ACT_ID AND TIT.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_ETI_ESTADO_TITULO ETI ON TIT.DD_ETI_ID = ETI.DD_ETI_ID AND ETI.BORRADO = 0
                  JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
                  WHERE CRA.DD_CRA_CODIGO = ''03''
                  AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                  AND ETI.DD_ETI_CODIGO = ''02''
                  AND TIT.TIT_FECHA_INSC_REG IS NULL
                ) T2 
                ON (T1.TIT_ID = T2.TIT_ID)
                WHEN MATCHED THEN UPDATE SET
                    T1.TIT_FECHA_PRESENT1_REG = T2.TIT_FECHA_PRESENT1_REG,
                    T1.TIT_FECHA_INSC_REG = T2.TIT_FECHA_INSC_REG,
                    T1.USUARIOMODIFICAR = '''||V_USUARIO||''',
                    T1.FECHAMODIFICAR = SYSDATE';   
  EXECUTE IMMEDIATE V_MSQL;  

  DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN LA ACT_TIT_TITULO: '||SQL%ROWCOUNT);
      
  COMMIT;

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);

          ROLLBACK;
          RAISE;          

END;

/

EXIT