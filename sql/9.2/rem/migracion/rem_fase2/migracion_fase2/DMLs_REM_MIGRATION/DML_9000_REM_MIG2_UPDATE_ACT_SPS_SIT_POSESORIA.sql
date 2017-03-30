--/*
--#########################################
--## AUTOR=PABLO MESEGUER
--## FECHA_CREACION=20170218
--## ARTEFACTO=migracion
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-855
--## PRODUCTO=NO
--## 
--## Finalidad: Proceso de migración Fase 2, para la actualizacion de estados del gasto.
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

    V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_MASTER VARCHAR2(15 CHAR) := '#ESQUEMA_MASTER#';
    V_TABLA VARCHAR2(40 CHAR) := 'ACT_SPS_SIT_POSESORIA';
    V_SENTENCIA VARCHAR2(32000 CHAR);
    V_REG_ACTUALIZADOS NUMBER(10,0) := 0;
    V_REG_TOTAL NUMBER(10,0) := 0;
      
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------') ;
    DBMS_OUTPUT.PUT_LINE('PROCESO DE ACTUALIZACION DE CAMPOS DE SITUACION POSESORIA FASE 2....') ;
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------------') ;

	--ACTUALIZACION DE SPS_NUMERO_CONTRATO_ALQUILER'
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE ACTUALIZACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
    
    V_SENTENCIA := '
			merge into ACT_SPS_SIT_POSESORIA act
			using (with tmp as 
			(select row_number()  over (partition by act_id order by HAL_FECHA_INICIO_CONTRATO desc) NUM,  act_id,HAL_NUMERO_CONTRATO_ALQUILER, HAL_FECHA_INICIO_CONTRATO 
			 from ACT_HAL_HIST_ALQUILERES
			)
			select * from tmp where num = 1) alq
			on (act.act_id = alq.act_id )
			when matched then update
			set act.SPS_NUMERO_CONTRATO_ALQUILER = alq.HAL_NUMERO_CONTRATO_ALQUILER
    '
    ;
    EXECUTE IMMEDIATE V_SENTENCIA;
    
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
     
    V_REG_TOTAL := V_REG_TOTAL + V_REG_ACTUALIZADOS;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas. 01 - PENDIENTE AUTOMATIZAR');
    
    
    --ACTUALIZACION DE SPS_FECHA_TITULO
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE ACTUALIZACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
    
    V_SENTENCIA := '
		update ACT_SPS_SIT_POSESORIA act
		set SPS_FECHA_TITULO = (
		with alq as 
		(select row_number()  over (partition by act_id order by HAL_FECHA_INICIO_CONTRATO desc) NUM,  act_id,HAL_FECHA_INICIO_CONTRATO 
		 from ACT_HAL_HIST_ALQUILERES
		) 
		select HAL_FECHA_INICIO_CONTRATO from alq where alq.act_id = act.act_id and alq.num = 1 ),
		 SPS_FECHA_VENC_TITULO = (
		with alq as 
		(select row_number()  over (partition by act_id order by HAL_FECHA_INICIO_CONTRATO desc) NUM,  act_id,HAL_FECHA_FIN_CONTRATO 
		 from ACT_HAL_HIST_ALQUILERES
		) 
		select HAL_FECHA_FIN_CONTRATO from alq where alq.act_id = act.act_id and alq.num = 1 )

		where SPS_FECHA_TITULO is null
    '
    ;
    EXECUTE IMMEDIATE V_SENTENCIA;
    
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
     
    V_REG_TOTAL := V_REG_TOTAL + V_REG_ACTUALIZADOS;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas. 02 - RECHAZO ADMINISTRACION');
    
    
    --ACTUALIZACION DE SPS_FECHA_RESOLUCION_CONTRATO
	DBMS_OUTPUT.PUT_LINE('[INFO] COMIENZA EL PROCESO DE ACTUALIZACION SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||'.');
    
    V_SENTENCIA := '
		update ACT_SPS_SIT_POSESORIA act
		set SPS_FECHA_RESOLUCION_CONTRATO = (
		with alq as 
		(select row_number()  over (partition by act_id order by HAL_FECHA_INICIO_CONTRATO desc) NUM,  act_id,HAL_FECHA_RESOLUCION_CONTRATO  
		 from ACT_HAL_HIST_ALQUILERES
		) 
		select HAL_FECHA_RESOLUCION_CONTRATO  from alq where alq.act_id = act.act_id and alq.num = 1 )

		where SPS_FECHA_RESOLUCION_CONTRATO is null
    '
    ;
    EXECUTE IMMEDIATE V_SENTENCIA;
    
    V_REG_ACTUALIZADOS := SQL%ROWCOUNT;
     
    V_REG_TOTAL := V_REG_TOTAL + V_REG_ACTUALIZADOS;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] - '||to_char(sysdate,'HH24:MI:SS')||'  '||V_ESQUEMA||'.'||V_TABLA||' ACTUALIZADAS. '||V_REG_ACTUALIZADOS||' Filas. 03 - AUTORIZADO ADMINISTRACION');
    
    EXECUTE IMMEDIATE('ANALYZE TABLE '||V_ESQUEMA||'.'||V_TABLA||' COMPUTE STATISTICS');
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' ANALIZADA.');
    
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
