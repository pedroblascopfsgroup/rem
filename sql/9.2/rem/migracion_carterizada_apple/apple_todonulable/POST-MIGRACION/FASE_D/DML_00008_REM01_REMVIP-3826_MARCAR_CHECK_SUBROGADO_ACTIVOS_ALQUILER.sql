--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190329
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=HREOS-5915
--## PRODUCTO=NO
--## 
--## Finalidad:  Se marca el check de SUBROGADO de activos de alquiler.
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
      
      DBMS_OUTPUT.PUT_LINE('[INICIO]');

      -------------------------------------------------
      --MERGE EN ACT_PTA_PATRIMONIO_ACTIVO--
      -------------------------------------------------   
      DBMS_OUTPUT.PUT_LINE('	[INFO] MERGE EN ACT_PTA_PATRIMONIO_ACTIVO');

      
      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO T1
				USING (
					SELECT PTA.ACT_PTA_ID,
						   ACT.ACT_ID,
						   ACT.ACT_NUM_ACTIVO
					FROM '||V_ESQUEMA||'.AUX_MMC_REMVIP_3818          AUX
					JOIN '||V_ESQUEMA||'.ACT_ACTIVO                   ACT ON AUX.ID_HAYA = ACT.ACT_NUM_ACTIVO
					JOIN '||V_ESQUEMA||'.ACT_PTA_PATRIMONIO_ACTIVO    PTA ON PTA.ACT_ID = ACT.ACT_ID
					WHERE ACT.USUARIOCREAR = ''MIG_APPLE''
				) T2
				ON (T1.ACT_PTA_ID = T2.ACT_PTA_ID AND T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.CHECK_SUBROGADO = 1,
					T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
					T1.FECHAMODIFICAR = SYSDATE
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] Se marca el check de SUBROGADO de '||V_NUM_TABLAS||' activos de alquiler de APPLE.');  
    
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
