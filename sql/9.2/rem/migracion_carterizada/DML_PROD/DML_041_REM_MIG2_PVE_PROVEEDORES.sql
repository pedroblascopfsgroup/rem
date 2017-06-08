--/*
--#########################################
--## AUTOR=Guillem Rey
--## FECHA_CREACION=20170608
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-2195
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

      TABLE_COUNT NUMBER(10,0) := 0;
      TABLE_COUNT_2 NUMBER(10,0) := 0;
      V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
      V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
      V_TABLA VARCHAR2(40 CHAR) := 'ACT_PVE_PROVEEDOR';
      V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_PVE_PROVEEDORES';
      V_SENTENCIA VARCHAR2(32000 CHAR);
      V_REG_MIG NUMBER(10,0) := 0;
      V_REG_INSERTADOS NUMBER(10,0) := 0;
      V_REG_UPDATE NUMBER(10,0) := 0;
      V_REJECTS NUMBER(10,0) := 0;
      V_COD NUMBER(10,0) := 0;
      V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

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
				  MIG.PVE_IND_MODIFICAR_DATOS_WEB
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
                  INNER JOIN '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR TPR ON TPR.DD_TPR_CODIGO = MIG.PVE_COD_TIPO_PROVEEDOR
                  LEFT JOIN '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID TDI ON TDI.DD_TDI_CODIGO = MIG.PVE_COD_TIPO_DOCUMENTO
                  LEFT JOIN '||V_ESQUEMA||'.DD_ZNG_ZONA_GEOGRAFICA ZNG ON ZNG.DD_ZNG_CODIGO = MIG.PVE_CON_ZONA_GEOGRAFICA
                  LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA PRV ON PRV.DD_PRV_CODIGO = MIG.PVE_COD_PROVINCIA
                  LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_CODIGO = MIG.PVE_COD_LOCALIDAD 
                  LEFT JOIN '||V_ESQUEMA||'.DD_TPC_TIPOS_COLABORADOR TPC ON TPC.DD_TPC_CODIGO = MIG.PVE_COD_TIPO_COLABORADOR
                  LEFT JOIN '||V_ESQUEMA||'.DD_TPE_TIPO_PERSONA TPE ON TPE.DD_TPE_CODIGO = MIG.PVE_COD_TIPO_PERSONA
                  LEFT JOIN '||V_ESQUEMA||'.DD_EPR_ESTADO_PROVEEDOR EPR ON EPR.DD_EPR_CODIGO = MIG.PVE_COD_ESTADO
                  LEFT JOIN '||V_ESQUEMA||'.DD_CPR_CALIFICACION_PROVEEDOR CPR ON CPR.DD_CPR_CODIGO = MIG.PVE_COD_CALIFICACION
                  LEFT JOIN '||V_ESQUEMA||'.DD_MRE_MOTIVO_RETENCION MRE ON MRE.DD_MRE_CODIGO = MIG.PVE_COD_MOTIVO_RETENCION
                  LEFT JOIN '||V_ESQUEMA||'.DD_RPB_RES_PROCESO_BLANQUEO RPB ON RPB.DD_RPB_CODIGO = MIG.PVE_COD_RES_PROCESO_BLANQUEO	
			WHERE MIG.VALIDACION = 0		
      ) SQLI
      ON (PVE.PVE_DOCIDENTIF = SQLI.PVE_DOCUMENTO_ID AND PVE.DD_TPR_ID = SQLI.DD_TPR_ID)
      WHEN MATCHED THEN UPDATE SET
            PVE.PVE_COD_UVEM = SQLI.PVE_COD_UVEM
            ,PVE.DD_TPC_ID = SQLI.DD_TPC_ID
            ,PVE.DD_TPE_ID = SQLI.DD_TPE_ID
            ,PVE.PVE_NIF = SQLI.PVE_RAZON_SOCIAL
            ,PVE.PVE_FECHA_ALTA = SQLI.PVE_FECHA_ALTA
            ,PVE.PVE_FECHA_BAJA = SQLI.PVE_FECHA_BAJA
            ,PVE.PVE_LOCALIZADA = SQLI.PVE_IND_LOCALIZADO
            ,PVE.DD_EPR_ID = SQLI.DD_EPR_ID
            ,PVE.PVE_FECHA_CONSTITUCION = SQLI.PVE_FECHA_CONSTITUCION
            ,PVE.PVE_AMBITO = SQLI.PVE_AMBITO
            ,PVE.PVE_OBSERVACIONES = SQLI.PVE_OBSERVACIONES
            ,PVE.PVE_HOMOLOGADO = SQLI.PVE_IND_HOMOLOGADO
            ,PVE.DD_CPR_ID = SQLI.DD_CPR_ID
            ,PVE.PVE_TOP = SQLI.PVE_TOP
            ,PVE.PVE_TITULAR_CUENTA = SQLI.PVE_TITULAR
            ,PVE.PVE_RETENER = SQLI.PVE_IND_RETENER
            ,PVE.DD_MRE_ID = SQLI.DD_MRE_ID
            ,PVE.PVE_FECHA_RETENCION = SQLI.PVE_FECHA_RETENCION
            ,PVE.PVE_FECHA_PBC = SQLI.PVE_FECHA_PBC
            ,PVE.DD_RPB_ID = SQLI.DD_RPB_ID
            ,PVE.USUARIOMODIFICAR = ''MIG2''
            ,PVE.FECHAMODIFICAR = SYSDATE
            ,PVE_COD_API_PROVEEDOR = SQLI.PVE_COD_API_PROVEEDOR
			,PVE.PVE_AUTORIZACION_WEB = SQLI.PVE_IND_MODIFICAR_DATOS_WEB
      WHEN NOT MATCHED THEN INSERT (
            PVE_ID
            ,PVE.PVE_COD_UVEM
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
            ''#USUARIO_MIGRACION#'',
            SYSDATE,
            0
      )      
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
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