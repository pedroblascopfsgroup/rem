--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190314
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3322
--## PRODUCTO=NO
--##
--## Finalidad: Igualar fecha actual APU con AHP
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3555';
    
 BEGIN

    	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION T1
                    USING (
                        SELECT DISTINCT(APU.APU_ID), APU.APU_FECHA_INI_VENTA, AHP.AHP_FECHA_INI_VENTA
                        FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                        JOIN '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP ON AHP.ACT_ID = APU.ACT_ID
                        WHERE (AHP.AHP_FECHA_INI_VENTA IS NOT NULL AND AHP.AHP_FECHA_FIN_VENTA IS NULL) 
                        AND AHP.DD_TCO_ID IN (1,2)
                        AND APU.APU_FECHA_INI_VENTA <> AHP.AHP_FECHA_INI_VENTA
                        AND AHP.BORRADO = 0
                    ) T2
                    ON (T1.APU_ID = T2.APU_ID)
                    WHEN MATCHED THEN UPDATE SET
                        T1.APU_FECHA_INI_VENTA = T2.AHP_FECHA_INI_VENTA
                        ,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        ,T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_SQL;

        V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION T1
                    USING (
                        SELECT DISTINCT(APU.APU_ID), APU.APU_FECHA_INI_ALQUILER, AHP.AHP_FECHA_INI_ALQUILER
                        FROM '||V_ESQUEMA||'.ACT_APU_ACTIVO_PUBLICACION APU
                        JOIN '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP ON AHP.ACT_ID = APU.ACT_ID
                        WHERE (AHP.AHP_FECHA_INI_ALQUILER IS NOT NULL AND AHP.AHP_FECHA_FIN_ALQUILER IS NULL) 
                        AND AHP.DD_TCO_ID IN (2,3)
                        AND APU.APU_FECHA_INI_ALQUILER <> AHP.AHP_FECHA_INI_ALQUILER
                        AND AHP.BORRADO = 0
                    ) T2
                    ON (T1.APU_ID = T2.APU_ID)
                    WHEN MATCHED THEN UPDATE SET
                        T1.APU_FECHA_INI_ALQUILER = T2.AHP_FECHA_INI_ALQUILER
                        ,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                        ,T1.FECHAMODIFICAR = SYSDATE';
        EXECUTE IMMEDIATE V_SQL;
      
 COMMIT;
 
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
