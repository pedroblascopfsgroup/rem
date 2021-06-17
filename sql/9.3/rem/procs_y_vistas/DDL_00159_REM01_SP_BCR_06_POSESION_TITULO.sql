--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210617
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14344
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - HREOS-14163 - Alejandra García (20210603)
--##        0.2 Cambiar FLAG_INS_UPD por FLAG_EN_REM y añadirlo como condición en cada merge  - HREOS-14163 - Alejandra García (20210604)
--##        0.3 Revisión - [HREOS-14344] - Alejandra García
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
   DBMS_OUTPUT.PUT_LINE('[INFO] 1 MERGE A LA TABLA ACT_TIT_TITULO.');

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
   

   V_NUM_FILAS := sql%rowcount;
   DBMS_OUTPUT.PUT_LINE('##INFO: ' || V_NUM_FILAS ||' FUSIONADAS') ;
    commit;

--2º Merge tabla ACT_SPS_SIT_POSESORIA
   DBMS_OUTPUT.PUT_LINE('[INFO] 2 MERGE A LA TABLA ACT_SPS_SIT_POSESORIA.');

   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_SPS_SIT_POSESORIA ACT
      USING (				
            SELECT 
                   TO_DATE(AUX.FEC_VALIDO_DE,''yyyymmdd'') AS SPS_FECHA_TOMA_POSESION 
                  ,TPO.DD_TPO_ID AS  DD_TPO_ID
                  ,TO_DATE(AUX.FEC_ESTADO_POSESORIO,''yyyymmdd'') AS SPS_FECHA_REVISION_ESTADO
                  ,CASE 
                     WHEN AUX.IND_OCUPANTES_VIVIENDA IN (''S'',''1'') THEN 1
                     WHEN AUX.IND_OCUPANTES_VIVIENDA IN (''N'',''0'') THEN 0
                     END AS SPS_OCUPADO
                  ,ACT2.ACT_ID AS ACT_ID
               FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
               JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT2.BORRADO=0
               LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''ESTADO_POSESORIO''  AND eqv1.DD_CODIGO_CAIXA = aux.ESTADO_POSESORIO AND EQV1.BORRADO=0
               LEFT JOIN '|| V_ESQUEMA ||'.DD_TPO_TIPO_TITULO_POSESORIO TPO ON TPO.DD_TPO_CODIGO = eqv1.DD_CODIGO_REM 
               WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
               ) US ON (US.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0)
               WHEN MATCHED THEN UPDATE SET
                  ACT.SPS_FECHA_TOMA_POSESION=US.SPS_FECHA_TOMA_POSESION
                  ,ACT.DD_TPO_ID=US.DD_TPO_ID
                  ,ACT.SPS_FECHA_REVISION_ESTADO=US.SPS_FECHA_REVISION_ESTADO
                  ,ACT.SPS_OCUPADO=US.SPS_OCUPADO
                  ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                  ,ACT.FECHAMODIFICAR = SYSDATE
               WHEN NOT MATCHED THEN INSERT (
                  SPS_ID
                  ,SPS_FECHA_TOMA_POSESION
                  ,DD_TPO_ID
                  ,SPS_FECHA_REVISION_ESTADO
                  ,SPS_OCUPADO
                  ,ACT_ID
                  ,USUARIOCREAR  
                  ,FECHACREAR             
                  )VALUES(
                        '|| V_ESQUEMA ||'.S_ACT_SPS_SIT_POSESORIA.NEXTVAL
                     ,US.SPS_FECHA_TOMA_POSESION
                     ,US.DD_TPO_ID
                     ,US.SPS_FECHA_REVISION_ESTADO
                     ,US.SPS_OCUPADO
                     ,US.ACT_ID
                     ,''STOCK_BC''
                     ,SYSDATE
                  )
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   DBMS_OUTPUT.PUT_LINE('##INFO: ' || V_NUM_FILAS ||' FUSIONADAS') ;
    commit;

--3º Merge tabla ACT_PAC_PERIMETRO_ACTIVO

--Para dar de baja el activo
DBMS_OUTPUT.PUT_LINE('[INFO] 3 MERGE A LA TABLA ACT_PAC_PERIMETRO_ACTIVO, PARA DAR DE BAJA EL ACTIVO.');

V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO ACT
	USING (				
           SELECT 
                  TO_DATE(AUX.FEC_VALIDO_A,''yyyymmdd'') AS PAC_FECHA_GESTIONAR
                 ,TO_DATE(AUX.FEC_VALIDO_A,''yyyymmdd'') AS PAC_FECHA_COMERCIALIZAR
                 ,TO_DATE(AUX.FEC_VALIDO_A,''yyyymmdd'') AS PAC_FECHA_FORMALIZAR
                 ,TO_DATE(AUX.FEC_VALIDO_A,''yyyymmdd'') AS PAC_FECHA_PUBLICAR
                 ,TO_DATE(AUX.FEC_VALIDO_A,''yyyymmdd'') AS PAC_FECHA_ADMISION
                 ,ACT2.ACT_ID AS ACT_ID
            FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
            JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO AND ACT2.BORRADO=0
                WHERE AUX.FEC_VALIDO_A IS NOT NULL
                AND AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
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
                    ,US.ACT_ID
                    ,''STOCK_BC''
                    ,SYSDATE
                )
';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   DBMS_OUTPUT.PUT_LINE('##INFO: ' || V_NUM_FILAS ||' FUSIONADAS') ;
    commit;

--Cuando está campo motivo no comercial (Código motivo no comercialización)
DBMS_OUTPUT.PUT_LINE('[INFO] 4 MERGE A LA TABLA ACT_PAC_PERIMETRO_ACTIVO, CUANDO HAY CAMPO MOTIVO_NO_COMERCIAL.');

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

   V_NUM_FILAS := sql%rowcount;
   DBMS_OUTPUT.PUT_LINE('##INFO: ' || V_NUM_FILAS ||' FUSIONADAS') ;
    commit;
 
--4º Merge tabla ACT_PAC_PROPIETARIO_ACTIVO

   DBMS_OUTPUT.PUT_LINE('[INFO] 5 MERGE A LA TABLA ACT_PAC_PROPIETARIO_ACTIVO.');

   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT
	USING (				
           SELECT 
                  TO_NUMBER(AUX.CUOTA)/100 AS PAC_PORC_PROPIEDAD
                 ,TGP.DD_TGP_ID AS DD_TGP_ID
                 ,ACT2.ACT_ID AS ACT_ID
                 ,PROP.PRO_ID AS PRO_ID
            FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
            JOIN ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT2.BORRADO=0
            LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''GRADO_PROPIEDAD''  AND eqv1.DD_CODIGO_CAIXA = aux.GRADO_PROPIEDAD and eqv1.BORRADO=0
            LEFT JOIN '|| V_ESQUEMA ||'.DD_TGP_TIPO_GRADO_PROPIEDAD TGP ON TGP.DD_TGP_CODIGO = eqv1.DD_CODIGO_REM
            JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv2 ON eqv2.DD_NOMBRE_CAIXA = ''SOCIEDAD_PATRIMONIAL''  AND eqv2.DD_CODIGO_CAIXA = aux.SOCIEDAD_PATRIMONIAL 
                                                            AND EQV2.DD_NOMBRE_REM=''ACT_PRO_PROPIETARIO'' and eqv2.BORRADO=0
            JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PROP ON PROP.PRO_DOCIDENTIF=eqv2.DD_CODIGO_REM
            WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
            ) US ON (US.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0)
            WHEN MATCHED THEN UPDATE SET
                 ACT.PAC_PORC_PROPIEDAD=US.PAC_PORC_PROPIEDAD
                ,ACT.DD_TGP_ID=US.DD_TGP_ID
                ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                ,ACT.FECHAMODIFICAR = SYSDATE
            WHEN NOT MATCHED THEN INSERT (
                 PAC_ID
                ,PRO_ID
                ,PAC_PORC_PROPIEDAD
                ,DD_TGP_ID
                ,ACT_ID
                ,USUARIOCREAR  
                ,FECHACREAR             
                )VALUES(
                     '|| V_ESQUEMA ||'.S_ACT_PAC_PROPIETARIO_ACTIVO.NEXTVAL
                    ,US.PRO_ID
                    ,US.PAC_PORC_PROPIEDAD
                    ,US.DD_TGP_ID
                    ,US.ACT_ID
                    ,''STOCK_BC''
                    ,SYSDATE
                )
';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   DBMS_OUTPUT.PUT_LINE('##INFO: ' || V_NUM_FILAS ||' FUSIONADAS') ;
    commit;

--5º Merge tabla ACT_PAC_PROPIETARIO_ACTIVO

   DBMS_OUTPUT.PUT_LINE('[INFO] 6 MERGE A LA TABLA ACT_ACTIVO_CAIXA.');

   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_ACTIVO_CAIXA ACT
               USING (				
                     SELECT 
                            SOR.DD_SOR_ID AS DD_SOR_ID
                           ,BOR.DD_BOR_ID AS DD_BOR_ID
                           ,ACT2.ACT_ID AS ACT_ID
                        FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX
                        JOIN ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA=AUX.NUM_IDENTIFICATIVO  AND ACT2.BORRADO=0
                        LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv2 ON eqv2.DD_NOMBRE_CAIXA = ''SOCIEDAD_ORIGEN''  AND eqv2.DD_CODIGO_CAIXA = aux.SOCIEDAD_ORIGEN and eqv2.BORRADO=0
                        LEFT JOIN '|| V_ESQUEMA ||'.DD_SOR_SOCIEDAD_ORIGEN SOR ON SOR.DD_SOR_CODIGO=eqv2.DD_CODIGO_REM
                        LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''BANCO_ORIGEN''  AND eqv1.DD_CODIGO_CAIXA = aux.BANCO_ORIGEN and eqv1.BORRADO=0
                        LEFT JOIN '|| V_ESQUEMA ||'.DD_BOR_BANCO_ORIGEN BOR ON BOR.DD_BOR_CODIGO = eqv1.DD_CODIGO_REM
                        WHERE AUX.FLAG_EN_REM='|| FLAG_EN_REM||'
                        ) US ON (US.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0)
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

   V_NUM_FILAS := sql%rowcount;
   DBMS_OUTPUT.PUT_LINE('##INFO: ' || V_NUM_FILAS ||' FUSIONADAS') ;
    commit;

--6º Merge tabla ACT_FAD_FISCALIDAD_ADQUISICION

   DBMS_OUTPUT.PUT_LINE('[INFO] 7 MERGE A LA TABLA ACT_FAD_FISCALIDAD_ADQUISICION.');

   V_MSQL := 'MERGE INTO '|| V_ESQUEMA ||'.ACT_FAD_FISCALIDAD_ADQUISICION ACT
               USING (		

                     SELECT
                         AUX.NUM_IDENTIFICATIVO AS ACT_NUM_ACTIVO_CAIXA
                        ,ACT2.ACT_ID AS ACT_ID   
                        ,TIC.DD_TIC_ID AS DD_TIC_ID
                        ,SIC.DD_SIC_ID AS DD_SIC_ID
                        ,TO_NUMBER(AUX.PORC_IMPUESTO_COMPRA)/100 AS FAD_PORCENTAJE_IMPUESTO_COMPRA 
                        ,AUX.COD_TP_IVA_COMPRA AS FAD_COD_TP_IVA_COMPRA 
                        ,AUX.RENUNCIA_EXENSION AS FAD_RENUNCIA_EXENCION     
                     FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK AUX                             
                     JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT2 ON ACT2.ACT_NUM_ACTIVO_CAIXA = AUX.NUM_IDENTIFICATIVO AND ACT2.BORRADO=0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''TIPO_IMPUESTO_COMPRA''  AND eqv1.DD_CODIGO_CAIXA = aux.TIPO_IMPUESTO_COMPRA AND EQV1.BORRADO=0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_TIC_TIPO_IMPUESTO_COMPRA TIC ON TIC.DD_TIC_CODIGO = eqv1.DD_CODIGO_REM
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv1 ON eqv1.DD_NOMBRE_CAIXA = ''SUBTIPO_IMPUESTO_COMPRA''  AND eqv1.DD_CODIGO_CAIXA = aux.SUBTIPO_IMPUESTO_COMPRA AND EQV1.BORRADO=0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_SIC_SUBTIPO_IMPUESTO_COMPRA SIC ON SIC.DD_SIC_CODIGO = eqv1.DD_CODIGO_REM
                     WHERE AUX.FLAG_EN_REM = '|| FLAG_EN_REM ||'        
                     ) US ON (US.ACT_ID = ACT.ACT_ID )
                     WHEN MATCHED THEN UPDATE SET
                         ACT.DD_TIC_ID=US.DD_TIC_ID
                        ,ACT.DD_SIC_ID=US.DD_SIC_ID
                        ,ACT.FAD_PORCENTAJE_IMPUESTO_COMPRA=US.FAD_PORCENTAJE_IMPUESTO_COMPRA
                        ,ACT.FAD_COD_TP_IVA_COMPRA=US.FAD_COD_TP_IVA_COMPRA
                        ,ACT.FAD_RENUNCIA_EXENCION=US.FAD_RENUNCIA_EXENCION
                        ,ACT.USUARIOMODIFICAR = ''STOCK_BC''
                        ,ACT.FECHAMODIFICAR = SYSDATE
                        WHEN NOT MATCHED THEN INSERT  (
                                  FAD_ID                                   
                                 ,ACT_ID
                                 ,DD_TIC_ID
                                 ,DD_SIC_ID
                                 ,FAD_PORCENTAJE_IMPUESTO_COMPRA
                                 ,FAD_COD_TP_IVA_COMPRA
                                 ,FAD_RENUNCIA_EXENCION                    
                                 ,USUARIOCREAR
                                 ,FECHACREAR
                           )VALUES ( 
                                  '|| V_ESQUEMA ||'.S_ACT_FAD_FISCALIDAD_ADQUISICION.NEXTVAL
                                 ,US.ACT_ID                                        
                                 ,US.DD_TIC_ID
                                 ,US.DD_SIC_ID
                                 ,US.FAD_PORCENTAJE_IMPUESTO_COMPRA
                                 ,US.FAD_COD_TP_IVA_COMPRA
                                 ,US.FAD_RENUNCIA_EXENCION
                                 ,''STOCK_BC''
                                 ,SYSDATE
                           )
   ';
   EXECUTE IMMEDIATE V_MSQL;

   V_NUM_FILAS := sql%rowcount;
   DBMS_OUTPUT.PUT_LINE('##INFO: ' || V_NUM_FILAS ||' FUSIONADAS') ;
    commit;


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
