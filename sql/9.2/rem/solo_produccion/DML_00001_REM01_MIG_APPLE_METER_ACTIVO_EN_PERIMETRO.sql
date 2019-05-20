--/*
--#########################################
--## AUTOR=Marco Munoz
--## FECHA_CREACION=20190327
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0
--## INCIDENCIA_LINK=HREOS-5915
--## PRODUCTO=NO
--## 
--## Finalidad: METER ACTIVO EN PERIMETRO
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
      --INSERCION EN ACT_PAC_PERIMETRO_ACTIVO--
      -------------------------------------------------   
      DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_PAC_PERIMETRO_ACTIVO');

      
      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO T1
				USING (
					SELECT ACT.ACT_NUM_ACTIVO, ACT.ACT_ID, CAP.DD_CAP_DESCRIPCION, PAC.PAC_ID, PAC.PAC_INCLUIDO, ACT.USUARIOCREAR
					FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT
					JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON ACT.ACT_ID = PAC.ACT_ID
					JOIN '||V_ESQUEMA||'.DD_CAP_CLASIFICACION_APPLE CAP ON CAP.DD_CAP_ID = ACT.DD_CAP_ID
					WHERE ACT.ACT_NUM_ACTIVO = 7044585
					  AND CAP.DD_CAP_CODIGO IN (''01'')
					  AND ACT.USUARIOCREAR = ''MIG_APPLE''
				) T2
				ON (T1.PAC_ID = T2.PAC_ID AND T1.ACT_ID = T2.ACT_ID)
				WHEN MATCHED THEN UPDATE SET
					T1.PAC_INCLUIDO = 1,
					T1.USUARIOMODIFICAR = ''MIG_PRUEBA_WEBCOM'',
					T1.FECHAMODIFICAR = SYSDATE
      ';
      EXECUTE IMMEDIATE V_SQL;
      
      V_NUM_TABLAS := SQL%ROWCOUNT;
      DBMS_OUTPUT.PUT_LINE('[INFO_MIGRA] Se mete el activo en el perimetro. '||V_NUM_TABLAS||' activos de APPLE.');  
    
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
