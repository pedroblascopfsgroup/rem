--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210812
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14820
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - HREOS-14163 - Alejandra García (20210603)
--##        0.2 Cambiar FLAG_INS_UPD por FLAG_EN_REM y añadirlo como condición en cada merge  - HREOS-14163 - Alejandra García (20210604)
--##        0.3 Revisión - [HREOS-14344] - Alejandra García
--##	      0.4 Añadir merges PAC_PERIMETRO - Pier GOtta
--##	      0.5 Quitar SUBTIPO_IMPUESTO_COMPRA, PORC_IMPUESTO_COMPRA, COD_TP_IVA_COMPRA y RENUNCIA_EXENSION - HREOS-14533
--##	      0.6 Quitar IND_OCUPANTES_VIVIENDA - HREOS-14545
--##	      0.7 Inclusión de cambios en modelo Fase 1, cambios en interfaz y añadidos. También se ha añadido el Año de concesión y la Fecha de finalización de concesión del activo - HREOS-14545
--##	      0.8 Campos fiscalidad - HREOS-14672
--##        0.9 Se inserta si un activo pasa a tener Fecha de inscripción de título o al contrario - [HREOS-14686] - Daniel Algaba
--##        0.10 Campos Estado posesorio, Estado titularidad y Situación V.P.O.- [HREOS-14712] - Alejandra García
--##        0.11 Correciones Ocupado y Sin título, se añade el FLAG EN REM [HREOS-14837] -Daniel Algaba
--##        0.12 Correción Estado posesorio y rellenar campo SPS_VERTICAL- [HREOS-14824] - Alejandra García
--##        0.13 Se añade por defecto como Tipo Grado Propiedad Plen Dominio con el 100% - [HREOS-14649] - Daniel Algaba
--##	      0.14 Correcciones - HREOS-14820
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_BCR_06_POSESION_TITULO
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
   V_NUM_FILAS number;

   V_FECHA_INICIO VARCHAR2(100 CHAR);
   V_FECHA_FIN VARCHAR2(100 CHAR);

BEGIN

--1º Merge tabla ACT_TIT_TITULO

   SALIDA := '[INICIO]'||CHR(10);

   V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_ACT_SCM (
                  ACT_ID
                  , FECHA_CALCULO
               )
               SELECT
                  DISTINCT ACT.ACT_ID
                  , SYSDATE
               FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK APR
               JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
               JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON ACT.ACT_ID = TIT.ACT_ID AND TIT.BORRADO = 0
               WHERE (APR.FEC_INSC_TITULO IS NULL AND TIT.TIT_FECHA_INSC_REG IS NOT NULL
               OR APR.FEC_INSC_TITULO IS NOT NULL AND TIT.TIT_FECHA_INSC_REG IS NULL 
               OR TO_DATE(APR.FEC_INSC_TITULO,''yyyymmdd'') <> TIT.TIT_FECHA_INSC_REG)
               AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TMP_ACT_SCM SCM WHERE SCM.ACT_ID = ACT.ACT_ID)
               AND APR.FLAG_EN_REM = '||FLAG_EN_REM||'';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '[INFO] SE HAN INSERTADO '|| SQL%ROWCOUNT||' REGISTROS EN TMP_ACT_SCM CAMBIO DE FECHA INSCRIPCIÓN [INFO]'|| CHR(10);

   V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_ACT_SCM (
                  ACT_ID
                  , FECHA_CALCULO
               )
               SELECT
                  DISTINCT ACT.ACT_ID
                  , SYSDATE
               FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK APR
               JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
               JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON ACT.ACT_ID = SPS.ACT_ID AND SPS.BORRADO = 0
               WHERE (APR.FEC_VALIDO_DE IS NULL AND SPS.SPS_FECHA_TOMA_POSESION IS NOT NULL
               OR APR.FEC_VALIDO_DE IS NOT NULL AND SPS.SPS_FECHA_TOMA_POSESION IS NULL 
               OR TO_DATE(APR.FEC_VALIDO_DE,''yyyymmdd'') <> SPS.SPS_FECHA_TOMA_POSESION)
               AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TMP_ACT_SCM SCM WHERE SCM.ACT_ID = ACT.ACT_ID)
               AND APR.FLAG_EN_REM = '||FLAG_EN_REM||'';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '[INFO] SE HAN INSERTADO '|| SQL%ROWCOUNT||' REGISTROS EN TMP_ACT_SCM CAMBIO DE FECHA POSESIÓN [INFO]'|| CHR(10);

   V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_ACT_SCM (
                  ACT_ID
                  , FECHA_CALCULO
               )
               SELECT
               DISTINCT ACT.ACT_ID
               , SYSDATE
               FROM '||V_ESQUEMA||'.AUX_APR_BCR_STOCK APR
               JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = APR.NUM_IDENTIFICATIVO AND ACT.BORRADO = 0
               JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON ACT.ACT_ID = SPS.ACT_ID AND SPS.BORRADO = 0
               LEFT JOIN '||V_ESQUEMA||'.DD_TPA_TIPO_TITULO_ACT TPA ON SPS.DD_TPA_ID = TPA.DD_TPA_ID AND TPA.BORRADO = 0
               WHERE (APR.ESTADO_POSESORIO IN (''P01'', ''P06'', ''P05'') AND SPS.SPS_OCUPADO = 1
               OR APR.ESTADO_POSESORIO IN (''P02'', ''P03'',''P04'') AND SPS.SPS_OCUPADO = 0
               OR APR.ESTADO_POSESORIO IN (''P02'', ''P04'') AND NOT (SPS.SPS_OCUPADO = 1 AND TPA.DD_TPA_CODIGO = ''01'')
               OR APR.ESTADO_POSESORIO = ''P03'' AND NOT (SPS.SPS_OCUPADO = 1 AND TPA.DD_TPA_CODIGO = ''02''))
               AND NOT EXISTS (SELECT 1 FROM '||V_ESQUEMA||'.TMP_ACT_SCM SCM WHERE SCM.ACT_ID = ACT.ACT_ID)
               AND APR.FLAG_EN_REM = '||FLAG_EN_REM||'';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '[INFO] SE HAN INSERTADO '|| SQL%ROWCOUNT||' REGISTROS EN TMP_ACT_SCM POR CAMBIO DE ESTADO POSESORIO [INFO]'|| CHR(10);

   SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS DE POSESIÓN Y TÍTULO.'|| CHR(10);

   SALIDA := SALIDA || '   [INFO] 1 - ACT_TIT_TITULO'||CHR(10);

    V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_TIT_TITULO ACT
	USING (				
           SELECT 
                 TO_DATE(AUX.FEC_PRESENTACION_REGISTRO,''yyyymmdd'') AS TIT_FECHA_PRESENT1_REG
                ,TO_DATE(AUX.FEC_INSC_TITULO,''yyyymmdd'') AS TIT_FECHA_INSC_REG
                ,TO_DATE(AUX.FEC_PRESENTADO,''yyyymmdd'') AS TIT_FECHA_PRESENT2_REG
                ,ETI.DD_ETI_ID AS DD_ETI_ID 
                ,TO_DATE(AUX.FEC_ESTADO_TITULARIDAD,''yyyymmdd'') AS FECHA_EST_TIT_ACT_INM
                ,ACT2.ACT_ID AS ACT_ID 
            FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
            JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO AND ACT2.BORRADO=0
            LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''ESTADO_TITULARIDAD''  AND eqv1.DD_CODIGO_CAIXA = aux.ESTADO_TITULARIDAD AND EQV1.BORRADO=0
            LEFT JOIN '|| V_ESQUEMA ||'.DD_ETI_ESTADO_TITULO ETI ON ETI.DD_ETI_CODIGO = eqv1.DD_CODIGO_REM
            WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
            ) US ON (US.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0)
            WHEN MATCHED THEN UPDATE SET
                 ACT.TIT_FECHA_PRESENT1_REG = US.TIT_FECHA_PRESENT1_REG
                ,ACT.TIT_FECHA_INSC_REG = US.TIT_FECHA_INSC_REG
                ,ACT.TIT_FECHA_PRESENT2_REG = US.TIT_FECHA_PRESENT2_REG
                ,ACT.DD_ETI_ID = US.DD_ETI_ID
                ,ACT.FECHA_EST_TIT_ACT_INM = US.FECHA_EST_TIT_ACT_INM
                ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                ,ACT.FECHAMODIFICAR = SYSDATE
            WHEN NOT MATCHED THEN INSERT (
                 TIT_ID
                ,TIT_FECHA_PRESENT1_REG
                ,TIT_FECHA_INSC_REG
                ,TIT_FECHA_PRESENT2_REG
                ,DD_ETI_ID
                ,FECHA_EST_TIT_ACT_INM
                ,act_id     
                ,USUARIOCREAR  
                ,FECHACREAR             
                )VALUES(
                     '|| V_ESQUEMA ||'.S_ACT_TIT_TITULO.NEXTVAL
                    ,US.TIT_FECHA_PRESENT1_REG
                    ,US.TIT_FECHA_INSC_REG
                    ,US.TIT_FECHA_PRESENT2_REG
                    ,US.DD_ETI_ID
                    ,US.FECHA_EST_TIT_ACT_INM
                    ,us.act_id
                    ,''STOCK_BC''
                    ,SYSDATE
                )
   ';
   EXECUTE IMMEDIATE V_MSQL;
   

   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

--2º Merge tabla ACT_SPS_SIT_POSESORIA
   SALIDA := SALIDA || '   [INFO] 2 - ACT_SPS_SIT_POSESORIA'||CHR(10);

   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA ACT
      USING (				
            SELECT 
                   TO_DATE(AUX.FEC_VALIDO_DE,''yyyymmdd'') AS SPS_FECHA_TOMA_POSESION 
                  ,TO_DATE(AUX.FEC_ESTADO_POSESORIO,''yyyymmdd'') AS SPS_FECHA_REVISION_ESTADO
                  ,CASE
                     WHEN AUX.ESTADO_POSESORIO IN (''P02'',''P03'',''P04'') THEN 1
                   ELSE 0 END AS SPS_OCUPADO
                  ,CASE
                     WHEN AUX.ESTADO_POSESORIO IN (''P02'',''P04'') THEN (SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_TITULO_ACT WHERE DD_TPA_CODIGO=''01'')
                     WHEN AUX.ESTADO_POSESORIO=''P03'' THEN (SELECT DD_TPA_ID FROM '|| V_ESQUEMA ||'.DD_TPA_TIPO_TITULO_ACT WHERE DD_TPA_CODIGO=''02'')
                   ELSE NULL END AS DD_TPA_ID
                  ,CASE
                     WHEN AUX.ESTADO_POSESORIO=''P05'' THEN 1
                   ELSE 0 END AS SPS_VERTICAL
                  ,ACT2.ACT_ID AS ACT_ID
               FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
               JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT2.BORRADO=0
               WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
               ) US ON (US.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0)
               WHEN MATCHED THEN UPDATE SET
                   ACT.SPS_FECHA_TOMA_POSESION=US.SPS_FECHA_TOMA_POSESION
                  ,ACT.SPS_FECHA_REVISION_ESTADO=US.SPS_FECHA_REVISION_ESTADO
                  ,ACT.SPS_OCUPADO=US.SPS_OCUPADO
                  ,ACT.DD_TPA_ID=US.DD_TPA_ID
                  ,ACT.SPS_VERTICAL=US.SPS_VERTICAL
                  ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                  ,ACT.FECHAMODIFICAR = SYSDATE
               WHEN NOT MATCHED THEN INSERT (
                   SPS_ID
                  ,SPS_FECHA_TOMA_POSESION
                  ,SPS_FECHA_REVISION_ESTADO
                  ,ACT_ID
                  ,SPS_OCUPADO
                  ,DD_TPA_ID
                  ,SPS_VERTICAL
                  ,USUARIOCREAR  
                  ,FECHACREAR             
                  )VALUES(
                        '|| V_ESQUEMA ||'.S_ACT_SPS_SIT_POSESORIA.NEXTVAL
                     ,US.SPS_FECHA_TOMA_POSESION
                     ,US.SPS_FECHA_REVISION_ESTADO
                     ,US.ACT_ID
                     ,US.SPS_OCUPADO
                     ,US.DD_TPA_ID
                     ,US.SPS_VERTICAL
                     ,''STOCK_BC''
                     ,SYSDATE
                  )
   ';
   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

--3º Merge tabla ACT_PAC_PERIMETRO_ACTIVO

--Para dar de baja el activo
   SALIDA := SALIDA || '   [INFO] 3 - ACT_PAC_PERIMETRO_ACTIVO, PARA DAR DE BAJA EL ACTIVO'||CHR(10);

V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT
	USING (				
           SELECT 
                  TO_DATE(AUX.FEC_VALIDO_A,''yyyymmdd'') AS PAC_FECHA_GESTIONAR
                 ,TO_DATE(AUX.FEC_VALIDO_A,''yyyymmdd'') AS PAC_FECHA_COMERCIALIZAR
                 ,TO_DATE(AUX.FEC_VALIDO_A,''yyyymmdd'') AS PAC_FECHA_FORMALIZAR
                 ,TO_DATE(AUX.FEC_VALIDO_A,''yyyymmdd'') AS PAC_FECHA_PUBLICAR
                 ,TO_DATE(AUX.FEC_VALIDO_A,''yyyymmdd'') AS PAC_FECHA_ADMISION
                 ,TO_DATE(AUX.FEC_VALIDO_A,''yyyymmdd'') AS PAC_FECHA_GESTION_COMERCIAL
                 ,ACT2.ACT_ID AS ACT_ID
            FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
            JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO AND ACT2.BORRADO=0
                WHERE AUX.FEC_VALIDO_A IS NOT NULL
                AND AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
                AND NOT EXISTS (SELECT 1 FROM '|| V_ESQUEMA ||'.OFR_OFERTAS OFR 
                JOIN '|| V_ESQUEMA ||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID 
                JOIN '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 
                WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''01'' AND ACTO.ACT_ID = ACT2.ACT_ID)
            ) US ON (US.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0)
            WHEN MATCHED THEN UPDATE SET
                 ACT.PAC_INCLUIDO=0
                ,ACT.PAC_CHECK_GESTIONAR=0
                ,ACT.PAC_FECHA_GESTIONAR=US.PAC_FECHA_GESTIONAR
                ,ACT.PAC_CHECK_COMERCIALIZAR=0
                ,ACT.PAC_FECHA_COMERCIALIZAR=US.PAC_FECHA_COMERCIALIZAR
                ,ACT.PAC_CHECK_FORMALIZAR=0
                ,ACT.PAC_FECHA_FORMALIZAR=US.PAC_FECHA_FORMALIZAR
                ,ACT.PAC_CHECK_PUBLICAR=0
                ,ACT.PAC_FECHA_PUBLICAR=US.PAC_FECHA_PUBLICAR
                ,ACT.PAC_CHECK_ADMISION=0
                ,ACT.PAC_FECHA_ADMISION=US.PAC_FECHA_ADMISION
                ,ACT.PAC_CHECK_GESTION_COMERCIAL=0
                ,ACT.PAC_FECHA_GESTION_COMERCIAL=US.PAC_FECHA_GESTION_COMERCIAL
                ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                ,ACT.FECHAMODIFICAR = SYSDATE
            WHEN NOT MATCHED THEN INSERT (
                 PAC_ID
                ,PAC_INCLUIDO
                ,PAC_CHECK_GESTIONAR
                ,PAC_FECHA_GESTIONAR
                ,PAC_CHECK_COMERCIALIZAR
                ,PAC_FECHA_COMERCIALIZAR
                ,PAC_CHECK_FORMALIZAR
                ,PAC_FECHA_FORMALIZAR
                ,PAC_CHECK_PUBLICAR
                ,PAC_FECHA_PUBLICAR
                ,PAC_CHECK_ADMISION
                ,PAC_FECHA_ADMISION
                ,PAC_CHECK_GESTION_COMERCIAL
                ,PAC_FECHA_GESTION_COMERCIAL
                ,ACT_ID
                ,USUARIOCREAR  
                ,FECHACREAR             
                )VALUES(
                     '|| V_ESQUEMA ||'.S_ACT_PAC_PERIMETRO_ACTIVO.NEXTVAL
                    ,0
                    ,0
                    ,US.PAC_FECHA_GESTIONAR
                    ,0
                    ,US.PAC_FECHA_COMERCIALIZAR
                    ,0
                    ,US.PAC_FECHA_FORMALIZAR
                    ,0
                    ,US.PAC_FECHA_PUBLICAR
                    ,0
                    ,US.PAC_FECHA_ADMISION
                    ,0
                    ,US.PAC_FECHA_GESTION_COMERCIAL
                    ,US.ACT_ID
                    ,''STOCK_BC''
                    ,SYSDATE
                )
';
   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

--Cuando está campo motivo no comercial (Código motivo no comercialización)
   SALIDA := SALIDA || '   [INFO] 4 - ACT_PAC_PERIMETRO_ACTIVO, CUANDO HAY CAMPO MOTIVO_NO_COMERCIAL'||CHR(10);

V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT
	USING (				
           SELECT 
                  MEC.DD_MEC_DESCRIPCION AS PAC_MOT_EXCL_COMERCIALIZAR 
                 ,ACT2.ACT_ID AS ACT_ID
            FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
            JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO AND ACT2.BORRADO=0
            LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''MOTIVO_NO_COMERCIAL''  AND eqv1.DD_CODIGO_CAIXA = aux.MOTIVO_NO_COMERCIAL AND EQV1.BORRADO=0
            LEFT JOIN '|| V_ESQUEMA ||'.DD_MEC_MOTIVO_EXCLU_CAIXA MEC ON MEC.DD_MEC_CODIGO = eqv1.DD_CODIGO_REM
            WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
            ) US ON (US.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0)
            WHEN MATCHED THEN UPDATE SET
                 ACT.PAC_MOT_EXCL_COMERCIALIZAR=US.PAC_MOT_EXCL_COMERCIALIZAR
                ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                ,ACT.FECHAMODIFICAR = SYSDATE
            WHEN NOT MATCHED THEN INSERT (
                 PAC_ID
                ,PAC_MOT_EXCL_COMERCIALIZAR
                ,ACT_ID
                ,USUARIOCREAR  
                ,FECHACREAR             
                )VALUES(
                     '|| V_ESQUEMA ||'.S_ACT_PAC_PERIMETRO_ACTIVO.NEXTVAL
                    ,US.PAC_MOT_EXCL_COMERCIALIZAR
                    ,US.ACT_ID
                    ,''STOCK_BC''
                    ,SYSDATE
                )
';
   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);
 
--4º Merge tabla ACT_PAC_PROPIETARIO_ACTIVO

   SALIDA := SALIDA || '   [INFO] 5 - ACT_PAC_PROPIETARIO_ACTIVO'||CHR(10);

   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT
	USING (				
           SELECT 
                  TO_NUMBER(AUX.CUOTA)/100 AS PAC_PORC_PROPIEDAD
                 ,TGP.DD_TGP_ID AS DD_TGP_ID
                 ,ACT2.ACT_ID AS ACT_ID
                 ,PROP.PRO_ID AS PRO_ID
                 , AUX.ANYO_CONCESION PAC_ANYO_CONCES
                 , AUX.FEC_FIN_CONCESION PAC_FEC_FIN_CONCES
                 , PAC.PAC_ID
            FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
            JOIN ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT2.BORRADO=0
            LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''GRADO_PROPIEDAD''  AND eqv1.DD_CODIGO_CAIXA = aux.GRADO_PROPIEDAD and eqv1.BORRADO=0
            LEFT JOIN '|| V_ESQUEMA ||'.DD_TGP_TIPO_GRADO_PROPIEDAD TGP ON TGP.DD_TGP_CODIGO = eqv1.DD_CODIGO_REM
            JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv2 ON eqv2.DD_NOMBRE_CAIXA = ''SOCIEDAD_PATRIMONIAL''  AND eqv2.DD_CODIGO_CAIXA = aux.SOCIEDAD_PATRIMONIAL 
                                                            AND EQV2.DD_NOMBRE_REM=''ACT_PRO_PROPIETARIO'' and eqv2.BORRADO=0
            JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PROP ON PROP.PRO_DOCIDENTIF=eqv2.DD_CODIGO_REM
            LEFT JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO PAC ON ACT2.ACT_ID = PAC.ACT_ID AND PROP.PRO_ID = PAC.PRO_ID AND PAC.BORRADO = 0
            WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
            ) US ON (US.PAC_ID = ACT.PAC_ID)
            WHEN MATCHED THEN UPDATE SET
                 ACT.PAC_PORC_PROPIEDAD=US.PAC_PORC_PROPIEDAD
                ,ACT.DD_TGP_ID=US.DD_TGP_ID
                ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                ,ACT.FECHAMODIFICAR = SYSDATE
                , ACT.PAC_ANYO_CONCES = US.PAC_ANYO_CONCES
                , ACT.PAC_FEC_FIN_CONCES = US.PAC_FEC_FIN_CONCES
            WHEN NOT MATCHED THEN INSERT (
                 PAC_ID
                ,PRO_ID
                ,PAC_PORC_PROPIEDAD
                ,DD_TGP_ID
                ,ACT_ID
                ,USUARIOCREAR  
                ,FECHACREAR
                , PAC_ANYO_CONCES
                , PAC_FEC_FIN_CONCES             
                )VALUES(
                     '|| V_ESQUEMA ||'.S_ACT_PAC_PROPIETARIO_ACTIVO.NEXTVAL
                    ,US.PRO_ID
                    ,NVL(US.PAC_PORC_PROPIEDAD, 100)
                    ,NVL(US.DD_TGP_ID, (SELECT DD_TGP_ID FROM '|| V_ESQUEMA ||'.DD_TGP_TIPO_GRADO_PROPIEDAD WHERE DD_TGP_CODIGO = ''01''))
                    ,US.ACT_ID
                    ,''STOCK_BC''
                    ,SYSDATE
                    , US.PAC_ANYO_CONCES
                    , US.PAC_FEC_FIN_CONCES
                )
';
   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);
--5º Merge tabla ACT_PAC_PROPIETARIO_ACTIVO
   SALIDA := SALIDA || '   [INFO] 6 - ACT_ACTIVO_CAIXA'||CHR(10);

   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO_CAIXA ACT
               USING (				
                     SELECT 
                            SOR.DD_SOR_ID AS DD_SOR_ID
                           ,BOR.DD_BOR_ID AS DD_BOR_ID
                           ,ACT2.ACT_ID AS ACT_ID
                           , CA.CBX_ID
                        FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                        JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT2.BORRADO=0
                        LEFT JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO_CAIXA CA ON CA.ACT_ID = ACT2.ACT_ID AND CA.BORRADO = 0
                        LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv2 ON eqv2.DD_NOMBRE_CAIXA = ''SOCIEDAD_ORIGEN''  AND eqv2.DD_CODIGO_CAIXA = aux.SOCIEDAD_ORIGEN and eqv2.BORRADO=0
                        LEFT JOIN '|| V_ESQUEMA ||'.DD_SOR_SOCIEDAD_ORIGEN SOR ON SOR.DD_SOR_CODIGO=eqv2.DD_CODIGO_REM
                        LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''BANCO_ORIGEN''  AND eqv1.DD_CODIGO_CAIXA = aux.BANCO_ORIGEN and eqv1.BORRADO=0
                        LEFT JOIN '|| V_ESQUEMA ||'.DD_BOR_BANCO_ORIGEN BOR ON BOR.DD_BOR_CODIGO = eqv1.DD_CODIGO_REM
                        WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
                        ) US ON (US.CBX_ID = ACT.CBX_ID)
                        WHEN MATCHED THEN UPDATE SET
                            ACT.DD_SOR_ID=US.DD_SOR_ID
                           ,ACT.DD_BOR_ID=US.DD_BOR_ID
                           ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                           ,ACT.FECHAMODIFICAR = SYSDATE
                        WHEN NOT MATCHED THEN INSERT (
                            CBX_ID
                           ,ACT_ID
                           ,DD_SOR_ID
                           ,DD_BOR_ID
                           ,USUARIOCREAR  
                           ,FECHACREAR             
                           )VALUES(
                              '|| V_ESQUEMA ||'.S_ACT_ACTIVO_CAIXA.NEXTVAL
                              ,US.ACT_ID
                              ,US.DD_SOR_ID
                              ,US.DD_BOR_ID
                              ,''STOCK_BC''
                              ,SYSDATE
                           )
   ';
   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);
    
   IF FLAG_EN_REM = 1 THEN
   SALIDA := SALIDA || '   [INFO] 7 - PASAMOS NUEVOS ACTIVOS A FORMALIZADOS'||CHR(10);
   SALIDA := SALIDA || '      [INFO] 1 - ACT_PAC_PERIMETRO_ACTIVO'||CHR(10);
   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                	 USING (				
                     	 SELECT ACT.ACT_ID AS ACT_ID
                        FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                        JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT.BORRADO=0
                        WHERE ACT.ACT_EN_TRAMITE = 1 AND AUX.FLAG_FICHEROS = ''I'' AND (AUX.FEC_VALIDO_A IS NULL OR TO_DATE(AUX.FEC_VALIDO_A, ''yyyymmdd'') > TRUNC(SYSDATE)) 
                        )US ON (US.ACT_ID = PAC.ACT_ID)
                        WHEN MATCHED THEN UPDATE SET
		         PAC.PAC_CHECK_GESTIONAR=1
              ,PAC.PAC_FECHA_GESTIONAR=SYSDATE
		        ,PAC.PAC_CHECK_COMERCIALIZAR=1
              ,PAC.PAC_FECHA_COMERCIALIZAR=SYSDATE
		        ,PAC.PAC_CHECK_FORMALIZAR=1
              ,PAC.PAC_FECHA_FORMALIZAR=SYSDATE
		        ,PAC.PAC_CHECK_PUBLICAR=1
              ,PAC.PAC_FECHA_PUBLICAR=SYSDATE
		        ,PAC.PAC_CHECK_ADMISION=1
              ,PAC.PAC_FECHA_ADMISION=SYSDATE
              ,PAC.PAC_CHECK_GESTION_COMERCIAL=1
              ,PAC.PAC_FECHA_GESTION_COMERCIAL=SYSDATE
                	,PAC.USUARIOMODIFICAR = ''STOCK_BC''
                	,PAC.FECHAMODIFICAR = SYSDATE';
                
   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

   SALIDA := SALIDA || '      [INFO] 2 - ACT_ACTIVO'||CHR(10);                        
    V_MSQL :=           'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                        USING (				
                        SELECT ACT.ACT_ID AS ACT_ID
                        FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                        JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO  AND ACT.BORRADO=0
                        WHERE ACT.ACT_EN_TRAMITE = 1 AND AUX.FLAG_FICHEROS = ''I'' AND (AUX.FEC_VALIDO_A IS NULL OR TO_DATE(AUX.FEC_VALIDO_A, ''yyyymmdd'') > TRUNC(SYSDATE))
                        )US ON (US.ACT_ID = ACT.ACT_ID)
                        WHEN MATCHED THEN UPDATE SET
                        ACT_EN_TRAMITE = 0
                       ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                       ,ACT.FECHAMODIFICAR = SYSDATE';
                       
   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

   SALIDA := SALIDA || '   [INFO] 8 - PASAMOS NUEVOS ACTIVOS A EN TRÁMITE'||CHR(10);

   SALIDA := SALIDA || '      [INFO] 1 - ACT_PAC_PERIMETRO_ACTIVO'||CHR(10);    
   V_MSQL :=            'MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                        USING (				
                        SELECT ACT.ACT_ID AS ACT_ID
                        FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                        JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT.BORRADO=0
                        WHERE ACT.ACT_EN_TRAMITE = 0 AND AUX.FLAG_FICHEROS = ''P'' AND (AUX.FEC_VALIDO_A IS NULL OR TO_DATE(AUX.FEC_VALIDO_A, ''yyyymmdd'') > TRUNC(SYSDATE))
                        ) US ON (US.ACT_ID = PAC.ACT_ID)
                        WHEN MATCHED THEN UPDATE SET
                        PAC.PAC_CHECK_GESTIONAR=0
                        ,PAC.PAC_FECHA_GESTIONAR=SYSDATE
                        ,PAC.PAC_CHECK_COMERCIALIZAR=0
                        ,PAC.PAC_FECHA_COMERCIALIZAR=SYSDATE
                        ,PAC.PAC_CHECK_FORMALIZAR=0
                        ,PAC.PAC_FECHA_FORMALIZAR=SYSDATE
                        ,PAC.PAC_CHECK_PUBLICAR=0
                        ,PAC.PAC_FECHA_PUBLICAR=SYSDATE
                        ,PAC.PAC_CHECK_ADMISION=0
                        ,PAC.PAC_FECHA_ADMISION=SYSDATE
                        ,PAC.PAC_CHECK_GESTION_COMERCIAL=0
                        ,PAC.PAC_FECHA_GESTION_COMERCIAL=SYSDATE
                        ,PAC.USUARIOMODIFICAR = ''STOCK_BC''
                        ,PAC.FECHAMODIFICAR = SYSDATE';
                        
   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

   SALIDA := SALIDA || '      [INFO] 2 - ACT_ACTIVO'||CHR(10);  
                        
   V_MSQL :=            'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                        USING (				
                        SELECT ACT.ACT_ID AS ACT_ID
                        FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                        JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT.BORRADO=0
                        WHERE ACT.ACT_EN_TRAMITE = 0 AND AUX.FLAG_FICHEROS = ''P'' AND (AUX.FEC_VALIDO_A IS NULL OR TO_DATE(AUX.FEC_VALIDO_A, ''yyyymmdd'') > TRUNC(SYSDATE))
                        ) US ON (US.ACT_ID = ACT.ACT_ID)
                        WHEN MATCHED THEN UPDATE SET
                         ACT_EN_TRAMITE = 1
                        ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                        ,ACT.FECHAMODIFICAR = SYSDATE';
                        
   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);
   
   ELSIF  FLAG_EN_REM = 0 THEN
   
   SALIDA := SALIDA || '   [INFO] 9 - ACTUALIZAMOS ACTIVOS A EN TRÁMITE'||CHR(10);

   SALIDA := SALIDA || '      [INFO] 1 - ACT_PAC_PERIMETRO_ACTIVO'||CHR(10);
   V_MSQL :=  		 'MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
               	 USING (				
                        SELECT ACT.ACT_ID AS ACT_ID
                        FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                        JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT.BORRADO=0
                        WHERE AUX.FLAG_EN_REM=0 AND AUX.FLAG_FICHEROS = ''P'' 
                        ) US ON (US.ACT_ID = PAC.ACT_ID)
                        WHEN MATCHED THEN UPDATE SET
                        PAC.PAC_INCLUIDO=1
                        ,PAC.PAC_CHECK_GESTIONAR=1
                        ,PAC.PAC_FECHA_GESTIONAR=SYSDATE
                        ,PAC.USUARIOMODIFICAR = ''STOCK_BC''
                        ,PAC.FECHAMODIFICAR = SYSDATE';
 
   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);
                        
   SALIDA := SALIDA || '      [INFO] 2 - ACT_ACTIVO'||CHR(10);
                           
   V_MSQL :=            'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
               	 USING (				
                     	 SELECT ACT.ACT_ID AS ACT_ID
                        FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                        JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT.BORRADO=0
                        WHERE AUX.FLAG_EN_REM=0 AND AUX.FLAG_FICHEROS = ''P''
                        ) US ON (US.ACT_ID = ACT.ACT_ID)
                        WHEN MATCHED THEN UPDATE SET
		         ACT.ACT_EN_TRAMITE = 1
                        ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                        ,ACT.FECHAMODIFICAR = SYSDATE';
                       
   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

   SALIDA := SALIDA || '   [INFO] 10 - ACTUALIZAMOS ACTIVOS A FORMALIZADOS'||CHR(10);

   SALIDA := SALIDA || '      [INFO] 1 - ACT_PAC_PERIMETRO_ACTIVO'||CHR(10);

    V_MSQL :=           'MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC
                        USING (				
                        SELECT ACT.ACT_ID AS ACT_ID
                        FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                        JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT.BORRADO=0
                        WHERE AUX.FLAG_FICHEROS = ''I'' AND AUX.FLAG_EN_REM = 0
                        ) US ON (US.ACT_ID = PAC.ACT_ID)
                        WHEN MATCHED THEN UPDATE SET
                        PAC.PAC_CHECK_GESTIONAR=1
                        ,PAC.PAC_FECHA_GESTIONAR=SYSDATE
                        ,PAC.PAC_CHECK_COMERCIALIZAR=1
                        ,PAC.PAC_FECHA_COMERCIALIZAR=SYSDATE
                        ,PAC.PAC_CHECK_FORMALIZAR=1
                        ,PAC.PAC_FECHA_FORMALIZAR=SYSDATE
                        ,PAC.PAC_CHECK_PUBLICAR=1
                        ,PAC.PAC_FECHA_PUBLICAR=SYSDATE
                        ,PAC.PAC_CHECK_ADMISION=1
                        ,PAC.PAC_FECHA_ADMISION=SYSDATE
                        ,PAC.PAC_CHECK_GESTION_COMERCIAL=1
                        ,PAC.PAC_FECHA_GESTION_COMERCIAL=SYSDATE
                        ,PAC.USUARIOMODIFICAR = ''STOCK_BC''
                        ,PAC.FECHAMODIFICAR = SYSDATE';
                       
   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

   SALIDA := SALIDA || '      [INFO] 2 - ACT_PAC_PERIMETRO_ACTIVO'||CHR(10);
                        
   V_MSQL :=            'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                        USING (				
                        SELECT ACT.ACT_ID AS ACT_ID
                        FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                        JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT.BORRADO=0
                        WHERE AUX.FLAG_FICHEROS = ''I'' AND AUX.FLAG_EN_REM = 0
                        ) US ON (US.ACT_ID = ACT.ACT_ID)
                        WHEN MATCHED THEN UPDATE SET
                         ACT_EN_TRAMITE = 0
                        ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                        ,ACT.FECHAMODIFICAR = SYSDATE';
                       
   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);
   
   END IF;


--6º Merge tabla ACT_FAD_FISCALIDAD_ADQUISICION
   SALIDA := SALIDA || '   [INFO] 11 - ACT_FAD_FISCALIDAD_ADQUISICION'||CHR(10);

   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_FAD_FISCALIDAD_ADQUISICION ACT
               USING (		
                  WITH CODIGOS AS
                  (SELECT 
                        *
                     FROM(
                        SELECT 
                           ''TIPO_IMPUESTO_COMPRA'' AS DD_NOMBRE_CAIXA  
                           , DD_CODIGO_CAIXA
                           , DD_NOMBRE_REM
                           , DD_CODIGO_REM
                        FROM '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM
                        WHERE DD_NOMBRE_CAIXA = ''TIPO_IMPUESTO_COMPRA'' AND BORRADO = 0
                     ) EQV
                     PIVOT(
                        MAX(DD_CODIGO_REM)
                        FOR DD_NOMBRE_REM IN (''DD_TIC_TIPO_IMPUESTO_COMPRA'' AS DD_TIC_TIPO_IMPUESTO_COMPRA
                                                , ''DD_POI_PORCENTAJE_IMPUESTO'' AS DD_POI_PORCENTAJE_IMPUESTO
                                                , ''DD_SIN_SINO_DEDU'' AS FAD_DEDUCIBLE
                                                , ''DD_SIN_SINO_BON'' AS FAD_BONIFICADO
                                                , ''FAD_COD_TP_IVA_COMPRA'' AS FAD_COD_TP_IVA_COMPRA
                                                , ''DD_SIN_SINO_EXE'' AS FAD_RENUNCIA_EXENCION )
                        
                     ) P   
                  )	
                  SELECT
                     FAD.FAD_ID
                     , ACT2.ACT_ID AS ACT_ID
                     , TIC.DD_TIC_ID AS DD_TIC_ID
                     , DEDUC.DD_SIN_ID AS FAD_DEDUCIBLE
                     , CASE
                           WHEN COD.DD_TIC_TIPO_IMPUESTO_COMPRA IS NOT NULL THEN (SELECT DD_TII_ID FROM '|| V_ESQUEMA ||'.DD_TII_TIPO_IMP_IVA_IGIC WHERE DD_TII_CODIGO = ''01'')
                           ELSE NULL
                        END AS DD_TII_ID
                     , CASE
                           WHEN COD.DD_TIC_TIPO_IMPUESTO_COMPRA IS NOT NULL THEN (SELECT DD_TIA_ID FROM '|| V_ESQUEMA ||'.DD_TIA_TIPO_IMP_AJD_ITP WHERE DD_TIA_CODIGO = ''01'')
                           ELSE NULL
                        END AS DD_TIA_ID
                     , BON.DD_SIN_ID  AS FAD_BONIFICADO
                     , POI.DD_POI_DESCRIPCION AS FAD_PORCENTAJE_IMPUESTO_COMPRA 
                     , NULL AS FAD_COD_TP_IVA_COMPRA
                     , EXE.DD_SIN_ID AS FAD_RENUNCIA_EXENCION
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX                             
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO AND ACT2.BORRADO = 0
                  LEFT JOIN '|| V_ESQUEMA ||'.ACT_FAD_FISCALIDAD_ADQUISICION FAD ON FAD.ACT_ID = ACT2.ACT_ID AND FAD.BORRADO = 0
                  LEFT JOIN CODIGOS COD ON COD.DD_CODIGO_CAIXA = AUX.TIPO_IMPUESTO_COMPRA
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_TIC_TIPO_IMPUESTO_COMPRA TIC ON TIC.DD_TIC_CODIGO = COD.DD_TIC_TIPO_IMPUESTO_COMPRA
                  LEFT JOIN '|| V_ESQUEMA_M ||'.DD_SIN_SINO DEDUC ON DEDUC.DD_SIN_CODIGO = COD.FAD_DEDUCIBLE            
                  LEFT JOIN '|| V_ESQUEMA ||'.DD_POI_PORCENTAJE_IMPUESTO POI ON POI.DD_POI_CODIGO = COD.DD_POI_PORCENTAJE_IMPUESTO
                  LEFT JOIN '|| V_ESQUEMA_M ||'.DD_SIN_SINO BON ON BON.DD_SIN_CODIGO = COD.FAD_BONIFICADO
                  LEFT JOIN '|| V_ESQUEMA_M ||'.DD_SIN_SINO EXE ON EXE.DD_SIN_CODIGO = COD.FAD_RENUNCIA_EXENCION
                  WHERE AUX.FLAG_EN_REM = '|| FLAG_EN_REM||') AUX
                  ON (ACT.FAD_ID = AUX.FAD_ID )
                                    WHEN MATCHED THEN UPDATE SET
                                       ACT.DD_TIC_ID = AUX.DD_TIC_ID
                                       , ACT.FAD_DEDUCIBLE = AUX.FAD_DEDUCIBLE
                                       , ACT.DD_TII_ID = AUX.DD_TII_ID
                                       , ACT.DD_TIA_ID = AUX.DD_TIA_ID
                                       , ACT.FAD_BONIFICADO = AUX.FAD_BONIFICADO
                                       , ACT.FAD_PORCENTAJE_IMPUESTO_COMPRA = AUX.FAD_PORCENTAJE_IMPUESTO_COMPRA
                                       , ACT.FAD_COD_TP_IVA_COMPRA = AUX.FAD_COD_TP_IVA_COMPRA
                                       , ACT.FAD_RENUNCIA_EXENCION = AUX.FAD_RENUNCIA_EXENCION
                                       , ACT.USUARIOMODIFICAR = ''STOCK_BC''
                                       , ACT.FECHAMODIFICAR = SYSDATE
                                       WHEN NOT MATCHED THEN INSERT  
                                          (FAD_ID
                                          , ACT_ID
                                          , DD_TIC_ID
                                          , FAD_DEDUCIBLE
                                          , DD_TII_ID
                                          , DD_TIA_ID
                                          , FAD_BONIFICADO
                                          , FAD_PORCENTAJE_IMPUESTO_COMPRA
                                          , FAD_COD_TP_IVA_COMPRA
                                          , FAD_RENUNCIA_EXENCION
                                          , USUARIOCREAR
                                          , FECHACREAR)
                                          VALUES 
                                          ('|| V_ESQUEMA ||'.S_ACT_FAD_FISCALIDAD_ADQUISICION.NEXTVAL
                                          , AUX.ACT_ID                                        
                                          , AUX.DD_TIC_ID
                                          , AUX.FAD_DEDUCIBLE
                                          , AUX.DD_TII_ID
                                          , AUX.DD_TIA_ID
                                          , AUX.FAD_BONIFICADO
                                          , AUX.FAD_PORCENTAJE_IMPUESTO_COMPRA
                                          , AUX.FAD_COD_TP_IVA_COMPRA
                                          , AUX.FAD_RENUNCIA_EXENCION
                                          , ''STOCK_BC''
                                          , SYSDATE)
   ';
   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

      SALIDA := SALIDA || '      [INFO] 3 - ACT_ACTIVO'||CHR(10);
                           
   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
               USING (				
                  SELECT 
                      ACT.ACT_ID AS ACT_ID
                     ,CASE
                        WHEN AUX.SITUACION_VPO IN (''00001'') THEN 0
                        WHEN AUX.SITUACION_VPO IN (''00002'') THEN 1
                        WHEN AUX.SITUACION_VPO IN (''00003'') THEN 1
                        WHEN AUX.SITUACION_VPO IN (''00004'') THEN 1
                        WHEN AUX.SITUACION_VPO IN (''00005'') THEN 1
                      END AS ACT_VPO
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT.BORRADO=0
                  WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM ||'
                  ) US ON (US.ACT_ID = ACT.ACT_ID)
                  WHEN MATCHED THEN UPDATE SET
                      ACT.ACT_VPO = US.ACT_VPO
                     ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                     ,ACT.FECHAMODIFICAR = SYSDATE
                  ';
                       
   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

   SALIDA := SALIDA || '      [INFO] 1 - ACT_ADM_INF_ADMINISTRATIVA'||CHR(10);
                           
   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ADM_INF_ADMINISTRATIVA ACT
               USING (				
                  SELECT 
                      ACT.ACT_ID AS ACT_ID
                     ,CASE
                        WHEN AUX.SITUACION_VPO=''00003'' THEN 0
                        WHEN AUX.SITUACION_VPO=''00004'' THEN 1
                      END AS ADM_ACTUALIZA_PRECIO_MAX
                     ,CASE
                        WHEN AUX.SITUACION_VPO=''00002'' THEN 1
                        WHEN AUX.SITUACION_VPO IN (''00003'',''00004'',''00005'') THEN 0
                      END AS ADM_DESCALIFICADO
                     ,CASE
                        WHEN AUX.SITUACION_VPO=''00005'' THEN 0
                        WHEN AUX.SITUACION_VPO IN (''00003'',''00004'',''00002'') THEN 1
                      END AS ADM_LIBERTAD_CESION
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT.BORRADO=0
                  WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM ||'
                  ) US ON (US.ACT_ID = ACT.ACT_ID)
                  WHEN MATCHED THEN UPDATE SET
                      ACT.ADM_ACTUALIZA_PRECIO_MAX = US.ADM_ACTUALIZA_PRECIO_MAX
                     ,ACT.ADM_DESCALIFICADO = US.ADM_DESCALIFICADO
                     ,ACT.ADM_LIBERTAD_CESION = US.ADM_LIBERTAD_CESION
                     ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                     ,ACT.FECHAMODIFICAR = SYSDATE
                  WHEN NOT MATCHED THEN 
                  INSERT  
                     ( ADM_ID
                     , ACT_ID
                     , ADM_ACTUALIZA_PRECIO_MAX
                     , ADM_DESCALIFICADO
                     , ADM_LIBERTAD_CESION
                     , USUARIOCREAR
                     , FECHACREAR)
                  VALUES 
                     ('|| V_ESQUEMA ||'.S_ACT_ADM_INF_ADMINISTRATIVA.NEXTVAL
                     , US.ACT_ID                                        
                     , US.ADM_ACTUALIZA_PRECIO_MAX
                     , US.ADM_DESCALIFICADO
                     , US.ADM_LIBERTAD_CESION
                     , ''STOCK_BC''
                     , SYSDATE)
                  ';
   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);
                       
   SALIDA := SALIDA || '      [INFO] 1 - ACT_AHT_HIST_TRAM_TITULO'||CHR(10);
                           
   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_AHT_HIST_TRAM_TITULO T1
                USING (
                    WITH ACT_HIST AS (
                            SELECT 
                                 HIST.TIT_ID
                                ,HIST.AHT_ID
                                ,ESP.DD_ESP_CODIGO
                                ,HIST.AHT_FECHA_PRES_REGISTRO
                                ,HIST.AHT_FECHA_INSCRIPCION
                                ,HIST.AHT_FECHA_CALIFICACION
                                ,ROW_NUMBER() OVER(PARTITION BY TIT_ID ORDER BY AHT_ID DESC) RN
                            FROM '|| V_ESQUEMA ||'.ACT_AHT_HIST_TRAM_TITULO HIST
                            JOIN '|| V_ESQUEMA ||'.DD_ESP_ESTADO_PRESENTACION ESP ON ESP.DD_ESP_ID=HIST.DD_ESP_ID
                            WHERE HIST.BORRADO=0
                        ), ACT_RECIENTE AS (
                            SELECT  
                                 TIT_ID
                                ,AHT_ID
                                ,DD_ESP_CODIGO
                                ,AHT_FECHA_PRES_REGISTRO
                                ,AHT_FECHA_INSCRIPCION
                                ,AHT_FECHA_CALIFICACION
                            FROM ACT_HIST
                            WHERE RN = 1 
                        )
                        SELECT  
                            CASE 
                                WHEN ETI.DD_ETI_CODIGO=''01'' AND REC.DD_ESP_CODIGO=''02'' AND AUX.FEC_ESTADO_TITULARIDAD IS NOT NULL AND AUX.FEC_ESTADO_TITULARIDAD !=''00000000''
                                    THEN TO_DATE(AUX.FEC_ESTADO_TITULARIDAD,''yyyymmdd'')
                                WHEN AUX.FEC_ESTADO_TITULARIDAD IS NOT NULL AND AUX.FEC_ESTADO_TITULARIDAD !=''00000000''
                                    THEN COALESCE(REC.AHT_FECHA_PRES_REGISTRO,TO_DATE(AUX.FEC_ESTADO_TITULARIDAD,''yyyymmdd'')) 
                            END AS AHT_FECHA_PRES_REGISTRO
                            ,CASE
                                WHEN ETI.DD_ETI_CODIGO=''02'' AND AUX.FEC_ESTADO_TITULARIDAD IS NOT NULL AND AUX.FEC_ESTADO_TITULARIDAD !=''00000000'' 
                                    THEN COALESCE(REC.AHT_FECHA_INSCRIPCION,TO_DATE(AUX.FEC_ESTADO_TITULARIDAD,''yyyymmdd''))
                                ELSE NULL
                            END AS AHT_FECHA_INSCRIPCION
                            ,CASE
                                WHEN ETI.DD_ETI_CODIGO=''06'' AND AUX.FEC_ESTADO_TITULARIDAD IS NOT NULL AND AUX.FEC_ESTADO_TITULARIDAD !=''00000000'' 
                                    THEN COALESCE(REC.AHT_FECHA_CALIFICACION,TO_DATE(AUX.FEC_ESTADO_TITULARIDAD,''yyyymmdd''))
                                ELSE NULL
                            END AS AHT_FECHA_CALIFICACION
                            ,TIT.TIT_ID AS TIT_ID
                            ,CASE       
                                WHEN ETI.DD_ETI_CODIGO=''01'' AND REC.AHT_ID IS NULL THEN NULL  
                                WHEN ETI.DD_ETI_CODIGO=''01'' AND REC.DD_ESP_CODIGO=''02'' THEN NULL 
                                WHEN ETI.DD_ETI_CODIGO=''02'' AND REC.AHT_ID IS NULL THEN NULL                
                                WHEN ETI.DD_ETI_CODIGO=''02'' AND REC.DD_ESP_CODIGO=''01'' THEN REC.AHT_ID  
                                WHEN ETI.DD_ETI_CODIGO=''02'' AND REC.DD_ESP_CODIGO=''02'' THEN NULL  
                                WHEN ETI.DD_ETI_CODIGO=''02'' AND REC.DD_ESP_CODIGO=''03'' THEN REC.AHT_ID  
                                WHEN ETI.DD_ETI_CODIGO=''06'' AND (REC.AHT_ID IS NULL OR REC.DD_ESP_CODIGO=''03'') THEN NULL             
                                WHEN ETI.DD_ETI_CODIGO=''06'' AND REC.DD_ESP_CODIGO=''01'' THEN REC.AHT_ID 
                            END AS AHT_ID
                            ,CASE
                                WHEN ETI.DD_ETI_CODIGO=''02'' THEN ''03''
                                WHEN ETI.DD_ETI_CODIGO=''01'' THEN ''01''
                                WHEN ETI.DD_ETI_CODIGO=''06'' THEN ''02''
                            END AS DD_ESP_CODIGO
                           ,AHT.FECHAMODIFICAR AS FECHAMODIFICAR
                        FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                        JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT.BORRADO=0
                        JOIN '|| V_ESQUEMA ||'.ACT_TIT_TITULO TIT ON ACT.ACT_ID=TIT.ACT_ID AND TIT.BORRADO=0
                        JOIN '|| V_ESQUEMA ||'.DD_ETI_ESTADO_TITULO ETI ON ETI.DD_ETI_ID=TIT.DD_ETI_ID
                        LEFT JOIN ACT_RECIENTE REC ON REC.TIT_ID=TIT.TIT_ID
                        JOIN '|| V_ESQUEMA ||'.ACT_AHT_HIST_TRAM_TITULO AHT ON TIT.TIT_ID=AHT.TIT_ID
                        WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM ||' 
                    ) T2 ON (T1.AHT_ID = T2.AHT_ID)
                    WHEN MATCHED THEN UPDATE SET
                          T1.DD_ESP_ID=(SELECT DD_ESP_ID FROM '|| V_ESQUEMA ||'.DD_ESP_ESTADO_PRESENTACION WHERE DD_ESP_CODIGO=T2.DD_ESP_CODIGO)
                        , T1.AHT_FECHA_PRES_REGISTRO = T2.AHT_FECHA_PRES_REGISTRO
                        , T1.AHT_FECHA_INSCRIPCION = T2.AHT_FECHA_INSCRIPCION
                        , T1.AHT_FECHA_CALIFICACION = T2.AHT_FECHA_CALIFICACION
                        , T1.USUARIOMODIFICAR = ''STOCK_BC''
                        , T1.FECHAMODIFICAR = COALESCE(T2.FECHAMODIFICAR,SYSDATE)
                    WHEN NOT MATCHED THEN 
                    INSERT  
                        ( AHT_ID
                        , TIT_ID
                        , AHT_FECHA_PRES_REGISTRO
                        , AHT_FECHA_INSCRIPCION
                        , AHT_FECHA_CALIFICACION
                        , DD_ESP_ID
                        , USUARIOCREAR
                        , FECHACREAR)
                    VALUES 
                        ('|| V_ESQUEMA ||'.S_ACT_AHT_HIST_TRAM_TITULO.NEXTVAL
                        , T2.TIT_ID
                        , T2.AHT_FECHA_PRES_REGISTRO
                        , T2.AHT_FECHA_INSCRIPCION
                        , T2.AHT_FECHA_CALIFICACION
                        , (SELECT DD_ESP_ID FROM '|| V_ESQUEMA ||'.DD_ESP_ESTADO_PRESENTACION WHERE DD_ESP_CODIGO=T2.DD_ESP_CODIGO)
                        , ''STOCK_BC''
                        , SYSDATE)
                  ';   

   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

   SALIDA := SALIDA || '      [INFO] 1 - ACT_PTA_PATRIMONIO_ACTIVO'||CHR(10);
   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_PTA_PATRIMONIO_ACTIVO ACT
               USING (				
                  SELECT 
                      SPS.ACT_ID AS ACT_ID
                     ,CASE
                        WHEN AUX.ESTADO_POSESORIO IN (''P01'',''P03'',''P05'',''P06'') THEN NULL
                        WHEN AUX.ESTADO_POSESORIO IN (''P02'',''P04'') THEN (SELECT DD_EAL_ID FROM '|| V_ESQUEMA ||'.DD_EAL_ESTADO_ALQUILER WHERE DD_EAL_CODIGO=''02'')
                      END AS DD_EAL_ID
                  FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                  JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT.BORRADO=0
                  JOIN '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA SPS ON ACT.ACT_ID=SPS.ACT_ID
                  WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM ||'
                  ) US ON (US.ACT_ID = ACT.ACT_ID)
                  WHEN MATCHED THEN UPDATE SET
                      ACT.DD_EAL_ID = US.DD_EAL_ID
                     ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                     ,ACT.FECHAMODIFICAR = SYSDATE
                  ';
   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '      [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

         V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TMP_ACT_SCM (
                  ACT_ID
                  , FECHA_CALCULO
               )
               SELECT
                  DISTINCT ACT2.ACT_ID
                  , SYSDATE
               FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
               JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO AND ACT2.BORRADO=0
                  WHERE AUX.FEC_VALIDO_A IS NOT NULL
                  AND AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
                  AND NOT EXISTS (SELECT 1 FROM '|| V_ESQUEMA ||'.OFR_OFERTAS OFR 
                  JOIN '|| V_ESQUEMA ||'.ACT_OFR ACTO ON OFR.OFR_ID = ACTO.OFR_ID 
                  JOIN '|| V_ESQUEMA ||'.DD_EOF_ESTADOS_OFERTA EOF ON OFR.DD_EOF_ID = EOF.DD_EOF_ID AND EOF.BORRADO = 0 
                  WHERE OFR.BORRADO = 0 AND EOF.DD_EOF_CODIGO = ''01'' AND ACTO.ACT_ID = ACT2.ACT_ID)';

   EXECUTE IMMEDIATE V_MSQL;

   SALIDA := SALIDA || '[INFO] SE HAN INSERTADO '|| SQL%ROWCOUNT||' REGISTROS EN TMP_ACT_SCM POR ACTIVOS DADOS DE BAJA [INFO]'|| CHR(10);
                   

COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      SALIDA := SALIDA || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      SALIDA := SALIDA || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_BCR_06_POSESION_TITULO;
/
EXIT;
