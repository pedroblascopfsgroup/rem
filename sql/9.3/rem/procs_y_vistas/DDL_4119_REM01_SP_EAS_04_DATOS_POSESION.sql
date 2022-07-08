--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220630
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



CREATE OR REPLACE PROCEDURE SP_EAS_04_DATOS_POSESION
   ( FLAG_EN_REM IN NUMBER,
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

      V_MSQL := 'TRUNCATE TABLE '|| V_ESQUEMA ||'.AUX_APR_DATOS_POSESION';
       EXECUTE IMMEDIATE V_MSQL;

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A ACTUALIZAR/INSERTAR CAMPOS EN AUX_APR_ATRIBUTOS_LEGALES.'|| CHR(10);


       V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_DATOS_POSESION dpos
				using (   



                WITH ACTIVO_MATRIZ AS (SELECT AGA.AGR_ID, ACT.ACT_ID,ACT.BIE_ID
                                FROM ACT_AGR_AGRUPACION AGR
                                JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO aga ON aga.AGR_ID = AGR.AGR_ID AND aga.BORRADO = 0
                                JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = aga.ACT_ID AND ACT.BORRADO = 0                                                              
                                WHERE AGR.BORRADO = 0 AND AGR.AGR_FECHA_BAJA IS NULL
                                AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''16'') AND AGA.AGA_PRINCIPAL = 1)
                

                SELECT DISTINCT
                            act.ACT_NUM_ACTIVO AS ZZEXTERNALID,
                            TO_CHAR(adj.BIE_ADJ_F_REA_POSESION,''YYYYMMDD'') AS ZZFE1APOS,                         
                            TO_CHAR(adj.BIE_ADJ_F_SEN_LANZAMIENTO,''YYYYMMDD'') AS ZZFECHAPREVLANZ,
                            TO_CHAR(adj.BIE_ADJ_F_REA_LANZAMIENTO,''YYYYMMDD'') AS ZZFECHALANZ,
                            TO_CHAR(adj.BIE_ADJ_F_RES_MORATORIA,''YYYYMMDD'') AS ZZFERESMOR,
                            NULL AS ZZMOTISUSP,
                            NULL AS ZZFOROBTPOS
                                                                                           
                            FROM '|| V_ESQUEMA ||'.ACT_AGR_AGRUPACION agr
                            JOIN '|| V_ESQUEMA ||'.ACT_AGA_AGRUPACION_ACTIVO aga ON aga.AGR_ID = AGR.AGR_ID AND aga.BORRADO = 0
                            JOIN '|| V_ESQUEMA ||'.ACT_ACTIVO ACT ON ACT.ACT_ID = aga.ACT_ID AND ACT.BORRADO = 0     
                            JOIN ACTIVO_MATRIZ MAT ON MAT.AGR_ID = AGR.AGR_ID                              
                            JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA cra ON cra.DD_CRA_ID = ACT.DD_CRA_ID  AND cra.BORRADO= 0     
                            JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO pac ON pac.ACT_ID = ACT.ACT_ID AND pac.BORRADO = 0             
                            JOIN '|| V_ESQUEMA ||'.BIE_ADJ_ADJUDICACION adj ON adj.BIE_ID = MAT.BIE_ID AND adj.BORRADO = 0                                                                                                              
                            
                            WHERE AGR.BORRADO = 0 
                            AND cra.DD_CRA_CODIGO = ''03''
                            AND pac.PAC_INCLUIDO = 1
                            AND AGR.DD_TAG_ID = (SELECT DD_TAG_ID FROM '|| V_ESQUEMA ||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = ''16'')
                            AND agr.AGR_FECHA_BAJA IS NULL
                            AND AGA.AGA_PRINCIPAL = 0

                             ) us ON (us.ZZEXTERNALID = dpos.ZZEXTERNALID)                          

                                 WHEN NOT MATCHED THEN
                                 INSERT     (ZZEXTERNALID,
                                            ZZFE1APOS,
                                            ZZFECHAPREVLANZ,
                                            ZZFECHALANZ,
                                            ZZFERESMOR,
                                            ZZMOTISUSP,
                                            ZZFOROBTPOS
                                          )
                                        VALUES (
                                            us.ZZEXTERNALID,
                                            us.ZZFE1APOS,
                                            us.ZZFECHAPREVLANZ,
                                            us.ZZFECHALANZ,
                                            us.ZZFERESMOR,
                                            us.ZZMOTISUSP,
                                            us.ZZFOROBTPOS)';

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
END SP_EAS_04_DATOS_POSESION;
/
EXIT;
