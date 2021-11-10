--/*
--#########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20211015
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## ARTEFACTO=batch
--## INCIDENCIA_LINK=HREOS-15592
--## PRODUCTO=NO
--## 
--## Finalidad:
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
	V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-16329';
	V_SQL VARCHAR2(2500 CHAR) := '';
	V_NUM NUMBER(25);
	V_SENTENCIA VARCHAR2(4000 CHAR);
	TABLE_COUNT NUMBER(10,0) := 0;
	
	V_TABLA_ACT VARCHAR2 (30 CHAR) := 'ACT_ACTIVO';
	V_TABLA_AUX VARCHAR2 (30 CHAR) := 'AUX_ACT_TRASPASO_ACTIVO';
	V_TABLA VARCHAR2(40 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO';
  V_TABLA_AUX_MIG VARCHAR2 (30 CHAR) := 'AUX_SEGUIR_MIGRACION';


BEGIN

      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
        
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_AUX_MIG||' WHERE SEGUIR_MIGRACION = 0';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM;
    
    IF V_NUM > 0  THEN
        
        DBMS_OUTPUT.PUT_LINE('[INFO] YA HAY ACTIVOS INSERTADOS EN ACT_ACTIVO DE LOS QUE SE QUIEREN INSERTAR');
        
    ELSE 
      V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
          PAC_ID
          ,ACT_ID
          ,PAC_INCLUIDO
          ,PAC_CHECK_TRA_ADMISION
          ,PAC_FECHA_TRA_ADMISION
          ,PAC_MOTIVO_TRA_ADMISION
          ,PAC_CHECK_GESTIONAR
          ,PAC_FECHA_GESTIONAR
          ,PAC_MOTIVO_GESTIONAR
          ,PAC_CHECK_ASIGNAR_MEDIADOR
          ,PAC_FECHA_ASIGNAR_MEDIADOR
          ,PAC_MOTIVO_ASIGNAR_MEDIADOR
          ,PAC_CHECK_COMERCIALIZAR
          ,PAC_FECHA_COMERCIALIZAR
          ,DD_MCO_ID
          ,PAC_CHECK_FORMALIZAR
          ,PAC_FECHA_FORMALIZAR
          ,PAC_MOTIVO_FORMALIZAR
          ,VERSION
          ,USUARIOCREAR
          ,FECHACREAR
          ,BORRADO
          ,PAC_MOT_EXCL_COMERCIALIZAR
	  ,PAC_CHECK_PUBLICAR
	  ,PAC_FECHA_PUBLICAR
	  ,PAC_MOTIVO_PUBLICAR
	  ,PAC_OFERTAS_VIVAS
	  ,PAC_TRABAJOS_VIVOS
    ,PAC_CHECK_ADMISION
    ,PAC_CHECK_GESTION_COMERCIAL
    ,PAC_FECHA_GESTION_COMERCIAL
        )
        SELECT 
          '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL                       AS PAC_ID,    
          ACT2.ACT_ID							AS ACT_ID,      
          1                                           	AS PAC_INCLUIDO,
          1                                	AS PAC_CHECK_TRA_ADMISION,
          PAC.PAC_FECHA_TRA_ADMISION                                    AS PAC_FECHA_TRA_ADMISION,
          PAC.PAC_MOTIVO_TRA_ADMISION                                   AS PAC_MOTIVO_TRA_ADMISION,
          1                                  	AS PAC_CHECK_GESTIONAR,
          PAC.PAC_FECHA_GESTIONAR                                       AS PAC_FECHA_GESTIONAR,
          PAC.PAC_MOTIVO_GESTIONAR                                      AS PAC_MOTIVO_GESTIONAR,
          PAC.PAC_CHECK_ASIGNAR_MEDIADOR                                AS PAC_CHECK_ASIGNAR_MEDIADOR,
          PAC.PAC_FECHA_ASIGNAR_MEDIADOR                                AS PAC_FECHA_ASIGNAR_MEDIADOR,
          PAC.PAC_MOTIVO_ASIGNAR_MEDIADOR                               AS PAC_MOTIVO_ASIGNAR_MEDIADOR,
          1                              	AS PAC_CHECK_COMERCIALIZAR,
          PAC.PAC_FECHA_COMERCIALIZAR                                   AS PAC_FECHA_COMERCIALIZAR,
          PAC.DD_MCO_ID                                                 AS DD_MCO_ID,
          1                                  	AS PAC_CHECK_FORMALIZAR,
          PAC.PAC_FECHA_FORMALIZAR                                      AS PAC_FECHA_FORMALIZAR,
          PAC.PAC_MOTIVO_FORMALIZAR                                     AS PAC_MOTIVO_FORMALIZAR,
          0                                                             AS VERSION, 
          '''||V_USUARIO||'''                                           AS USUARIOCREAR,                            
          SYSDATE                                                       AS FECHACREAR,                             
          0                                                             AS BORRADO,
          null							        AS PAC_MOT_EXCL_COMERCIALIZAR,
  	 1 					AS PAC_CHECK_PUBLICAR,
	  PAC.PAC_FECHA_PUBLICAR 					AS PAC_FECHA_PUBLICAR,
	  PAC.PAC_MOTIVO_PUBLICAR 					AS PAC_MOTIVO_PUBLICAR,
	  PAC.PAC_OFERTAS_VIVAS 					AS PAC_OFERTAS_VIVAS,
	  PAC.PAC_TRABAJOS_VIVOS 					AS PAC_TRABAJOS_VIVOS,
    1                               AS PAC_CHECK_ADMISION,
    1                               AS PAC_CHECK_GESTION_COMERCIAL,
    PAC.PAC_FECHA_GESTION_COMERCIAL  AS PAC_FECHA_GESTION_COMERCIAL
			FROM '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT 
			JOIN '||V_ESQUEMA||'.'||V_TABLA_AUX||' AUX ON ACT.ACT_NUM_ACTIVO = AUX.ACT_NUM_ACTIVO_ANT
			JOIN '||V_ESQUEMA||'.'||V_TABLA_ACT||' ACT2 ON AUX.ACT_NUM_ACTIVO_NUV = ACT2.ACT_NUM_ACTIVO
			JOIN '||V_ESQUEMA||'.'||V_TABLA||' PAC ON PAC.ACT_ID = ACT.ACT_ID
      '
      ;
      EXECUTE IMMEDIATE V_SENTENCIA;
      
      DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
      
   END IF;
   
   COMMIT;
      
      V_SENTENCIA := 'BEGIN '||V_ESQUEMA||'.OPERACION_DDL.DDL_TABLE(''ANALYZE'','''||V_TABLA||''',''1''); END;';
      EXECUTE IMMEDIATE V_SENTENCIA;
      
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
