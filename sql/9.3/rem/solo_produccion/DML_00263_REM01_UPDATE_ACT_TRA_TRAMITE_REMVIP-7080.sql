--/*
--######################################### 
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200421
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7080
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(50 CHAR) := 'REMVIP-7080';
	PL_OUTPUT VARCHAR2(32000 CHAR);
	
	TOKEN_ID NUMBER(16);
	MODULE_ID NUMBER(16);
	VMAP_ID NUMBER(16);
	VINST_ID NUMBER(16);
    
BEGIN

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO ECO_EXPEDIENTE_COMERCIAL NUM: 208356');

    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET ECO_FECHA_ANULACION = NULL, ECO_PETICIONARIO_ANULACION = NULL, 
						DD_MAN_ID = NULL, USUARIOMODIFICAR = '''||V_USR||''', FECHAMODIFICAR = SYSDATE WHERE ECO_NUM_EXPEDIENTE = 208356';

    
    #ESQUEMA#.AVANCE_TRAMITE_MIG_DIVARIAN(V_USR, '208356', 'T017_PBCVenta', NULL, NULL);
    
    EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS SET USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''nesteban'')
						WHERE USUARIOCREAR = '''||V_USR||''' AND BORRADO = 0';
    
	#ESQUEMA#.AVANCE_TRAMITE_MIG_DIVARIAN(V_USR, '208356', 'T017_InformeJuridico', NULL, NULL);
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS SET USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''ebenitezt'')
						WHERE USUARIOCREAR = '''||V_USR||''' AND BORRADO = 0 AND USU_ID != (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''nesteban'')';
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ACT_TRA_TRAMITE SET TRA_PROCESS_BPM = NULL, DD_EPR_ID = 30, TRA_FECHA_FIN = NULL
						WHERE TBJ_ID = (SELECT TBJ_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = 208356)';
						
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA SET TEX_TOKEN_ID_BPM = NULL
						WHERE USUARIOCREAR = '''||V_USR||''' AND BORRADO = 0';
						
	#ESQUEMA#.ALTA_BPM_INSTANCES(V_USR, PL_OUTPUT);	
	
	
	FOR CURSOR IN (SELECT 
		CASE WHEN TIENE_RESERVA = 1 THEN 
			(SELECT ID_ FROM REMMASTER.JBPM_NODE WHERE NAME_ = 'forkReservaSi' AND processdefinition_ = AUX.processdefinition_) 
		    ELSE (SELECT ID_ FROM REMMASTER.JBPM_NODE WHERE NAME_ = 'forkReservaNo' AND processdefinition_ = AUX.processdefinition_) END AS NODE_PARENT,
		AUX.* FROM(SELECT DISTINCT
		TRA.TRA_ID,
		TRA.TRA_PROCESS_BPM,
		INST.PROCESSDEFINITION_,
		TAR.TAR_ID,
		TAP.TAP_CODIGO,
		TEX.TEX_ID,
		TEX.TEX_TOKEN_ID_BPM,
		NODE.ID_ NODE_ID,
		TOKEN.PARENT_,
		ECO.ECO_NUM_EXPEDIENTE,
		CASE WHEN RES.RES_ID IS NULL THEN 0 ELSE 1 END AS TIENE_RESERVA,
		TAR.TAR_TAREA_FINALIZADA
		FROM REM01.ECO_EXPEDIENTE_COMERCIAL ECO
		INNER JOIN REM01.ACT_TRA_TRAMITE TRA
		ON TRA.TBJ_ID = ECO.TBJ_ID
		INNER JOIN REMMASTER.JBPM_PROCESSINSTANCE INST 
		ON INST.ID_ = TRA.TRA_PROCESS_BPM
		INNER JOIN REM01.TAC_TAREAS_ACTIVOS TAC
		ON TAC.TRA_ID = TRA.TRA_ID
		INNER JOIN REM01.TAR_TAREAS_NOTIFICACIONES TAR
		ON TAR.TAR_ID = TAC.TAR_ID
		INNER JOIN REM01.TEX_TAREA_EXTERNA TEX
		ON TEX.TAR_ID = TAR.TAR_ID
		INNER JOIN REM01.TAP_TAREA_PROCEDIMIENTO TAP
		ON TEX.TAP_ID = TAP.TAP_ID
		INNER JOIN REMMASTER.JBPM_TOKEN TOKEN
		ON TOKEN.ID_ = TEX.TEX_TOKEN_ID_BPM
		INNER JOIN REMMASTER.JBPM_NODE NODE
		ON NODE.ID_ = TOKEN.NODE_
		LEFT JOIN REM01.RES_RESERVAS RES
		ON RES.ECO_ID = ECO.ECO_ID AND RES.BORRADO = 0
		WHERE ECO.ECO_NUM_EXPEDIENTE = 208356
		AND TAP_CODIGO IN (
		'T017_AdvisoryNote',
		'T017_InformeJuridico',
		'T017_InstruccionesReserva',
		'T017_ObtencionContratoReserva',
		'T017_PBCReserva',
		'T017_PBCVenta',
		'T017_RecomendCES',
		'T017_ResolucionPROManzana'
		)
	ORDER BY TRA_ID ASC, TAP_CODIGO ASC) AUX) LOOP
		
		IF CURSOR.TAR_TAREA_FINALIZADA = 0 THEN
			IF CURSOR.PARENT_ IS NULL THEN
				TOKEN_ID := REMMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
				MODULE_ID := REMMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
				VMAP_ID := REMMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
				VINST_ID := REMMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
				V_MSQL := 'INSERT INTO '||V_ESQUEMA_M||'.JBPM_TOKEN(ID_, VERSION_, NAME_, START_, END_, NODEENTER_, NEXTLOGINDEX_, ISABLETOREACTIVATEPARENT_, ISTERMINATIONIMPLICIT_, ISSUSPENDED_, LOCK_, NODE_, PROCESSINSTANCE_, PARENT_, SUBPROCESSINSTANCE_,  RPR_REFERENCIA, T_REFERENCIA) VALUES (
				'||TOKEN_ID||', 0, (SELECT NAME_ FROM '||V_ESQUEMA_M||'.JBPM_NODE WHERE ID_ = '||CURSOR.NODE_PARENT||'), SYSDATE, NULL, SYSDATE, 2, 0, 0, 0, NULL, '||CURSOR.NODE_PARENT||', '||CURSOR.TRA_PROCESS_BPM||', NULL, NULL, NULL, NULL)';
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.JBPM_TOKEN SET ISABLETOREACTIVATEPARENT_ = 1, NEXTLOGINDEX_ = 2, PARENT_ = '||TOKEN_ID||' WHERE ID_ = '||CURSOR.TEX_TOKEN_ID_BPM;
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.JBPM_PROCESSINSTANCE SET ROOTTOKEN_ = '||TOKEN_ID||'  WHERE ID_ = '||CURSOR.TRA_PROCESS_BPM;
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				--DBMS_OUTPUT.PUT_LINE('Actualizando las module y vmap...') ;
				V_MSQL := 'INSERT INTO REMMASTER.JBPM_MODULEINSTANCE
				            (ID_, CLASS_, VERSION_, PROCESSINSTANCE_, NAME_) VALUES (
				            '||MODULE_ID||'
				            , ''C'' 
				            , 0
				            , '||CURSOR.TRA_PROCESS_BPM||'
				            , ''org.jbpm.context.exe.ContextInstance'' )';
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				 V_MSQL := 'INSERT INTO REMMASTER.JBPM_TOKENVARIABLEMAP
				            (ID_, VERSION_, TOKEN_, CONTEXTINSTANCE_) VALUES (
				      	'||VMAP_ID||'
				        , 0 
				        , '||TOKEN_ID||'
				        , '||MODULE_ID||'  
				    )';
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				  --DBMS_OUTPUT.PUT_LINE('module y vmap actualizadas!!') ;
		
		
				    --DBMS_OUTPUT.PUT_LINE('Actualizando VARIABLE INSTABLE...') ;
		
				    --DBMS_OUTPUT.PUT_LINE('Insertamos la variable DB_ID para cada instancia..') ;
				   V_MSQL := 'INSERT INTO REMMASTER.JBPM_VARIABLEINSTANCE
				        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_) VALUES (
				      '||VINST_ID||'
				      ,''L'' 
				      , 0 
				      , ''DB_ID''
				      , '||TOKEN_ID||'
				      , '||VMAP_ID||'
				      , '||CURSOR.TRA_PROCESS_BPM||'
				      , 1
				    )';
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				    --DBMS_OUTPUT.PUT_LINE('Insertamos la variable procedimientoTareaExterna para cada instancia..') ;
				VINST_ID := REMMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
				    V_MSQL := 'INSERT INTO REMMASTER.JBPM_VARIABLEINSTANCE
				        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_) VALUES (
				      '||VINST_ID||'
				        ,''L'' 
				        , 0 
				        , ''procedimientoTareaExterna''
				        , '||TOKEN_ID||'
				      , '||VMAP_ID||'
				      , '||CURSOR.TRA_PROCESS_BPM||'
				        , '||CURSOR.TRA_ID||'
				    )';
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				    --DBMS_OUTPUT.PUT_LINE('Insertamos la variable bpmParalizado para cada instancia..') ;
				VINST_ID := REMMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
				    V_MSQL := 'INSERT INTO REMMASTER.JBPM_VARIABLEINSTANCE
				        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_) VALUES (
				      '||VINST_ID||'
				      ,''L'' 
				      , 0 
				      , ''bpmParalizado''
				      , '||TOKEN_ID||'
				      , '||VMAP_ID||'
				      , '||CURSOR.TRA_PROCESS_BPM||'
				      , 0 
				    )';
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				    --DBMS_OUTPUT.PUT_LINE('Insertamos la variable idCODIGOTAREA para cada instancia..') ;
				VINST_ID := REMMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
				    V_MSQL := 'INSERT INTO REMMASTER.JBPM_VARIABLEINSTANCE
				        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_) VALUES (
				      '||VINST_ID||'
				      ,''L'' 
				      , 0 
				      , ''id'||CURSOR.TAP_CODIGO||'.'||CURSOR.TEX_TOKEN_ID_BPM||'''
				      , '||TOKEN_ID||'
				      , '||VMAP_ID||'
				      , '||CURSOR.TRA_PROCESS_BPM||'
				      , '||CURSOR.TEX_ID||'
				    )';
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				  --DBMS_OUTPUT.PUT_LINE('FIN VARIABLE INSTANCE!!') ;
		
		
				--Insertamos variable sin concatenar TOKEN_PADRE_ID
				VINST_ID := REMMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
				    V_MSQL := 'INSERT INTO REMMASTER.JBPM_VARIABLEINSTANCE
				        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_) VALUES (
				      '||VINST_ID||'
				      ,''L'' 
				      , 0 
				      , ''id'||CURSOR.TAP_CODIGO||'''
				      , '||TOKEN_ID||'
				      , '||VMAP_ID||'
				      , '||CURSOR.TRA_PROCESS_BPM||'
				      , '||CURSOR.TEX_ID||'
				    )';
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				  --DBMS_OUTPUT.PUT_LINE('FIN VARIABLE INSTANCE!!') ;
		
		
				VINST_ID := REMMASTER.HIBERNATE_SEQUENCE.NEXTVAL;
				    V_MSQL := 'INSERT INTO REMMASTER.JBPM_VARIABLEINSTANCE
				        (ID_, CLASS_, VERSION_, NAME_, TOKEN_, TOKENVARIABLEMAP_, PROCESSINSTANCE_, LONGVALUE_) VALUES (
				       '||VINST_ID||'
				      ,''L'' 
				      , 0
				      , ''activoTramiteTareaExterna''
				      , '||TOKEN_ID||'
				      , '||VMAP_ID||'
				      , '||CURSOR.TRA_PROCESS_BPM||'
				      , '||CURSOR.TRA_ID||'
				    )';
				EXECUTE IMMEDIATE V_MSQL;
				--DBMS_OUTPUT.PUT_LINE(V_MSQL);
				  --DBMS_OUTPUT.PUT_LINE('FIN VARIABLE INSTANCE!!') ;
		
			ELSE
				V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.JBPM_TOKEN SET NODE_ = '||CURSOR.NODE_PARENT||' WHERE ID_ = '||CURSOR.PARENT_;	
				EXECUTE IMMEDIATE V_MSQL;
				V_MSQL := 'UPDATE '||V_ESQUEMA_M||'.JBPM_TOKEN SET NEXTLOGINDEX_= 2, ISABLETOREACTIVATEPARENT_ = 1 WHERE ID_ = '||CURSOR.TEX_TOKEN_ID_BPM;
				EXECUTE IMMEDIATE V_MSQL;
			END IF;
		END IF;
	END LOOP;

    COMMIT;


    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
    ERR_NUM := SQLCODE;
    ERR_MSG := SQLERRM;    
    DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
    DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
    DBMS_OUTPUT.put_line(ERR_MSG);    
    ROLLBACK;
    RAISE;        

END;
/
EXIT;
