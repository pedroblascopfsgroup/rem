--/*
--##########################################
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190312
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3322
--## PRODUCTO=NO
--##
--## Finalidad: Eliminar fechas alquiler registros venta (TCO = 2)
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##		0.2 Correcciones REMVIP-3555
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-3322';
    
    
 BEGIN

    	V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION T1 USING(
			SELECT * FROM (
			    WITH TODO AS (
			    SELECT AHP.AHP_ID, ACT.ACT_ID, ACT.ACT_NUM_ACTIVO, AHP.AHP_FECHA_INI_ALQUILER,  AHP.AHP_FECHA_INI_VENTA,
				    AHP.AHP_FECHA_FIN_ALQUILER, AHP.AHP_FECHA_FIN_VENTA, AHP.DD_TCO_ID
			    FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
			    JOIN '||V_ESQUEMA||'.ACT_AHP_HIST_PUBLICACION AHP ON AHP.ACT_ID = ACT.ACT_ID AND AHP.BORRADO = 0
			    WHERE ACT.BORRADO = 0
			    )
			    SELECT AHP_ID, ACT_NUM_ACTIVO, AHP_FECHA_INI_ALQUILER, AHP_FECHA_INI_VENTA, AHP_FECHA_FIN_ALQUILER, AHP_FECHA_FIN_VENTA, DD_TCO_ID
			    FROM TODO
			)WHERE DD_TCO_ID = 2 AND ((AHP_FECHA_INI_VENTA IS NOT NULL OR AHP_FECHA_FIN_VENTA IS NOT NULL) AND (AHP_FECHA_INI_ALQUILER IS NOT NULL OR AHP_FECHA_FIN_ALQUILER IS NOT NULL))) T2
			ON (T1.AHP_ID = T2.AHP_ID)
			WHEN MATCHED THEN 
			UPDATE SET
			T1.AHP_FECHA_INI_ALQUILER = NULL
			,T1.AHP_FECHA_FIN_ALQUILER = NULL
			,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
			,T1.FECHAMODIFICAR = SYSDATE';
    				
      EXECUTE IMMEDIATE V_SQL;
      
	  DBMS_OUTPUT.PUT_LINE('Se han creado los registros en la histórica correctamente');
      
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
