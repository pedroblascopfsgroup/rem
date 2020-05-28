--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200519
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7284
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: actualizar destinatario de tarea a PROVEEDOR
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
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_1 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_2 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_3 NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7284'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    TRA_ID NUMBER(16);
    TAR_ID NUMBER(16);
    TEX_ID NUMBER(16);
    ACT_ID NUMBER(16);
    USU_ID NUMBER(16);
    PRO_ID NUMBER(16);
    SUP_ID NUMBER(16);
    NUM_TBJ NUMBER(16);
    TEX_TOKEN NUMBER(16);

    SEQ_TAR_ID NUMBER(16);

    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_2 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_3 NUMBER(16):= 0; -- Vble. para contar updates

    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--TRA_ID , TAR_ID, ACT_ID, USU_ID, PRO_ID, NUM_TBJ

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(

T_JBV(489685, 5171467, 482450 ,29638 ,90034,916887800001 ),
T_JBV(545274, 5169542, 473354 ,89633 ,29624,916748900001 ),
T_JBV(528564, 5171717, 452644 ,89632 ,29624,916941900001 ),
T_JBV(487374, 5169232, 464206 ,29544 ,90032,916732100001 ),
T_JBV(514777, 5171441, 445401 ,29544 ,90032,916927200001 ),
T_JBV(533199, 5177012, 489825 ,89630 ,89912,916891300001 ),
T_JBV(556074, 5171381, 461004 ,29544 ,90032,915848900001 ),
T_JBV(504602, 5173105, 445248 ,89912 ,89632,916375700001 ),
T_JBV(490929, 5171170, 453771 ,89803 ,89801,916915400001 ),
T_JBV(502854, 5170180, 464394 ,29544 ,89911,916679700001 ),
T_JBV(529383, 5169905, 476292 ,29638 ,90031,916675100001 ),
T_JBV(503904, 5170114, 476298 ,29638 ,90031,916675200001 ),
T_JBV(483335, 5171842, 481883 ,89632 ,90031,916860100001 )

		); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TRAMITES Y TAREAS');

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	TRA_ID := TRIM(V_TMP_JBV(1));
  	
  	TAR_ID := TRIM(V_TMP_JBV(2));

	ACT_ID := TRIM(V_TMP_JBV(3));

	USU_ID := TRIM(V_TMP_JBV(4));

	PRO_ID := TRIM(V_TMP_JBV(5));
  	
  	NUM_TBJ := TRIM(V_TMP_JBV(6));


	--COMPROBAMOS SI EXISTE TRABAJO

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO = '||NUM_TBJ;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS > 0 THEN 
	
	--COMPROBAMOS SI EXISTE TAREA

		DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO TRAMITE DE TRABAJO '||NUM_TBJ||'');

		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS WHERE TRA_ID = '||TRA_ID||' AND TAR_ID = '||TAR_ID||' AND ACT_ID = '||ACT_ID||'';
	
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
		IF V_NUM_FILAS_1 > 0 THEN
	
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS 
					   SET USU_ID = '||PRO_ID||',
					   USUARIOMODIFICAR = '''||V_USR||''',
					   FECHAMODIFICAR = SYSDATE 
					   WHERE TRA_ID = '||TRA_ID||' AND TAR_ID = '||TAR_ID||' AND ACT_ID = '||ACT_ID||'';
	

			EXECUTE IMMEDIATE V_MSQL;
	    
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON TRA_ID: '||TRA_ID||' ACTUALIZADO');
		
			V_COUNT_UPDATE_1 := V_COUNT_UPDATE_1 + 1;
		
		ELSE
		
			DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
		END IF;
        
   	ELSE
		
	DBMS_OUTPUT.PUT_LINE('[INFO] TRABAJO NO EXISTE');
		
	END IF; 

   	END LOOP;

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_1||' registros EN TAC_TAREAS_ACTIVOS');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

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
