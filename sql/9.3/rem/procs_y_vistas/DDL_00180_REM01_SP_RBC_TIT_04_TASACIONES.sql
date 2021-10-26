--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211026
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15969
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Se cambian los NIFs de titulizados - [HREOS-15634] - Daniel Algaba
--##        0.3 Se añaden los campos reción creados y los mapeos necesarios - [HREOS-15894] - Daniel Algaba
--##        0.4 Se cambia la cartera por la nuevo Titulizada - [HREOS-15634] - Daniel Algaba
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						



CREATE OR REPLACE PROCEDURE SP_RBC_TIT_04_TASACIONES
	( FLAG_EN_REM IN NUMBER,
   SALIDA OUT VARCHAR2, 
	COD_RETORNO OUT NUMBER)

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

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A EXTRAER LAS TASACIONES'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - EXTRACCIÓN DE CAMPOS DE TASACIÓN'||CHR(10);

      V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_TIT_STOCK RBC_TIT
				USING (				                 
                  SELECT       
                     ACT.ACT_NUM_ACTIVO_CAIXA as NUM_IDENTIFICATIVO   
                     , TASACION.TASADORA                    
                     , TASACION.FEC_TASACION                
                     , TASACION.GASTO_COM_TASACION          
                     , TASACION.IMP_TAS_INTEGRO             
                     , TASACION.REF_ID_TASADORA             
                     , TASACION.TIPO_VAL_EST_TASACION       
                     , TASACION.FLAG_PORC_COSTE_DEFECTO     
                     , TASACION.APROV_PARCELA               
                     , TASACION.DESAROLLO_PLANT             
                     , TASACION.FASE_GESTION                
                     , TASACION.ACO_NORMATIVA               
                     , TASACION.NUM_VIVIENDAS               
                     , TASACION.PORC_AMB_VALORADO           
                     , TASACION.PRODUCTO_DESAR              
                     , TASACION.PROX_NUCLEO_URB             
                     , TASACION.SISTEMA_GESTION             
                     , TASACION.SUPERFICIE_ADOPTADA         
                     , TASACION.SUPERFICIE_PARCELA          
                     , TASACION.SUPERFICIE                  
                     , TASACION.TIPO_SUELO_TAS              
                     , TASACION.VAL_HIP_EDI_TERM_PROM       
                     , TASACION.ADVERTENCIAS                
                     , TASACION.APROVECHAMIENTO             
                     , TASACION.COD_SOCIEDAD_TAS            
                     , TASACION.CONDICIONANTES              
                     , TASACION.COST_EST_TER_OBRA           
                     , TASACION.COST_DEST_USO_PROPIO        
                     , TASACION.FEC_ULT_GRA_AVANCA_EST      
                     , TASACION.FEC_EST_TER_OBRA            
                     , TASACION.FINCA_RUS_EXP_URB           
                     , TASACION.MET_VALORACION              
                     , TASACION.PLA_MAX_IN_COM              
                     , TASACION.PLA_MAX_IN_CON              
                     , TASACION.TASA_ANU_HOMOGENEA          
                     , TASACION.TIPO_ACTUALIZACION          
                     , TASACION.MARGEN_BEN_PROMOTOR         
                     , TASACION.PARALIZACION_URB            
                     , TASACION.PORC_URB_EJECUTADO          
                     , TASACION.PORC_AMBITO_VAL             
                     , TASACION.PRODUCTO_DESA               
                     , TASACION.PROYECTO_OBRA               
                     , TASACION.SUPERFICIE_TERRENO          
                     , TASACION.TASA_ANU_MED_VAR_PRECIO     
                     , TASACION.TIPO_DAT_INM_COMPARABLES    
                     , TASACION.VAL_TERRENO                 
                     , TASACION.VAL_TERRENO_AJUSTADO        
                     , TASACION.VAL_HIP_EDI_TERMINADO       
                     , TASACION.VAL_HIPOTECARIO             
                     , TASACION.VISITA_INT_INMUEBLE 
                     FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT_PRO ON ACT_PRO.ACT_ID = ACT.ACT_ID AND ACT_PRO.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = ACT_PRO.PRO_ID AND PRO.BORRADO = 0
                     JOIN (SELECT
                     TAS.ACT_ID
                     , ROW_NUMBER() OVER (PARTITION BY TAS.ACT_ID ORDER BY TAS.TAS_ID DESC) RN
                     , SUBSTR(TAS.TAS_NOMBRE_TASADOR, 0, 10) TASADORA                    
                     , TO_CHAR(TAS.TAS_FECHA_RECEPCION_TASACION,''YYYYMMDD'') FEC_TASACION                
                     , TAS.GASTO_COM_TASACION*100 GASTO_COM_TASACION          
                     , TAS.TAS_IMPORTE_TAS_FIN*100 IMP_TAS_INTEGRO             
                     , TAS.REF_TASADORA REF_ID_TASADORA             
                     , NULL /*TTS.DD_TTS_CODIGO*/ TIPO_VAL_EST_TASACION   
                     , CASE WHEN TAS.PORC_COSTE_DEFECTO = 1 THEN ''S'' ELSE ''N'' END FLAG_PORC_COSTE_DEFECTO     
                     , TAS.APROV_PARCELA_SUELO APROV_PARCELA               
                     , EQV1.DD_CODIGO_CAIXA DESAROLLO_PLANT             
                     , EQV2.DD_CODIGO_CAIXA FASE_GESTION                
                     , CASE WHEN TAS.ACOGIDA_NORMATIVA = 1 THEN ''S'' ELSE ''N'' END ACO_NORMATIVA               
                     , TAS.NUM_VIVIENDAS NUM_VIVIENDAS               
                     , TAS.PORC_AMBITO_VAL*100 PORC_AMB_VALORADO           
                     , EQV3.DD_CODIGO_CAIXA PRODUCTO_DESAR              
                     , EQV4.DD_CODIGO_CAIXA PROX_NUCLEO_URB             
                     , EQV5.DD_CODIGO_CAIXA SISTEMA_GESTION             
                     , TAS.SUPERFICIE_ADOPTADA SUPERFICIE_ADOPTADA         
                     , NULL SUPERFICIE_PARCELA          
                     , NULL SUPERFICIE                  
                     , EQV9.DD_CODIGO_CAIXA TIPO_SUELO_TAS              
                     , TAS.VAL_HIPO_EDI_TERM_PROM*100 VAL_HIP_EDI_TERM_PROM       
                     , CASE WHEN TAS.ADVERTENCIAS = 1 THEN ''S'' ELSE ''N'' END ADVERTENCIAS                
                     , TAS.APROVECHAMIENTO APROVECHAMIENTO             
                     , TAS.COD_SOCIEDAD_TAS_VAL COD_SOCIEDAD_TAS            
                     , CASE WHEN TAS.CONDICIONANTES = 1 THEN ''S'' ELSE ''N'' END CONDICIONANTES              
                     , TAS.COSTE_EST_TER_OBRA COST_EST_TER_OBRA           
                     , TAS.COSTE_DEST_PROPIO COST_DEST_USO_PROPIO        
                     , TO_CHAR(TAS.FEC_ULT_AVANCE_EST,''YYYYMMDD'') FEC_ULT_GRA_AVANCA_EST      
                     , TO_CHAR(TAS.FEC_EST_TER_OBRA,''YYYYMMDD'') FEC_EST_TER_OBRA            
                     , CASE WHEN TAS.FINCA_RUS_EXP_URB = 1 THEN ''S'' ELSE ''N'' END FINCA_RUS_EXP_URB           
                     , EQV6.DD_CODIGO_CAIXA MET_VALORACION              
                     , TAS.MET_RES_DIN_MAX_COM PLA_MAX_IN_COM              
                     , TAS.MET_RES_DIN_MAX_CONS PLA_MAX_IN_CON              
                     , TAS.MET_RES_DIN_TAS_ANU TASA_ANU_HOMOGENEA          
                     , TAS.MET_RES_DIN_TIPO_ACT TIPO_ACTUALIZACION          
                     , TAS.MET_RES_EST_MAR_PROM MARGEN_BEN_PROMOTOR         
                     , CASE WHEN TAS.PARALIZACION_URB = 1 THEN ''S'' ELSE ''N'' END PARALIZACION_URB            
                     , TAS.PORC_URB_EJECUTADO PORC_URB_EJECUTADO          
                     , TAS.PORC_AMBITO_VAL_ENT PORC_AMBITO_VAL             
                     , EQV8.DD_CODIGO_CAIXA PRODUCTO_DESA               
                     , CASE WHEN TAS.PROYECTO_OBRA = 1 THEN ''S'' ELSE ''N'' END PROYECTO_OBRA               
                     , TAS.SUPERFICIE_TERRENO SUPERFICIE_TERRENO          
                     , TAS.TAS_ANU_VAR_MERCADO TASA_ANU_MED_VAR_PRECIO     
                     , EQV7.DD_CODIGO_CAIXA TIPO_DAT_INM_COMPARABLES    
                     , TAS.VALOR_TERRENO VAL_TERRENO                 
                     , TAS.VALOR_TERRENO_AJUS VAL_TERRENO_AJUSTADO        
                     , TAS.VAL_HIPO_EDI_TERM VAL_HIP_EDI_TERMINADO       
                     , TAS.VALOR_HIPOTECARIO VAL_HIPOTECARIO             
                     , CASE WHEN TAS.VISITA_ANT_INMUEBLE = 1 THEN ''S'' ELSE ''N'' END VISITA_INT_INMUEBLE 
                     FROM '|| V_ESQUEMA ||'.ACT_TAS_TASACION TAS
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_TTS_TIPO_TASACION TTS ON TAS.DD_TTS_ID = TTS.DD_TTS_ID AND TTS.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_DSP_DESARROLLO_PLANTEAMIENTO DSP ON DSP.DD_DSP_ID = TAS.DD_DSP_ID AND DSP.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_TIT_CAIXA_REM EQV1 ON EQV1.DD_NOMBRE_CAIXA = ''DESA_PLANTEMIENTO'' AND EQV1.DD_CODIGO_REM = DSP.DD_DSP_CODIGO AND EQV1.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_FSG_FASE_GESTION FSG ON FSG.DD_FSG_ID = TAS.DD_FSG_ID AND FSG.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_TIT_CAIXA_REM EQV2 ON EQV2.DD_NOMBRE_CAIXA = ''FASE_GESTION'' AND EQV2.DD_CODIGO_REM = FSG.DD_FSG_CODIGO AND EQV2.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_PRD_PRODUCTO_DESARROLLAR PRD ON PRD.DD_PRD_ID = TAS.DD_PRD_ID AND PRD.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_TIT_CAIXA_REM EQV3 ON EQV3.DD_NOMBRE_CAIXA = ''PRODUCTO_DESARROLLAR'' AND EQV3.DD_CODIGO_REM = PRD.DD_PRD_CODIGO AND EQV3.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_PNU_PROX_RESP_NUCLEO_URB PNU ON PNU.DD_PNU_ID = TAS.DD_PNU_ID AND PNU.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_TIT_CAIXA_REM EQV4 ON EQV4.DD_NOMBRE_CAIXA = ''PROX_RESPECT_NUCLEO_URB'' AND EQV4.DD_CODIGO_REM = PNU.DD_PNU_CODIGO AND EQV4.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_SGT_SISTEMA_GESTION SGT ON SGT.DD_SGT_ID = TAS.DD_SGT_ID AND SGT.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_TIT_CAIXA_REM EQV5 ON EQV5.DD_NOMBRE_CAIXA = ''SISTEMA_GESTION'' AND EQV5.DD_CODIGO_REM = SGT.DD_SGT_CODIGO AND EQV5.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_MTV_METODO_VALORACION MTV ON MTV.DD_MTV_ID = TAS.DD_MTV_ID AND MTV.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_TIT_CAIXA_REM EQV6 ON EQV6.DD_NOMBRE_CAIXA = ''METODO_VALORACION'' AND EQV6.DD_CODIGO_REM = MTV.DD_MTV_CODIGO AND EQV6.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_TDU_TIPO_DAT_UTI_INM_COMP TDU ON TDU.DD_TDU_ID = TAS.DD_TDU_ID AND TDU.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_TIT_CAIXA_REM EQV7 ON EQV7.DD_NOMBRE_CAIXA = ''TIPO_DAT_UTI_INM_COMPARABLES'' AND EQV7.DD_CODIGO_REM = TDU.DD_TDU_CODIGO AND EQV7.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_PRD_PRODUCTO_DESARROLLAR PRD_PREV ON PRD_PREV.DD_PRD_ID = TAS.DD_PRD_ID_PREV AND PRD_PREV.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_TIT_CAIXA_REM EQV8 ON EQV8.DD_NOMBRE_CAIXA = ''PRODUCTO_DESARROLLAR'' AND EQV8.DD_CODIGO_REM = PRD_PREV.DD_PRD_CODIGO AND EQV8.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_SAC_SUBTIPO_ACTIVO SAC_SUELO ON SAC_SUELO.DD_SAC_ID = TAS.DD_SAC_ID AND SAC_SUELO.BORRADO = 0
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_TIT_CAIXA_REM EQV9 ON EQV9.DD_NOMBRE_CAIXA = ''SUBTIPO_SUELO'' AND EQV9.DD_CODIGO_REM = SAC_SUELO.DD_SAC_CODIGO AND EQV9.BORRADO = 0
                     WHERE TAS.BORRADO = 0) TASACION ON RN = 1 AND TASACION.ACT_ID = ACT.ACT_ID
                     WHERE ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                     --AND ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''18'')
                     AND ACT.BORRADO = 0
                     AND PAC.PAC_INCLUIDO = 1
                     --AND ACT.ACT_EN_TRAMITE = 0
                     AND PRO.PRO_DOCIDENTIF IN (''V84966126'',''V85164648'',''V85587434'',''V84322205'',''V84593961'',''V84669332'',''V85082675'',''V85623668'',''V84856319'',''V85500866'',''V85143659'',''V85594927'',''V85981231'',''V84889229'',''V84916956'',''V85160935'',''V85295087'',''V84175744'',''V84925569'',''V84054840'')
                  ) AUX ON (RBC_TIT.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
                  WHEN MATCHED THEN UPDATE SET
                     RBC_TIT.TASADORA = AUX.TASADORA
                     , RBC_TIT.FEC_TASACION = AUX.FEC_TASACION                
                     , RBC_TIT.GASTO_COM_TASACION = AUX.GASTO_COM_TASACION          
                     , RBC_TIT.IMP_TAS_INTEGRO = AUX.IMP_TAS_INTEGRO             
                     , RBC_TIT.REF_ID_TASADORA = AUX.REF_ID_TASADORA             
                     , RBC_TIT.TIPO_VAL_EST_TASACION = AUX.TIPO_VAL_EST_TASACION       
                     , RBC_TIT.FLAG_PORC_COSTE_DEFECTO = AUX.FLAG_PORC_COSTE_DEFECTO     
                     , RBC_TIT.APROV_PARCELA = AUX.APROV_PARCELA               
                     , RBC_TIT.DESAROLLO_PLANT = AUX.DESAROLLO_PLANT             
                     , RBC_TIT.FASE_GESTION = AUX.FASE_GESTION                
                     , RBC_TIT.ACO_NORMATIVA = AUX.ACO_NORMATIVA               
                     , RBC_TIT.NUM_VIVIENDAS = AUX.NUM_VIVIENDAS               
                     , RBC_TIT.PORC_AMB_VALORADO = AUX.PORC_AMB_VALORADO          
                     , RBC_TIT.PRODUCTO_DESAR = AUX.PRODUCTO_DESAR              
                     , RBC_TIT.PROX_NUCLEO_URB = AUX.PROX_NUCLEO_URB             
                     , RBC_TIT.SISTEMA_GESTION = AUX.SISTEMA_GESTION             
                     , RBC_TIT.SUPERFICIE_ADOPTADA = AUX.SUPERFICIE_ADOPTADA         
                     , RBC_TIT.SUPERFICIE_PARCELA = AUX.SUPERFICIE_PARCELA          
                     , RBC_TIT.SUPERFICIE = AUX.SUPERFICIE                  
                     , RBC_TIT.TIPO_SUELO_TAS = AUX.TIPO_SUELO_TAS              
                     , RBC_TIT.VAL_HIP_EDI_TERM_PROM = AUX.VAL_HIP_EDI_TERM_PROM       
                     , RBC_TIT.ADVERTENCIAS = AUX.ADVERTENCIAS                
                     , RBC_TIT.APROVECHAMIENTO = AUX.APROVECHAMIENTO             
                     , RBC_TIT.COD_SOCIEDAD_TAS = AUX.COD_SOCIEDAD_TAS            
                     , RBC_TIT.CONDICIONANTES = AUX.CONDICIONANTES              
                     , RBC_TIT.COST_EST_TER_OBRA = AUX.COST_EST_TER_OBRA           
                     , RBC_TIT.COST_DEST_USO_PROPIO = AUX.COST_DEST_USO_PROPIO        
                     , RBC_TIT.FEC_ULT_GRA_AVANCA_EST = AUX.FEC_ULT_GRA_AVANCA_EST      
                     , RBC_TIT.FEC_EST_TER_OBRA = AUX.FEC_EST_TER_OBRA            
                     , RBC_TIT.FINCA_RUS_EXP_URB = AUX.FINCA_RUS_EXP_URB           
                     , RBC_TIT.MET_VALORACION = AUX.MET_VALORACION              
                     , RBC_TIT.PLA_MAX_IN_COM = AUX.PLA_MAX_IN_COM              
                     , RBC_TIT.PLA_MAX_IN_CON = AUX.PLA_MAX_IN_CON              
                     , RBC_TIT.TASA_ANU_HOMOGENEA = AUX.TASA_ANU_HOMOGENEA          
                     , RBC_TIT.TIPO_ACTUALIZACION = AUX.TIPO_ACTUALIZACION          
                     , RBC_TIT.MARGEN_BEN_PROMOTOR = AUX.MARGEN_BEN_PROMOTOR         
                     , RBC_TIT.PARALIZACION_URB = AUX.PARALIZACION_URB            
                     , RBC_TIT.PORC_URB_EJECUTADO = AUX.PORC_URB_EJECUTADO          
                     , RBC_TIT.PORC_AMBITO_VAL = AUX.PORC_AMBITO_VAL             
                     , RBC_TIT.PRODUCTO_DESA = AUX.PRODUCTO_DESA               
                     , RBC_TIT.PROYECTO_OBRA = AUX.PROYECTO_OBRA               
                     , RBC_TIT.SUPERFICIE_TERRENO = AUX.SUPERFICIE_TERRENO          
                     , RBC_TIT.TASA_ANU_MED_VAR_PRECIO = AUX.TASA_ANU_MED_VAR_PRECIO     
                     , RBC_TIT.TIPO_DAT_INM_COMPARABLES = AUX.TIPO_DAT_INM_COMPARABLES    
                     , RBC_TIT.VAL_TERRENO = AUX.VAL_TERRENO                 
                     , RBC_TIT.VAL_TERRENO_AJUSTADO = AUX.VAL_TERRENO_AJUSTADO        
                     , RBC_TIT.VAL_HIP_EDI_TERMINADO = AUX.VAL_HIP_EDI_TERMINADO       
                     , RBC_TIT.VAL_HIPOTECARIO = AUX.VAL_HIPOTECARIO             
                     , RBC_TIT.VISITA_INT_INMUEBLE = AUX.VISITA_INT_INMUEBLE';

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
END SP_RBC_TIT_04_TASACIONES;
/
EXIT;
