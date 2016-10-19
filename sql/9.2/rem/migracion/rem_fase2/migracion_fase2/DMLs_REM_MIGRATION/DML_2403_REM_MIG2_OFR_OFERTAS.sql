--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161004
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración [MIG2_OFR_OFERTAS -> OFR_OFERTAS] Y carga de ECO_EXPEDIENTE_COMERCIAL
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
    MAX_NUM_OFR NUMBER(10,0) := 0;
    V_NUM_TABLAS NUMBER(10,0) := 0;
    V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
    V_TABLA VARCHAR2(40 CHAR) := 'OFR_OFERTAS';
    V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_OFR_OFERTAS';
    V_SENTENCIA VARCHAR2(32000 CHAR);
    V_REG_MIG NUMBER(10,0) := 0;
    V_REG_INSERTADOS NUMBER(10,0) := 0;
    V_REJECTS NUMBER(10,0) := 0;
    V_COD NUMBER(10,0) := 0;
    V_OBSERVACIONES VARCHAR2(3000 CHAR) := '';
    V_OFR_ID NUMBER(16,0);    -- Varaible que almacenara las OFR_ID de aquellas ofertas aceptadas
    V_TABLE_ECO NUMBER(16,0); -- Variable que almacenara los Expedientes Comerciales creados
    
BEGIN

    --Inicio del proceso de volcado sobre OFR_OFERTAS
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
    
    V_SENTENCIA := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
            OFR_ID,
            OFR_NUM_OFERTA,            
            AGR_ID,
            OFR_IMPORTE,
            CLC_ID,
            DD_EOF_ID,
            DD_TOF_ID,
            VIS_ID,
            DD_EVO_ID,            
            OFR_FECHA_ALTA,
            OFR_FECHA_NOTIFICACION,
            OFR_IMPORTE_CONTRAOFERTA,
            OFR_FECHA_CONTRAOFERTA,
            USU_ID,
            OFR_FECHA_RECHAZO,
            OFR_IND_LOTE_RESTRINGIDO,
            OFR_IMPORTE_APROBADO,
            VERSION,
            USUARIOCREAR,
            FECHACREAR,
            BORRADO
        )
        SELECT
            '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL            		 		OFR_ID, 
            MIG.OFR_COD_OFERTA												OFR_COD_OFERTA,            
            AGR.AGR_ID														AGR_ID,
            CASE WHEN MIG.OFR_IMPORTE = 0 THEN null
            ELSE MIG.OFR_IMPORTE END										OFR_IMPORTE,
            CLC.CLC_ID														CLC_ID,
            EOF.DD_EOF_ID													DD_EOF_ID,
            TOF.DD_TOF_ID													DD_TOF_ID,
            VIS.VIS_ID														VIS_ID,
            EVO.DD_EVO_ID													DD_EVO_ID,            
            MIG.OFR_FECHA_ALTA												OFR_FECHA_ALTA,
            CASE WHEN MIG.OFR_FECHA_NOTIFICACION IS null 
            AND  MIG.OFR_COD_ESTADO_OFERTA = ''01'' THEN SYSDATE
            ELSE MIG.OFR_FECHA_NOTIFICACION END								OFR_FECHA_NOTIFICACION,
            CASE WHEN MIG.OFR_IMPORTE_CONTRAOFERTA = 0 THEN null
            ELSE MIG.OFR_IMPORTE_CONTRAOFERTA END							OFR_IMPORTE_CONTRAOFERTA,
            CASE WHEN MIG.OFR_IMPORTE_CONTRAOFERTA != 0 
            AND MIG.OFR_FECHA_CONTRAOFERTA is null THEN SYSDATE
            ELSE MIG.OFR_FECHA_CONTRAOFERTA END								OFR_FECHA_CONTRAOFERTA,
            USU.USU_ID														USU_ID,
            CASE WHEN MIG.OFR_FECHA_RECHAZO IS null 
            AND  MIG.OFR_COD_ESTADO_OFERTA = ''02'' THEN SYSDATE
            ELSE MIG.OFR_FECHA_RECHAZO END									OFR_FECHA_RECHAZO,
            MIG.OFR_IND_LOTE_RESTRINGIDO									OFR_IND_LOTE_RESTRINGIDO,
            CASE WHEN MIG.OFR_IMPORTE_APROBADO = 0 THEN null
            ELSE MIG.OFR_IMPORTE_APROBADO END								OFR_IMPORTE_APROBADO,
            0																VERSION,
            ''MIG2''                                            			USUARIOCREAR,
            SYSDATE                                            				FECHACREAR,
            0                                                  				BORRADO
        FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
        LEFT JOIN '||V_ESQUEMA||'.ACT_AGR_AGRUPACION AGR
            ON AGR.AGR_NUM_AGRUP_UVEM = MIG.OFR_COD_AGRUPACION
        LEFT JOIN '||V_ESQUEMA||'.CLC_CLIENTE_COMERCIAL CLC
            ON CLC.CLC_WEBCOM_ID = MIG.OFR_COD_CLIENTE_WEBCOM
        LEFT JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF
            ON EOF.DD_EOF_CODIGO = MIG.OFR_COD_ESTADO_OFERTA
        LEFT JOIN '||V_ESQUEMA||'.DD_TOF_TIPOS_OFERTA TOF
            ON TOF.DD_TOF_CODIGO = MIG.OFR_COD_TIPO_OFERTA
        LEFT JOIN '||V_ESQUEMA||'.VIS_VISITAS VIS
            ON VIS.VIS_WEBCOM_ID = MIG.OFR_COD_VISITA_WEBCOM
        LEFT JOIN '||V_ESQUEMA||'.DD_EVO_EST_VISITA_OFERTA EVO
            ON EVO.DD_EVO_CODIGO = MIG.OFR_COD_ESTADO_VISITA_OFR
        LEFT JOIN '||V_ESQUEMA_MASTER||'.USU_USUARIOS USU
            ON USU.USU_USERNAME = MIG.OFR_COD_USUARIO_LDAP_ACCION
    '
    ;
    EXECUTE IMMEDIATE V_SENTENCIA	;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' cargada. '||SQL%ROWCOUNT||' Filas.');
    
    V_REG_INSERTADOS := SQL%ROWCOUNT;
    
    COMMIT;
    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
    
    -- Inicializamos la secuencia S_OFR_NUM_OFERTA    
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE INICIALIZACION DE LA SECUENCIA S_OFR_NUM_OFERTA  DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
    
    -- Obtenemos el valor maximo de la columna OFR_NUM_OFERTA y lo incrementamos en 1
    V_SENTENCIA := 'SELECT NVL(MAX(OFR_NUM_OFERTA),0) FROM '||V_ESQUEMA||'.'||V_TABLA||'';
    EXECUTE IMMEDIATE V_SENTENCIA INTO MAX_NUM_OFR;
    
    MAX_NUM_OFR := MAX_NUM_OFR +1;
    
    EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_OFR_NUM_OFERTA'' 
        AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''' INTO V_NUM_TABLAS; 
    
    -- Si existe secuencia la borramos
    IF V_NUM_TABLAS = 1 THEN
        EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_OFR_NUM_OFERTA';
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_OFR_NUM_OFERTA... Secuencia eliminada');    
    END IF;
    
    EXECUTE IMMEDIATE 'CREATE SEQUENCE ' ||V_ESQUEMA|| '.S_OFR_NUM_OFERTA  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH '||MAX_NUM_OFR||' NOCACHE NOORDER  NOCYCLE';
    
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.S_OFR_NUM_OFERTA... Secuencia creada e inicializada correctamente.');
    
    -----------------------------------------
    -- CREACION DE EXPEDIENTES COMERCIALES --
    -----------------------------------------   
    DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE GENERACION DE EXPEDIENTES COMERCIALES PARA OFERTAS ACEPTADAS');

    EXECUTE IMMEDIATE '
        INSERT INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL (
            ECO_ID
            ,ECO_NUM_EXPEDIENTE
            ,OFR_ID
            ,DD_EEC_ID
            ,ECO_FECHA_ALTA
            ,ECO_FECHA_SANCION  
            , VERSION
            , USUARIOCREAR
            , FECHACREAR
        )
        SELECT
          '||V_ESQUEMA||'.S_ECO_EXPEDIENTE_COMERCIAL.NEXTVAL                                              AS ECO_ID,
          '||V_ESQUEMA||'.S_ECO_NUM_EXPEDIENTE.NEXTVAL                                                        AS ECO_NUM_EXPEDIENTE,
          OFR.OFR_ID                                                                                                                  AS OFR_ID,
          (SELECT DD.DD_EEC_ID
            FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL DD
            WHERE DD.DD_EEC_CODIGO =  DECODE(EOF.DD_EOF_CODIGO, ''01-01'',''10'', 
                                                                ''01-02'',''06'', 
                                                                ''01-03'',''11'', 
                                                                ''01-04'',''04'', 
                                                                ''01-05'',''12'', 
                                                                ''01-06'',''07'', 
                                                                ''01-07'',''03'', 
                                                                ''01-08'',''02'', 
                                                                ''01-09'',''08'')
                                                                )                                                                  AS DD_EEC_ID,
          OFR.OFR_FECHA_ALTA                                                                                        AS ECO_FECHA_ALTA,
          CASE
              WHEN EOF.DD_EOF_CODIGO = ''01-02'' 
                THEN OFR.OFR_FECHA_ALTA
              ELSE NULL
          END                                                                                                                   AS ECO_FECHA_SANCION,
          0                                                                                                                           AS VERSION,
          ''MIG2''                                                                                                                  AS USUARIOCREAR,
          SYSDATE                                                                                                           AS FECHACREAR
        FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
        INNER JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA EOF ON EOF.DD_EOF_ID = OFR.DD_EOF_ID 
        WHERE SUBSTR(EOF.DD_EOF_CODIGO,0,2) = ''01'' AND OFR.USUARIOCREAR = ''MIG2''
        AND NOT EXISTS (
            SELECT 1
            FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL AUX
            WHERE AUX.OFR_ID = OFR.OFR_ID
        )
    '
    ;   
    
    V_TABLE_ECO := SQL%ROWCOUNT;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL cargada. '||V_TABLE_ECO||' Filas.');
    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL COMPUTE STATISTICS');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ANALIZADA.');
    
    -- INFORMAMOS A LA TABLA INFO
    
    -- Registros MIG
    V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
    EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
    
    -- Registros insertados en REM
    -- V_REG_INSERTADOS
    
    -- Total registros rechazados
    V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
    
    -- Observaciones
    IF V_TABLE_ECO != 0 THEN
         V_OBSERVACIONES := 'Se han creado '||V_TABLE_ECO||' Expedientes Comerciales de Ofertas aceptadas.';
    END IF;
     
    IF V_REJECTS != 0 THEN
        V_OBSERVACIONES := V_OBSERVACIONES ||' Se han rechazado '||V_REJECTS||' registros, comprobar integridad de los campos.';
    END IF;
    
    V_SENTENCIA := '
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
    EXECUTE IMMEDIATE V_SENTENCIA;
    
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
