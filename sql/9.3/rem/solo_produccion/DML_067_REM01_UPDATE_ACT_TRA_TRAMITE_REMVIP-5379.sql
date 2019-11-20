--/*
--##########################################
--## AUTOR=GUILLEM REY
--## FECHA_CREACION=20191003
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5379
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5379'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    TRA_ID NUMBER(16);

    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_2 NUMBER(16):= 0; -- Vble. para contar updates
        
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--TRA_ID

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
				T_JBV(385455)
				); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION COLUMNA ACT_RECOVERY_ID');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	TRA_ID := TRIM(V_TMP_JBV(1));

	--UPDATE ACT_TRA_TRAMITE
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE WHERE TRA_ID = '||TRA_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
	IF V_NUM_FILAS_1 = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_TRA_TRAMITE 
				   SET TRA_PROCESS_BPM = NULL,
				   USUARIOMODIFICAR = '''||V_USR||''',
				   FECHAMODIFICAR = SYSDATE 
				   WHERE TRA_ID = '||TRA_ID;
	

		EXECUTE IMMEDIATE V_MSQL;
		
		V_COUNT_UPDATE_1 := V_COUNT_UPDATE_1 + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;

	--UPDATE TEX_TAREA_EXTERNA

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TEX_TAREA_EXTERNA WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS WHERE TRA_ID = '||TRA_ID||')';
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_2;
	
	IF V_NUM_FILAS_2 > 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TEX_TAREA_EXTERNA 
				   SET TEX_TOKEN_ID_BPM = NULL, 
				   USUARIOMODIFICAR = '''||V_USR||''',
				   FECHAMODIFICAR = SYSDATE 
				   WHERE TAR_ID IN (SELECT TAR_ID FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS WHERE TRA_ID = '||TRA_ID||')';

	
		EXECUTE IMMEDIATE V_MSQL;
		
		V_COUNT_UPDATE_2 := V_COUNT_UPDATE_2 + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
	
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_1||' registros EN ACT_TRA_TRAMITE');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');


	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_2||' registros EN TEX_TAREA_EXTERNA');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[INFO] SE LANZA SP ALTA_BPM_INSTANCES');

	#ESQUEMA#.ALTA_BPM_INSTANCES(V_USR, PL_OUTPUT);

	DBMS_OUTPUT.PUT_LINE('[FIN] FINAL EJECUCION SP ALTA_BPM_INSTANCES');
	
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
