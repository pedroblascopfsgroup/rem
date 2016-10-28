--/*
--#########################################
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20160928
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_COM_COMPRADOR -> COM_COMPRADOR
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
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'COM_COMPRADOR';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_COM_COMPRADORES';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_DUPLICADOS NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
      
	  --COMPROBACIONES PREVIAS - CLIENTE_COMERCIAL (CLC_NUM_CLIENTE_HAYA)
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO CLIENTE_COMERCIAL...');
      
      V_SENTENCIA := '
      SELECT COUNT(1) 
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
      WHERE NOT EXISTS (
        SELECT 1 
        FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC 
        WHERE CLC.CLC_NUM_CLIENTE_HAYA = MIG2.COM_COD_COMPRADOR
      )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN
      
          DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS CLIENTE_COMERCIAL EXISTEN EN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL');
      
      ELSE
      
          DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' CLIENTE_COMERCIAL INEXISTENTES EN CLC_CLIENTE_COMERCIAL. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_CLC_NOT_EXISTS.');
          
          --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
          
          EXECUTE IMMEDIATE '
          DELETE FROM '||V_ESQUEMA||'.MIG2_CLC_NOT_EXISTS
          WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
          '
          ;
          
          COMMIT;
          
          EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.MIG2_CLC_NOT_EXISTS (
            TABLA_MIG,
            CODIGO_RECHAZADO,
            CAMPO_CLC_MOTIVO_RECHAZO,            
            FECHA_COMPROBACION
          )
          WITH NOT_EXISTS AS (
            SELECT DISTINCT MIG2.COM_COD_COMPRADOR 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
              SELECT 1 
              FROM '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC
              WHERE MIG2.COM_COD_COMPRADOR = CLC.CLC_NUM_CLIENTE_HAYA
            )
          )
          SELECT DISTINCT
          '''||V_TABLA_MIG||'''                                                   TABLA_MIG,
          MIG2.COM_COD_COMPRADOR                                   CODIGO_RECHAZADO,
          ''CLC_NUM_CLIENTE_HAYA''	                                      CAMPO_CLC_MOTIVO_RECHAZO,
          SYSDATE                                                                 FECHA_COMPROBACION
          FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2  
          INNER JOIN NOT_EXISTS ON NOT_EXISTS.COM_COD_COMPRADOR = MIG2.COM_COD_COMPRADOR
          '
          ;
          
          COMMIT;      
      
      END IF;
      
      --Inicio del proceso de volcado sobre CLC_CLIENTE_COMERCIAL
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
          INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            COM_ID
            ,CLC_ID
            ,DD_TPE_ID
            ,COM_NOMBRE
            ,COM_APELLIDOS
            ,DD_TDI_ID
            ,COM_DOCUMENTO
            ,COM_TELEFONO1
            ,COM_TELEFONO2
            ,COM_EMAIL
            ,COM_DIRECCION
            ,COM_CODIGO_POSTAL
            ,VERSION
            ,USUARIOCREAR
            ,FECHACREAR
            ,BORRADO
            ,DD_LOC_ID
            ,DD_PRV_ID
          ) WITH DUPLICADOS AS(
			  SELECT DISTINCT COM_COD_COMPRADOR
			  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WMIG2
			  GROUP BY COM_COD_COMPRADOR 
			  HAVING COUNT(1) > 1
          )
          SELECT
            '||V_ESQUEMA||'.S_COM_COMPRADOR.NEXTVAL                                                           AS COM_ID,
            AUX.*
          FROM (
            SELECT DISTINCT
              CLC.CLC_ID                                                                                                   AS CLC_ID,
              TPE.DD_TPE_ID                                                                                           AS DD_TPE_ID,
              MIG2.COM_NOMBRE                                                                                     AS COM_NOMBRE,
              MIG2.COM_APELLIDOS                                                                                  AS COM_APELLIDOS,
              TDI.DD_TDI_ID                                                                                            AS DD_TDI_ID,
              MIG2.COM_DOCUMENTO                                                                               AS COM_DOCUMENTO,
              MIG2.COM_TELEFONO1                                                                                  AS COM_TELEFONO1,
              MIG2.COM_TELEFONO2                                                                                  AS COM_TELEFONO2,
              MIG2.COM_EMAIL                                                                                          AS COM_EMAIL,
              MIG2.COM_DIRECCION                                                                                    AS COM_DIRECCION,              
              MIG2.COM_CODIGO_POSTAL                                                                            AS COM_CODIGO_POSTAL,
              0                                                                                                                   AS VERSION,
              ''MIG2''                                                                                                            AS USUARIOCREAR,
              SYSDATE                                                                                                     AS FECHACREAR,
              0                                                                                                                 AS BORRADO,
              LOC.DD_LOC_ID                                                                                               AS DD_LOC_ID,
              PRV.DD_PRV_ID                                                                                               AS DD_PRV_ID
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2
            INNER JOIN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC ON CLC.CLC_NUM_CLIENTE_HAYA = MIG2.COM_COD_COMPRADOR
            INNER JOIN '||V_ESQUEMA||'.MIG2_CEX_COMPRADOR_EXPEDIENTE MCEX ON MCEX.CEX_COD_COMPRADOR = MIG2.COM_COD_COMPRADOR
            LEFT JOIN '||V_ESQUEMA||'.DD_TPE_TIPO_PERSONA TPE ON TPE.DD_TPE_CODIGO = MIG2.COM_COD_TIPO_PERSONA AND TPE.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA||'.DD_TDI_TIPO_DOCUMENTO_ID TDI ON TDI.DD_TDI_CODIGO = MIG2.COM_COD_TIPO_DOCUMENTO AND TDI.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_LOC_LOCALIDAD LOC ON LOC.DD_LOC_CODIGO = MIG2.COM_COD_LOCALIDAD AND LOC.BORRADO = 0
            LEFT JOIN '||V_ESQUEMA_MASTER||'.DD_PRV_PROVINCIA  PRV ON PRV.DD_PRV_CODIGO = MIG2.COM_COD_PROVINCIA AND PRV.BORRADO = 0
            WHERE NOT EXISTS (
              SELECT 1
              FROM '||V_ESQUEMA||'.'||V_TABLA||' AUX2
              WHERE AUX2.CLC_ID = CLC.CLC_ID
            )
            AND NOT EXISTS (
            SELECT 1
            FROM DUPLICADOS DUP
            WHERE DUP.COM_COD_COMPRADOR = MIG2.COM_COD_COMPRADOR)
          ) AUX      
      '
      ;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      --VALIDACION DE DUPLICADOS
      V_SENTENCIA := '
      SELECT SUM(COUNT(1))
      FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' WMIG2
      GROUP BY COM_COD_COMPRADOR 
      HAVING COUNT(1) > 1
      '
      ;  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_DUPLICADOS;
      
      -- INFORMAMOS A LA TABLA INFO
      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
      
      -- Registros insertados en REM
      -- V_REG_INSERTADOS
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
      
     
      -- Observaciones
      IF V_REJECTS != 0 THEN
        V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' registros.';
        
        IF TABLE_COUNT != 0 THEN
           V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' CLIENTES_COMERCIALES inexistentes. ';
        END IF;
        
        IF V_DUPLICADOS != 0 THEN
			V_OBSERVACIONES := V_OBSERVACIONES||' Hay '||V_DUPLICADOS||' COM_COD_COMPRADOR duplicados. ';	
		END IF;
      END IF;
      
      EXECUTE IMMEDIATE '
      INSERT INTO '||V_ESQUEMA||'.MIG_INFO_TABLE (
        TABLA_MIG,
        TABLA_REM,
        REGISTROS_TABLA_MIG,
        REGISTROS_INSERTADOS,
        REGISTROS_RECHAZADOS,
        DD_COD_INEXISTENTES,
        FECHA,
        OBSERVACIONES
      )
      SELECT
      '''||V_TABLA_MIG||''',
      '''||V_TABLA||''',
      '||V_REG_MIG||',
      '||V_REG_INSERTADOS||',
      '||V_REJECTS||',
      '||V_COD||',
      SYSDATE,
      '''||V_OBSERVACIONES||'''
      FROM DUAL
      '
      ;
      
      COMMIT;  

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
