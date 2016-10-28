--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161011
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_PRP_PROPUESTAS_PRECIOS -> PRP_PROPUESTAS_PRECIOS
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

TABLE_COUNT     NUMBER(10,0) := 0;
TABLE_COUNT_2 NUMBER(10,0) := 0;
TABLE_COUNT_3 NUMBER(10,0) := 0;
TABLE_COUNT_4 NUMBER(10,0) := 0;
V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
V_TABLA VARCHAR2(40 CHAR) := 'PRP_PROPUESTAS_PRECIOS';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_PRP_PROPUESTAS_PRECIOS';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
V_COD NUMBER(10,0) := 0;
V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';

BEGIN
--INICIO---------------------------------
      --COMPROBACIONES PREVIAS - Estado de la propuesta
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] Estado de la propuesta...');
      
      V_SENTENCIA := '
            SELECT COUNT(1) 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
            SELECT 1 
            FROM '||V_ESQUEMA||'.DD_EPP_ESTADO_PROP_PRECIO EPP 
          WHERE DD_EPP_CODIGO = MIG2.PRP_COD_ESTADO_PRP 
            )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT;
      
      IF TABLE_COUNT = 0 THEN    
            DBMS_OUTPUT.PUT_LINE('[INFO] TODOS ESTADOS EXISTEN EN '||V_ESQUEMA||'.DD_EPP_ESTADO_PROP_PRECIO');    
      ELSE
            
            DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT||' ESTADOS INEXISTENTES EN DD_EPP_ESTADO_PROP_PRECIO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS.');
            
            --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
            
            EXECUTE IMMEDIATE '
                  DELETE FROM '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS
                  WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
                     AND DICCIONARIO = ''DD_EPP_ID''
            '
            ;
            
            COMMIT;
            
            EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS (
                  CLAVE           ,  
                  TABLA_MIG  , 
                  CAMPO_ORIGEN    ,
                  DICCIONARIO     ,
                  VALOR           ,
                  FECHA_COMPROBACION      
            )
            SELECT
                  PRP_NUM_PROPUESTA,
                  '''||V_TABLA_MIG||''',
                  ''PRP_COD_ESTADO_PRP'',
                  ''DD_EPP_ID'',
                  PRP_COD_ESTADO_PRP,
                  SYSDATE
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
                  SELECT 1 
                  FROM '||V_ESQUEMA||'.DD_EPP_ESTADO_PROP_PRECIO EPP 
               WHERE DD_EPP_CODIGO = MIG2.PRP_COD_ESTADO_PRP 
            )'
            ;
            
            V_COD := SQL%ROWCOUNT;
            
            COMMIT;      
      
      END IF;  
      
      
      --COMPROBACIONES PREVIAS - Cartera (entidad propietaria) de la propuesta
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] Cartera (entidad propietaria) de la propuesta...');
      
      V_SENTENCIA := '
            SELECT COUNT(1) 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
            SELECT 1 
            FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA 
          WHERE CRA.DD_CRA_CODIGO = MIG2.PRP_COD_CARTERA
            )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_2;
      
      IF TABLE_COUNT_2 = 0 THEN    
            DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LAS CARTERAS EXISTEN EN '||V_ESQUEMA||'.DD_CRA_CARTERA');    
      ELSE
            
            DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_2||' CARTERAS INEXISTENTES EN DD_CRA_CARTERA. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS.');
            
            --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
            
            EXECUTE IMMEDIATE '
                  DELETE FROM '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS
                  WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
                    AND DICCIONARIO = ''DD_CRA_ID''
            '
            ;
            
            COMMIT;
            
            EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS (
                  CLAVE           ,  
                  TABLA_MIG  , 
                  CAMPO_ORIGEN    ,
                  DICCIONARIO     ,
                  VALOR           ,
                  FECHA_COMPROBACION      
            )
            SELECT
                  PRP_NUM_PROPUESTA,
                  '''||V_TABLA_MIG||''',
                  ''PRP_COD_CARTERA'',
                  ''DD_CRA_ID'',
                  PRP_COD_CARTERA,
                  SYSDATE
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
                  SELECT 1 
                  FROM '||V_ESQUEMA||'.DD_CRA_CARTERA CRA 
               WHERE CRA.DD_CRA_CODIGO = MIG2.PRP_COD_CARTERA
            )'
            ;
          
            V_COD := V_COD + SQL%ROWCOUNT;
            
            COMMIT;      
      
      END IF;  
      
      --COMPROBACIONES PREVIAS - Gestor de la propuesta
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] Gestor de la propuesta...');
      
      V_SENTENCIA := '
            SELECT COUNT(1) 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
            SELECT 1 
            FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU 
            WHERE USU.USU_USERNAME = MIG2.PRP_COD_USUARIO
            )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_3;
      
      IF TABLE_COUNT_3 = 0 THEN    
            DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS GESTORES EXISTEN EN '||V_ESQUEMA_MASTER||'.USU_USUARIOS');    
      ELSE
            
            DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_3||' GESTORES INEXISTENTES EN USU_USUARIOS. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS.');
            
            --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
            
            EXECUTE IMMEDIATE '
                  DELETE FROM '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS
                  WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
                      AND DICCIONARIO = ''USU_ID''
            '
            ;
            
            COMMIT;
            
            EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS (
                  CLAVE           ,  
                  TABLA_MIG  , 
                  CAMPO_ORIGEN    ,
                  DICCIONARIO     ,
                  VALOR           ,
                  FECHA_COMPROBACION      
            )
            SELECT
                  PRP_NUM_PROPUESTA,
                  '''||V_TABLA_MIG||''',
                  ''PRP_COD_USUARIO'',
                  ''USU_ID'',
                  PRP_COD_USUARIO,
                  SYSDATE
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
                  SELECT 1 
                  FROM '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU 
            WHERE USU.USU_USERNAME = MIG2.PRP_COD_USUARIO
            )'
            ;
           
            V_COD := V_COD + SQL%ROWCOUNT;
            
            COMMIT;      
      
      END IF;  

      --COMPROBACIONES PREVIAS - Tipo de propuesta 
      DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] Tipo de propuesta...');
      
      V_SENTENCIA := '
            SELECT COUNT(1) 
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
            SELECT 1 
            FROM '||V_ESQUEMA||'.DD_TPP_TIPO_PROP_PRECIO TPP 
          WHERE TPP.DD_TPP_CODIGO = MIG2.PRP_COD_TIPO_PRP
            )
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_4;
      
      IF TABLE_COUNT_4 = 0 THEN    
            DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS TIPOS PROPUESTA EXISTEN EN '||V_ESQUEMA||'.DD_TPP_TIPO_PROP_PRECIO');    
      ELSE
            
            DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_4||' TIPOS DE PROPUESTA INEXISTENTES EN DD_TPP_TIPO_PROP_PRECIO. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS.');
            
            --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
            
            EXECUTE IMMEDIATE '
                  DELETE FROM '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS
                  WHERE TABLA_MIG = '''||V_TABLA_MIG||'''
                    AND DICCIONARIO = ''DD_TPP_ID''
            '
            ;
            
            COMMIT;
            
            EXECUTE IMMEDIATE '
            INSERT INTO '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS (
                  CLAVE           ,  
                  TABLA_MIG  , 
                  CAMPO_ORIGEN    ,
                  DICCIONARIO     ,
                  VALOR           ,
                  FECHA_COMPROBACION      
            )
            SELECT
                  PRP_NUM_PROPUESTA,
                  '''||V_TABLA_MIG||''',
                  ''PRP_COD_TIPO_PRP'',
                  ''DD_TPP_ID'',
                  PRP_COD_TIPO_PRP,
                  SYSDATE
            FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
            WHERE NOT EXISTS (
                  SELECT 1 
                  FROM '||V_ESQUEMA||'.DD_TPP_TIPO_PROP_PRECIO TPP 
          WHERE TPP.DD_TPP_CODIGO = MIG2.PRP_COD_TIPO_PRP
            )'
            ;
            
            V_COD := V_COD + SQL%ROWCOUNT;
            
            COMMIT;      
      
      END IF;  
--FIN -----------------------------------
     
      --Inicio del proceso de volcado sobre PRP_PROPUESTAS_PRECIOS
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      EXECUTE IMMEDIATE '
		INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' PRP (
			  PRP_ID,
			  PRP_NUM_PROPUESTA,
			  PRP_NOMBRE_PROPUESTA,
			  DD_EPP_ID,
			  USU_ID,
			  DD_CRA_ID,
			  DD_TPP_ID,
			  PRP_ES_PROP_MANUAL,
			  PRP_FECHA_EMISION,
			  PRP_FECHA_ENVIO,
			  PRP_FECHA_SANCION,
			  PRP_FECHA_CARGA,
			  PRP_OBSERVACIONES,
			  VERSION,
			  USUARIOCREAR,
			  FECHACREAR,
			  BORRADO
		)
		SELECT
			'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                		PRP_ID,
			MIG.PRP_NUM_PROPUESTA										PRP_NUM_PROPUESTA,
			MIG.PRP_NOMBRE_PROPUESTA									PRP_NOMBRE_PROPUESTA,
			EPP.DD_EPP_ID												DD_EPP_ID,
			NVL(USU.USU_ID,
				(SELECT USU_ID
				FROM REMMASTER.USU_USUARIOS
				WHERE USU_USERNAME = ''MIGRACION''
				AND BORRADO = 0)
			)															USU_ID,
			CRA.DD_CRA_ID												DD_CRA_ID,
			TPP.DD_TPP_ID												DD_TPP_ID,
			MIG.PRP_IND_PROP_MANUAL										PRP_ES_PROP_MANUAL,
			MIG.PRP_FECHA_EMISION										PRP_FECHA_EMISION,
			MIG.PRP_FECHA_ENVIO											PRP_FECHA_ENVIO,
			MIG.PRP_FECHA_SANCION										PRP_FECHA_SANCION,
			MIG.PRP_FECHA_CARGA											PRP_FECHA_CARGA,
			MIG.PRP_OBSERVACIONES										PRP_OBSERVACIONES,
			0 															VERSION,
			''MIG2'' 													USUARIOCREAR,
			SYSDATE 													FECHACREAR,
			0 															BORRADO
		  FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG 
		  INNER JOIN '||V_ESQUEMA||'.DD_EPP_ESTADO_PROP_PRECIO EPP 
			ON DD_EPP_CODIGO = MIG.PRP_COD_ESTADO_PRP 
		  LEFT JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU 
			ON USU.USU_USERNAME = MIG.PRP_COD_USUARIO
		  INNER JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA 
			ON CRA.DD_CRA_CODIGO = MIG.PRP_COD_CARTERA
		  INNER JOIN '||V_ESQUEMA||'.DD_TPP_TIPO_PROP_PRECIO TPP 
			ON TPP.DD_TPP_CODIGO = MIG.PRP_COD_TIPO_PRP
		  WHERE NOT EXISTS (
			SELECT 1
			FROM '||V_ESQUEMA||'.'||V_TABLA||' NOTE
			WHERE NOTE.PRP_NUM_PROPUESTA = MIG.PRP_NUM_PROPUESTA
			AND NOTE.BORRADO = 0
			)
      '
      ;
   
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
      V_REG_INSERTADOS := SQL%ROWCOUNT;
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
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
            V_OBSERVACIONES := 'Se han rechazado  '||V_REJECTS||' registros.';    
    
            IF TABLE_COUNT != 0 THEN    
                  V_OBSERVACIONES := V_OBSERVACIONES || ' Hay '||TABLE_COUNT||' Estado de la propuesta (DD_EPP_ID) inexistentes. ';    
            END IF;     
            
            IF TABLE_COUNT_2 != 0 THEN    
                  V_OBSERVACIONES := V_OBSERVACIONES ||  ' Hay, '||TABLE_COUNT_2||'  Cartera (entidad propietaria) de la propuesta (DD_CRA_ID) inexistentes. ';    
            END IF;       
            
            IF TABLE_COUNT_3 != 0 THEN    
                  V_OBSERVACIONES := V_OBSERVACIONES ||  ' Hay, '||TABLE_COUNT_3||'  Gestor de la propuesta (USU_ID) inexistentes. ';    
            END IF;      
            
            IF TABLE_COUNT_4 != 0 THEN    
                  V_OBSERVACIONES := V_OBSERVACIONES ||  ' Hay, '||TABLE_COUNT_4||'  Tipo de propuesta (DD_TPP_ID) inexistentes. ';    
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
