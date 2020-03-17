--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200317
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
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-6688_3'; -- USUARIOCREAR/USUARIOMODIFICAR.
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
	T_JBV(292944, 4135832 ,687 ,50476 ,156072),
	T_JBV(307249, 4217853 ,1024 ,50476 ,161214),
	T_JBV(263313, 3976986 ,2012 ,50476 ,145351),
	T_JBV(285382, 4089759 ,2131 ,50476 ,153196),
	T_JBV(267248, 3996617 ,2133 ,50476 ,146424),
	T_JBV(263325, 3977046 ,2313 ,50476 ,145358),
	T_JBV(263528, 3978255 ,2314 ,50476 ,145442),
	T_JBV(388781, 4621253 ,3502 ,50476 ,181747),
	T_JBV(311242, 4236161 ,4112 ,50476 ,162189),
	T_JBV(272437, 4018555 ,4465 ,50476 ,147751),
	T_JBV(272438, 4018561 ,4601 ,50476 ,147752),
	T_JBV(272440, 4018565 ,6156 ,50476 ,147754),
	T_JBV(272436, 4018551 ,6165 ,50476 ,147750),
	T_JBV(307396, 4218892 ,6166 ,50476 ,161290),
	T_JBV(260796, 3960827 ,40147 ,50476 ,144354),
	T_JBV(265221, 3986763 ,40151 ,50476 ,145819),
	T_JBV(272441, 4018568 ,44989 ,50476 ,147755),
	T_JBV(311145, 4235693 ,48060 ,50476 ,162144),
	T_JBV(321615, 4292308 ,259107 ,50476 ,165480),
	T_JBV(324240, 4306043 ,259141 ,50476 ,166193),
	T_JBV(463609, 4998446 ,347662 ,74444 ,199402)

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
