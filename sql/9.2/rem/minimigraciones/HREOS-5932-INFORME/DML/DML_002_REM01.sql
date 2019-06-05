--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190325
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.9.0
--## INCIDENCIA_LINK=HREOS-5932
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
	V_MSQL VARCHAR2(5000 CHAR);
	TABLE_COUNT NUMBER(1,0) := 0;
	V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
	V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
	V_COUNT NUMBER(16);
	
	
	    CURSOR ANALIZAR_TABLAS_MIGRACION IS SELECT  	OWNER 
												,       TABLE_NAME 
												FROM  SYS.ALL_TABLES where TABLE_NAME in 
												('HIST_PTA_PATRIMONIO_ACTIVO'
												,'ACT_PTA_PATRIMONIO_ACTIVO'
												,'ACT_SPS_SIT_POSESORIA'
												,'ACT_APU_ACTIVO_PUBLICACION'
												,'ACT_AHP_HIST_PUBLICACION'
												,'GAC_GESTOR_ADD_ACTIVO'
												,'GEE_GESTOR_ENTIDAD'
												,'GAH_GESTOR_ACTIVO_HISTORICO'
												,'GEH_GESTOR_ENTIDAD_HIST'
												,'OFR_OFERTAS'
												,'ECO_EXPEDIENTE_COMERCIAL'
												,'ACT_TRA_TRAMITE'
												,'TAR_TAREAS_NOTIFICACIONES'
												,'TEX_TAREA_EXTERNA') 
												AND OWNER IN ('REM01','REMMASTER');

    									
    						
    FILA ANALIZAR_TABLAS_MIGRACION%ROWTYPE;
	
BEGIN			
			
	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de insertar tablas afectadas por la migración ...'); 

	-- Se ejecutan ANALIZES SOBRE LAS TABLAS AFECTADAS.
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se analizan las tablas afectadas por la migración');
	OPEN ANALIZAR_TABLAS_MIGRACION;
	
	V_COUNT := 0;
	V_COUNT2 := 0;
		
	LOOP
  		FETCH ANALIZAR_TABLAS_MIGRACION INTO FILA;
  		EXIT WHEN ANALIZAR_TABLAS_MIGRACION%NOTFOUND;
  		
  		V_MSQL := 'ANALYZE TABLE '||FILA.OWNER||'.'||FILA.TABLE_NAME||' COMPUTE STATISTICS FOR TABLE';
        
  		EXECUTE IMMEDIATE V_MSQL; 				
  		  		
  		V_COUNT := V_COUNT + 1 ;
        V_COUNT2 := V_COUNT2 +1 ;
        
        IF V_COUNT2 = 100 THEN
            
            COMMIT;
            
            DBMS_OUTPUT.PUT_LINE('	[INFO] Se actualizan '||V_COUNT2||' activos ');
            V_COUNT2 := 0;
            
        END IF;
  		
	END LOOP;
	
    DBMS_OUTPUT.PUT_LINE('	[INFO] Se insertan '||V_COUNT2||' tablas ');
    
	CLOSE ANALIZAR_TABLAS_MIGRACION;
	
	-----------------------------------------------------------------------------
	
	-- Se insertan las tablas afectadas en un tabla.
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se informa de las tablas afectadas por la migración ');
	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.AUX_MIG_ALQUILERES_TAB_AFEC (
					SELECT  OWNER 
					,       TABLE_NAME 
					,       NUM_ROWS
					, 		NULL
					,		0 
					FROM  SYS.ALL_TABLES where TABLE_NAME in 
					(''HIST_PTA_PATRIMONIO_ACTIVO''
					,''ACT_PTA_PATRIMONIO_ACTIVO''
					,''ACT_SPS_SIT_POSESORIA''
					,''ACT_APU_ACTIVO_PUBLICACION''
					,''ACT_AHP_HIST_PUBLICACION''
					,''GAC_GESTOR_ADD_ACTIVO''
					,''GEE_GESTOR_ENTIDAD''
					,''GAH_GESTOR_ACTIVO_HISTORICO''
					,''GEH_GESTOR_ENTIDAD_HIST''
					,''OFR_OFERTAS''
					,''ECO_EXPEDIENTE_COMERCIAL''
					,''ACT_TRA_TRAMITE''
					,''TAR_TAREAS_NOTIFICACIONES''
					,''TEX_TAREA_EXTERNA'') 
					AND OWNER IN (''REM01'',''REMMASTER'')
					)';
	
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('	[INFO] Se han insertado '||SQL%ROWCOUNT||' tablas.');

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN]');


EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
