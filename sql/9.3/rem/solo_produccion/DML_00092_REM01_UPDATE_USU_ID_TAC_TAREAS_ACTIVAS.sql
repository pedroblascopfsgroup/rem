--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200203
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
				T_JBV(4925447,29642),
				T_JBV(4925448,29643),
				T_JBV(4925449,29644),
				T_JBV(4925450,29645),
				T_JBV(4925451,29646),
				T_JBV(4925452,29647),
				T_JBV(4925453,29648),
				T_JBV(4925454,29649),
				T_JBV(4925455,29650),
				T_JBV(4925456,29651),
				T_JBV(4925457,29652),
				T_JBV(4925458,29653),
				T_JBV(4925459,29654),
				T_JBV(4925460,29655),
				T_JBV(4925461,29656),
				T_JBV(4925462,29657),
				T_JBV(4925463,29658),
				T_JBV(4925464,29659),
				T_JBV(4925465,29660),
				T_JBV(4925466,29661),
				T_JBV(4925467,29662),
				T_JBV(4925468,29663),
				T_JBV(4925469,29664),
				T_JBV(4925470,29665),
				T_JBV(4925471,29666),
				T_JBV(4925472,29667),
				T_JBV(4925473,29668),
				T_JBV(4925474,29669),
				T_JBV(4925475,29670),
				T_JBV(4925476,29671),
				T_JBV(4925477,29672),
				T_JBV(4925478,29673),
				T_JBV(4925479,29674),
				T_JBV(4925480,29675),
				T_JBV(4925481,29676),
				T_JBV(4925482,29677),
				T_JBV(4925483,29678),
				T_JBV(4925484,29679),
				T_JBV(4925485,29680),
				T_JBV(4925486,29681),
				T_JBV(4925487,29682),
				T_JBV(4925488,29683),
				T_JBV(4925489,29684),
				T_JBV(4925490,29685),
				T_JBV(4925491,29686),
				T_JBV(4925492,29687),
				T_JBV(4925493,29688),
				T_JBV(4925494,29689),
				T_JBV(4925495,29690),
				T_JBV(4925496,29691),
				T_JBV(4925497,29692),
				T_JBV(4925498,29693),
				T_JBV(4925499,29694),
				T_JBV(4925500,29695),
				T_JBV(4925501,29696),
				T_JBV(4925502,29697),
				T_JBV(4925503,29698),
				T_JBV(4925504,29699),
				T_JBV(4925505,29700),
				T_JBV(4925506,29701),
				T_JBV(4925507,29702),
				T_JBV(4925508,29703),
				T_JBV(4925509,29704)


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
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS 
               		   SET USU_ID = '||USU_ID||', 
                    	   USUARIOMODIFICAR = ''REMVIP-6314_2'', 
                    	   FECHAMODIFICAR = SYSDATE 
		           WHERE TAR_ID = '||TAR_ID;

	
		EXECUTE IMMEDIATE V_MSQL;
    
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
