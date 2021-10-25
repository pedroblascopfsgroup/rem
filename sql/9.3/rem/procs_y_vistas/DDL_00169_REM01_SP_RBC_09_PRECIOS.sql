--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15634
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-14222] - Alejandra García
--##        0.2 Cambio de numeración del SP y modificación de los checks de 1 y 0 a S y N respectivamente - [HREOS-14222] - Alejandra García
--##        0.3 Formatos númericos en ACT_EN_TRAMITE = 0  - [HREOS-14366] - Daniel Algaba
--##        0.4 Metemos NUM_IDENTFICATIVO como campos de cruce - [HREOS-14368] - Daniel Algaba
--##	      0.5 Inclusión de cambios en modelo Fase 1, cambios en interfaz y añadidos - HREOS-14545
--##	      0.6 Filtramos las consultas para que no salgan los activos titulizados - HREOS-15423
--##        0.7 Se cambian los NIFs de titulizados - [HREOS-15634] - Daniel Algaba
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;						

CREATE OR REPLACE PROCEDURE SP_RBC_09_PRECIOS
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

--1º Merge tabla AUX_APR_RBC_STOCK
    SALIDA := '[INICIO]'||CHR(10);

    SALIDA := SALIDA || '[INFO] SE VA A PROCEDER A EXTRAER LOS DATOS BÁSICOS'|| CHR(10);

    SALIDA := SALIDA || '   [INFO] 1 - EXTRACCIÓN ACT_VAL_VALORACIONES'||CHR(10);

    V_MSQL := 'MERGE INTO REM01.AUX_APR_RBC_STOCK AUX
		USING (
			SELECT ACT.ACT_NUM_ACTIVO_CAIXA NUM_IDENTIFICATIVO, ACT.ACT_NUM_ACTIVO NUM_INMUEBLE, VAL.VAL_IMPORTE 
		    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
		    JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.BORRADO = 0
		    JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
		    JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID
		    JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID
          JOIN '|| V_ESQUEMA ||'.ACT_PAC_PROPIETARIO_ACTIVO ACT_PRO ON ACT_PRO.ACT_ID = ACT.ACT_ID AND ACT_PRO.BORRADO = 0
          JOIN '|| V_ESQUEMA ||'.ACT_PRO_PROPIETARIO PRO ON PRO.PRO_ID = ACT_PRO.PRO_ID AND PRO.BORRADO = 0
		    WHERE TPC.DD_TPC_CODIGO = ''12'' AND ACT.BORRADO = 0 AND CRA.DD_CRA_CODIGO = ''03'' AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL AND PAC.PAC_INCLUIDO = 1
            AND ACT.ACT_EN_TRAMITE = 0
            AND PRO.PRO_DOCIDENTIF NOT IN (''V84966126'',''V85164648'',''V85587434'',''V84322205'',''V84593961'',''V84669332'',''V85082675'',''V85623668'',''V84856319'',''V85500866'',''V85143659'',''V85594927'',''V85981231'',''V84889229'',''V84916956'',''V85160935'',''V85295087'',''V84175744'',''V84925569''''A80352750'', ''A80514466'')
		) US ON (US.NUM_INMUEBLE=AUX.NUM_INMUEBLE  AND US.NUM_IDENTIFICATIVO = AUX.NUM_IDENTIFICATIVO)
		WHEN MATCHED THEN UPDATE SET
		AUX.IMP_PRECIO_REF_ALQUI = US.VAL_IMPORTE * 100
                  WHEN NOT MATCHED THEN INSERT
                  (
                  AUX.NUM_IDENTIFICATIVO,
                  AUX.NUM_INMUEBLE,
                  AUX.IMP_PRECIO_REF_ALQUI
                  )
                  VALUES
                  (
                  US.NUM_IDENTIFICATIVO,
                  US.NUM_INMUEBLE,
                  US.VAL_IMPORTE)
                  
   ';
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
END SP_RBC_09_PRECIOS;
/
EXIT;
