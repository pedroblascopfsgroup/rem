--/*
--##########################################
--## AUTOR=Javier Esbri
--## FECHA_CREACION=20220405
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17611
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-14224] - Santi Monzó
--##        0.2 Revisión - [HREOS-14344] - Alejandra García
--##        0.3 Inclusión de cambios en modelo Fase 1, cambios en interfaz y añadidos - HREOS-14545
--##        0.4 Añadir campos VPO - HREOS-17611
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_BCR_05_INFORMACION_ADMINISTRATIVA
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

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS DE INFORMACIÓN ADMINISTRATIVA.'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - ACT_ADM_INF_ADMINISTRATIVA'||CHR(10);

       V_MSQL := '  MERGE INTO '|| V_ESQUEMA ||'.ACT_ADM_INF_ADMINISTRATIVA act1
				using (		

            SELECT
            aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_CAIXA,
            act2.ACT_ID as ACT_ID,          
            aux.PRECIO_MAX_MOD_VENTA/100 as ADM_MAX_PRECIO_VENTA,
            aux.PRECIO_MAX_MOD_ALQUILER/100 as ADM_MAX_PRECIO_MODULO_ALQUILER,
            CASE 
               WHEN aux.NECESARIA_AUTORI_TRANS IN (''S'',''1'') THEN 1
               WHEN aux.NECESARIA_AUTORI_TRANS IN (''N'',''0'') THEN 0
            END AS ADM_OBLIG_AUT_ADM_VENTA,
            CASE 
               WHEN aux.TANTEO_RETRACTO_TRANS IN (''S'',''1'') THEN 1
               WHEN aux.TANTEO_RETRACTO_TRANS IN (''N'',''0'') THEN 0
            END AS ADM_RENUNCIA_TANTEO_RETRAC,            
            CASE
               WHEN aux.IND_COMPRADOR_ACOGE_AYUDA IN (''S'',''1'') THEN 1
               WHEN aux.IND_COMPRADOR_ACOGE_AYUDA IN (''N'',''0'') THEN 0
            END AS COMPRADOR_ACOJE_AYUDA,
            aux.IMP_AYUDA_FINANCIACION as IMPORTE_AYUDA_FINANCIACION,
            TO_DATE(aux.FEC_VENCIMIENTO_SEGURO,''yyyymmdd'') as FECHA_VENCIMIENTO_AVAL_SEGURO,
            TO_DATE(aux.FEC_DEVOLUCION_AYUDA,''yyyymmdd'') as FECHA_DEVOLUCION_AYUDA,
            ADM.ADM_ID
            FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux                             
            JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
            LEFT JOIN '|| V_ESQUEMA ||'.ACT_ADM_INF_ADMINISTRATIVA ADM ON ADM.ACT_ID = ACT2.ACT_ID AND ADM.BORRADO = 0
            WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
            
            ) us ON (us.ADM_ID = act1.ADM_ID )
                              when matched then update set
                             act1.ADM_MAX_PRECIO_VENTA = us.ADM_MAX_PRECIO_VENTA   
                            ,act1.ADM_MAX_PRECIO_MODULO_ALQUILER = us.ADM_MAX_PRECIO_MODULO_ALQUILER 
                            ,act1.ADM_OBLIG_AUT_ADM_VENTA = us.ADM_OBLIG_AUT_ADM_VENTA 
                            ,act1.ADM_RENUNCIA_TANTEO_RETRAC = us.ADM_RENUNCIA_TANTEO_RETRAC 
                            ,act1.COMPRADOR_ACOJE_AYUDA = us.COMPRADOR_ACOJE_AYUDA
                            ,act1.IMPORTE_AYUDA_FINANCIACION = us.IMPORTE_AYUDA_FINANCIACION
                            ,act1.FECHA_VENCIMIENTO_AVAL_SEGURO = us.FECHA_VENCIMIENTO_AVAL_SEGURO
                            ,act1.FECHA_DEVOLUCION_AYUDA = us.FECHA_DEVOLUCION_AYUDA
                            ,act1.USUARIOMODIFICAR = ''STOCK''
                            ,act1.FECHAMODIFICAR = sysdate
                            
                             WHEN NOT MATCHED THEN
                                INSERT  (ADM_ID,                                       
                                        ACT_ID,
                                        ADM_MAX_PRECIO_VENTA,
                                        ADM_MAX_PRECIO_MODULO_ALQUILER,  
                                        ADM_OBLIG_AUT_ADM_VENTA,
                                        ADM_RENUNCIA_TANTEO_RETRAC,
                                        COMPRADOR_ACOJE_AYUDA,
                                        IMPORTE_AYUDA_FINANCIACION,
                                        FECHA_VENCIMIENTO_AVAL_SEGURO,
                                        FECHA_DEVOLUCION_AYUDA,
                                        USUARIOCREAR,
                                        FECHACREAR
                                        )
                                VALUES ('|| V_ESQUEMA ||'.S_ACT_ADM_INF_ADMINISTRATIVA.NEXTVAL,
                                        us.ACT_ID,                                        
                                        us.ADM_MAX_PRECIO_VENTA,
                                        us.ADM_MAX_PRECIO_MODULO_ALQUILER,   
                                        us.ADM_OBLIG_AUT_ADM_VENTA,   
                                        us.ADM_RENUNCIA_TANTEO_RETRAC,   
                                        us.COMPRADOR_ACOJE_AYUDA,
                                        us.IMPORTE_AYUDA_FINANCIACION,
                                        us.FECHA_VENCIMIENTO_AVAL_SEGURO,
                                        us.FECHA_DEVOLUCION_AYUDA,
                                        ''STOCK'',
                                        sysdate)';


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
END SP_BCR_05_INFORMACION_ADMINISTRATIVA;
/
EXIT;
