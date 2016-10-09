--/*
--#########################################
--## AUTOR=Sergio Hernández
--## FECHA_CREACION=20161007
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración MIG2_AGR_AGRUPACIONES -> ACT_AGR_AGRUPACION
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
V_TABLA VARCHAR2(40 CHAR) := 'ACT_AGR_AGRUPACION';
V_TABLA_MIG VARCHAR2(40 CHAR) := 'MIG2_AGR_AGRUPACIONES';
V_SENTENCIA VARCHAR2(32000 CHAR);
V_REG_MIG NUMBER(10,0) := 0;
V_REG_INSERTADOS NUMBER(10,0) := 0;
V_REJECTS NUMBER(10,0) := 0;
TABLE_COUNT_1 NUMBER(10,0) := 0;


BEGIN
      
--    --COMPROBACIONES PREVIAS - TIPO AGRUPACION
--    DBMS_OUTPUT.PUT_LINE('[INFO] ['||V_TABLA||'] COMPROBANDO TIPO AGRUPACION...');
--    
--    V_SENTENCIA := '
--    SELECT COUNT(1) 
--    FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
--    WHERE NOT EXISTS (
--      SELECT 1 
--      FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG 
--      WHERE TAG.DD_TAG_CODIGO = MIG2.AGR_COD_TIPO_AGRUPACION
--    )
--    '
--    ;
--    EXECUTE IMMEDIATE V_SENTENCIA INTO TABLE_COUNT_1;
--    
--    IF TABLE_COUNT_1 = 0 THEN
--    
--        DBMS_OUTPUT.PUT_LINE('[INFO] TODOS LOS TIPOS DE AGRUPACION EXISTEN EN '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION');
--    
--    ELSE
--    
--        DBMS_OUTPUT.PUT_LINE('[INFO] SE HAN INFORMADO '||TABLE_COUNT_1||' TIPOS DE AGRUPACION INEXISTENTES EN DD_TAG_TIPO_AGRUPACION. SE DERIVARÁN A LA TABLA '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS.');
--        
--        --BORRAMOS LOS REGISTROS QUE HAYA EN NOT_EXISTS REFERENTES A ESTA INTERFAZ
--        
--        EXECUTE IMMEDIATE '
--        DELETE FROM '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS
--        WHERE FICHERO_ORIGEN = '''||V_TABLA_MIG||'''
--        '
--        ;
--        
--        COMMIT;
--        
--        EXECUTE IMMEDIATE '
--        INSERT INTO '||V_ESQUEMA||'.MIG2_DD_COD_NOT_EXISTS (
--              CLAVE           ,  
--              FICHERO_ORIGEN  , 
--              CAMPO_ORIGEN    ,
--              DICCIONARIO     ,
--              VALOR           ,
--              FECHA_COMPROBACION
--
--        )
--              SELECT
--                      AGR_UVEM,'''||V_TABLA_MIG||''',''AGR_COD_TIPO_AGRUPACION'',''DD_TAG_TIPO_AGRUPACION'',AGR_COD_TIPO_AGRUPACION, SYSDATE
--
--              FROM '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG2 
--                    WHERE NOT EXISTS (
--                      SELECT 1 
--                      FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION TAG 
--                      WHERE TAG.DD_TAG_CODIGO = MIG2.AGR_COD_TIPO_AGRUPACION)'
--        ;
--        
--        COMMIT;      
--    
--    END IF;

      --Inicio del proceso de volcado 
      DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE MIGRACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
      
      V_SENTENCIA:= '
		MERGE INTO '||V_ESQUEMA||'.'||V_TABLA||' DEST	
   		     USING '||V_ESQUEMA||'.'||V_TABLA_MIG||' MIG
		        ON (DEST.AGR_NUM_AGRUP_UVEM = MIG.AGR_UVEM)
		WHEN MATCHED THEN UPDATE
		     SET  
			   DEST.DD_TAG_ID = (SELECT DD_TAG_ID FROM '||V_ESQUEMA||'.DD_TAG_TIPO_AGRUPACION WHERE DD_TAG_CODIGO = MIG.AGR_COD_TIPO_AGRUPACION),
			   DEST.VERSION = DEST.VERSION +1,
			   DEST.AGR_PUBLICADO = MIG.AGR_IND_PUBLICADA ,
			   DEST.USUARIOMODIFICAR = ''MIG2''           ,
			   DEST.FECHAMODIFICAR = SYSDATE  ';
      DBMS_OUTPUT.PUT_LINE(V_SENTENCIA);
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
