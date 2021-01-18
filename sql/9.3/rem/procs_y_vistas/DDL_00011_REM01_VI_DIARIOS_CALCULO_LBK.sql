--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20201123
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-12178
--## PRODUCTO=NO
--## Finalidad: Vista para calcular los diarios de los gastos Liberbank
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

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_DIARIOS_CALCULO_LBK' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_DIARIOS_CALCULO_LBK...');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.V_DIARIOS_CALCULO_LBK';  
    DBMS_OUTPUT.PUT_LINE('DROP MATERIALIZED VIEW '|| V_ESQUEMA ||'.V_DIARIOS_CALCULO_LBK... borrada OK'); 
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = 'V_DIARIOS_CALCULO_LBK' AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_DIARIOS_CALCULO_LBK...');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.V_DIARIOS_CALCULO_LBK';  
    DBMS_OUTPUT.PUT_LINE('DROP VIEW '|| V_ESQUEMA ||'.V_DIARIOS_CALCULO_LBK... borrada OK');
  END IF;  
  
  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_DIARIOS_CALCULO_LBK...');
  EXECUTE IMMEDIATE 'CREATE VIEW ' || V_ESQUEMA || '.V_DIARIOS_CALCULO_LBK 
  AS
    WITH TIPO_DIARIO AS (
        SELECT /*+ materialize */GPV.GPV_ID, TDI.TIPO_DIARIO
        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID 
            AND GLD.BORRADO = 0
        JOIN '||V_ESQUEMA||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
            AND GEN.BORRADO = 0
        JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID
            AND ENT.BORRADO = 0
        JOIN '||V_ESQUEMA||'.ACT_ETD_ENT_TDI ETD ON ETD.ENT_ID = GEN.ENT_ID 
            AND ETD.DD_ENT_ID = GEN.DD_ENT_ID
            AND ETD.BORRADO = 0
        JOIN '||V_ESQUEMA||'.ACT_TDI_TIPO_DIARIO TDI ON TDI.TDI_ID = ETD.TDI_ID
            AND TDI.BORRADO = 0
        WHERE ENT.DD_ENT_CODIGO IN (''ACT'',''GEN'')
        GROUP BY GPV.GPV_ID, TDI.TIPO_DIARIO
        UNION
        SELECT /*+ materialize */GPV.GPV_ID, TDI.TIPO_DIARIO
        FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
        JOIN '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD ON GLD.GPV_ID = GPV.GPV_ID 
            AND GLD.BORRADO = 0
        JOIN '||V_ESQUEMA||'.GLD_ENT GEN ON GEN.GLD_ID = GLD.GLD_ID
            AND GEN.BORRADO = 0
        JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT ON ENT.DD_ENT_ID = GEN.DD_ENT_ID
            AND ENT.BORRADO = 0
        JOIN '||V_ESQUEMA||'.ACT_ILB_NFO_LIBERBANK ILB ON ILB.ILB_COD_PROMOCION = TO_CHAR(GEN.ENT_ID)
        JOIN '||V_ESQUEMA||'.ACT_ETD_ENT_TDI ETD ON ETD.ENT_ID = ILB.ACT_ID
            AND ETD.BORRADO = 0
        JOIN '||V_ESQUEMA||'.DD_ENT_ENTIDAD_GASTO ENT_PRO ON ENT_PRO.DD_ENT_ID = ETD.DD_ENT_ID
            AND ENT_PRO.BORRADO = 0
        JOIN '||V_ESQUEMA||'.ACT_TDI_TIPO_DIARIO TDI ON TDI.TDI_ID = ETD.TDI_ID
            AND TDI.BORRADO = 0
        WHERE ENT.DD_ENT_CODIGO = ''PRO''
            AND ENT_PRO.DD_ENT_CODIGO = ''ACT''
        GROUP BY GPV.GPV_ID, TDI.TIPO_DIARIO   
    ), DIARIO20 AS (
        SELECT /*+ materialize */GPV_ID, CASE WHEN COUNT(1) = 2 THEN 1
            WHEN COUNT(1) = 1 THEN 0 END DIARIO20
        FROM TIPO_DIARIO
        GROUP BY GPV_ID
    ), TIPO_DIARIO_EFECTIVO AS (
        SELECT /*+ materialize */DISTINCT TDI.GPV_ID
            , CASE 
                WHEN D20.DIARIO20 = 1 THEN ''20'' 
                WHEN D20.DIARIO20 = 0 THEN TDI.TIPO_DIARIO 
                ELSE NULL 
                END TIPO_DIARIO
        FROM TIPO_DIARIO TDI
        JOIN DIARIO20 D20 ON D20.GPV_ID = TDI.GPV_ID
    ), TIPOS_EFECTIVOS AS (
        SELECT GLD.GPV_ID, GLD.GLD_ID
            , CASE WHEN NVL(GLD.GLD_IMP_IND_EXENTO, 0) = 1 AND NVL(GLD.GLD_IMP_IND_RENUNCIA_EXENCION, 0) = 0
                    THEN 0
                    ELSE NVL(GLD.GLD_IMP_IND_TIPO_IMPOSITIVO, 0)
                END TIPO_IMPOSITIVO_EFECTIVO
        FROM '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD 
        WHERE GLD.BORRADO = 0
    ), IMPORTES_SUJETOS AS (
        SELECT GLD.GPV_ID
            , SUM(NVL(GLD.GLD_PRINCIPAL_SUJETO, 0)) SUJETO
            , SUM(NVL(GLD.GLD_IMP_IND_CUOTA, 0)) CUOTA
            , CASE WHEN SUM(NVL(GLD.GLD_PRINCIPAL_SUJETO, 0)) > 0 THEN MAX(TEF.TIPO_IMPOSITIVO_EFECTIVO) ELSE 0 END TIPO_IMPOSITIVO_EFECTIVO
        FROM '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD
        JOIN TIPOS_EFECTIVOS TEF ON TEF.GLD_ID = GLD.GLD_ID
        WHERE TEF.TIPO_IMPOSITIVO_EFECTIVO <> 0
        GROUP BY GLD.GPV_ID
    ), IMPORTES_NO_SUJETOS AS (
        SELECT GLD.GPV_ID
            , SUM((NVL(GLD.GLD_PRINCIPAL_NO_SUJETO, 0) + NVL(GLD.GLD_RECARGO, 0) + NVL(GLD.GLD_INTERES_DEMORA, 0) 
                        + NVL(GLD.GLD_COSTAS, 0) + NVL(GLD.GLD_OTROS_INCREMENTOS, 0) + NVL(GLD.GLD_PROV_SUPLIDOS, 0))) NO_SUJETO
        FROM '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD
        JOIN TIPOS_EFECTIVOS TEF ON TEF.GLD_ID = GLD.GLD_ID
        GROUP BY GLD.GPV_ID
    ), IMPORTES_SUJETOS_EXENTOS AS (
        SELECT GLD.GPV_ID
            , SUM(NVL(GLD.GLD_PRINCIPAL_SUJETO, 0)) SUJETO_EXENTO
        FROM '||V_ESQUEMA||'.GLD_GASTOS_LINEA_DETALLE GLD
        JOIN TIPOS_EFECTIVOS TEF ON TEF.GLD_ID = GLD.GLD_ID
        WHERE TEF.TIPO_IMPOSITIVO_EFECTIVO = 0
        GROUP BY GLD.GPV_ID
    )
    SELECT TED.GPV_ID
        , CASE WHEN NVL(SUJ.SUJETO, 0) <> 0                                                                         THEN TED.TIPO_DIARIO                                                WHEN (NVL(NSU.NO_SUJETO, 0) + NVL(SUE.SUJETO_EXENTO, 0)) <> 0                                                                       THEN ''60''                                                                                                                                                                                                                           ELSE NULL END DIARIO1
        , CASE WHEN NVL(SUJ.SUJETO, 0) <> 0 AND TRE.DD_TRE_CODIGO = ''ANT'' AND NVL(GDE.GDE_RET_GAR_APLICA, 0) = 1    THEN SUJ.SUJETO * (1 - NVL(GDE.GDE_RET_GAR_TIPO_IMPOSITIVO, 0)/100) WHEN NVL(SUJ.SUJETO, 0) <> 0                                                                                                        THEN SUJ.SUJETO                                                                                             WHEN (NVL(NSU.NO_SUJETO, 0) + NVL(SUE.SUJETO_EXENTO, 0)) <> 0 THEN NVL(NSU.NO_SUJETO, 0) + NVL(SUE.SUJETO_EXENTO, 0)    ELSE NULL END DIARIO1_BASE
        , CASE WHEN NVL(SUJ.SUJETO, 0) <> 0                                                                         THEN SUJ.TIPO_IMPOSITIVO_EFECTIVO                                   WHEN (NVL(NSU.NO_SUJETO, 0) + NVL(SUE.SUJETO_EXENTO, 0)) <> 0                                                                       THEN 0                                                                                                                                                                                                                              ELSE NULL END DIARIO1_TIPO
        , CASE WHEN NVL(SUJ.SUJETO, 0) <> 0 AND TRE.DD_TRE_CODIGO = ''ANT'' AND NVL(GDE.GDE_RET_GAR_APLICA, 0) = 1    THEN SUJ.CUOTA * (1 - NVL(GDE.GDE_RET_GAR_TIPO_IMPOSITIVO, 0)/100)  WHEN NVL(SUJ.SUJETO, 0) <> 0                                                                                                        THEN SUJ.CUOTA                                                                                              WHEN (NVL(NSU.NO_SUJETO, 0) + NVL(SUE.SUJETO_EXENTO, 0)) <> 0 THEN 0                                                    ELSE NULL END DIARIO1_CUOTA
        , CASE WHEN NVL(SUJ.SUJETO, 0) = 0                                                                          THEN NULL                                                           WHEN (NVL(NSU.NO_SUJETO, 0) + NVL(SUE.SUJETO_EXENTO, 0)) <> 0                                                                       THEN ''60''                                                                                                                                                                                                                           ELSE NULL END DIARIO2
        , CASE WHEN NVL(SUJ.SUJETO, 0) = 0                                                                          THEN NULL                                                           WHEN (NVL(NSU.NO_SUJETO, 0) + NVL(SUE.SUJETO_EXENTO, 0)) <> 0 AND TRE.DD_TRE_CODIGO = ''ANT'' AND NVL(GDE.GDE_RET_GAR_APLICA, 0) = 1  THEN (NVL(NSU.NO_SUJETO, 0) + NVL(SUE.SUJETO_EXENTO, 0)) * (1 - NVL(GDE.GDE_RET_GAR_TIPO_IMPOSITIVO, 0)/100)  WHEN (NVL(NSU.NO_SUJETO, 0) + NVL(SUE.SUJETO_EXENTO, 0)) <> 0 THEN NVL(NSU.NO_SUJETO, 0) + NVL(SUE.SUJETO_EXENTO, 0)  ELSE NULL END DIARIO2_BASE
        , CASE WHEN NVL(SUJ.SUJETO, 0) = 0                                                                          THEN NULL                                                           WHEN (NVL(NSU.NO_SUJETO, 0) + NVL(SUE.SUJETO_EXENTO, 0)) <> 0                                                                       THEN 0                                                                                                                                                                                                                              ELSE NULL END DIARIO2_TIPO
        , CASE WHEN NVL(SUJ.SUJETO, 0) = 0                                                                          THEN NULL                                                           WHEN (NVL(NSU.NO_SUJETO, 0) + NVL(SUE.SUJETO_EXENTO, 0)) <> 0                                                                       THEN 0                                                                                                                                                                                                                              ELSE NULL END DIARIO2_CUOTA
    FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
    JOIN TIPO_DIARIO_EFECTIVO TED ON TED.GPV_ID = GPV.GPV_ID
    JOIN '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
        AND GDE.BORRADO = 0
    LEFT JOIN '||V_ESQUEMA||'.DD_TRE_TIPO_RETENCION TRE ON TRE.DD_TRE_ID = GDE.DD_TRE_ID
        AND TRE.BORRADO = 0
    LEFT JOIN IMPORTES_SUJETOS SUJ ON SUJ.GPV_ID = GPV.GPV_ID
    LEFT JOIN IMPORTES_NO_SUJETOS NSU ON NSU.GPV_ID = GPV.GPV_ID
    LEFT JOIN IMPORTES_SUJETOS_EXENTOS SUE ON SUE.GPV_ID = GPV.GPV_ID';

  DBMS_OUTPUT.PUT_LINE('CREATE VIEW '|| V_ESQUEMA ||'.V_DIARIOS_CALCULO_LBK...Creada OK');
  
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

