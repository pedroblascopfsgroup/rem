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

   
   --Cargamos en la ACT_PVE_PROVEEDORES todas las C.P.s que vengan por migración y no estén ya insertadas en la ACT_PVE_PROVEEDORES.
   -------------------------------------------------
   --INSERCION EN ACT_PVE_PROVEEDOR--
   -------------------------------------------------   
   DBMS_OUTPUT.PUT_LINE('	[INFO] INSERCION EN ACT_PVE_PROVEEDOR');
   
   EXECUTE IMMEDIATE 'INSERT INTO '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR 
					(
						PVE_ID, PVE_COD_REM, DD_TPR_ID, DD_EPR_ID, PVE_COD_UVEM, 
						PVE_NOMBRE, PVE_NOMBRE_COMERCIAL, PVE_NUM_CUENTA, PVE_DOCIDENTIF, 
						PVE_TELF1, PVE_TELF2, PVE_DIRECCION, PVE_EMAIL, PVE_FECHA_ALTA, 
						USUARIOCREAR, FECHACREAR
					)
					SELECT  '||V_ESQUEMA||'.S_ACT_PVE_PROVEEDOR.NEXTVAL                                       AS PVE_ID,
							'||V_ESQUEMA||'.S_PVE_COD_REM.NEXTVAL                                             AS PVE_COD_REM,
							AUX.*
					FROM (
						SELECT DISTINCT 
							   TPR.DD_TPR_ID                                                        AS DD_TPR_ID,
							   EPR.DD_EPR_ID                                                        AS DD_EPR_ID,
							   CPR.CPR_COD_COM_PROP_EXTERNO                                         AS PVE_COD_UVEM,
							   CPR.CPR_NOMBRE                                                       AS PVE_NOMBRE,
							   CPR.CPR_NOMBRE                                                       AS PVE_NOMBRE_COMERCIAL,
							   CPR.CPR_NUM_CUENTA                                                   AS PVE_NUM_CUENTA,
							   CPR.CPR_NIF                                                          AS PVE_DOCIDENTIF,
							   NVL(CPR.CPR_PRESIDENTE_TELF,CPR.CPR_ADMINISTRADOR_TELF)              AS PVE_TELF1, 
							   NVL(CPR.CPR_PRESIDENTE_TELF2,CPR.CPR_ADMINISTRADOR_TELF2)            AS PVE_TELF2, 
							   NVL(CPR.CPR_DIRECCION,NVL(CPR.CPR_PRESIDENTE_DIR,CPR.CPR_ADMINISTRADOR_DIR))  AS PVE_DIRECCION, 
							   NVL(SUBSTR(CPR.CPR_PRESIDENTE_EMAIL,0,50),SUBSTR(CPR.CPR_ADMINISTRADOR_EMAIL,0,50))            AS PVE_EMAIL,
							   SYSDATE                                                              AS PVE_FECHA_ALTA,
							   '''||USUARIO_MIGRACION||'''                                          AS USUARIOCREAR,
							   SYSDATE                                                              AS FECHACREAR           
							 FROM '||V_ESQUEMA||'.MIG_CPC_PROP_CABECERA      CPR
							 JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR      TPR
							   ON TPR.DD_TPR_CODIGO = ''07''
							 JOIN '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR    EPR
							   ON EPR.DD_EPR_CODIGO = ''04''
						LEFT JOIN '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR          PVE
							   ON CPR.CPR_COD_COM_PROP_EXTERNO = PVE.PVE_COD_UVEM
							  AND TPR.DD_TPR_ID = PVE.DD_TPR_ID
						WHERE PVE.PVE_ID IS NULL
					) AUX
   '; 
   DBMS_OUTPUT.PUT_LINE('  [INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ACT_PVE_PROVEEDOR cargada. '||SQL%ROWCOUNT||' Filas.');
  
   
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
				  ON PVE.PVE_COD_UVEM = MIG.CPR_COD_COM_PROP_EXTERNO
				 AND PVE.DD_TPR_ID = TPR.DD_TPR_ID
				JOIN '||V_ESQUEMA||'.MIG_ADA_DATOS_ADI                                 ADA
				  ON ADA.CPR_COD_COM_PROP_EXTERNO = MIG.CPR_COD_COM_PROP_EXTERNO
				JOIN '||V_ESQUEMA||'.ACT_ACTIVO                                        ACT 
				  ON ADA.ACT_NUMERO_ACTIVO = ACT.ACT_NUM_ACTIVO
				WHERE MIG.VALIDACION IN (0,1)
				  AND ADA.VALIDACION IN (0,1)
				  AND ACT.BORRADO = 0 
				  AND PVE.BORRADO = 0 
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

