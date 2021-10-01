--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211001
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15217
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
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
                     JOIN '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK BCR ON ACT.ACT_NUM_ACTIVO_CAIXA = BCR.NUM_IDENTIFICATIVO
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT_PRO ON ACT_PRO.ACT_ID = ACT.ACT_ID AND ACT_PRO.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = ACT_PRO.PRO_ID AND PRO.BORRADO = 0
                     JOIN (SELECT
                     TAS.ACT_ID
                     , ROW_NUMBER() OVER (PARTITION BY TAS.ACT_ID ORDER BY TAS.TAS_ID DESC) RN
                     , SUBSTR(TAS.TAS_NOMBRE_TASADOR, 0, 10) TASADORA                    
                     , TO_CHAR(TAS.TAS_FECHA_RECEPCION_TASACION,''YYYYMMDD'') FEC_TASACION                
                     , NULL GASTO_COM_TASACION          
                     , TAS.TAS_IMPORTE_TAS_FIN*100 IMP_TAS_INTEGRO             
                     , NULL REF_ID_TASADORA             
                     , NULL /*TTS.DD_TTS_CODIGO*/ TIPO_VAL_EST_TASACION   
                     , NULL FLAG_PORC_COSTE_DEFECTO     
                     , NULL APROV_PARCELA               
                     , NULL DESAROLLO_PLANT             
                     , NULL FASE_GESTION                
                     , NULL ACO_NORMATIVA               
                     , NULL NUM_VIVIENDAS               
                     , NULL PORC_AMB_VALORADO           
                     , NULL PRODUCTO_DESAR              
                     , NULL PROX_NUCLEO_URB             
                     , NULL SISTEMA_GESTION             
                     , NULL SUPERFICIE_ADOPTADA         
                     , NULL SUPERFICIE_PARCELA          
                     , NULL SUPERFICIE                  
                     , NULL TIPO_SUELO_TAS              
                     , NULL VAL_HIP_EDI_TERM_PROM       
                     , NULL ADVERTENCIAS                
                     , NULL APROVECHAMIENTO             
                     , NULL COD_SOCIEDAD_TAS            
                     , NULL CONDICIONANTES              
                     , NULL COST_EST_TER_OBRA           
                     , NULL COST_DEST_USO_PROPIO        
                     , NULL FEC_ULT_GRA_AVANCA_EST      
                     , NULL FEC_EST_TER_OBRA            
                     , NULL FINCA_RUS_EXP_URB           
                     , NULL MET_VALORACION              
                     , NULL PLA_MAX_IN_COM              
                     , NULL PLA_MAX_IN_CON              
                     , NULL TASA_ANU_HOMOGENEA          
                     , NULL TIPO_ACTUALIZACION          
                     , NULL MARGEN_BEN_PROMOTOR         
                     , NULL PARALIZACION_URB            
                     , NULL PORC_URB_EJECUTADO          
                     , NULL PORC_AMBITO_VAL             
                     , NULL PRODUCTO_DESA               
                     , NULL PROYECTO_OBRA               
                     , NULL SUPERFICIE_TERRENO          
                     , NULL TASA_ANU_MED_VAR_PRECIO     
                     , NULL TIPO_DAT_INM_COMPARABLES    
                     , NULL VAL_TERRENO                 
                     , NULL VAL_TERRENO_AJUSTADO        
                     , NULL VAL_HIP_EDI_TERMINADO       
                     , NULL VAL_HIPOTECARIO             
                     , NULL VISITA_INT_INMUEBLE 
                     FROM '|| V_ESQUEMA ||'.ACT_TAS_TASACION TAS
                     LEFT JOIN '|| V_ESQUEMA ||'.DD_TTS_TIPO_TASACION TTS ON TAS.DD_TTS_ID = TTS.DD_TTS_ID AND TTS.BORRADO = 0
                     WHERE TAS.BORRADO = 0) TASACION ON RN = 1 AND TASACION.ACT_ID = ACT.ACT_ID
                     WHERE ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                     AND ACT.DD_CRA_ID = (SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''03'')
                     AND ACT.BORRADO = 0
                     AND PAC.PAC_INCLUIDO = 1
                     AND ACT.ACT_EN_TRAMITE = 0
                     AND PRO.PRO_DOCIDENTIF IN (''A80352750'', ''A80514466'')
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
