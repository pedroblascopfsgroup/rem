--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5980
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE

    PL_OUTPUT VARCHAR2(32000 CHAR);
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS_1 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_2 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_3 NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5980'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    TRA_ID NUMBER(16);
    TAR_ID NUMBER(16);
    TEX_ID NUMBER(16);
    ACT_ID NUMBER(16);
    USU_ID NUMBER(16);
    SUP_ID NUMBER(16);
    TEX_TOKEN NUMBER(16);

    SEQ_TAR_ID NUMBER(16);

    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_2 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_3 NUMBER(16):= 0; -- Vble. para contar updates

    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--TRA_ID , TAR_ID, TEX_ID, TEX_TOKEN, ACT_ID, USU_ID, SUP_ID

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
				T_JBV(268369, 4002811, 8986100, 56113850, 292044, 29751, 29485),
				T_JBV(268487, 4003088, 8986310, 56115141, 260404, 29751, 29485),
				T_JBV(268523, 4003230, 8986425, 56115661, 324943, 29751, 29485),
				T_JBV(268540, 4003270, 8986457, 56115855, 4602, 29751, 29485),
				T_JBV(268866, 4004115, 8987133, 56119746, 218, 29751, 29485),
				T_JBV(268867, 4004116, 8987134, 56119755, 333, 29751, 29485),
				T_JBV(268868, 4004117, 8987135, 56119764, 2721, 29751, 29485),
				T_JBV(268869, 4004118, 8987136, 56119773, 2723, 29751, 29485),
				T_JBV(268870, 4004119, 8987137, 56119782, 2724, 29751, 29485),
				T_JBV(268871, 4004120, 8987138, 56119791, 2907, 29751, 29485),
				T_JBV(268872, 4004121, 8987139, 56119800, 2938, 29751, 29485),
				T_JBV(268873, 4004122, 8987140, 56119810, 3244, 29751, 29485),
				T_JBV(268874, 4004123, 8987141, 56119820, 3247, 29751, 29485),
				T_JBV(269010, 4004383, 8987379, 56122669, 43687, 29751, 29485),
				T_JBV(269014, 4004390, 8987386, 56122712, 43700, 29751, 29485),
				T_JBV(269016, 4004392, 8987388, 56122730, 43704, 29751, 29485),
				T_JBV(269020, 4004397, 8987393, 56122768, 43729, 29751, 29485),
				T_JBV(269022, 4004400, 8987396, 56122788, 43737, 29751, 29485),
				T_JBV(269024, 4004403, 8987399, 56122812, 43746, 29751, 29485),
				T_JBV(273155, 4021771, 9000247, 56211198, 275414, 29751, 29485),
				T_JBV(273159, 4021775, 9000251, 56211234, 275459, 29751, 29485),
				T_JBV(273161, 4021777, 9000253, 56211252, 275478, 29751, 29485),
				T_JBV(273162, 4021778, 9000254, 56211261, 275482, 29751, 29485),
				T_JBV(273163, 4021779, 9000255, 56211270, 275518, 29751, 29485),
				T_JBV(273164, 4021780, 9000256, 56211279, 275537, 29751, 29485),
				T_JBV(355255, 4453924, 9308053, 58261412, 388633, 29751, 29485)
		); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TRAMITES Y TAREAS');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	TRA_ID := TRIM(V_TMP_JBV(1));
  	
  	TAR_ID := TRIM(V_TMP_JBV(2));

	TEX_ID := TRIM(V_TMP_JBV(3));

	TEX_TOKEN := TRIM(V_TMP_JBV(4));
  	
  	ACT_ID := TRIM(V_TMP_JBV(5));

	USU_ID := TRIM(V_TMP_JBV(6));

	SUP_ID := TRIM(V_TMP_JBV(7));

--CREAMOS CAMPOS FORMULARIO TAREA

	--INSERT EN LA TEV

	V_SQL := 'Insert into REM01.TEV_TAREA_EXTERNA_VALOR (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTYPE) values (S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL,'||TEX_ID||',''titulo'',null,''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',''TareaExternaValor'')';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL := 'Insert into REM01.TEV_TAREA_EXTERNA_VALOR (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTYPE) values (S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL,'||TEX_ID||',''comboTramitar'',''01'',''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',''TareaExternaValor'')';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL := 'Insert into REM01.TEV_TAREA_EXTERNA_VALOR (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTYPE) values (S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL,'||TEX_ID||',''motivoDenegacion'',null,''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',''TareaExternaValor'')';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL := 'Insert into REM01.TEV_TAREA_EXTERNA_VALOR (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTYPE) values (S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL,'||TEX_ID||',''saldoDisponible'',''1000000€'',''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',''TareaExternaValor'')';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL := 'Insert into REM01.TEV_TAREA_EXTERNA_VALOR (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTYPE) values (S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL,'||TEX_ID||',''comboSaldo'',''01'',''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',''TareaExternaValor'')';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL := 'Insert into REM01.TEV_TAREA_EXTERNA_VALOR (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTYPE) values (S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL,'||TEX_ID||',''observaciones'',null,''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',''TareaExternaValor'')';
	EXECUTE IMMEDIATE V_SQL;
	V_SQL := 'Insert into REM01.TEV_TAREA_EXTERNA_VALOR (TEV_ID,TEX_ID,TEV_NOMBRE,TEV_VALOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,DTYPE) values (S_TEV_TAREA_EXTERNA_VALOR.NEXTVAL,'||TEX_ID||',''GESECO'',null,''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',''TareaExternaValor'')';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INSERT] Insertado REGISTROS en TEV');
	
--QUITAMOS EL TOKEN DEL TRAMITE

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE WHERE TRA_ID = '||TRA_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
	IF V_NUM_FILAS_1 > 0 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TRA_TRAMITE 
				   SET TRA_PROCESS_BPM = NULL,
				   USUARIOMODIFICAR = '''||V_USR||''',
				   FECHAMODIFICAR = SYSDATE 
				   WHERE TRA_ID = '||TRA_ID;
	

		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON TRA_ID: '||TRA_ID||' ACTUALIZADO');
		
		V_COUNT_UPDATE_1 := V_COUNT_UPDATE_1 + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
	
--CERRAMOS TAREA ACTUAL

	--UPDATE TAR_TAREAS_NOTIFICACIONES

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES WHERE TAR_ID = '||TAR_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_2;
	
	IF V_NUM_FILAS_2 = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES 
						   SET TAR_TAREA_FINALIZADA = 1, 
						   BORRADO = 1, 
						   FECHABORRAR = SYSDATE, 
						   USUARIOBORRAR = '''||V_USR||''', 
						   TAR_FECHA_FIN = SYSDATE
						   WHERE TAR_ID = '||TAR_ID;

	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON TAR_ID: '||TAR_ID||' ACTUALIZADO');
		
		V_COUNT_UPDATE_2 := V_COUNT_UPDATE_2 + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;

	--UPDATE TEX_TAREA_EXTERNA

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA WHERE TEX_ID = '||TEX_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_3;
	
	IF V_NUM_FILAS_3 = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA 
				   		  SET USUARIOBORRAR = '''||V_USR||''' 
						  , FECHABORRAR = SYSDATE
						  , BORRADO = 1 
				   		  WHERE TEX_ID = '||TEX_ID;

	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON TEX_ID: '||TEX_ID||' ACTUALIZADO');
		
		V_COUNT_UPDATE_3 := V_COUNT_UPDATE_3 + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF; 

--CREAMOS NUEVA TAREA 

	V_SQL := 'SELECT '||V_ESQUEMA||'.S_TAR_TAREAS_NOTIFICACIONES.NEXTVAL FROM DUAL';
				
        EXECUTE IMMEDIATE V_SQL INTO SEQ_TAR_ID;

	V_SQL := 'Insert into REM01.TAR_TAREAS_NOTIFICACIONES (TAR_ID,CLI_ID,EXP_ID,ASU_ID,TAR_TAR_ID,SPR_ID,SCX_ID,DD_EST_ID,DD_EIN_ID,DD_STA_ID,TAR_CODIGO,TAR_TAREA,TAR_DESCRIPCION,TAR_FECHA_FIN,TAR_FECHA_INI,TAR_EN_ESPERA,TAR_ALERTA,TAR_TAREA_FINALIZADA,TAR_EMISOR,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,PRC_ID,CMB_ID,SET_ID,TAR_FECHA_VENC,OBJ_ID,TAR_FECHA_VENC_REAL,DTYPE,NFA_TAR_REVISADA,NFA_TAR_FECHA_REVIS_ALER,NFA_TAR_COMENTARIOS_ALERTA,DD_TRA_ID,CNT_ID,TAR_DESTINATARIO,TAR_TIPO_DESTINATARIO,TAR_ID_DEST,PER_ID,RPR_REFERENCIA,T_REFERENCIA,SYS_GUID) 
		  values 
		  ('||SEQ_TAR_ID||',null,null,null,null,null,null,null,''61'',''839'',''1'',''Emisión certificado'',''Emisión certificado'',null,SYSDATE,''0'',''0'',''0'',null,''1'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',null,null,null,SYSDATE+20,null,null,''EXTTareaNotificacion'',''0'',null,null,null,null,null,null,null,null,null,null,null)';
	
	EXECUTE IMMEDIATE V_SQL;

	DBMS_OUTPUT.PUT_LINE('[INFO] CREADO NUEVO REGISTRO EN TABLA TAR_TAREAS_NOTIFICACIONES');

--CREAMOS REGISTRO EN TEX

	V_SQL := 'Insert into REM01.TEX_TAREA_EXTERNA (TEX_ID,TAR_ID,TAP_ID,TEX_TOKEN_ID_BPM,TEX_DETENIDA,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO,TEX_CANCELADA,TEX_NUM_AUTOP,DTYPE,RPR_REFERENCIA,T_REFERENCIA) 
		  values 
		  (S_TEX_TAREA_EXTERNA.NEXTVAL,'||SEQ_TAR_ID||',''10000000004654'',null,''0'',''0'','''||V_USR||''',SYSDATE,null,null,null,null,''0'',null,''0'',''EXTTareaExterna'',null,null)';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] CREADO NUEVO REGISTRO EN TABLA TEX_TAREA_EXTERNA');

--CREAMOS REGISTRO EN TAC

	V_SQL := 'Insert into REM01.TAC_TAREAS_ACTIVOS (TAR_ID,TRA_ID,ACT_ID,USU_ID,SUP_ID,VERSION,USUARIOCREAR,FECHACREAR,USUARIOMODIFICAR,FECHAMODIFICAR,USUARIOBORRAR,FECHABORRAR,BORRADO) 
		  values 
		  ('||SEQ_TAR_ID||','||TRA_ID||','||ACT_ID||',''29642'','||SUP_ID||',''0'',null,null,null,null,null,null,''0'')';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] CREADO NUEVO REGISTRO EN TABLA TAC_TAREAS_ACTIVOS');

--CREAMOS REGISTRO EN ETN

	V_SQL := 'Insert into REM01.ETN_EXTAREAS_NOTIFICACIONES (TAR_ID,TAR_FECHA_VENC_REAL,NFA_TAR_REVISADA,NFA_TAR_FECHA_REVIS_ALER,NFA_TAR_COMENTARIOS_ALERTA,DD_TRA_ID,TAR_TIPO_DESTINATARIO,TAR_ID_DEST,CNT_ID,PER_ID,SYS_GUID) 
		  values 
		  ('||SEQ_TAR_ID||',SYSDATE+20,null,null,null,null,null,null,null,null,null)';

	EXECUTE IMMEDIATE V_SQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO] CREADO NUEVO REGISTRO EN TABLA TAC_TAREAS_ACTIVOS');

	END LOOP;

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_1||' registros EN ACT_TRA_TRAMITE');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_2||' registros EN TAR_TAREAS_NOTIFICACIONES');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_3||' registros EN TEX_TAREA_EXTERNA');

	DBMS_OUTPUT.PUT_LINE('[INFO] SE LANZA SP ALTA_BPM_INSTANCES');

	REM01.ALTA_BPM_INSTANCES(V_USR, PL_OUTPUT);

	DBMS_OUTPUT.PUT_LINE('[FIN] FINAL EJECUCION SP ALTA_BPM_INSTANCES');

	DBMS_OUTPUT.PUT_LINE('[FIN] ');
	
	COMMIT;
	
EXCEPTION
     WHEN OTHERS THEN
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
