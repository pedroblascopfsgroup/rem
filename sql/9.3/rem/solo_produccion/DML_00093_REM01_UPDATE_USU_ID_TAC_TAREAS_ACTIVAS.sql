--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6314
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6314'; -- USUARIOCREAR/USUARIOMODIFICAR. 
    
    TAR_ID NUMBER(16);
    USU_ID NUMBER(16);
    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	-- TAR_ID, USU_ID 

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
		T_JBV(4925518,29642),
		T_JBV(4925482,29642),
		T_JBV(4925383,29642),
		T_JBV(4925367,29642),
		T_JBV(4925355,29642),
		T_JBV(4925324,29642),
		T_JBV(4925304,29642),
		T_JBV(4923403,29642),
		T_JBV(4922886,29642),
		T_JBV(4922884,29642),
		T_JBV(4922882,29642),
		T_JBV(4922881,29642),
		T_JBV(4922879,29642),
		T_JBV(4922875,29642),
		T_JBV(4922874,29642),
		T_JBV(4922863,29642),
		T_JBV(4922858,29642),
		T_JBV(4922857,29642),
		T_JBV(4922855,29642),
		T_JBV(4922850,29642),
		T_JBV(4922845,29642),
		T_JBV(4922844,29642),
		T_JBV(4922843,29642),
		T_JBV(4922842,29642),
		T_JBV(4922841,29642),
		T_JBV(4922839,29642),
		T_JBV(4922838,29642),
		T_JBV(4922837,29642),
		T_JBV(4922827,29642),
		T_JBV(4922822,29642),
		T_JBV(4922820,29642),
		T_JBV(4922817,29642),
		T_JBV(4922812,29642),
		T_JBV(4922804,29642),
		T_JBV(4922764,29642),
		T_JBV(4922725,29642),
		T_JBV(4922663,29642),
		T_JBV(4922624,29642),
		T_JBV(4922614,29642),
		T_JBV(4922532,29642),
		T_JBV(4922461,29642),
		T_JBV(4922394,29642),
		T_JBV(4922312,29642),
		T_JBV(4922178,29642),
		T_JBV(4922121,29642),
		T_JBV(4922094,29642),
		T_JBV(4922061,29642),
		T_JBV(4922052,29642),
		T_JBV(4922006,29642),
		T_JBV(4921909,29642),
		T_JBV(4919346,29642),
		T_JBV(4919344,29642),
		T_JBV(4919343,29642),
		T_JBV(4919342,29642),
		T_JBV(4919341,29642),
		T_JBV(4919340,29642),
		T_JBV(4919338,29642),
		T_JBV(4919336,29642),
		T_JBV(4919324,29642),
		T_JBV(4919310,29642),
		T_JBV(4919299,29642),
		T_JBV(4919248,29642),
		T_JBV(4918735,29642),
		T_JBV(4901872,86356),
		T_JBV(4897354,86356)

				); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
  	
  	TAR_ID := TRIM(V_TMP_JBV(1));

	USU_ID := TRIM(V_TMP_JBV(2));

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS WHERE TAR_ID = '||TAR_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
	IF V_NUM_FILAS_1 > 0 THEN
	
		/*V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS 
               		   SET USU_ID = '||USU_ID||', 
                    	   USUARIOMODIFICAR = ''REMVIP-6314_3'', 
                    	   FECHAMODIFICAR = SYSDATE 
		           WHERE TAR_ID = '||TAR_ID;

	
		EXECUTE IMMEDIATE V_MSQL;*/
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON TAR_ID: '||TAR_ID||' ACTUALIZADO');
		
		V_COUNT_UPDATE_1 := V_COUNT_UPDATE_1 + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
	
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_1||' registros EN TAC_TAREAS_ACTIVOS');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN]');
	
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
