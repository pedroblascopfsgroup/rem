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
--##        0.1 Versión inicial - [HREOS-14224] - Santi Monzó
--##        0.2 Revisión - [HREOS-14344] - Alejandra García
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



      DBMS_OUTPUT.PUT_LINE('[INFO] INSERTAR/ACTUALIZAR EN ACT_ADM_INF_ADMINISTRATIVA.');

       V_MSQL := '  MERGE INTO '|| V_ESQUEMA ||'.ACT_ADM_INF_ADMINISTRATIVA act1
				using (		

            SELECT
            aux.NUM_IDENTIFICATIVO as ACT_NUM_ACTIVO_CAIXA,
            act2.ACT_ID as ACT_ID,          
            aux.PRECIO_MAX_MOD_VENTA as ADM_MAX_PRECIO_VENTA,
            aux.PRECIO_MAX_MOD_ALQUILER as ADM_MAX_PRECIO_MODULO_ALQUILER,
            CASE 
               WHEN aux.NECESARIA_AUTORI_TRANS IN (''S'',''1'') THEN 1
               WHEN aux.NECESARIA_AUTORI_TRANS IN (''N'',''0'') THEN 0
            END AS ADM_OBLIG_AUT_ADM_VENTA,
            CASE 
               WHEN aux.TANTEO_RETRACTO_TRANS IN (''S'',''1'') THEN 1
               WHEN aux.TANTEO_RETRACTO_TRANS IN (''N'',''0'') THEN 0
            END AS ADM_RENUNCIA_TANTEO_RETRAC            
            FROM '|| V_ESQUEMA ||'.AUX_APR_BCR_STOCK aux                             
            JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO act2 ON act2.ACT_NUM_ACTIVO_CAIXA = aux.NUM_IDENTIFICATIVO AND act2.BORRADO=0
            WHERE aux.FLAG_EN_REM = '|| FLAG_EN_REM ||'
            
            ) us ON (us.ACT_ID = act1.ACT_ID )
                              when matched then update set
                             act1.ADM_MAX_PRECIO_VENTA = us.ADM_MAX_PRECIO_VENTA   
                            ,act1.ADM_MAX_PRECIO_MODULO_ALQUILER = us.ADM_MAX_PRECIO_MODULO_ALQUILER 
                            ,act1.ADM_OBLIG_AUT_ADM_VENTA = us.ADM_OBLIG_AUT_ADM_VENTA 
                            ,act1.ADM_RENUNCIA_TANTEO_RETRAC = us.ADM_RENUNCIA_TANTEO_RETRAC 
                            ,act1.USUARIOMODIFICAR = ''STOCK''
                            ,act1.FECHAMODIFICAR = sysdate
                            
                             WHEN NOT MATCHED THEN
                                INSERT  (ADM_ID,                                       
                                        ACT_ID,
                                        ADM_MAX_PRECIO_VENTA,
                                        ADM_MAX_PRECIO_MODULO_ALQUILER,  
                                        ADM_OBLIG_AUT_ADM_VENTA,
                                        ADM_RENUNCIA_TANTEO_RETRAC,
                                        USUARIOCREAR,
                                        FECHACREAR
                                        )
                                VALUES ('|| V_ESQUEMA ||'.S_ACT_ADM_INF_ADMINISTRATIVA.NEXTVAL,
                                        us.ACT_ID,                                        
                                        us.ADM_MAX_PRECIO_VENTA,
                                        us.ADM_MAX_PRECIO_MODULO_ALQUILER,   
                                        us.ADM_OBLIG_AUT_ADM_VENTA,   
                                        us.ADM_RENUNCIA_TANTEO_RETRAC,   
                                        ''STOCK'',
                                        sysdate)';


   EXECUTE IMMEDIATE V_MSQL;
   
   
 

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
