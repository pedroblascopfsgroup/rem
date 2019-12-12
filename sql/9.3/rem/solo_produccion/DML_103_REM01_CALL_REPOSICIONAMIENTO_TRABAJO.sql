--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20191209
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5587
--## PRODUCTO=NO
--##
--## Finalidad:  
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5587'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_NUM_TBJ NUMBER(16); 
    TRA_ID NUMBER(16);
    TAR_ID NUMBER(16);
    TAP_CODIGO VARCHAR2(50 CHAR);
    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_2 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_3 NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--TRA_ID , TAR_ID, TEX_ID 

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
				T_JBV(9000128400,	224110,	'T004_CierreEconomico')
				); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] *** INICIO PROCESO ***');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	V_NUM_TBJ := TRIM(V_TMP_JBV(1));
  	
  	TRA_ID := TRIM(V_TMP_JBV(2));

	TAP_CODIGO := TRIM(V_TMP_JBV(3));
	
	DBMS_OUTPUT.PUT_LINE('[INFO] REPOSICIONANDO TRABAJO -> ''' || V_NUM_TBJ || ''' A TAREA -> ''' || TAP_CODIGO || '''');
	
	#ESQUEMA#.REPOSICIONAMIENTO_TRABAJO(V_USR, V_NUM_TBJ, TRA_ID, TAP_CODIGO, PL_OUTPUT);
	
	DBMS_OUTPUT.PUT_LINE('[INFO] LANZADO procedimiento ''REPOSICIONAMIENTO_TRABAJO'' CORRECTAMENTE!!');
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO TRÁMITE -> ''' || TRA_ID || '''');
	
	--UPDATE ACT_TRA_TRAMITE
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE WHERE TRA_ID = '||TRA_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
	IF V_NUM_FILAS_1 > 0 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TRA_TRAMITE 
				   SET TRA_PROCESS_BPM = NULL,
				   DD_EPR_ID = 30,
				   BORRADO = 0,
				   FECHABORRAR = NULL, 
				   TRA_FECHA_FIN = NULL,
				   USUARIOMODIFICAR = '''||V_USR||''',
				   FECHAMODIFICAR = SYSDATE 
				   WHERE TRA_ID = '||TRA_ID;
	

		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] TRÁMITE ACTUALIZADO CORRECTAMENTE!!');
		
		V_COUNT_UPDATE_1 := V_COUNT_UPDATE_1 + SQL%ROWCOUNT;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] TRÁMITE NO EXISTE');
		
	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO TARs DEL TRÁMITE -> ''' || TRA_ID || '''');
	--UPDATE TAR_TAREAS_NOTIFICACIONES

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR 
									WHERE TBJ_ID = (SELECT TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO 
													WHERE TBJ_NUM_TRABAJO = '''||V_NUM_TBJ||'''))';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_2;
	
	IF V_NUM_FILAS_2 > 0 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES 
				   SET TAR_TAREA_FINALIZADA = 0, 
				   BORRADO = 0, 
				   FECHABORRAR = NULL, 
				   USUARIOBORRAR = NULL, 
				   TAR_FECHA_FIN = NULL, 
				   USUARIOMODIFICAR = '''||V_USR||''',
				   FECHAMODIFICAR = SYSDATE 
				   WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR 
									WHERE TBJ_ID = (SELECT TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO 
													WHERE TBJ_NUM_TRABAJO = '''||V_NUM_TBJ||'''))';

	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| SQL%ROWCOUNT || ' TAR/s DEL TRÁMITE -> ''' || TRA_ID || ''' ACTUALIZADA/S CORRECTAMENTE!!');
		
		V_COUNT_UPDATE_2 := V_COUNT_UPDATE_2 + SQL%ROWCOUNT;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] NO HAY TARs QUE ACTUALIZAR');
		
	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO TEXs DEL TRÁMITE -> ''' || TRA_ID || '''');
	--UPDATE TEX_TAREA_EXTERNA

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA WHERE TEX_ID IN (SELECT TEX_ID FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR 
									WHERE TBJ_ID = (SELECT TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO 
													WHERE TBJ_NUM_TRABAJO = '''||V_NUM_TBJ||'''))';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_3;
	
	IF V_NUM_FILAS_3 > 0 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA 
				   SET TEX_TOKEN_ID_BPM = NULL, 
				   BORRADO = 0, 
				   FECHABORRAR = NULL,
				   USUARIOBORRAR = NULL,  
				   USUARIOMODIFICAR = '''||V_USR||''',
				   FECHAMODIFICAR = SYSDATE 
				   WHERE TEX_ID IN (SELECT TEX_ID FROM '||V_ESQUEMA||'.TRABAJOS_REPOSICIONAR 
									WHERE TBJ_ID = (SELECT TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO 
													WHERE TBJ_NUM_TRABAJO = '''||V_NUM_TBJ||'''))';

	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| SQL%ROWCOUNT || ' TEX/s DEL TRÁMITE -> ''' || TRA_ID || ''' ACTUALIZADA/S CORRECTAMENTE!!');
		
		V_COUNT_UPDATE_3 := V_COUNT_UPDATE_3 + SQL%ROWCOUNT;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] NO HAY TEXs QUE ACTUALIZAR');
		
	END IF;
	
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han actualizado en total '||V_COUNT_UPDATE_1||' registros EN ACT_TRA_TRAMITE');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han actualizado en total '||V_COUNT_UPDATE_2||' registros EN TAR_TAREAS_NOTIFICACIONES');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han actualizado en total '||V_COUNT_UPDATE_3||' registros EN TEX_TAREA_EXTERNA');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[INFO] SE LANZA SP ALTA_BPM_INSTANCES');

	#ESQUEMA#.ALTA_BPM_INSTANCES(V_USR, PL_OUTPUT);

	DBMS_OUTPUT.PUT_LINE('[FIN] FINAL EJECUCION SP ALTA_BPM_INSTANCES');
	
	COMMIT;
	DBMS_OUTPUT.PUT_LINE('[FIN] *** FIN PROCESO ***');
	
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
