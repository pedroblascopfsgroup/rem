--/*
--###########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20200507
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6575
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR INFORMACION GASTOS
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_NUM_TABLAS_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  GPV_ID NUMBER(16);
  GIC_CCC VARCHAR2(50 CHAR);
  GIC_CPP VARCHAR2(50 CHAR);
  V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
  V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-6575';
	
   V_PAR VARCHAR( 32000 CHAR );
   V_RET VARCHAR( 1024 CHAR );  
  
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

   V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
    -- GPV_ID,  GIC_CCC, GIC_CPP 
T_JBV('4423119','14094','679523'),
T_JBV('4423120','14121','679523'),
T_JBV('6849247','14094','576155'),
T_JBV('6394054','14121','679523'),
T_JBV('6849244','14121','576155'),
T_JBV('6412996','14121','679523'),
T_JBV('6618480','14094','679523'),
T_JBV('6656216','14121','679523'),
T_JBV('6684809','14121','0'),
T_JBV('6804736','14094','679523'),
T_JBV('6849259','14121','679523'),
T_JBV('6849254','14094','679523'),
T_JBV('6852380','14121','679523'),
T_JBV('6849255','14121','653704'),
T_JBV('6850637','14121','679523'),
T_JBV('6849257','14121','679523'),
T_JBV('6852368','14121','679523'),
T_JBV('6869663','14121','653704'),
T_JBV('6958479','14121','679523'),
T_JBV('7035765','14094','679523'),
T_JBV('6965566','14121','679523'),
T_JBV('6969215','14121','653704'),
T_JBV('6956682','14121','679523'),
T_JBV('6969223','14121','679523'),
T_JBV('6965519','14121','679523'),
T_JBV('6977905','14121','679523'),
T_JBV('6969222','14121','679523'),
T_JBV('7077519','14121','679523'),
T_JBV('7077520','14094','679523'),
T_JBV('7144505','14121','679523'),
T_JBV('7078570','14121','679523'),
T_JBV('7167157','14094','576155'),
T_JBV('7078595','14121','679523'),
T_JBV('7078669','14121','679523'),
T_JBV('7054548','14121','653704'),
T_JBV('7167127','14121','576155'),
T_JBV('7168939','14044','518346'),
T_JBV('7168946','14094','576155'),
T_JBV('7168945','14094','576155'),
T_JBV('7167120','14121','576155'),
T_JBV('7155351','14121','576155'),
T_JBV('7226557','14121','576155'),
T_JBV('7078611','14121','653704'),
T_JBV('6618392','14121','679523'),
T_JBV('6618394','14121','679523'),
T_JBV('6684785','14121','679523'),
T_JBV('6958424','14121','653704'),
T_JBV('7078604','14121','653704'),
T_JBV('7167070','14121','576155'),
T_JBV('7168947','14121','576155'),
T_JBV('7216181','14094','576155')

	); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP  -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTA REFERENCIA CATASTRAL ACTIVOS');
   FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);

  	GPV_ID := TRIM(V_TMP_JBV(1));
  	
  	GIC_CCC := TRIM(V_TMP_JBV(2));

	GIC_CPP := TRIM(V_TMP_JBV(3));


	V_MSQL := 'UPDATE '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD SET GIC_CUENTA_CONTABLE = '''||GIC_CCC||'''
					, GIC_PTDA_PRESUPUESTARIA = '''||GIC_CPP||'''
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
			WHERE GPV_ID = '||GPV_ID||'';
				
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE LA CCC Y LA CPP');

	V_COUNT_UPDATE := V_COUNT_UPDATE + 1;


	V_MSQL := 'UPDATE '||V_ESQUEMA||'.GGE_GASTOS_GESTION SET DD_EAH_ID = 3 
					, DD_EAP_ID = 2 
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
			WHERE GPV_ID = '||GPV_ID||'';
				
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE LA GGE');

	V_COUNT_INSERT := V_COUNT_INSERT + 1;
			
		
    END LOOP;
    COMMIT;
   
	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' registros ');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_INSERT||' registros ');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.put_line('[INICIO]');

-----------------------------------------------------------------------------------------------------------------      

   V_PAR := '9648809,
9648810,
10875525,
10420296,
10875522,
10439222,
10644712,
10682442,
10711016,
10830957,
10875537,
10875532,
10878707,
10875533,
10876934,
10875535,
10878695,
10896033,
10984971,
11062312,
10992071,
10995735,
10983161,
10995743,
10992024,
11004452,
10995742,
11104016,
11104017,
11171028,
11105077,
11193684,
11105102,
11105170,
11081089,
11193654,
11195466,
11195473,
11195472,
11193647,
11181878,
11253104,
11105118,
10644619,
10644621,
10710992,
10984916,
11105111,
11193597,
11195474,
11242728
';	
   REM01.SP_EXT_REENVIO_GASTO ( V_PAR , V_USUARIO, V_RET );

-----------------------------------------------------------------------------------------------------------------

   DBMS_OUTPUT.PUT_LINE( V_RET );
   DBMS_OUTPUT.PUT_LINE(' [INFO] Reenviado gastos ');
   DBMS_OUTPUT.PUT_LINE('[FIN] ');

EXCEPTION

   WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;

        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);

        ROLLBACK;
        RAISE;          

END;

/

EXIT
