--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190709
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4761
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-4761'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    ACT_ID NUMBER(16);
    V_COUNT_UPDATE_1 NUMBER(16):= 0; -- Vble. para contar updates

    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	--ACT_NUM_ACTIVO 

	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
			T_JBV(6893413),
			T_JBV(6893394),
			T_JBV(6893395),
			T_JBV(6893396),
			T_JBV(6893397),
			T_JBV(6893398),
			T_JBV(6893399),
			T_JBV(6893400),
			T_JBV(6893401),
			T_JBV(6893402),
			T_JBV(6893405),
			T_JBV(6893407),
			T_JBV(6893408),
			T_JBV(6896046),
			T_JBV(6896048),
			T_JBV(6896050),
			T_JBV(6896051),
			T_JBV(6896052),
			T_JBV(6896053),
			T_JBV(6896054),
			T_JBV(6896055),
			T_JBV(6896056),
			T_JBV(6896057),
			T_JBV(6896058),
			T_JBV(6896059),
			T_JBV(6896060),
			T_JBV(6896061),
			T_JBV(6896062),
			T_JBV(6896063),
			T_JBV(6896064),
			T_JBV(6896065),
			T_JBV(6896066),
			T_JBV(6896067),
			T_JBV(6896068),
			T_JBV(6896069),
			T_JBV(6896070),
			T_JBV(6896071),
			T_JBV(6896072),
			T_JBV(6896078),
			T_JBV(6896079),
			T_JBV(6896080),
			T_JBV(6896081),
			T_JBV(6896082),
			T_JBV(6896083),
			T_JBV(6896084),
			T_JBV(6894807),
			T_JBV(6894809),
			T_JBV(6894810),
			T_JBV(6894811),
			T_JBV(6894812),
			T_JBV(6894813),
			T_JBV(6894815),
			T_JBV(6894816),
			T_JBV(6894818),
			T_JBV(6894819),
			T_JBV(6894820),
			T_JBV(6894821),
			T_JBV(6894822),
			T_JBV(6894828),
			T_JBV(6895990),
			T_JBV(6896000),
			T_JBV(6896001),
			T_JBV(6896002),
			T_JBV(6896003),
			T_JBV(6896004),
			T_JBV(6896005),
			T_JBV(6896007),
			T_JBV(6896008),
			T_JBV(6896010),
			T_JBV(6896011),
			T_JBV(6896012),
			T_JBV(6896014),
			T_JBV(6896015),
			T_JBV(6896016),
			T_JBV(6895322),
			T_JBV(6895324),
			T_JBV(6895327),
			T_JBV(6895328),
			T_JBV(6895330),
			T_JBV(6895331),
			T_JBV(6895704),
			T_JBV(6895705),
			T_JBV(6895708),
			T_JBV(6895709),
			T_JBV(6895711),
			T_JBV(6895712)
				); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION ACTIVOS');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	ACT_ID := TRIM(V_TMP_JBV(1));

	--UPDATE ACT_SPS_SIT_POSESORIA
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_ID;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS_1;
	
	IF V_NUM_FILAS_1 = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA  
				   SET SPS_RIESGO_OCUPACION = 1
				   , USUARIOMODIFICAR = '''||V_USR||''' 
				   , FECHAMODIFICAR = SYSDATE 
				   WHERE ACT_ID = (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE ACT_NUM_ACTIVO = '||ACT_ID||')';
	

		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON ACT_NUM_ACTIVO: '||ACT_ID||' ACTUALIZADO EN ACT_SPS_SIT_POSESORIA');

		V_COUNT_UPDATE_1 := V_COUNT_UPDATE_1 + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
	
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE_1||' registros EN ACT_SPS_SIT_POSESORIA');

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
