--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220404
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17614
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Se quita los filtrados - HREOS-15634
--##        0.3 Se añaden nuevos campos a la ICO (ICO_ANO_REHABILITACION y ICO_ANO_CONSTRUCCION) - HREOS-17329 - Javier Esbrí
--##        0.4 Se cambia los campos por el nuevo modelo de Informe comercial - HREOS-17366
--##        0.5 Se añaden nuevos campos Informe comercial - HREOS-17351 - Javier Esbri
--##        0.6 Se añaden el campo de número de aparcaminetos - HREOS-17497 - Daniel Algaba
--##        0.7 Nuevos mapeos - HREOS-17515 - Daniel Algaba
--##        0.7 Añadimos ICO_BALCON - HREOS-17614 - Daniel Algaba
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_BCR_07_INFORME_COMERCIAL
   (     
      FLAG_EN_REM IN NUMBER
      , SALIDA OUT VARCHAR2
      , COD_RETORNO OUT NUMBER
   )

   AS

   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_AUX NUMBER(10); -- Variable auxiliar

   V_FECHA_INICIO VARCHAR2(100 CHAR);
   V_FECHA_FIN VARCHAR2(100 CHAR);

BEGIN
      SALIDA := '[INICIO]'||CHR(10);

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS DE INFORME COMERCIAL.'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - ACT_ICO_INFO_COMERCIAL'||CHR(10);

      V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO
               USING (
                  SELECT
                  ICO.ICO_ID
                  , NVL(TO_NUMBER(APR.ANYO_ULTIMA_REFORMA), ICO.ICO_ANO_REHABILITACION) ICO_ANO_REHABILITACION
                  , ACT.ACT_NUM_ACTIVO_CAIXA AS NUM_IDENTIFICATIVO      
                  , ACT.ACT_NUM_ACTIVO AS NUM_INMUEBLE  
                  , ACT.ACT_ID
                  , NVL(TO_NUMBER(APR.ANYO_CONSTRUCCION),ICO.ICO_ANO_CONSTRUCCION) AS ICO_ANO_CONSTRUCCION
                  , APR.NUM_APARACAMIENTOS/100 ICO_NUM_GARAJE
                  , APR.NUM_HABITACIONES/100 ICO_NUM_DORMITORIOS
                  , APR.NUM_BANYOS/100 ICO_NUM_BANYOS
                  , CASE 
                     WHEN TIENE_ASCENSOR IN (''S'',''1'',''01'',''SI'',''Si'') THEN (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''01'')
                     WHEN TIENE_ASCENSOR IN (''N'',''0'',''02'',''NO'',''No'') THEN (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02'') 
                     ELSE NULL
                  END AS ICO_ASCENSOR
                  , CASE 
                     WHEN TIENE_TRASTERO IN (''S'',''1'',''01'',''SI'',''Si'') THEN (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''01'')
                     WHEN TIENE_TRASTERO IN (''N'',''0'',''02'',''NO'',''No'') THEN (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02'') 
                     ELSE NULL
                  END AS ICO_ANEJO_TRASTERO
                  , APR.IDEN_TRASTERO ICO_IDEF_TRASTERO
                  , CASE 
                     WHEN EQUIPAMIENTO_015001 IN (''S'',''1'',''01'',''SI'',''Si'') THEN (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''01'')
                     WHEN EQUIPAMIENTO_015001 IN (''N'',''0'',''02'',''NO'',''No'') THEN (SELECT DD_SIN_ID FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_CODIGO = ''02'') 
                     ELSE NULL
                  END AS ICO_ANEJO_GARAJE
                  , APR.IDEN_PL_PARKING ICO_IDEF_PLAZA_PARKING
                  , TCL.DD_TCL_ID ICO_CALEFACCION
                  , SIN_COC.DD_SIN_ID ICO_COCINA_AMUEBLADA
                  , ECV.DD_ECV_ID as DD_ECV_ID
                  , CASE 
                     WHEN DIS_USO_JAR.DD_DIS_ID IS NOT NULL THEN DIS_USO_JAR.DD_DIS_ID
                     WHEN DIS_JAR.DD_DIS_ID IS NOT NULL THEN DIS_JAR.DD_DIS_ID
                     WHEN JARDIN = ''002501'' THEN (SELECT DD_DIS_ID FROM '|| V_ESQUEMA ||'.DD_DIS_DISPONIBILIDAD WHERE DD_DIS_CODIGO = ''03'') 
                     ELSE NULL
                  END AS ICO_JARDIN
                  , DIS_PISC.DD_DIS_ID ICO_PISCINA
                  , SIN_HUM.DD_SIN_ID ICO_SALIDA_HUMOS
                  , SIN_TER.DD_SIN_ID ICO_TERRAZA
                  , SIN_BAL.DD_SIN_ID ICO_BALCON
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK APR
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_ICO_INFO_COMERCIAL ICO ON ACT.ACT_ID = ICO.ACT_ID AND ICO.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''EST_CONSERVACION''  AND eqv1.DD_CODIGO_CAIXA = APR.EST_CONSERVACION AND EQV1.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_ECV_ESTADO_CONSERVACION ECV ON ECV.DD_ECV_CODIGO = eqv1.DD_CODIGO_REM 
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV2 ON EQV2.DD_NOMBRE_CAIXA = ''CALEFACCION''  AND EQV2.DD_CODIGO_CAIXA = APR.CALEFACCION AND EQV2.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_TCL_TIPO_CLIMATIZACION TCL ON TCL.DD_TCL_CODIGO = EQV2.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV3 ON EQV3.DD_NOMBRE_CAIXA = ''COCINA_EQUIPADA''  AND EQV3.DD_CODIGO_CAIXA = APR.COCINA_EQUIPADA AND EQV3.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA_M ||'.DD_SIN_SINO SIN_COC ON SIN_COC.DD_SIN_CODIGO = EQV3.DD_CODIGO_REM 
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV4 ON EQV4.DD_NOMBRE_CAIXA = ''JARDIN''  AND EQV4.DD_CODIGO_CAIXA = APR.JARDIN AND EQV4.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_DIS_DISPONIBILIDAD DIS_JAR ON DIS_JAR.DD_DIS_CODIGO = EQV4.DD_CODIGO_REM 
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV5 ON EQV5.DD_NOMBRE_CAIXA = ''USO_JARDIN''  AND EQV5.DD_CODIGO_CAIXA = APR.USO_JARDIN AND EQV5.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_DIS_DISPONIBILIDAD DIS_USO_JAR ON DIS_USO_JAR.DD_DIS_CODIGO = EQV5.DD_CODIGO_REM  
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV6 ON EQV6.DD_NOMBRE_CAIXA = ''PISCINA''  AND EQV6.DD_CODIGO_CAIXA = APR.PISCINA AND EQV6.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_DIS_DISPONIBILIDAD DIS_PISC ON DIS_PISC.DD_DIS_CODIGO = EQV6.DD_CODIGO_REM
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV7 ON EQV7.DD_NOMBRE_CAIXA = ''SALIDA_HUMOS''  AND EQV7.DD_CODIGO_CAIXA = APR.SALIDA_HUMOS AND EQV7.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA_M ||'.DD_SIN_SINO SIN_HUM ON SIN_HUM.DD_SIN_CODIGO = EQV7.DD_CODIGO_REM  
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV8 ON EQV8.DD_NOMBRE_CAIXA = ''TERRAZA''  AND EQV8.DD_CODIGO_CAIXA = APR.TERRAZA AND EQV8.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA_M ||'.DD_SIN_SINO SIN_TER ON SIN_TER.DD_SIN_CODIGO = EQV8.DD_CODIGO_REM  
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM EQV9 ON EQV9.DD_NOMBRE_CAIXA = ''BALCON''  AND EQV9.DD_CODIGO_CAIXA = APR.BALCON AND EQV9.BORRADO=0
                  LEFT JOIN '|| V_ESQUEMA_M ||'.DD_SIN_SINO SIN_BAL ON SIN_BAL.DD_SIN_CODIGO = EQV9.DD_CODIGO_REM  
                  WHERE ACT.BORRADO = 0
                  AND APR.FLAG_EN_REM = '|| FLAG_EN_REM||'
               ) AUX
               ON (ICO.ICO_ID = AUX.ICO_ID)
                  WHEN MATCHED THEN
                  UPDATE SET 
                    ICO.ICO_ANO_REHABILITACION = AUX.ICO_ANO_REHABILITACION
                  , ICO.ICO_ANO_CONSTRUCCION = AUX.ICO_ANO_CONSTRUCCION
                  , ICO.ICO_NUM_GARAJE = NVL(AUX.ICO_NUM_GARAJE,ICO.ICO_NUM_GARAJE)
                  , ICO.ICO_NUM_DORMITORIOS = NVL(AUX.ICO_NUM_DORMITORIOS,ICO.ICO_NUM_DORMITORIOS)
                  , ICO.ICO_NUM_BANYOS = NVL(AUX.ICO_NUM_BANYOS,ICO.ICO_NUM_BANYOS)
                  , ICO.ICO_ASCENSOR = NVL(AUX.ICO_ASCENSOR,ICO.ICO_ASCENSOR)
                  , ICO.ICO_ANEJO_TRASTERO = NVL(AUX.ICO_ANEJO_TRASTERO,ICO.ICO_ANEJO_TRASTERO)
                  , ICO.ICO_IDEF_TRASTERO = NVL(AUX.ICO_IDEF_TRASTERO,ICO.ICO_IDEF_TRASTERO)
                  , ICO.ICO_ANEJO_GARAJE = NVL(AUX.ICO_ANEJO_GARAJE,ICO.ICO_ANEJO_GARAJE)
                  , ICO.ICO_IDEF_PLAZA_PARKING = NVL(AUX.ICO_IDEF_PLAZA_PARKING,ICO.ICO_IDEF_PLAZA_PARKING)
                  , ICO.ICO_CALEFACCION = NVL(AUX.ICO_CALEFACCION,ICO.ICO_CALEFACCION)
                  , ICO.ICO_COCINA_AMUEBLADA = NVL(AUX.ICO_COCINA_AMUEBLADA,ICO.ICO_COCINA_AMUEBLADA)
                  , ICO.DD_ECV_ID = NVL(AUX.DD_ECV_ID,ICO.DD_ECV_ID)
                  , ICO.ICO_JARDIN = NVL(AUX.ICO_JARDIN,ICO.ICO_JARDIN)
                  , ICO.ICO_PISCINA = NVL(AUX.ICO_PISCINA,ICO.ICO_PISCINA)
                  , ICO.ICO_SALIDA_HUMOS = NVL(AUX.ICO_SALIDA_HUMOS,ICO.ICO_SALIDA_HUMOS)
                  , ICO.ICO_TERRAZA = NVL(AUX.ICO_TERRAZA,ICO.ICO_TERRAZA)
                  , ICO.ICO_BALCON = NVL(AUX.ICO_BALCON,ICO.ICO_BALCON)
                  , ICO.USUARIOMODIFICAR = ''STOCK_BC''
                  , ICO.FECHAMODIFICAR = SYSDATE
                  WHEN NOT MATCHED THEN
                  INSERT 
                  (ICO_ID
                  , ACT_ID
                  , ICO_ANO_REHABILITACION
                  , ICO_ANO_CONSTRUCCION
                  , ICO_NUM_GARAJE
                  , ICO_NUM_DORMITORIOS
                  , ICO_NUM_BANYOS
                  , ICO_ASCENSOR
                  , ICO_ANEJO_TRASTERO
                  , ICO_IDEF_TRASTERO
                  , ICO_ANEJO_GARAJE
                  , ICO_IDEF_PLAZA_PARKING
                  , ICO_CALEFACCION
                  , ICO_COCINA_AMUEBLADA
                  , DD_ECV_ID
                  , ICO_JARDIN
                  , ICO_PISCINA
                  , ICO_SALIDA_HUMOS
                  , ICO_TERRAZA
                  , ICO_BALCON
                  , USUARIOCREAR
                  , FECHACREAR)
                  VALUES 
                  ('|| V_ESQUEMA ||'.S_ACT_ICO_INFO_COMERCIAL.nextval
                  , AUX.ACT_ID
                  , AUX.ICO_ANO_REHABILITACION
                  , AUX.ICO_ANO_CONSTRUCCION
                  , AUX.ICO_NUM_GARAJE
                  , AUX.ICO_NUM_DORMITORIOS
                  , AUX.ICO_NUM_BANYOS
                  , AUX.ICO_ASCENSOR
                  , AUX.ICO_ANEJO_TRASTERO
                  , AUX.ICO_IDEF_TRASTERO
                  , AUX.ICO_ANEJO_GARAJE
                  , AUX.ICO_IDEF_PLAZA_PARKING
                  , AUX.ICO_CALEFACCION
                  , AUX.ICO_COCINA_AMUEBLADA
                  , AUX.DD_ECV_ID
                  , AUX.ICO_JARDIN
                  , AUX.ICO_PISCINA
                  , AUX.ICO_SALIDA_HUMOS
                  , AUX.ICO_TERRAZA
                  , AUX.ICO_BALCON
                  , ''STOCK_BC''
                  , SYSDATE)';
      
      EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      SALIDA := SALIDA || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      SALIDA := SALIDA || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_BCR_07_INFORME_COMERCIAL;
/
EXIT;
