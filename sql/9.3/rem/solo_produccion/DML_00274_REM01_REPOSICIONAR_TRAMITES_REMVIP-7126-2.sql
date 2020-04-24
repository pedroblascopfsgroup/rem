--/*
--######################################### 
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20200424
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7126
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
    V_USR VARCHAR2(50 CHAR) := 'REMVIP-7126-2';
	PL_OUTPUT VARCHAR2(32000 CHAR);
	
	TOKEN_ID NUMBER(16);
	MODULE_ID NUMBER(16);
	VMAP_ID NUMBER(16);
	VINST_ID NUMBER(16);
	

    TYPE T_ALTER IS TABLE OF NUMBER(16);
    TYPE T_ARRAY_ALTER IS TABLE OF T_ALTER;
    V_ALTER T_ARRAY_ALTER := T_ARRAY_ALTER(
    		--NUM_OFERTA
		T_ALTER(6006496),
		T_ALTER(6006716),
		T_ALTER(6006801),
		T_ALTER(6006832),
		T_ALTER(6000375),
		T_ALTER(6007007),
		T_ALTER(6007029),
		T_ALTER(6000793),
		T_ALTER(6001239),
		T_ALTER(6001344),
		T_ALTER(6004619),
		T_ALTER(6004703),
		T_ALTER(6002958),
		T_ALTER(6003008),
		T_ALTER(6005298),
		T_ALTER(6005709),
		T_ALTER(6006207),
		T_ALTER(6004103),
		T_ALTER(6010810),
		T_ALTER(6010963),
		T_ALTER(6011647),
		T_ALTER(6011088),
		T_ALTER(6011821),
		T_ALTER(6011881),
		T_ALTER(6007242),
		T_ALTER(6007376),
		T_ALTER(6007424),
		T_ALTER(6007453),
		T_ALTER(6007454),
		T_ALTER(6012027),
		T_ALTER(6012045),
		T_ALTER(6012064),
		T_ALTER(6012090),
		T_ALTER(6012094),
		T_ALTER(6012096),
		T_ALTER(6012097),
		T_ALTER(6012119),
		T_ALTER(6012144),
		T_ALTER(6007498),
		T_ALTER(6007579),
		T_ALTER(6007597),
		T_ALTER(6007651),
		T_ALTER(6012158),
		T_ALTER(6012181),
		T_ALTER(6012190),
		T_ALTER(6012211),
		T_ALTER(6012258),
		T_ALTER(6012268),
		T_ALTER(6012281),
		T_ALTER(6012299),
		T_ALTER(6012328),
		T_ALTER(6012334),
		T_ALTER(6007770),
		T_ALTER(6007773),
		T_ALTER(6007821),
		T_ALTER(6007826),
		T_ALTER(6007847),
		T_ALTER(6007883),
		T_ALTER(6007953),
		T_ALTER(6007957),
		T_ALTER(6007972),
		T_ALTER(6012353),
		T_ALTER(6012362),
		T_ALTER(6012381),
		T_ALTER(6012382),
		T_ALTER(6012383),
		T_ALTER(6012404),
		T_ALTER(6012419),
		T_ALTER(6012433),
		T_ALTER(6012439),
		T_ALTER(6012442),
		T_ALTER(6012463),
		T_ALTER(6012481),
		T_ALTER(6012488),
		T_ALTER(6012489),
		T_ALTER(6012490),
		T_ALTER(6012497),
		T_ALTER(6012498),
		T_ALTER(6012501),
		T_ALTER(6012502),
		T_ALTER(6012514),
		T_ALTER(6012515),
		T_ALTER(6012526),
		T_ALTER(6008137),
		T_ALTER(6008151),
		T_ALTER(6008156),
		T_ALTER(6008191),
		T_ALTER(6008197),
		T_ALTER(6011323),
		T_ALTER(6012533),
		T_ALTER(6012535),
		T_ALTER(6012542),
		T_ALTER(6012543),
		T_ALTER(6012549),
		T_ALTER(6012555),
		T_ALTER(6012558),
		T_ALTER(6012562),
		T_ALTER(6012578),
		T_ALTER(6012589),
		T_ALTER(6012598),
		T_ALTER(6012609),
		T_ALTER(6012637),
		T_ALTER(6012638),
		T_ALTER(6012655),
		T_ALTER(6012658),
		T_ALTER(6012659),
		T_ALTER(6012661),
		T_ALTER(6012664),
		T_ALTER(6012667),
		T_ALTER(6012681),
		T_ALTER(6012684),
		T_ALTER(6012685),
		T_ALTER(6012686),
		T_ALTER(6012687),
		T_ALTER(6008330),
		T_ALTER(6008379),
		T_ALTER(6008386),
		T_ALTER(6008437),
		T_ALTER(6008440),
		T_ALTER(6008458),
		T_ALTER(6008483),
		T_ALTER(6008496),
		T_ALTER(6008516),
		T_ALTER(6011466),
		T_ALTER(6011501),
		T_ALTER(6012693),
		T_ALTER(6012702),
		T_ALTER(6012706),
		T_ALTER(6012717),
		T_ALTER(6012718),
		T_ALTER(6012724),
		T_ALTER(6012741),
		T_ALTER(6012743),
		T_ALTER(6012746),
		T_ALTER(6012747),
		T_ALTER(6012752),
		T_ALTER(6012760),
		T_ALTER(6012764),
		T_ALTER(6012765),
		T_ALTER(6012769),
		T_ALTER(6012772),
		T_ALTER(6012773),
		T_ALTER(6012785),
		T_ALTER(6012786),
		T_ALTER(6012787),
		T_ALTER(6012789),
		T_ALTER(6012790),
		T_ALTER(6012792),
		T_ALTER(6012793),
		T_ALTER(6012797),
		T_ALTER(6012800),
		T_ALTER(6012803),
		T_ALTER(6012805),
		T_ALTER(6012812),
		T_ALTER(6012819),
		T_ALTER(6012823),
		T_ALTER(6012840),
		T_ALTER(6012843),
		T_ALTER(6012850),
		T_ALTER(6012851),
		T_ALTER(6012858),
		T_ALTER(6012860),
		T_ALTER(6012865),
		T_ALTER(6008544),
		T_ALTER(6008548),
		T_ALTER(6008561),
		T_ALTER(6008574),
		T_ALTER(6008579),
		T_ALTER(6008591),
		T_ALTER(6008594),
		T_ALTER(6008627),
		T_ALTER(6008637),
		T_ALTER(6008642),
		T_ALTER(6008654),
		T_ALTER(6008677),
		T_ALTER(6008684)
		);
    V_T_ALTER T_ALTER;
    
    V_NUM NUMBER(16);
    V_ECO_ID NUMBER(16);
    V_ECO NUMBER(16);
    EXPEDIENTES VARCHAR2(32000 CHAR) := '';
    V_TRA_ID NUMBER(16);
    V_TAR_ID NUMBER(16);
    
BEGIN
	
	FOR I IN V_ALTER.FIRST .. V_ALTER.LAST LOOP
      
        V_T_ALTER := V_ALTER(I);
        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||V_T_ALTER(1)||' AND DD_EOF_ID = 1' INTO V_NUM;
        
        IF V_NUM > 0 THEN
        	
	        EXECUTE IMMEDIATE 'SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS WHERE OFR_NUM_OFERTA = '||V_T_ALTER(1)||')' INTO V_ECO_ID;
	        
	        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_ID = '||V_ECO_ID||' AND DD_EEC_ID != 2' INTO V_NUM;
	        
	        IF V_NUM > 0 THEN
		        EXECUTE IMMEDIATE 'SELECT ECO_NUM_EXPEDIENTE FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_ID = '||V_ECO_ID INTO V_ECO;
		        EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET ECO_ESTADO_PBC_R = NULL, USUARIOMODIFICAR = '''||V_USR||''', FECHAMODIFICAR = SYSDATE WHERE ECO_ID = '||V_ECO_ID INTO V_ECO;		        
		        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.RES_RESERVAS WHERE ECO_ID = '||V_ECO_ID||' AND BORRADO = 0' INTO V_NUM;
					
					IF V_NUM > 0 THEN
			        	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS SET BORRADO = 1, USUARIOBORRAR = '''||V_USR||''', FECHABORRAR = SYSDATE 
										WHERE ECO_ID = '||V_ECO_ID;
					END IF;
					
			        EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.COE_CONDICIONANTES_EXPEDIENTE SET COE_PORCENTAJE_RESERVA = NULL, COE_PLAZO_FIRMA_RESERVA = NULL,
										COE_IMPORTE_RESERVA = NULL, DD_TCC_ID = NULL, COE_SOLICITA_RESERVA = 0, USUARIOMODIFICAR = '''||V_USR||''', FECHAMODIFICAR = SYSDATE 
										WHERE ECO_ID = '||V_ECO_ID;
		        EXECUTE IMMEDIATE 'SELECT TRA_ID FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE WHERE TBJ_ID = (SELECT TBJ_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_ID = '||V_ECO_ID||')' INTO V_TRA_ID;
		        
		        EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID = TAC.TAR_ID AND TAR.BORRADO = 0
		                            INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAR.TAR_ID AND TEX.BORRADO = 0	WHERE TAC.TRA_ID = '||V_TRA_ID||' AND TAC.BORRADO = 0 
									AND TEX.TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''T017_InstruccionesReserva'',''T017_ObtencionContratoReserva'',''T017_PBCReserva''))' INTO V_NUM;
									
				IF V_NUM > 0 THEN					
										
					EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS SET BORRADO = 1, USUARIOBORRAR = '''||V_USR||''', FECHABORRAR = SYSDATE 
										WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS WHERE TRA_ID = '||V_TRA_ID||') 
									AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''T017_InstruccionesReserva'',''T017_ObtencionContratoReserva'',''T017_PBCReserva'')) 
									AND BORRADO = 0)';
										
					EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES SET BORRADO = 1, USUARIOBORRAR = '''||V_USR||''', FECHABORRAR = SYSDATE,
										TAR_TAREA_FINALIZADA = 1, TAR_FECHA_FIN = SYSDATE WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS WHERE TRA_ID = '||V_TRA_ID||') 
									AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''T017_InstruccionesReserva'',''T017_ObtencionContratoReserva'',''T017_PBCReserva'')) 
									AND BORRADO = 0)';
										
					EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA SET BORRADO = 1, USUARIOBORRAR = '''||V_USR||''', FECHABORRAR = SYSDATE
										WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS WHERE TRA_ID = '||V_TRA_ID||') 
									AND TAP_ID IN (SELECT TAP_ID FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE TAP_CODIGO IN (''T017_InstruccionesReserva'',''T017_ObtencionContratoReserva'',''T017_PBCReserva'')) 
									AND BORRADO = 0)';
					
					EXPEDIENTES := EXPEDIENTES||V_ECO||',';
					
				END IF;
			END IF;
		END IF;
		
	END LOOP;
	EXPEDIENTES := SUBSTR(EXPEDIENTES, 1, LENGTH(EXPEDIENTES)-1);
	#ESQUEMA#.AVANCE_TRAMITE_MIG_DIVARIAN(V_USR, EXPEDIENTES, 'T017_PBCVenta', NULL, NULL, PL_OUTPUT);
	
	
	EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ACT_TRA_TRAMITE SET TRA_PROCESS_BPM = NULL WHERE USUARIOMODIFICAR = '''||V_USR||'''';
					
	EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX
						USING (SELECT TAR_ID 
							FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
							INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID AND TRA.BORRADO = 0
							WHERE TRA.USUARIOMODIFICAR = '''||V_USR||''' AND TAC.BORRADO = 0
						) AUX ON (AUX.TAR_ID = TEX.TAR_ID)
						WHEN MATCHED THEN UPDATE SET TEX.TEX_TOKEN_ID_BPM = NULL WHERE TEX.BORRADO = 0';
	
	EXECUTE IMMEDIATE 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
						USING (SELECT TAR_ID 
							FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC
							INNER JOIN '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX ON TEX.TAR_ID = TAC.TAR_ID
							INNER JOIN '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP ON TAP.TAP_ID = TEX.TAP_ID
							INNER JOIN '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA ON TRA.TRA_ID = TAC.TRA_ID AND TRA.BORRADO = 0
							WHERE TRA.USUARIOMODIFICAR = '''||V_USR||''' AND TAC.BORRADO = 0 AND TAP.TAP_CODIGO = ''T017_PBCVenta''
						) AUX ON (AUX.TAR_ID = TEX.TAR_ID)
						WHEN MATCHED THEN UPDATE SET TAC.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''nesteban'') WHERE TAC.BORRADO = 0';
						
	#ESQUEMA#.ALTA_BPM_INSTANCES(V_USR, PL_OUTPUT);	
	
	FOR CURSOR IN (SELECT DISTINCT
		TRA.TRA_ID,
		TRA.TRA_PROCESS_BPM,
		INST.PROCESSDEFINITION_,
		(SELECT ID_ FROM REMMASTER.JBPM_NODE WHERE NAME_ = 'forkReservaNo' AND processdefinition_ = INST.PROCESSDEFINITION_) AS NODE_PARENT,
		TAR.TAR_ID,
		TAP.TAP_CODIGO,
		TEX.TEX_ID,
		TEX.TEX_TOKEN_ID_BPM,
		NODE.ID_ NODE_ID,
		TOKEN.PARENT_,
		ECO.ECO_NUM_EXPEDIENTE,
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
		WHERE TRA.USUARIOMODIFICAR = 'REMVIP-7126-2'
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
	ORDER BY TRA_ID ASC, TAP_CODIGO ASC) LOOP		
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
