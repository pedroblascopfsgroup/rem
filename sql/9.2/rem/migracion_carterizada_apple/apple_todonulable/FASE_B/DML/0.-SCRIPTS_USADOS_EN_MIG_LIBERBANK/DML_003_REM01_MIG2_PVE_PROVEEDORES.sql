--/*
--#########################################
--## AUTOR=DAP
--## FECHA_CREACION=20170612
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2209
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_PVE_PROVEEDORES -> ACT_PVE_PROVEEDOR
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

      V_ESQUEMA VARCHAR2(10 CHAR) := 'REM01';
      V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := 'REMMASTER';
      V_USUARIO VARCHAR2(50 CHAR) := '#USUARIO_MIGRACION#';
      V_TABLA VARCHAR2(40 CHAR) := 'ACT_PVE_PROVEEDOR';
      V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_PVE_PROVEEDORES';
      V_SENTENCIA VARCHAR2(32000 CHAR);

BEGIN
      
      --Inicio del proceso de volcado sobre ACT_PVE_PROVEEDOR
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      
      EXECUTE IMMEDIATE '
      MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' PVE
      USING 
      ( 
            SELECT
                  MIG.PVE_COD_UVEM,
                  TPR.DD_TPR_ID,
                  MIG.PVE_NOMBRE,
                  MIG.PVE_NOMBRE_COMERCIAL,
                  TDI.DD_TDI_ID,
                  MIG.PVE_DOCUMENTO_ID,
                  ZNG.DD_ZNG_ID,
                  PRV.DD_PRV_ID,
                  LOC.DD_LOC_ID,
                  MIG.PVE_COD_POSTAL,
                  MIG.PVE_DIRECCION,
                  MIG.PVE_TELEFONO1,
                  MIG.PVE_TELEFONO2,
                  MIG.PVE_FAX,
                  MIG.PVE_EMAIL,
                  MIG.PVE_PAGINA_WEB,
                  MIG.PVE_IND_FRANQUICIA,
                  MIG.PVE_IND_IVA_CAJA,
                  MIG.PVE_NUM_CUENTA,
                  TPC.DD_TPC_ID,
                  TPE.DD_TPE_ID,
                  MIG.PVE_RAZON_SOCIAL,
                  MIG.PVE_FECHA_ALTA,
                  MIG.PVE_FECHA_BAJA,
                  MIG.PVE_IND_LOCALIZADO,
                  EPR.DD_EPR_ID,
                  MIG.PVE_FECHA_CONSTITUCION,
                  MIG.PVE_AMBITO,
                  MIG.PVE_OBSERVACIONES,
                  MIG.PVE_IND_HOMOLOGADO,
                  CPR.DD_CPR_ID,
                  MIG.PVE_TOP,
                  MIG.PVE_TITULAR,
                  MIG.PVE_IND_RETENER,
                  MRE.DD_MRE_ID,
                  MIG.PVE_FECHA_RETENCION,
                  MIG.PVE_FECHA_PBC,
                  RPB.DD_RPB_ID,
                  MIG.PVE_COD_API_PROVEEDOR,
                  MIG.PVE_IND_MODIFICAR_DATOS_WEB,
                  MIG.PVE_REM_ID
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                  INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_CODIGO = MIG.PVE_COD_TIPO_PROVEEDOR
                  LEFT JOIN '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID TDI ON TDI.DD_TDI_CODIGO = MIG.PVE_COD_TIPO_DOCUMENTO
                  LEFT JOIN '||V_ESQUEMA||'.DD_ZNG_ZONA_GEOGRAFICA ZNG ON ZNG.DD_ZNG_CODIGO = MIG.PVE_CON_ZONA_GEOGRAFICA
                  LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_CODIGO = MIG.PVE_COD_PROVINCIA
                  LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_CODIGO = MIG.PVE_COD_LOCALIDAD 
                  LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_COLABORADOR TPC ON TPC.DD_TPC_CODIGO = MIG.PVE_COD_TIPO_COLABORADOR
                  LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_TPE_TIPO_PERSONA TPE ON TPE.DD_TPE_CODIGO = MIG.PVE_COD_TIPO_PERSONA
                  LEFT JOIN '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR EPR ON EPR.DD_EPR_CODIGO = MIG.PVE_COD_ESTADO
                  LEFT JOIN '||V_ESQUEMA||'.DD_CPR_CALIFICACION_PROVEEDOR CPR ON CPR.DD_CPR_CODIGO = MIG.PVE_COD_CALIFICACION
                  LEFT JOIN '||V_ESQUEMA||'.DD_MRE_MOTIVO_RETENCION MRE ON MRE.DD_MRE_CODIGO = MIG.PVE_COD_MOTIVO_RETENCION
                  LEFT JOIN '||V_ESQUEMA||'.DD_RPB_RES_PROCESO_BLANQUEO RPB ON RPB.DD_RPB_CODIGO = MIG.PVE_COD_RES_PROCESO_BLANQUEO 
                  WHERE MIG.VALIDACION = 0  AND MIG.PVE_COD_TIPO_PROVEEDOR NOT IN (23,28,29,30,31,38)
      ) SQLI
      ON (PVE.PVE_DOCIDENTIF = SQLI.PVE_DOCUMENTO_ID AND PVE.DD_TPR_ID = SQLI.DD_TPR_ID)
      WHEN MATCHED THEN UPDATE SET
            PVE.PVE_COD_PRINEX = SQLI.PVE_COD_UVEM
            ,PVE.USUARIOMODIFICAR = '''||V_USUARIO||'''
            ,PVE.FECHAMODIFICAR = SYSDATE
      WHEN NOT MATCHED THEN INSERT (
            PVE_ID
            ,PVE.PVE_COD_PRINEX
            ,PVE.DD_TPR_ID
            ,PVE.PVE_NOMBRE
            ,PVE.PVE_NOMBRE_COMERCIAL
            ,PVE.DD_TDI_ID
            ,PVE.PVE_DOCIDENTIF
            ,PVE.DD_ZNG_ID
            ,PVE.DD_PRV_ID
            ,PVE.DD_LOC_ID
            ,PVE.PVE_CP
            ,PVE.PVE_DIRECCION
            ,PVE.PVE_TELF1
            ,PVE.PVE_TELF2
            ,PVE.PVE_FAX
            ,PVE.PVE_EMAIL
            ,PVE.PVE_PAGINA_WEB
            ,PVE.PVE_FRANQUICIA
            ,PVE.PVE_IVA_CAJA
            ,PVE.PVE_NUM_CUENTA
            ,PVE.DD_TPC_ID
            ,PVE.DD_TPE_ID
            ,PVE.PVE_NIF
            ,PVE.PVE_FECHA_ALTA
            ,PVE.PVE_FECHA_BAJA
            ,PVE.PVE_LOCALIZADA
            ,PVE.DD_EPR_ID
            ,PVE.PVE_FECHA_CONSTITUCION
            ,PVE.PVE_AMBITO
            ,PVE.PVE_OBSERVACIONES
            ,PVE.PVE_HOMOLOGADO
            ,PVE.DD_CPR_ID
            ,PVE.PVE_TOP
            ,PVE.PVE_TITULAR_CUENTA
            ,PVE.PVE_RETENER
            ,PVE.DD_MRE_ID
            ,PVE.PVE_FECHA_RETENCION
            ,PVE.PVE_FECHA_PBC
            ,PVE.DD_RPB_ID
            ,PVE_COD_API_PROVEEDOR
            ,PVE.PVE_AUTORIZACION_WEB
            ,PVE.VERSION
            ,PVE.USUARIOCREAR
            ,PVE.FECHACREAR
            ,PVE.BORRADO
            ,PVE_COD_REM
            ,PVE_WEBCOM_ID
      )
      VALUES (
            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,
            SQLI.PVE_COD_UVEM,
            SQLI.DD_TPR_ID,
            SQLI.PVE_NOMBRE,
            SQLI.PVE_NOMBRE_COMERCIAL,
            SQLI.DD_TDI_ID,
            SQLI.PVE_DOCUMENTO_ID,
            SQLI.DD_ZNG_ID,
            SQLI.DD_PRV_ID,
            SQLI.DD_LOC_ID,
            SQLI.PVE_COD_POSTAL,
            SQLI.PVE_DIRECCION,
            SQLI.PVE_TELEFONO1,
            SQLI.PVE_TELEFONO2,
            SQLI.PVE_FAX,
            SQLI.PVE_EMAIL,
            SQLI.PVE_PAGINA_WEB,
            SQLI.PVE_IND_FRANQUICIA,
            SQLI.PVE_IND_IVA_CAJA,
            SQLI.PVE_NUM_CUENTA,
            SQLI.DD_TPC_ID,
            SQLI.DD_TPE_ID,
            SQLI.PVE_RAZON_SOCIAL,
            SQLI.PVE_FECHA_ALTA,
            SQLI.PVE_FECHA_BAJA,
            SQLI.PVE_IND_LOCALIZADO,
            SQLI.DD_EPR_ID,
            SQLI.PVE_FECHA_CONSTITUCION,
            SQLI.PVE_AMBITO,
            SQLI.PVE_OBSERVACIONES,
            SQLI.PVE_IND_HOMOLOGADO,
            SQLI.DD_CPR_ID,
            SQLI.PVE_TOP,
            SQLI.PVE_TITULAR,
            SQLI.PVE_IND_RETENER,
            SQLI.DD_MRE_ID,
            SQLI.PVE_FECHA_RETENCION,
            SQLI.PVE_FECHA_PBC,
            SQLI.DD_RPB_ID,
            SQLI.PVE_COD_API_PROVEEDOR,
            SQLI.PVE_IND_MODIFICAR_DATOS_WEB,
            ''0'',
            '''||V_USUARIO||''',
            SYSDATE,
            0,
            NVL(SQLI.PVE_REM_ID,REM01.S_PVE_COD_REM.NEXTVAL),
            SQLI.PVE_REM_ID
      )      
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

      /* 
            CAMBIO EL 2017-07-03 PARA QUE CARGUE MOMENTANEAMENTE 
            PRINCIPAL PROBLEMA: DUPLICADOS CON VAL=0 EN NIF+TIPO (Uno esta Vigente y el otro no)
      */

      /*EXECUTE IMMEDIATE 'INSERT INTO REM01.ACT_PVE_PROVEEDOR (PVE_ID
            ,PVE_COD_UVEM
            ,DD_TPR_ID
            ,PVE_NOMBRE
            ,PVE_NOMBRE_COMERCIAL
            ,DD_TDI_ID
            ,PVE_DOCIDENTIF
            ,DD_ZNG_ID
            ,DD_PRV_ID
            ,DD_LOC_ID
            ,PVE_CP
            ,PVE_DIRECCION
            ,PVE_TELF1
            ,PVE_TELF2
            ,PVE_FAX
            ,PVE_EMAIL
            ,PVE_PAGINA_WEB
            ,PVE_FRANQUICIA
            ,PVE_IVA_CAJA
            ,PVE_NUM_CUENTA
            ,DD_TPC_ID
            ,DD_TPE_ID
            ,PVE_NIF
            ,PVE_FECHA_ALTA
            ,PVE_FECHA_BAJA
            ,PVE_LOCALIZADA
            ,DD_EPR_ID
            ,PVE_FECHA_CONSTITUCION
            ,PVE_AMBITO
            ,PVE_OBSERVACIONES
            ,PVE_HOMOLOGADO
            ,DD_CPR_ID
            ,PVE_TOP
            ,PVE_TITULAR_CUENTA
            ,PVE_RETENER
            ,DD_MRE_ID
            ,PVE_FECHA_RETENCION
            ,PVE_FECHA_PBC
            ,DD_RPB_ID
            ,PVE_COD_API_PROVEEDOR
            ,PVE_AUTORIZACION_WEB
            ,USUARIOCREAR
            ,FECHACREAR
            ,PVE_COD_REM
            ,PVE_WEBCOM_ID)
SELECT REM01.S_ACT_PVE_PROVEEDOR.NEXTVAL,
                  MIG.PVE_COD_UVEM,
                  TPR.DD_TPR_ID,
                  MIG.PVE_NOMBRE,
                  MIG.PVE_NOMBRE_COMERCIAL,
                  TDI.DD_TDI_ID,
                  MIG.PVE_DOCUMENTO_ID,
                  ZNG.DD_ZNG_ID,
                  PRV.DD_PRV_ID,
                  LOC.DD_LOC_ID,
                  MIG.PVE_COD_POSTAL,
                  MIG.PVE_DIRECCION,
                  MIG.PVE_TELEFONO1,
                  MIG.PVE_TELEFONO2,
                  MIG.PVE_FAX,
                  MIG.PVE_EMAIL,
                  MIG.PVE_PAGINA_WEB,
                  MIG.PVE_IND_FRANQUICIA,
                  MIG.PVE_IND_IVA_CAJA,
                  MIG.PVE_NUM_CUENTA,
                  TPC.DD_TPC_ID,
                  TPE.DD_TPE_ID,
                  MIG.PVE_RAZON_SOCIAL,
                  MIG.PVE_FECHA_ALTA,
                  MIG.PVE_FECHA_BAJA,
                  MIG.PVE_IND_LOCALIZADO,
                  EPR.DD_EPR_ID,
                  MIG.PVE_FECHA_CONSTITUCION,
                  MIG.PVE_AMBITO,
                  MIG.PVE_OBSERVACIONES,
                  MIG.PVE_IND_HOMOLOGADO,
                  CPR.DD_CPR_ID,
                  MIG.PVE_TOP,
                  MIG.PVE_TITULAR,
                  MIG.PVE_IND_RETENER,
                  MRE.DD_MRE_ID,
                  MIG.PVE_FECHA_RETENCION,
                  MIG.PVE_FECHA_PBC,
                  RPB.DD_RPB_ID,
                  MIG.PVE_COD_API_PROVEEDOR,
                  MIG.PVE_IND_MODIFICAR_DATOS_WEB,
                  '''||V_USUARIO||''',
                  SYSDATE,
                  REM01.S_PVE_COD_REM.NEXTVAL,
                  MIG.PVE_REM_ID
 FROM REM01.MIG2_PVE_PROVEEDORES MIG
                  INNER JOIN REM01.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_CODIGO = MIG.PVE_COD_TIPO_PROVEEDOR
                  LEFT JOIN REM01.ACT_PVE_PROVEEDOR PVE ON PVE.PVE_COD_REM = MIG.PVE_REM_ID
                  LEFT JOIN REM01.DD_TDI_TIPO_DOCUMENTO_ID TDI ON TDI.DD_TDI_CODIGO = MIG.PVE_COD_TIPO_DOCUMENTO
                  LEFT JOIN REM01.DD_ZNG_ZONA_GEOGRAFICA ZNG ON ZNG.DD_ZNG_CODIGO = MIG.PVE_CON_ZONA_GEOGRAFICA
                  LEFT JOIN REM01.DD_TPC_TIPOS_COLABORADOR TPC ON TPC.DD_TPC_CODIGO = MIG.PVE_COD_TIPO_COLABORADOR
                  LEFT JOIN REM01.DD_EPR_ESTADO_PROVEEDOR EPR ON EPR.DD_EPR_CODIGO = MIG.PVE_COD_ESTADO
                  LEFT JOIN REM01.DD_CPR_CALIFICACION_PROVEEDOR CPR ON CPR.DD_CPR_CODIGO = MIG.PVE_COD_CALIFICACION
                  LEFT JOIN REM01.DD_MRE_MOTIVO_RETENCION MRE ON MRE.DD_MRE_CODIGO = MIG.PVE_COD_MOTIVO_RETENCION
                  LEFT JOIN REM01.DD_RPB_RES_PROCESO_BLANQUEO RPB ON RPB.DD_RPB_CODIGO = MIG.PVE_COD_RES_PROCESO_BLANQUEO 
                  LEFT JOIN REMMASTER.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_CODIGO = MIG.PVE_COD_PROVINCIA
                  LEFT JOIN REMMASTER.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_CODIGO = MIG.PVE_COD_LOCALIDAD 
                  LEFT JOIN REMMASTER.DD_TPE_TIPO_PERSONA TPE ON TPE.DD_TPE_CODIGO = MIG.PVE_COD_TIPO_PERSONA
                  WHERE MIG.VALIDACION = 0 AND PVE.PVE_ID IS NULL  
                  AND MIG.PVE_REM_ID > 0
      '
      ;*/
      
      EXECUTE IMMEDIATE '
      MERGE INTO REM01.ACT_PVE_PROVEEDOR PVE
      USING 
      ( 
            SELECT
                  PVE1.PVE_ID,
                  MIG.PVE_REM_ID
                  FROM REM01.MIG2_PVE_PROVEEDORES MIG
                  INNER JOIN REM01.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_CODIGO = MIG.PVE_COD_TIPO_PROVEEDOR
                  INNER JOIN REM01.ACT_PVE_PROVEEDOR PVE1 ON UPPER(TRIM(PVE1.PVE_NOMBRE_COMERCIAL)) = UPPER(TRIM(MIG.PVE_NOMBRE_COMERCIAL))
                  WHERE MIG.VALIDACION = 0
                  AND PVE1.DD_TPR_ID = TPR.DD_TPR_ID
                  AND MIG.PVE_COD_TIPO_PROVEEDOR IN (23,28,29,30,31,38)
      ) SQLI
      ON (PVE.PVE_ID = SQLI.PVE_ID)
      WHEN MATCHED THEN UPDATE SET
            PVE.PVE_WEBCOM_ID = SQLI.PVE_REM_ID
            ,PVE.USUARIOMODIFICAR = '''||V_USUARIO||'''
            ,PVE.FECHAMODIFICAR = SYSDATE
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');

      
      
      
      /*
			MODIFICACIÓN PARA COMUNIDAD DE PROPIETARIOS: (08/08/2018)
				Cargamos en la ACT_PVE_PROVEEDORES todas las C.P.s que vengan por migración y no estén ya insertadas en la ACT_PVE_PROVEEDORES.
      */
      
      EXECUTE IMMEDIATE 'INSERT INTO REM01.ACT_PVE_PROVEEDOR 
						(
							PVE_ID, PVE_COD_REM, DD_TPR_ID, DD_EPR_ID, PVE_COD_PRINEX, 
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
								   CPR.CPR_COD_COM_PROP_UVEM                                            AS PVE_COD_PRINEX,
								   CPR.CPR_NOMBRE                                                       AS PVE_NOMBRE,
								   CPR.CPR_NOMBRE                                                       AS PVE_NOMBRE_COMERCIAL,
								   CPR.CPR_NUM_CUENTA                                                   AS PVE_NUM_CUENTA,
								   CPR.CPR_NIF                                                          AS PVE_DOCIDENTIF,
								   NVL(CPR.CPR_PRESIDENTE_TELF,CPR.CPR_ADMINISTRADOR_TELF)              AS PVE_TELF1, 
								   NVL(CPR.CPR_PRESIDENTE_TELF2,CPR.CPR_ADMINISTRADOR_TELF2)            AS PVE_TELF2, 
								   NVL(CPR.CPR_DIRECCION,NVL(CPR.CPR_PRESIDENTE_DIR,CPR.CPR_ADMINISTRADOR_DIR))  AS PVE_DIRECCION, 
								   NVL(CPR.CPR_PRESIDENTE_EMAIL,CPR.CPR_ADMINISTRADOR_EMAIL)            AS PVE_EMAIL,
								   SYSDATE                                                              AS PVE_FECHA_ALTA,
								   '''||V_USUARIO||'''                                                  AS USUARIOCREAR,
								   SYSDATE                                                              AS FECHACREAR           
								 FROM ACT_CPR_COM_PROPIETARIOS   CPR
								 JOIN DD_TPR_TIPO_PROVEEDOR      TPR
								   ON TPR.DD_TPR_CODIGO = ''07''
								 JOIN DD_EPR_ESTADO_PROVEEDOR    EPR
								   ON EPR.DD_EPR_CODIGO = ''04''
							LEFT JOIN ACT_PVE_PROVEEDOR          PVE
								   ON CPR.CPR_COD_COM_PROP_UVEM = PVE.PVE_COD_PRINEX
								  AND TPR.DD_TPR_ID = PVE.DD_TPR_ID
							WHERE CPR.USUARIOCREAR = '''||V_USUARIO||''' 
							  AND PVE.PVE_ID IS NULL
						) AUX
      '; 
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');




	  /*
			PARTE FINAL DEL SCRIPT.
      */

      EXECUTE IMMEDIATE 'MERGE INTO REM01.ACT_PVE_PROVEEDOR T1
            USING(SELECT T1.PVE_ID, ROW_NUMBER() OVER(PARTITION BY T1.PVE_DOCIDENTIF, T1.DD_TPR_ID ORDER BY T1.PVE_ID DESC) RN
                FROM REM01.ACT_PVE_PROVEEDOR T1
                WHERE T1.BORRADO = 0 AND T1.PVE_FECHA_BAJA IS NULL AND T1.PVE_DOCIDENTIF IS NOT NULL) T2
            ON (T1.PVE_ID = T2.PVE_ID AND T2.RN > 1)
            WHEN MATCHED THEN UPDATE SET
                T1.PVE_FECHA_BAJA = SYSTIMESTAMP, T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSTIMESTAMP';

      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' dados de baja por ser proveedor antiguo. '||SQL%ROWCOUNT||' Filas.');
      
      EXECUTE IMMEDIATE 'TRUNCATE TABLE REM01.MIG_AUX_ACT_PVE_PROVEEDOR';
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.MIG_AUX_ACT_PVE_PROVEEDOR truncada. '||SQL%ROWCOUNT||' Filas.');
      EXECUTE IMMEDIATE 'INSERT INTO REM01.MIG_AUX_ACT_PVE_PROVEEDOR (PVE_ID, PVE_COD_UVEM, DD_TPR_ID)
            SELECT PVE_ID, PVE_COD_UVEM, DD_TPR_ID
            FROM (SELECT PVE_ID, PVE_COD_PRINEX AS PVE_COD_UVEM, DD_TPR_ID, PVE_FECHA_BAJA, ROW_NUMBER() OVER(PARTITION BY PVE_COD_PRINEX, DD_TPR_ID ORDER BY PVE_FECHA_BAJA NULLS FIRST) RN
                FROM REM01.ACT_PVE_PROVEEDOR
                WHERE PVE_COD_PRINEX IS NOT NULL
                    AND BORRADO = 0)
            WHERE RN = 1';
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.MIG_AUX_ACT_PVE_PROVEEDOR cargada. '||SQL%ROWCOUNT||' Filas.');
      COMMIT;
      
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'',''MIG_AUX_ACT_PVE_PROVEEDOR'',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.MIG_AUX_ACT_PVE_PROVEEDOR ANALIZADA.');


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
