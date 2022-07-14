--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220708
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18228
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-18228] - Santi Monzó 
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;                  



CREATE OR REPLACE PROCEDURE SP_EAS_06_MEDIDAS
   (
   SALIDA OUT VARCHAR2
   )

   AS

   V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar
   V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
   V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(10024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_AUX NUMBER(10); -- Variable auxiliar
   V_COUNT NUMBER(16);
   V_SUBSTR NUMBER(16);
   V_INCREM NUMBER(16);

   V_FECHA_INICIO VARCHAR2(100 CHAR);
   V_FECHA_FIN VARCHAR2(100 CHAR);

BEGIN

      SALIDA := '[INICIO]'||CHR(10);

      V_MSQL := 'TRUNCATE TABLE '|| V_ESQUEMA ||'.AUX_APR_MEDIDAS';
       EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS EN AUX_APR_MEDIDAS.'|| CHR(10);


       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_MEDIDAS MED USING(
			WITH ACTIVO_MATRIZ AS (SELECT AGR.AGR_ID, ACT.ACT_NUM_ACTIVO,
			
            TO_CHAR(ICO.ICO_ANO_CONSTRUCCION) AS ICO_ANO_CONSTRUCCION,
            TO_CHAR(ICO.ICO_ANO_REHABILITACION) AS ICO_ANO_REHABILITACION,
            TO_CHAR(ICO.ICO_NUM_BANYOS) AS ICO_NUM_BANYOS,
            TO_CHAR(ICO.ICO_NUM_PLANTAS_EDI) AS ICO_NUM_PLANTAS_EDI,
            TO_CHAR(ICO.ICO_NUM_ESTANCIAS) AS ICO_NUM_ESTANCIAS,
            TO_CHAR(ICO.ICO_SUP_TERRAZA) AS ICO_SUP_TERRAZA,
            TO_CHAR(ICO.ICO_SUP_PATIO) AS ICO_SUP_PATIO,
            TO_CHAR(ICO.ICO_IDEF_PLAZA_PARKING) AS ICO_IDEF_PLAZA_PARKING,
            TO_CHAR(ICO.ICO_IDEF_TRASTERO) AS ICO_IDEF_TRASTERO,
            TO_CHAR(ICO.ICO_NUM_GARAJE) AS ICO_NUM_GARAJE,
            
            TO_CHAR(CAT.CAT_SUPERFICIE_SUELO) AS CAT_SUPERFICIE_SUELO,
            
            
            TO_CHAR(REG.REG_SUPERFICIE_PARCELA_UTIL) AS REG_SUPERFICIE_PARCELA_UTIL, 
            TO_CHAR(REG.REG_SUPERFICIE_UTIL) AS REG_SUPERFICIE_UTIL,
            TO_CHAR(REG.REG_SUPERFICIE_CONSTRUIDA) AS REG_SUPERFICIE_CONSTRUIDA,
            --TO_CHAR(REG.REG_SUPERFICIE_PARCELA) AS REG_SUPERFICIE_PARCELA,
            
            TO_CHAR(BIE.BIE_DREG_SUPERFICIE_CONSTRUIDA) AS BIE_DREG_SUPERFICIE_CONSTRUIDA,
            TO_CHAR(ACT.ACT_PORCENTAJE_CONSTRUCCION) AS ACT_PORCENTAJE_CONSTRUCCION
            FROM ACT_ACTIVO ACT
            JOIN ACT_ICO_INFO_COMERCIAL ICO ON ICO.ACT_ID = ACT.ACT_ID
            JOIN ACT_CAT_CATASTRO CAT ON CAT.ACT_ID = ACT.ACT_ID
            JOIN ACT_REG_INFO_REGISTRAL REG ON REG.ACT_ID = ACT.ACT_ID
            JOIN BIE_DATOS_REGISTRALES BIE ON BIE.BIE_ID = ACT.BIE_ID
            
            
            JOIN ACT_AGA_AGRUPACION_ACTIVO AGA ON ACT.ACT_ID = AGA.ACT_ID AND AGA.BORRADO = 0
            JOIN ACT_AGR_AGRUPACION AGR ON AGR.AGR_ID = AGA.AGR_ID
            WHERE AGR.BORRADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL AND 
            AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''16'') AND AGA.AGA_PRINCIPAL = 1
            ) ,

            UA AS (
            SELECT ACT.ACT_NUM_ACTIVO,
            ICO_ANO_CONSTRUCCION,
            ICO_ANO_REHABILITACION,
            ICO_NUM_BANYOS,
            ICO_NUM_PLANTAS_EDI,
            ICO_NUM_ESTANCIAS,
            ICO_SUP_TERRAZA,
            ICO_SUP_PATIO,
            ICO_IDEF_PLAZA_PARKING,
            ICO_IDEF_TRASTERO,
            ICO_NUM_GARAJE,
               
            CAT_SUPERFICIE_SUELO,
               
            
            REG_SUPERFICIE_PARCELA_UTIL, 
            REG_SUPERFICIE_UTIL,
            REG_SUPERFICIE_CONSTRUIDA,
            --REG_SUPERFICIE_PARCELA,
               
            BIE_DREG_SUPERFICIE_CONSTRUIDA,
            MAT.ACT_PORCENTAJE_CONSTRUCCION
            FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION AGR 
            JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO AGA ON AGR.AGR_ID = AGA.AGR_ID AND AGA.BORRADO = 0
            JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = AGA.ACT_ID AND ACT.BORRADO = 0 
            JOIN ACTIVO_MATRIZ MAT ON MAT.AGR_ID = AGR.AGR_ID
            WHERE AGR.BORRADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL AND 
            AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''16'') AND AGA.AGA_PRINCIPAL = 0
            )	         
            
            SELECT ''7'' AS TIPO_REGISTRO, ACT_NUM_ACTIVO AS ZZEXTERNALID, MEAS, NULL AS MEASVALUE,NULL AS MEASUNIT,NULL AS VALIDFROM,NULL AS VALIDTO
                 FROM UA
                UNPIVOT(
                QUALITY
                FOR MEAS IN 
                (ICO_ANO_CONSTRUCCION AS ''6''
                , ICO_ANO_REHABILITACION AS ''8''
                , ICO_NUM_BANYOS AS ''34''
                , ICO_NUM_PLANTAS_EDI AS ''36''
                , ICO_NUM_ESTANCIAS AS ''38''
                , ICO_SUP_TERRAZA AS ''87''
                , ICO_SUP_PATIO AS ''101''
                , ICO_IDEF_PLAZA_PARKING AS ''157''
                , ICO_IDEF_TRASTERO AS ''158''
                , ICO_NUM_GARAJE AS ''745''
                
                , CAT_SUPERFICIE_SUELO AS ''307''
                
                
                , REG_SUPERFICIE_PARCELA_UTIL AS ''179''
                , REG_SUPERFICIE_UTIL AS ''183''
                , REG_SUPERFICIE_CONSTRUIDA AS ''891''
                --, REG_SUPERFICIE_PARCELA AS ''892''
                
                , BIE_DREG_SUPERFICIE_CONSTRUIDA AS ''61''
                 ,ACT_PORCENTAJE_CONSTRUCCION AS ''188''))
                


			) us ON (us.ZZEXTERNALID = MED.ZZEXTERNALID AND us.MEAS = MED.MEAS) 
			WHEN NOT MATCHED THEN INSERT
                                        (ZZEXTERNALID,
                                            MEAS,
                                            MEASVALUE,
                                            MEASUNIT,
                                            VALIDFROM,
                                            VALIDTO
                                          )
                                        VALUES (
                                            us.ZZEXTERNALID,
                                            us.MEAS,
                                            us.MEASVALUE,
                                            us.MEASUNIT,
                                            us.VALIDFROM,
                                            us.VALIDTO)';

   EXECUTE IMMEDIATE V_MSQL;


   SALIDA := SALIDA || '   [INFO] MERGE TERMINADO ';   
COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      SALIDA := SALIDA || CHR(10) ||'    [ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM);
      SALIDA := SALIDA || CHR(10) ||'    '||ERR_MSG;
      ROLLBACK;
      RAISE;
END SP_EAS_06_MEDIDAS;
/
EXIT;
