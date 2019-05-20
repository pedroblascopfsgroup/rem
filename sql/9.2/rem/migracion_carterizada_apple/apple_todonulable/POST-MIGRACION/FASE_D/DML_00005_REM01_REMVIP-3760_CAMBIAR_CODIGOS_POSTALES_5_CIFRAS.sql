--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190326
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=HREOS-5915
--## PRODUCTO=NO
--## 
--## Finalidad: Codigos postales a 5 cifras
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

  V_ESQUEMA VARCHAR2(30 CHAR):= 'REM01'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  USUARIO_MIGRACION VARCHAR2(50 CHAR):= 'MIG_APPLE';

BEGIN
      
      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la actualizacion de codigos postales a 5 cifras.');

      -------------------------------------------------
      --MERGE EN BIE_LOCALIZACION--
      -------------------------------------------------   
      DBMS_OUTPUT.PUT_LINE('	[INFO] MERGE EN BIE_LOCALIZACION');

      
      V_SQL := 'MERGE INTO REM01.BIE_LOCALIZACION T1
				USING (
					SELECT AUX.ACT_NUMERO_ACTIVO,
						   ACT.ACT_ID,
						   BIE.BIE_ID,
						   LOC.BIE_LOC_ID,
						   LOC.BIE_LOC_COD_POST   		AS BD_REM,
						   AUX.LOC_COD_POST       		AS FICH_ORIGINAL,
						   AUX2.LOC_COD_POST       		AS FICH_NUEVO,
						   LPAD(AUX2.LOC_COD_POST,5,0) 	AS FICH_NUEVO_BIEN
					FROM '||V_ESQUEMA||'.MIG_ADA_DATOS_ADI AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO        ACT  ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUMERO_ACTIVO
					JOIN '||V_ESQUEMA||'.BIE_BIEN          BIE  ON BIE.BIE_ID = ACT.BIE_ID
					JOIN '||V_ESQUEMA||'.BIE_LOCALIZACION  LOC  ON LOC.BIE_ID = BIE.BIE_ID
					JOIN '||V_ESQUEMA||'.AUX_REMVIP_3729   AUX2 ON AUX2.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
				) T2
				ON (T1.BIE_LOC_ID = T2.BIE_LOC_ID AND T1.BIE_ID = T2.BIE_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.BIE_LOC_COD_POST = FICH_NUEVO_BIEN,
					T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
					T1.FECHAMODIFICAR = SYSDATE
	  ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] Se updatea a 5 cifras el codigo postal de '||V_NUM_TABLAS||' activos de APPLE.');  
    
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('[FIN]');   
       
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;
/
EXIT;
