 --/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20180315
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3890
--## PRODUCTO=NO
--## Finalidad: DDL creación de la vista busqueda publicación activo con correccion al filtrar con historico de inf comercial
--## Comentario1: Se adapta la vista para filtrar por valoracion sin borrar y que diferencie entre el destino comercial del activo.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 

DECLARE
    seq_count NUMBER(3); -- Vble. para validar la existencia de las Secuencias.
    table_count NUMBER(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count NUMBER(3); -- Vble. para validar la existencia de las Columnas.    
    v_constraint_count NUMBER(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas.
    V_ESQUEMA_MASTER VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas.
    V_TEXT_VISTA VARCHAR2(30 CHAR) := 'V_BUSQUEDA_PUBLICACION_ACTIVO';
    V_MSQL VARCHAR2(4000 CHAR); 
    CUENTA NUMBER(1); -- Vble. existencia de la vista.
    
BEGIN

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='MATERIALIZED VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('Vista materializada: '|| V_ESQUEMA ||'.' || V_TEXT_VISTA || ' existe, se procede a eliminarla..');
    EXECUTE IMMEDIATE 'DROP MATERIALIZED VIEW ' || V_ESQUEMA || '.' || V_TEXT_VISTA || '';  
    DBMS_OUTPUT.PUT_LINE('Vista materializada borrada OK');
  END IF;

  SELECT COUNT(*) INTO CUENTA FROM ALL_OBJECTS WHERE OBJECT_NAME = V_TEXT_VISTA AND OWNER=V_ESQUEMA AND OBJECT_TYPE='VIEW';  
  IF CUENTA>0 THEN
    DBMS_OUTPUT.PUT_LINE('Vista: '|| V_ESQUEMA ||'.' || V_TEXT_VISTA || ' existe, se procede a eliminarla..');
    EXECUTE IMMEDIATE 'DROP VIEW ' || V_ESQUEMA || '.' || V_TEXT_VISTA || '';  
    DBMS_OUTPUT.PUT_LINE('Vista borrada OK');
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('Crear nueva vista: '|| V_ESQUEMA ||'.' || V_TEXT_VISTA || '..');
 
EXECUTE IMMEDIATE 'CREATE OR REPLACE FORCE VIEW ' || V_ESQUEMA || '.' || V_TEXT_VISTA || ' (act_id,
                                                                  act_num_activo,
                                                                  tipo_activo_codigo,
                                                                  tipo_activo_descripcion,
                                                                  subtipo_activo_codigo,
                                                                  subtipo_activo_descripcion,
                                                                  direccion,
                                                                  cartera_codigo,
                                                                  estado_publicacion_codigo,
                                                                  estado_publicacion_descripcion,
                                                                  TIPO_COMERCIALIZACION_CODIGO,
                                                                  tipo_comercializacion_desc,
                                                                  admision,
                                                                  gestion,
                                                                  informe_comercial,
                                                                  publicacion,
                                                                  precio
                                                                 )
AS 
  WITH VISTA_ACT_PUB AS (
  SELECT 
    ACT.ACT_ID    
    , ACT.ACT_NUM_ACTIVO AS ACT_NUM_ACTIVO
    , TPA.DD_TPA_CODIGO AS TIPO_ACTIVO_CODIGO
    , TPA.DD_TPA_DESCRIPCION AS TIPO_ACTIVO_DESCRIPCION
    , SAC.DD_SAC_CODIGO AS SUBTIPO_ACTIVO_CODIGO
    , SAC.DD_SAC_DESCRIPCION AS SUBTIPO_ACTIVO_DESCRIPCION
    , TVI.DD_TVI_DESCRIPCION || '' '' || LOC.BIE_LOC_NOMBRE_VIA || '' '' || LOC.BIE_LOC_NUMERO_DOMICILIO || '' '' || LOC.BIE_LOC_PUERTA AS DIRECCION
    , CRA.DD_CRA_CODIGO AS CARTERA_CODIGO
    , DECODE(TCO.DD_TCO_CODIGO,''01'',EPV.DD_EPV_CODIGO,''03'',EPA.DD_EPA_CODIGO,''02'',EPA.DD_EPA_CODIGO||''/''||EPV.DD_EPV_CODIGO)   ESTADO_PUBLICACION_CODIGO 
    , DECODE(TCO.DD_TCO_CODIGO,''01'',EPV.DD_EPV_DESCRIPCION,''03'',EPA.DD_EPA_DESCRIPCION,''02'',EPA.DD_EPA_DESCRIPCION||''/''||EPV.DD_EPV_DESCRIPCION)   ESTADO_PUBLICACION_DESCRIPCION   
    , TCO.DD_TCO_CODIGO AS TIPO_COMERCIALIZACION_CODIGO
    , TCO.DD_TCO_DESCRIPCION AS TIPO_COMERCIALIZACION_DESC           
    , ACT.ACT_ADMISION AS ADMISION
    , ACT.ACT_GESTION AS GESTION
    , DECODE (AIC.DD_AIC_CODIGO, ''02'', 1, 0) INFORME_COMERCIAL
    , CASE 
        WHEN ACT.ACT_FECHA_IND_PUBLICABLE IS NULL THEN 0 
        ELSE 1 
      END AS PUBLICACION
    , CASE 
        WHEN NVL(TPC.DD_TPC_CODIGO,''00'') = ''02'' AND NVL(TCO.DD_TCO_CODIGO,''00'') IN (''01'',''02'',''04'') THEN 1 
        WHEN NVL(TPC.DD_TPC_CODIGO,''00'') = ''03'' AND NVL(TCO.DD_TCO_CODIGO,''00'') IN (''02'',''03'',''04'') THEN 1
        ELSE 0 
      END AS PRECIO
    , TPC.DD_TPC_CODIGO
    , TCO.DD_TCO_CODIGO
    , HIC.HIC_FECHA
    , AIC.DD_AIC_CODIGO
    , ROW_NUMBER() OVER(PARTITION BY ACT.ACT_ID ORDER BY DECODE(AIC.DD_AIC_CODIGO,''02'',0,''04'',0,''01'',1,''03'',1,2), HIC.HIC_FECHA DESC, DECODE(TPC.DD_TPC_CODIGO||TCO.DD_TCO_CODIGO,''0201'',0,''0202'',0,''0204'',0,''0302'',0,''0303'',0,''0304'',0,1)) RN
  FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
  JOIN '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID AND SCM.DD_SCM_CODIGO IN (''02'',''03'',''04'',''06'',''07'',''08'',''09'')
  LEFT JOIN '||V_ESQUEMA||'.ACT_HIC_EST_INF_COMER_HIST HIC ON ACT.ACT_ID = HIC.ACT_ID AND HIC.BORRADO = 0
  LEFT JOIN '||V_ESQUEMA||'.DD_AIC_ACCION_INF_COMERCIAL AIC ON HIC.DD_AIC_ID = AIC.DD_AIC_ID AND AIC.DD_AIC_CODIGO IN (''01'',''02'',''03'',''04'')
  LEFT JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0
  LEFT JOIN '||V_ESQUEMA||'.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_ID = ACT.DD_SAC_ID AND SAC.BORRADO = 0 
  LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_ID = ACT.DD_TPA_ID AND TPA.BORRADO = 0
  LEFT JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION LOC ON ACT.BIE_ID = LOC.BIE_ID AND LOC.BORRADO = 0
  LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_TVI_TIPO_VIA TVI ON LOC.DD_TVI_ID = TVI.DD_TVI_ID AND TVI.BORRADO = 0
  LEFT JOIN '||V_ESQUEMA||'.DD_EPU_ESTADO_PUBLICACION EPU ON ACT.DD_EPU_ID = EPU.DD_EPU_ID AND EPU.BORRADO = 0
  LEFT JOIN '||V_ESQUEMA||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID AND ICO.BORRADO = 0
  LEFT JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID AND PAC.BORRADO = 0
  LEFT JOIN '||V_ESQUEMA||'.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.BORRADO = 0
  LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID AND TPC.DD_TPC_CODIGO IN (''02'',''03'')
  LEFT JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION ACT_APU ON ACT_APU.ACT_ID = ACT.ACT_ID AND ACT_APU.BORRADO = 0
  LEFT JOIN '||V_ESQUEMA||'.DD_EPA_ESTADO_PUB_ALQUILER EPA ON ACT_APU.DD_EPA_ID = EPA.DD_EPA_ID AND EPA.BORRADO = 0
  LEFT JOIN '||V_ESQUEMA||'.DD_EPV_ESTADO_PUB_VENTA EPV ON ACT_APU.DD_EPV_ID = EPV.DD_EPV_ID AND EPV.BORRADO = 0
  LEFT JOIN '||V_ESQUEMA||'.DD_TCO_TIPO_COMERCIALIZACION TCO ON TCO.DD_TCO_ID = ACT_APU.DD_TCO_ID AND TCO.BORRADO = 0
  WHERE (PAC.PAC_ID IS NULL OR PAC.PAC_CHECK_COMERCIALIZAR = 1) AND ACT.BORRADO = 0)
  SELECT ACT_ID, ACT_NUM_ACTIVO, TIPO_ACTIVO_CODIGO, TIPO_ACTIVO_DESCRIPCION, SUBTIPO_ACTIVO_CODIGO, SUBTIPO_ACTIVO_DESCRIPCION
    , DIRECCION, CARTERA_CODIGO, ESTADO_PUBLICACION_CODIGO, ESTADO_PUBLICACION_DESCRIPCION, TIPO_COMERCIALIZACION_CODIGO, TIPO_COMERCIALIZACION_DESC, ADMISION, GESTION, INFORME_COMERCIAL
    , PUBLICACION, PRECIO
  FROM VISTA_ACT_PUB
  WHERE RN = 1';

  DBMS_OUTPUT.PUT_LINE('Vista creada OK');
  
END;
/

EXIT;
