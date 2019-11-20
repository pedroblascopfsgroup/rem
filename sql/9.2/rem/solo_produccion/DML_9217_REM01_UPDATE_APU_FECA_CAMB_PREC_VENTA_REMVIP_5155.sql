--/*
--##########################################								
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190830
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5155
--## PRODUCTO=NO
--##
--## Finalidad:  ACTUALIZAR APU_FECHA_CAMB_PREC_VENTA A LOS ACTIVOS DE LA TABLA AUXILIAR
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-5155';

    
 BEGIN

   DBMS_OUTPUT.PUT_LINE('[INICIO] ');


	V_SQL := ' MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
				USING(
				SELECT APU_ID, APU.APU_FECHA_CAMB_PREC_VENTA
				FROM REM_EXT.TMP_PERIMETRO_290819 TMP
				JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = TMP.NUM_ACTIVO_HAYA
				JOIN '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU ON APU.ACT_ID = ACT.ACT_ID
				WHERE DD_SCM_ID <> 5 AND 
				TO_CHAR(APU_FECHA_CAMB_PREC_VENTA,''dd/mm/yy'') LIKE ''29/08/19''
				) AUX ON (APU.APU_ID = AUX.APU_ID)
		   WHEN MATCHED THEN
		       UPDATE SET
		       APU.APU_FECHA_CAMB_PREC_VENTA = TO_DATE(''21/08/2019'', ''dd/mm/yyyy''),
		       APU.USUARIOMODIFICAR = ''REMVIP-5155'',
		       APU.FECHAMODIFICAR = SYSDATE';

	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] MERGEADOS '||SQL%ROWCOUNT||' registros en ACT_APU_ACTIVO_PUBLICACION ');  

  COMMIT;

  DBMS_OUTPUT.PUT_LINE('[FIN]');
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
