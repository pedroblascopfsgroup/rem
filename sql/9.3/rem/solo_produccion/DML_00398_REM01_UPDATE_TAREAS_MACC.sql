--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200719
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7786
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: actualizar destinatario de tarea a nesteban
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-7786'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    TRA_ID NUMBER(16);
    TAR_ID NUMBER(16);
    TEX_ID NUMBER(16);
    ACT_ID NUMBER(16);
    USU_ID NUMBER(16);
    SUP_ID NUMBER(16);
    NUM_TBJ NUMBER(16);
    TEX_TOKEN NUMBER(16);

    SEQ_TAR_ID NUMBER(16);

    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_2 NUMBER(16):= 0; -- Vble. para contar updates
    V_COUNT_UPDATE_3 NUMBER(16):= 0; -- Vble. para contar updates

    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--TRA_ID , TAR_ID, ACT_ID, USU_ID, NUM_TBJ

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
T_JBV(404918, 4713787, 372081, 86863 ),
T_JBV(405972, 4720607, 372081, 86863 ),
T_JBV(591608, 5349620, 483622, 86863 ),
T_JBV(586568, 5319735, 449925, 39899 ),
T_JBV(580198, 5287242, 486026, 86863 ),
T_JBV(407220, 4728150, 372081, 86863 ),
T_JBV(586587, 5336174, 359489, 86863 ),
T_JBV(588390, 5348656, 473446, 86863 ),
T_JBV(588466, 5348624, 466563, 86863 ),
T_JBV(579680, 5342494, 459581, 86863 ),
T_JBV(588875, 5348676, 444493, 86863 ),
T_JBV(580674, 5339135, 486025, 86863 ),
T_JBV(587599, 5348702, 451407, 86863 ),
T_JBV(585416, 5328461, 477488, 86863 ),
T_JBV(591383, 5348344, 450117, 86863 ),
T_JBV(587991, 5342378, 383263, 86863 ),
T_JBV(587906, 5340800, 366035, 86863 ),
T_JBV(587501, 5324958, 459673, 86863 ),
T_JBV(587572, 5325440, 386169, 86863 ),
T_JBV(587588, 5325519, 497656, 86863 ),
T_JBV(587595, 5325549, 473526, 86863 ),
T_JBV(588468, 5331627, 444492, 86863 ),
T_JBV(588845, 5333108, 368850, 86863 ),
T_JBV(588858, 5333113, 381715, 86863 ),
T_JBV(589196, 5335250, 383264, 86863 ),
T_JBV(589199, 5342603, 457689, 86863 ),
T_JBV(589216, 5335422, 449881, 86863 ),
T_JBV(589744, 5348716, 473332, 86863 ),
T_JBV(589948, 5340410, 386123, 86863 ),
T_JBV(590430, 5342596, 456003, 86863 ),
T_JBV(590439, 5342627, 478936, 86863 ),
T_JBV(590444, 5342641, 386101, 86863 ),
T_JBV(591206, 5347057, 386231, 86863 ),
T_JBV(591309, 5348420, 478730, 86863 ),
T_JBV(591384, 5348318, 466481, 86863 ),
T_JBV(591387, 5348322, 378963, 86863 ),
T_JBV(591398, 5348415, 450143, 86863 ),
T_JBV(591399, 5348424, 479033, 86863 ),
T_JBV(591463, 5348689, 386077, 86863 ),
T_JBV(591467, 5348718, 483955, 86863 ),
T_JBV(591466, 5348715, 472080, 86863 ),
T_JBV(587110, 5322462, 445218, 86863 ),
T_JBV(586600, 5333106, 475779, 86863 ),
T_JBV(591468, 5348721, 494741, 86863 ),
T_JBV(586561, 5319680, 449852, 86863 ),
T_JBV(586549, 5319614, 379270, 86863 ),
T_JBV(586526, 5319514, 386189, 86863 ),
T_JBV(585934, 5333099, 449845, 86863 ),
T_JBV(585917, 5316306, 472581, 86863 ),
T_JBV(585516, 5313953, 499558, 86863 ),
T_JBV(591636, 5349738, 469185, 86863 ),
T_JBV(581005, 5296283, 486063, 86863 ),
T_JBV(581095, 5296253, 476468, 86863 )
		); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION TRAMITES Y TAREAS');

	V_SQL := 'SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = ''grupgmacc''';
	
	EXECUTE IMMEDIATE V_SQL INTO USU_ID;

	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	TRA_ID := TRIM(V_TMP_JBV(1));
  	
  	TAR_ID := TRIM(V_TMP_JBV(2));

	ACT_ID := TRIM(V_TMP_JBV(3));

	--COMPROBAMOS SI EXISTE EL ACTIVO

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_ID = '||ACT_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS > 0 THEN 
	
	--COMPROBAMOS SI EXISTE TAREA

		DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZANDO TRAMITE DE ID_ACTIVO '||ACT_ID||'');

		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS WHERE TRA_ID = '||TRA_ID||' AND TAR_ID = '||TAR_ID||' AND ACT_ID = '||ACT_ID||'';
	
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
		IF V_NUM_FILAS_1 > 0 THEN
	
			V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS 
					   SET USU_ID = '||USU_ID||' ,
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
		
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTIVO NO EXISTE');
		
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
