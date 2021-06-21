--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210618
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14366
--## PRODUCTO=NO
--##
--## Finalidad: 
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-14222] - Alejandra García
--##        0.2 Cambio de numeración del SP y modificación de los checks de 1 y 0 a S y N respectivamente - [HREOS-14222] - Alejandra García
--##        0.3 Formatos númericos en ACT_EN_TRAMITE = 0  - [HREOS-14366] - Daniel Algaba
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
   DBMS_OUTPUT.PUT_LINE('[INFO] 1 MERGE A LA TABLA AUX_APR_RBC_STOCK.');

    V_MSQL := 'MERGE INTO REM01.AUX_APR_RBC_STOCK AUX
		USING (
			SELECT ACT.ACT_NUM_ACTIVO_CAIXA NUM_IDENTIFICATIVO, ACT.ACT_NUM_ACTIVO NUM_INMUEBLE, VAL.VAL_IMPORTE 
		    FROM '|| V_ESQUEMA ||'.ACT_ACTIVO ACT
		    JOIN '|| V_ESQUEMA ||'.ACT_VAL_VALORACIONES VAL ON VAL.ACT_ID = ACT.ACT_ID AND VAL.BORRADO = 0
		    JOIN '|| V_ESQUEMA ||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID
		    JOIN '|| V_ESQUEMA ||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID
		    JOIN '|| V_ESQUEMA ||'.DD_TPC_TIPO_PRECIO TPC ON TPC.DD_TPC_ID = VAL.DD_TPC_ID
		    WHERE TPC.DD_TPC_CODIGO = ''12'' AND ACT.BORRADO = 0 AND CRA.DD_CRA_CODIGO = ''03'' AND ACT.ACT_NUM_ACTIVO_CAIXA IS NOT NULL AND PAC.PAC_INCLUIDO = 1
            AND ACT.ACT_EN_TRAMITE = 0
		) US ON (US.NUM_INMUEBLE=AUX.NUM_INMUEBLE)
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
END SP_RBC_09_PRECIOS;
/
EXIT;
