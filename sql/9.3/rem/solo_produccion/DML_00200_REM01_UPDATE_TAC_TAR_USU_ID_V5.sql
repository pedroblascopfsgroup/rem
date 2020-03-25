--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200318
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6688
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
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_1 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_2 NUMBER(16); -- Vble. para validar la existencia de un registro.
    V_NUM_FILAS_3 NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6688_5'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    TRA_ID NUMBER(16);
    TAR_ID NUMBER(16);
    TEX_ID NUMBER(16);
    ACT_ID NUMBER(16);
    USU_ID NUMBER(16);
    SUP_ID NUMBER(16);
    ECO_ID NUMBER(16);
    TEX_TOKEN NUMBER(16);

    SEQ_TAR_ID NUMBER(16);

    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_2 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_3 NUMBER(16):= 0; -- Vble. para contar updates

    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--TRA_ID , TAR_ID, ACT_ID, USU_ID, ECO_NUM_EXPEDIENTE

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
	T_JBV(353282, 4954720, 350559, 88740, 172884),
	T_JBV(360761, 4956432, 5468, 88740, 174736),
	T_JBV(385624, 5013206, 49610, 88740, 180825),
	T_JBV(393100, 4996644, 4188, 88740, 182930),
	T_JBV(395513, 4950336, 13255, 88740, 183756),
	T_JBV(406498, 4962366, 349843, 88740, 186789),
	T_JBV(406343, 4965663, 414209, 88740, 186752),
	T_JBV(409031, 4968782, 262309, 88740, 187298),
	T_JBV(409603, 4941157, 45160, 88740, 187466),
	T_JBV(411228, 4951111, 357119, 88740, 187785),
	T_JBV(410814, 4948209, 416175, 88740, 187678),
	T_JBV(413073, 4948300, 74378, 88740, 188237),
	T_JBV(415159, 5021297, 13284, 88740, 188782),
	T_JBV(415995, 5002132, 3067, 88740, 189008),
	T_JBV(417296, 5002185, 263039, 88740, 189224),
	T_JBV(418847, 4978734, 73968, 88740, 189406),
	T_JBV(419908, 4951192, 2300, 88740, 189653),
	T_JBV(420243, 5026783, 354854, 88740, 189754),
	T_JBV(423478, 4961158, 123044, 88740, 190228),
	T_JBV(423206, 4993613, 13302, 88740, 190188),
	T_JBV(427636, 4965197, 356024, 88740, 191129),
	T_JBV(426892, 4947816, 13232, 88740, 190909),
	T_JBV(428995, 5009289, 2685, 88740, 191408),
	T_JBV(428718, 4960285, 2485, 88740, 191329),
	T_JBV(428736, 4961216, 52116, 88740, 191334),
	T_JBV(431090, 4937919, 270302, 88740, 191842),
	T_JBV(431089, 4977454, 333929, 88740, 191841),
	T_JBV(432091, 4962213, 1924, 88740, 192231),
	T_JBV(431138, 5000939, 331968, 88740, 191863),
	T_JBV(434498, 4993282, 259569, 88740, 192754),
	T_JBV(432839, 5026771, 354902, 88740, 192406),
	T_JBV(434865, 4970650, 334287, 88740, 192927),
	T_JBV(434882, 4957665, 3259, 88740, 192934),
	T_JBV(434893, 4965610, 417255, 88740, 192938),
	T_JBV(434996, 4941724, 39192, 88740, 192985),
	T_JBV(435675, 4993295, 390684, 88740, 193159),
	T_JBV(436052, 4990303, 1805, 88740, 193231),
	T_JBV(441386, 4999354, 2873, 88740, 194317),
	T_JBV(441387, 4999368, 556, 88740, 194318),
	T_JBV(437402, 4990508, 53818, 88740, 193535),
	T_JBV(437794, 4988994, 39770, 88740, 193599),
	T_JBV(438089, 4991655, 2529, 88740, 193671),
	T_JBV(439461, 4993216, 2211, 88740, 193943),
	T_JBV(440391, 4984493, 4043, 88740, 194216),
	T_JBV(441637, 5017338, 52996, 88740, 194353),
	T_JBV(443807, 5009068, 260470, 88740, 194798),
	T_JBV(442779, 5027458, 292572, 88740, 194611),
	T_JBV(442189, 5024783, 74084, 88740, 194510),
	T_JBV(445020, 5025560, 39779, 88740, 195109),
	T_JBV(445063, 5027585, 74109, 88740, 195123),
	T_JBV(445271, 4999504, 40158, 88740, 195194),
	T_JBV(444643, 4988958, 4187, 88740, 195019),
	T_JBV(444284, 4957111, 358913, 88740, 194918),
	T_JBV(446818, 4993465, 49585, 88740, 195704),
	T_JBV(448130, 4993683, 254461, 88740, 195781),
	T_JBV(448926, 4980407, 13162, 88740, 195983),
	T_JBV(449239, 5007623, 344174, 88740, 196079),
	T_JBV(450545, 4985952, 12807, 88740, 196416),
	T_JBV(455560, 4994963, 349834, 88740, 197484),
	T_JBV(455895, 5010603, 2562, 88740, 197594),
	T_JBV(456075, 4989436, 47551, 88740, 197678),
	T_JBV(456306, 4991225, 2615, 88740, 197755),
	T_JBV(450930, 5026748, 74779, 88740, 196497),
	T_JBV(452997, 4991284, 262274, 88740, 196857),
	T_JBV(453878, 4983235, 74751, 88740, 197072),
	T_JBV(454385, 5003663, 4473, 88740, 197263),
	T_JBV(454359, 5009978, 344959, 88740, 197254),
	T_JBV(454354, 5009917, 345004, 88740, 197251),
	T_JBV(461674, 5022758, 418376, 88740, 198969),
	T_JBV(461730, 5024572, 73269, 88740, 198998)

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
  	
  	ECO_ID := TRIM(V_TMP_JBV(5));


	--COMPROBAMOS SI EXISTE TRABAJO

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||ECO_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS > 0 THEN 
	
	--QUITAMOS EL TOKEN DEL TRAMITE

		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS WHERE TRA_ID = '||TRA_ID||' AND TAR_ID = '||TAR_ID||' AND ACT_ID = '||ACT_ID||'';
	
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
		IF V_NUM_FILAS_1 > 0 THEN
	
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS 
					   SET USU_ID = '||USU_ID||',
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
		
	DBMS_OUTPUT.PUT_LINE('[INFO] EXPEDIENTE NO EXISTE');
		
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
