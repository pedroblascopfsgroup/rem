--/*
--##########################################
--## AUTOR=Alejandra garcía
--## FECHA_CREACION=20220330
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17577
--## PRODUCTO=NO
--##
--## Finalidad: INSERTAR ACT_PAC_PERIMETRO_ACTIVO
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(250 CHAR) := 'HREOS-17577';

BEGIN
DBMS_OUTPUT.PUT_LINE('[INICIO]');

    -- LOOP para insertar los valores --
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TEXT_TABLA);

        --Comprobar la existencia de la tabla.
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TEXT_TABLA||''' ';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

        IF V_NUM_TABLAS = 1 THEN

          --Merge activos
          DBMS_OUTPUT.PUT_LINE('[INFO]: Merge para activos con destino comercial alquiler, tipo de comercialización sólo alquiler,  NO está publicado, con fase de publicación V, subfase "Excluido publicación estrategia cliente" y PAC_EXCLUIR_VALIDACIONES igual a NO');

          V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
                      USING (
                            SELECT 
                                HFP.ACT_ID
                            FROM '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB HFP 
                            JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = HFP.ACT_ID
                                AND ACT.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
                                AND APU.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID
                                AND TCO.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = APU.DD_EPA_ID
                                AND EPA.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_FSP_FASE_PUBLICACION FSP ON FSP.DD_FSP_ID = HFP.DD_FSP_ID
                                AND FSP.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_SFP_SUBFASE_PUBLICACION SFP ON SFP.DD_SFP_ID = HFP.DD_SFP_ID
                                AND SFP.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
                                AND PAC.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                                AND CRA.BORRADO = 0
                            JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
                                AND SCR.BORRADO = 0
                            LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO SINO ON SINO.DD_SIN_ID = PAC.PAC_EXCLUIR_VALIDACIONES
                                AND SINO.BORRADO = 0
                            WHERE HFP.BORRADO = 0
                            AND FSP.DD_FSP_CODIGO = ''09''  
                            AND SFP.DD_SFP_CODIGO = ''14''  
                            AND TCO.DD_TCO_CODIGO = ''03''
                            AND SINO.DD_SIN_CODIGO = ''02''
                            AND DD_EPA_CODIGO <> ''03''
                            AND CRA.DD_CRA_CODIGO = ''07''
                            AND SCR.DD_SCR_CODIGO = ''71''
                            AND HFP.HFP_FECHA_FIN IS NULL
                            AND NOT EXISTS ( SELECT
                                                1
                                            FROM '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA 
                                            JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
                                                AND AGR.BORRADO = 0
                                            JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                                                AND TAG.BORRADO = 0
                                            WHERE AGA.ACT_ID = ACT.ACT_ID
                                            AND TAG.DD_TAG_CODIGO = ''02''
                                            )
                      ) T2 ON (T1.ACT_ID = T2.ACT_ID)
                      WHEN MATCHED THEN UPDATE SET
                          T1.PAC_CHECK_GESTION_COMERCIAL = 1
                        , T1.PAC_FECHA_GESTION_COMERCIAL = SYSDATE
                        , T1.USUARIOMODIFICAR = '''||V_ESQUEMA||'''
                        , T1.FECHAMODIFICAR = SYSDATE
                    ';
          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS MODIFICADOS EN '||V_TEXT_TABLA||'');  

          --Merge agrupaciones restringidas, pone PAC_CHECK_GESTION_COMERCIAL = 1 cuando TODOS los activos de la agrupación restringida cumplen las condiciones
          DBMS_OUTPUT.PUT_LINE('[INFO]: Merge para agrupaciones restringidas cuando TODOS los activos de la agrupación restringida cumplen las condiciones');

          V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
                      USING (
                              WITH PRINCIPAL AS (
                                  SELECT 
                                        AGR.AGR_ID
                                      , FSP.DD_FSP_CODIGO
                                      , SFP.DD_SFP_CODIGO  
                                      , TCO.DD_TCO_CODIGO
                                      , SINO.DD_SIN_CODIGO
                                  FROM '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB HFP 
                                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = HFP.ACT_ID
                                      AND ACT.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
                                      AND APU.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID
                                      AND TCO.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = APU.DD_EPA_ID
                                      AND EPA.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_FSP_FASE_PUBLICACION FSP ON FSP.DD_FSP_ID = HFP.DD_FSP_ID
                                      AND FSP.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_SFP_SUBFASE_PUBLICACION SFP ON SFP.DD_SFP_ID = HFP.DD_SFP_ID
                                      AND SFP.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
                                      AND PAC.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID
                                          AND AGA.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
                                      AND AGR.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                                      AND TAG.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                                      AND CRA.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
                                      AND SCR.BORRADO = 0
                                  LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO SINO ON SINO.DD_SIN_ID = PAC.PAC_EXCLUIR_VALIDACIONES
                                      AND SINO.BORRADO = 0
                                  WHERE HFP.BORRADO = 0
                                  AND TAG.DD_TAG_CODIGO = ''02''
                                  AND DD_EPA_CODIGO <> ''03''
                                  AND CRA.DD_CRA_CODIGO = ''07''
                                  AND SCR.DD_SCR_CODIGO = ''71''
                                  AND HFP.HFP_FECHA_FIN IS NULL
                              ), CUMPLE_CONDICION AS (
                                  SELECT DISTINCT
                                      PRIN.AGR_ID
                                  FROM PRINCIPAL PRIN
                                  WHERE PRIN.DD_FSP_CODIGO = ''09''  
                                  AND PRIN.DD_SFP_CODIGO = ''14''  
                                  AND PRIN.DD_TCO_CODIGO = ''03''
                                  AND PRIN.DD_SIN_CODIGO = ''02''
                              ), NO_CUMPLE_CONDICION AS (
                                  SELECT DISTINCT
                                      PRIN.AGR_ID
                                  FROM PRINCIPAL PRIN
                                  WHERE PRIN.DD_FSP_CODIGO <> ''09''  
                                  OR PRIN.DD_SFP_CODIGO <> ''14''  
                                  OR PRIN.DD_TCO_CODIGO <> ''03''
                                  OR PRIN.DD_SIN_CODIGO <> ''02''
                              )
                              SELECT
                                    CUMPLE.AGR_ID
                                  , AGA.ACT_ID 
                              FROM CUMPLE_CONDICION CUMPLE
                              JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = CUMPLE.AGR_ID
                                  AND AGA.BORRADO = 0
                              WHERE NOT EXISTS ( SELECT
                                                      1
                                                  FROM NO_CUMPLE_CONDICION NO_CUMPLE
                                                  WHERE NO_CUMPLE.AGR_ID = CUMPLE.AGR_ID
                                                )
                      ) T2 ON (T1.ACT_ID = T2.ACT_ID)
                      WHEN MATCHED THEN UPDATE SET
                          T1.PAC_CHECK_GESTION_COMERCIAL = 1
                        , T1.PAC_FECHA_GESTION_COMERCIAL = SYSDATE
                        , T1.USUARIOMODIFICAR = '''||V_ESQUEMA||'''
                        , T1.FECHAMODIFICAR = SYSDATE
                    ';
          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS EN AGRUPACIÓN RESTRINGIDA MODIFICADOS EN '||V_TEXT_TABLA||'');

          --Merge agrupaciones restringidas, pone PAC_CHECK_GESTION_COMERCIAL = 0 cuando alguno los activos de la agrupación restringida no cumple las condiciones
          DBMS_OUTPUT.PUT_LINE('[INFO]: Merge para agrupaciones restringidas cuando alguno los activos de la agrupación restringida no cumple las condiciones');

          V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1
                      USING (
                              WITH PRINCIPAL AS (
                                  SELECT 
                                        AGR.AGR_ID
                                      , FSP.DD_FSP_CODIGO
                                      , SFP.DD_SFP_CODIGO  
                                      , TCO.DD_TCO_CODIGO
                                      , SINO.DD_SIN_CODIGO
                                  FROM '||V_ESQUEMA||'.ACT_HFP_HIST_FASES_PUB HFP 
                                  JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_ID = HFP.ACT_ID
                                      AND ACT.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
                                      AND APU.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = APU.DD_TCO_ID
                                      AND TCO.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON EPA.DD_EPA_ID = APU.DD_EPA_ID
                                      AND EPA.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_FSP_FASE_PUBLICACION FSP ON FSP.DD_FSP_ID = HFP.DD_FSP_ID
                                      AND FSP.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_SFP_SUBFASE_PUBLICACION SFP ON SFP.DD_SFP_ID = HFP.DD_SFP_ID
                                      AND SFP.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID
                                      AND PAC.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.ACT_ID = ACT.ACT_ID
                                          AND AGA.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
                                      AND AGR.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG ON TAG.DD_TAG_ID = AGR.DD_TAG_ID
                                      AND TAG.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
                                      AND CRA.BORRADO = 0
                                  JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SCR ON SCR.DD_SCR_ID = ACT.DD_SCR_ID
                                      AND SCR.BORRADO = 0
                                  LEFT JOIN '||V_ESQUEMA_M||'.DD_SIN_SINO SINO ON SINO.DD_SIN_ID = PAC.PAC_EXCLUIR_VALIDACIONES
                                      AND SINO.BORRADO = 0
                                  WHERE HFP.BORRADO = 0
                                  AND TAG.DD_TAG_CODIGO = ''02''
                                  AND DD_EPA_CODIGO <> ''03''
                                  AND CRA.DD_CRA_CODIGO = ''07''
                                  AND SCR.DD_SCR_CODIGO = ''71''
                                  AND HFP.HFP_FECHA_FIN IS NULL
                              ), NO_CUMPLE_CONDICION AS (
                                  SELECT DISTINCT
                                      PRIN.AGR_ID
                                  FROM PRINCIPAL PRIN
                                  WHERE PRIN.DD_FSP_CODIGO <> ''09''  
                                  OR PRIN.DD_SFP_CODIGO <> ''14''  
                                  OR PRIN.DD_TCO_CODIGO <> ''03''
                                  OR PRIN.DD_SIN_CODIGO <> ''02''
                              )
                              SELECT
                                    NO_CUMPLE.AGR_ID
                                  , AGA.ACT_ID 
                              FROM NO_CUMPLE_CONDICION NO_CUMPLE
                              JOIN '||V_ESQUEMA||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGA.AGR_ID = NO_CUMPLE.AGR_ID
                                  AND AGA.BORRADO = 0                              
                      ) T2 ON (T1.ACT_ID = T2.ACT_ID)
                      WHEN MATCHED THEN UPDATE SET
                          T1.PAC_CHECK_GESTION_COMERCIAL = 0
                        , T1.PAC_FECHA_GESTION_COMERCIAL = SYSDATE
                        , T1.USUARIOMODIFICAR = '''||V_ESQUEMA||'''
                        , T1.FECHAMODIFICAR = SYSDATE
                    ';
          EXECUTE IMMEDIATE V_MSQL;

          DBMS_OUTPUT.PUT_LINE('[INFO] '||SQL%ROWCOUNT||' REGISTROS EN AGRUPACIÓN RESTRINGIDA MODIFICADOS EN '||V_TEXT_TABLA||'');

        ELSE 
          -- Si no existe se inserta.
          DBMS_OUTPUT.PUT_LINE('[INFO]: La tabla '||V_ESQUEMA||'.'||V_TEXT_TABLA||' no existe');

        END IF;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLA '||V_TEXT_TABLA||' ACTUALIZADA CORRECTAMENTE ');

EXCEPTION
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