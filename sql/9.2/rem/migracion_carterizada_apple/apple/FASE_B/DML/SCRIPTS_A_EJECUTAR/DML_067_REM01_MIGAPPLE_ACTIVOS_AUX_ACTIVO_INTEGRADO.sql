--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20180702
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4266
--## PRODUCTO=NO
--## 
--## Finalidad: Informar nueva tabla AIN_ACTIVO_INTEGRADO
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

  USUARIO_MIGRACION VARCHAR2(50 CHAR):= '#USUARIO_MIGRACION#';

BEGIN
      
   DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la migración de ACTIVOS ACTIVO-INTEGRADO');

   -------------------------------------------------
   --INSERCION EN AIN_ACTIVO_INTEGRADO--
   -------------------------------------------------
   DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN AIN_ACTIVO_INTEGRADO');
      
      
   V_SQL :=  'INSERT INTO '||V_ESQUEMA||'.AIN_ACTIVO_INTEGRADO 
              (
				AIN_ID, ACT_ID, PVE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO
		      )
			  SELECT
			  '||V_ESQUEMA||'.S_AIN_ACTIVO_INTEGRADO.NEXTVAL	AS AIN_ID,
			  AUX.*
			  FROM (
				SELECT DISTINCT
					ACT.ACT_ID 									AS ACT_ID,
					PVE.PVE_ID 									AS PVE_ID,
					0 											AS VERSION,
					'''||USUARIO_MIGRACION||''' 				AS USUARIOCREAR,
					SYSDATE 									AS FECHACREAR,
					0 											AS BORRADO
				FROM '||V_ESQUEMA||'.MIG_CPC_PROP_CABECERA                             MIG
				JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR                             TPR
				  ON TPR.DD_TPR_CODIGO = ''07'' 
				JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR                                 PVE 
				  ON PVE.PVE_COD_PRINEX = MIG.CPR_COD_COM_PROP_EXTERNO
				 AND PVE.DD_TPR_ID = TPR.DD_TPR_ID
				JOIN '||V_ESQUEMA||'.ACT_CPR_COM_PROPIETARIOS                          CPR 
				  ON CPR.CPR_COD_COM_PROP_UVEM = MIG.CPR_COD_COM_PROP_EXTERNO
				JOIN '||V_ESQUEMA||'.MIG_ADA_DATOS_ADI                                 ADA
				  ON ADA.CPR_COD_COM_PROP_EXTERNO = CPR.CPR_COD_COM_PROP_UVEM
				JOIN '||V_ESQUEMA||'.ACT_ACTIVO                                        ACT 
				  ON ADA.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
				WHERE MIG.VALIDACION IN (0,1)
				  AND ADA.VALIDACION IN (0,1)
				  AND ACT.BORRADO = 0 
				  AND PVE.BORRADO = 0 
				  AND CPR.BORRADO = 0
				  AND NOT EXISTS 
				  (
					  SELECT 1
					  FROM '||V_ESQUEMA||'.AIN_ACTIVO_INTEGRADO AIN
					  WHERE AIN.PVE_ID = PVE.PVE_ID
						AND AIN.ACT_ID = ACT.ACT_ID
				  )
   ) AUX
   ';
   EXECUTE IMMEDIATE V_SQL;
      
   DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.AIN_ACTIVO_INTEGRADO cargada. '||SQL%ROWCOUNT||' Filas.');
      
   V_SQL := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''STATS'',''AIN_ACTIVO_INTEGRADO'',''10''); END;';
   EXECUTE IMMEDIATE V_SQL;

   COMMIT; 
      
   DBMS_OUTPUT.PUT_LINE('[FIN] Acaba la migración de ACTIVOS ACTIVO-INTEGRADO');
      
      
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

