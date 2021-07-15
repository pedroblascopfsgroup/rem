--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210715
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14545
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 ACT_EN_TRAMITE = 0 - [HREOS-14366] - Daniel Algaba
--##        0.3 Quitamos INDICADOR_LLAVES y FEC_RECEP_LLAVES - [HREOS-14533] - Daniel Algaba
--##	      0.4 Inclusión de cambios en modelo Fase 1, cambios en interfaz y añadidos - HREOS-14545
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						



CREATE OR REPLACE PROCEDURE SP_RBC_01_DATOS_GENERALES
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

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A EXTRAER LOS DATOS BÁSICOS'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - EXTRACCIÓN ACT_ACTIVO'||CHR(10);

       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_STOCK aux
				using (				
                           
                 SELECT       
                  act.ACT_NUM_ACTIVO as NUM_INMUEBLE,
                  act.ACT_NUM_ACTIVO_CAIXA as NUM_IDENTIFICATIVO,   
                  CASE                  
                  WHEN (SELECT DD_SIN_CODIGO FROM '|| V_ESQUEMA_M ||'.DD_SIN_SINO WHERE DD_SIN_ID=act.ACT_OVN_COMERC) = ''01'' THEN ''S''
                  ELSE ''N''
                  END as STATUS_USUARIO,             
                  CASE                  
                  WHEN (SELECT DD_TUD_CODIGO FROM '|| V_ESQUEMA ||'.DD_TUD_TIPO_USO_DESTINO WHERE DD_TUD_ID=act.DD_TUD_ID) = ''06'' THEN ''N''
                  ELSE ''S''
                  END as INMUEBLE_VACACIONAL
                  FROM '|| V_ESQUEMA ||'.ACT_ACTIVO act
                  JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO pac ON pac.ACT_ID = act.ACT_ID
                 
                  WHERE act.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                  AND act.DD_CRA_ID = (SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''03'')
                  AND act.BORRADO=0
                  AND pac.PAC_INCLUIDO=1
                  AND pac.BORRADO=0
                  AND ACT.ACT_EN_TRAMITE = 0
                                       
                                 ) us ON ((us.NUM_INMUEBLE = aux.NUM_INMUEBLE) AND (us.NUM_IDENTIFICATIVO = aux.NUM_IDENTIFICATIVO) )
                                 when matched then update set
                                    
                                    aux.STATUS_USUARIO = us.STATUS_USUARIO  
                                    ,aux.INMUEBLE_VACACIONAL = us.INMUEBLE_VACACIONAL                                  
                                    
                                       
                                 WHEN NOT MATCHED THEN
                                 INSERT  (
                                          NUM_INMUEBLE,
                                          NUM_IDENTIFICATIVO,                                                                          
                                          STATUS_USUARIO,                                       
                                          INMUEBLE_VACACIONAL
                                          )
                                 VALUES (
                                          us.NUM_INMUEBLE,
                                          us.NUM_IDENTIFICATIVO,                                       
                                          us.STATUS_USUARIO,                                      
                                          us.INMUEBLE_VACACIONAL)';

   EXECUTE IMMEDIATE V_MSQL;
   
   SALIDA := SALIDA || '   [INFO] ACTUALIZADOS '|| SQL%ROWCOUNT|| CHR(10);

   SALIDA := SALIDA || '   [INFO] 1 - EXTRACCIÓN ACT_ACTIVO_CAIXA'||CHR(10);

       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_STOCK aux
				using (				
                           
                SELECT       
                  act.ACT_ID as ACT_ID,
                 
                  eqv.DD_CODIGO_CAIXA as ESTADO_TECNICO,
                  
                  TO_CHAR(act.FECHA_EAT_EST_TECNICO,''YYYYMMDD'') as FEC_ESTADO_TECNICO,                                             
                  act2.ACT_NUM_ACTIVO as NUM_INMUEBLE,
                  act2.ACT_NUM_ACTIVO_CAIXA as NUM_IDENTIFICATIVO,
                  eqv2.DD_CODIGO_CAIXA as TRIBUT_PROPUESTA_VENTA,
                  eqv3.DD_CODIGO_CAIXA as TRIBUT_PROPUESTA_CLI_EXT_IVA
                  FROM '|| V_ESQUEMA ||'.ACT_ACTIVO_CAIXA act
  
                 LEFT JOIN '|| V_ESQUEMA ||'.DD_EAT_EST_TECNICO eat ON eat.DD_EAT_ID = act.DD_EAT_ID  
                 LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv ON eqv.DD_NOMBRE_CAIXA = ''ESTADO_TECNICO''  AND eqv.DD_CODIGO_REM =eat.DD_EAT_CODIGO  AND eqv.BORRADO=0  
                 LEFT JOIN '|| V_ESQUEMA ||'.DD_TPV_TRIBUT_PROP_VENTA TPV ON TPV.DD_TPV_ID = act.DD_TPV_ID  
                 LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv2 ON eqv2.DD_NOMBRE_CAIXA = ''TRIBUT_PROPUESTA_VENTA''  AND eqv2.DD_CODIGO_REM =TPV.DD_TPV_CODIGO  AND eqv2.BORRADO=0  
                 LEFT JOIN '|| V_ESQUEMA ||'.DD_TPE_TRIB_PROP_CLI_EX_IVA TPE ON TPE.DD_TPE_ID = act.DD_TPE_ID  
                 LEFT JOIN '|| V_ESQUEMA ||'.DD_EQV_CAIXA_REM eqv3 ON eqv3.DD_NOMBRE_CAIXA = ''TRIBUT_PROPUESTA_CLI_EXT_IVA''  AND eqv3.DD_CODIGO_REM =TPE.DD_TPE_CODIGO  AND eqv3.BORRADO=0  
                 JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 on act2.ACT_ID = act.ACT_ID 
                 JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO pac ON pac.ACT_ID = act2.ACT_ID

                WHERE act2.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                    AND act2.DD_CRA_ID = (SELECT DD_CRA_ID FROM '|| V_ESQUEMA ||'.DD_CRA_CARTERA WHERE DD_CRA_CODIGO = ''03'')
                    AND act2.BORRADO=0 
                    AND act.BORRADO=0
                    AND pac.PAC_INCLUIDO=1
                    AND pac.BORRADO=0
                                       
                                 ) us ON ((us.NUM_INMUEBLE = aux.NUM_INMUEBLE) AND (us.NUM_IDENTIFICATIVO = aux.NUM_IDENTIFICATIVO) )
                                 when matched then update set
                                    
                                    aux.ESTADO_TECNICO = us.ESTADO_TECNICO  
                                    ,aux.FEC_ESTADO_TECNICO = us.FEC_ESTADO_TECNICO
                                    ,aux.TRIBUT_PROPUESTA_VENTA = us.TRIBUT_PROPUESTA_VENTA
                                    ,aux.TRIBUT_PROPUESTA_CLI_EXT_IVA = us.TRIBUT_PROPUESTA_CLI_EXT_IVA';

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
END SP_RBC_01_DATOS_GENERALES;
/
EXIT;
