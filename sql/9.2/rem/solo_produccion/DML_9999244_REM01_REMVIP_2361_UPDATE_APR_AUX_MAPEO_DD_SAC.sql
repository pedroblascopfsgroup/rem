--/*
--#########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20181030
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2361
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR TABLA APR_AUX_MAPEO_DD_SAC DESDE TABLA AUXILIAR
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; --'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; --'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-2361';

BEGIN

--BUSCA Y ACTUALIZA APR_AUX_MAPEO_DD_SAC

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de actualizacion.');

		V_SQL := '  MERGE INTO REM01.APR_AUX_MAPEO_DD_SAC T1 
			    USING (
			    SELECT AUX.COD_BIEN_IRIS, AUX.DD_SAC_CODIGO, AUX.DD_TPA_CODIGO 
			    FROM REM01.AUX_APR_AUX_MAPEO_DD_SAC AUX 
			    LEFT JOIN REM01.APR_AUX_MAPEO_DD_SAC SAC2 ON SAC2.DD_CODIGO_SUBTIPO_REC = AUX.COD_BIEN_IRIS 
			    LEFT JOIN REM01.DD_TPA_TIPO_ACTIVO TPA ON TPA.DD_TPA_CODIGO = AUX.DD_TPA_CODIGO 
			    LEFT JOIN REM01.DD_SAC_SUBTIPO_ACTIVO SAC ON SAC.DD_SAC_CODIGO = AUX.DD_SAC_CODIGO 
			    WHERE SAC2.DD_CODIGO_SUBTIPO_REC IS NULL 
			    )
			    T2 
			    ON (T1.DD_CODIGO_SUBTIPO_REC = T2.COD_BIEN_IRIS)
				   WHEN NOT MATCHED THEN INSERT (DD_MSA_ID, 
								 DD_CODIGO_SUBTIPO_REC, 
								 DD_CODIGO_SUBTIPO_REM, 
								 DD_CODIGO_TIPO_REM, 
								 DD_CODIGO_TUD_REM, 
								 VERSION, 
								 USUARIOCREAR, 
								 FECHACREAR, 
								 USUARIOMODIFICAR, 
								 FECHAMODIFICAR, 
								 USUARIOBORRAR, 
								 FECHABORRAR, 
								 BORRADO)
				   VALUES (REM01.S_APR_AUX_MAPEO_DD_SAC.NEXTVAL,
					   T2.COD_BIEN_IRIS, 
					   T2.DD_SAC_CODIGO, 
					   T2.DD_TPA_CODIGO, 
					   NULL, 
					   0, 
					   ''REMVIP_2361'', 
					   SYSDATE, 
					   NULL, 
					   NULL, 
					   NULL, 
					   NULL, 
					   0)';
                    

		EXECUTE IMMEDIATE V_SQL;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado en total '||SQL%ROWCOUNT||' registros en la tabla APR_AUX_MAPEO_DD_SAC.');
		COMMIT;

		DBMS_OUTPUT.PUT_LINE('[FIN] Finaliza el proceso de actualizacion.');

EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------');
      DBMS_OUTPUT.PUT_LINE(SQLERRM);
      ROLLBACK;
      RAISE;
END;
/
EXIT;
