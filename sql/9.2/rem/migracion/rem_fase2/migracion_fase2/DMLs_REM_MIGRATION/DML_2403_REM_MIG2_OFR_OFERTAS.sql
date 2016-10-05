--/*
--#########################################
--## AUTOR=Pablo Meseguer
--## FECHA_CREACION=20161004
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_OFR_OFERTAS -> OFR_OFERTAS
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
      
      COMMIT;
      
      EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
      
      DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
      
      -- Inicializamos la secuencia S_OFR_NUM_OFERTA
      
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE INICIALIZACION DE LA SECUENCIA S_OFR_NUM_OFERTA  DE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
	   -- Obtenemos el valor maximo de la columna OFR_NUM_OFERTA y lo incrementamos en 1
       V_SENTENCIA := 'SELECT MAX(OFR_NUM_OFERTA) FROM '||V_ESQUEMA||'.'||V_TABLA||'';
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
      
      -- INFORMAMOS A LA TABLA INFO
      
      -- Registros MIG
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||'';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_MIG;
      
      -- Registros insertados en REM
      V_SENTENCIA := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE USUARIOCREAR = ''MIG2''';  
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_REG_INSERTADOS;
      
      -- Total registros rechazados
      V_REJECTS := V_REG_MIG - V_REG_INSERTADOS;	
      
      /*  
      -- Diccionarios rechazados
      V_SENTENCIA := '
      SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_COD_NOT_EXISTS 
      WHERE DICCIONARIO IN (''DD_TPR_TIPO_PROVEEDOR'',''DD_TDI_TIPO_DOCUMENTO_ID'',''DD_ZNG_ZONA_GEOGRAFICA'',''DD_PRV_PROVINCIA'',''DD_LOC_LOCALIDAD'')
      AND FICHERO_ORIGEN = ''PROVEEDORES.dat''
      AND CAMPO_ORIGEN IN (''TIPO_PROVEEDOR'',''TIPO_DOCUMENTO'',''ZONA_GEOGRAFICA'',''PVE_PROVINCIA'',''PVE_LOCALIDAD'')
      '
      ;
      
      EXECUTE IMMEDIATE V_SENTENCIA INTO V_COD;
      */
      
      -- Observaciones
	  IF V_REJECTS != 0 THEN
				V_OBSERVACIONES := 'Se han rechazado '||V_REJECTS||' registros, comprobar integridad de los campos.';
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
