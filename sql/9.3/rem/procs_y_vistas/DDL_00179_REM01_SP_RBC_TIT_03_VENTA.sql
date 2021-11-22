--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211108
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16362
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##        0.2 Se cambian los NIFs de titulizados - [HREOS-15634] - Daniel Algaba
--##        0.3 Se cambia la cartera por la nuevo Titulizada - [HREOS-15634] - Daniel Algaba
--##        0.4 Se refactoriza la consulta para que solo mire si son de la cartera Titulizada y están en perímetro - [HREOS-15969] - Daniel Algaba
--##        0.5 Se quita la corrección de comas en decimales - [HREOS-16362] - Daniel Algaba
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						



CREATE OR REPLACE PROCEDURE SP_RBC_TIT_03_VENTA
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

      SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A EXTRAER LAS VENTAS'|| CHR(10);

      SALIDA := SALIDA || '   [INFO] 1 - EXTRACCIÓN DE CAMPOS DE VENTA'||CHR(10);

      V_MSQL := ' MERGE INTO '|| V_ESQUEMA ||'.AUX_APR_RBC_TIT_STOCK RBC_TIT
				USING (				                 
                  SELECT       
                     ACT.ACT_NUM_ACTIVO_CAIXA as NUM_IDENTIFICATIVO 
                     , TO_CHAR(VENTA.FEC_VENTA,''YYYYMMDD'') FEC_VENTA
                     , VENTA.IMP_VENTA IMP_VENTA
                     , VENTA.NIF_COMPRADOR NIF_COMPRADOR
                     , NULL INGRESOS_COMPRADOR
                     FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
                     JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND DD_CRA_CODIGO = ''18''
                     JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACT_ID = ACT.ACT_ID AND PAC.BORRADO = 0
                     JOIN '|| V_ESQUEMA ||'.DD_SCM_SITUACION_COMERCIAL SCM ON ACT.DD_SCM_ID = SCM.DD_SCM_ID AND SCM.BORRADO = 0 AND SCM.DD_SCM_CODIGO = ''05''
                     JOIN (SELECT
                        ACO.ACT_ID
                        , ECO.ECO_FECHA_FIRMA_CONT FEC_VENTA
                        , COALESCE(OFR.OFR_IMPORTE_CONTRAOFERTA, OFR.OFR_IMPORTE, 0)*OFR_ACT_PORCEN_PARTICIPACION/100 IMP_VENTA
                        , COM.COM_DOCUMENTO NIF_COMPRADOR
                        FROM '|| V_ESQUEMA ||'.OFR_OFERTAS OFR
                        JOIN '|| V_ESQUEMA ||'.ACT_OFR ACO ON OFR.OFR_ID = ACO.OFR_ID
                        JOIN '|| V_ESQUEMA ||'.ECO_EXPEDIENTE_COMERCIAL ECO ON OFR.OFR_ID = ECO.OFR_ID AND ECO.BORRADO = 0
                        JOIN '|| V_ESQUEMA ||'.DD_TOF_TIPOS_OFERTA TOF ON OFR.DD_TOF_ID = TOF.DD_TOF_ID AND TOF.BORRADO = 0 AND DD_TOF_CODIGO = ''01''
                        JOIN '|| V_ESQUEMA ||'.DD_EEC_EST_EXP_COMERCIAL EEC ON EEC.DD_EEC_ID = ECO.DD_EEC_ID AND EEC.BORRADO = 0 AND EEC.DD_EEC_CODIGO = ''08''
                        JOIN '|| V_ESQUEMA ||'.CLC_CLIENTE_COMERCIAL CLC ON CLC.CLC_ID = OFR.CLC_ID AND CLC.BORRADO = 0
                        JOIN '|| V_ESQUEMA ||'.COM_COMPRADOR COM ON COM.CLC_ID = OFR.CLC_ID AND COM.BORRADO = 0
                        WHERE OFR.BORRADO = 0) VENTA ON VENTA.ACT_ID = ACT.ACT_ID
                     WHERE ACT.BORRADO = 0
                     AND PAC.PAC_INCLUIDO = 1
                     AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL
                  ) AUX ON (RBC_TIT.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
                  WHEN MATCHED THEN UPDATE SET
                     RBC_TIT.FEC_VENTA = AUX.FEC_VENTA
                     , RBC_TIT.IMP_VENTA = AUX.IMP_VENTA
                     , RBC_TIT.NIF_COMPRADOR = AUX.NIF_COMPRADOR
                     , RBC_TIT.INGRESOS_COMPRADOR = AUX.INGRESOS_COMPRADOR';

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
END SP_RBC_TIT_03_VENTA;
/
EXIT;
