--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190329
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=HREOS-5915
--## PRODUCTO=NO
--## 
--## Finalidad: Metemos en el perimetro los activos de APPLE según su DD_CAP_ID (Normal - 01)
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
      
      DBMS_OUTPUT.PUT_LINE('[INICIO] Sacamos del perimetro los activos de APPLE según su DD_CAP_ID.');

      -------------------------------------------------
      --MERGE EN ACT_PAC_PERIMETRO_ACTIVO--
      -------------------------------------------------   
      DBMS_OUTPUT.PUT_LINE('	[INFO] MERGE EN ACT_PAC_PERIMETRO_ACTIVO');

      
      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T1
				USING (
					SELECT ACT.ACT_NUM_ACTIVO,
						   ACT.ACT_ID,
						   CAP.DD_CAP_ID,
						   CAP.DD_CAP_DESCRIPCION,
						   PAC.PAC_ID
					FROM '||V_ESQUEMA||'.ACT_ACTIVO                   ACT 
					JOIN '||V_ESQUEMA||'.DD_CAP_CLASIFICACION_APPLE   CAP ON CAP.DD_CAP_ID = ACT.DD_CAP_ID
					JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO     PAC ON PAC.ACT_ID = ACT.ACT_ID
					WHERE ACT.USUARIOCREAR = ''MIG_APPLE'' 
					  AND CAP.DD_CAP_CODIGO IN (''01'')
				) T2
				ON (T1.PAC_ID = T2.PAC_ID AND T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.PAC_INCLUIDO = 1,
					T1.USUARIOMODIFICAR = ''MIG_APPLE_POST'',
					T1.FECHAMODIFICAR = SYSDATE 
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] Se sacan del perímetro según su DD_CAP_ID '||V_NUM_TABLAS||' activos de APPLE.');  
    
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
