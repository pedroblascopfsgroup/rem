--/*
--###########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20210222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9006
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR GASTOS A PAGADO
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
  GPV_NUM_GASTO NUMBER(16);
  GDE_FECHA_PAGO VARCHAR2(50 CHAR);
  V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
  V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-9006';
	
   V_PAR VARCHAR( 32000 CHAR );
   V_RET VARCHAR( 1024 CHAR );  
  
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 

   V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
    --GPV_NUM_GASTO_HAYA, GDE_FECHA_PAGO
		T_JBV('13015465','2018/01/01'),
		T_JBV('13072714','2017/01/01'),
		T_JBV('13016448','2018/01/01'),
		T_JBV('13010849','2016/01/01'),
		T_JBV('13081047','2016/12/30'),
		T_JBV('13169242','2017/02/06'),
		T_JBV('13016449','2018/01/01'),
		T_JBV('13054455','2019/01/01'),
		T_JBV('13065732','2020/01/01'),
		T_JBV('13065912','2020/01/01'),
		T_JBV('13068548','2020/01/01'),
		T_JBV('13070563','2020/01/01'),
		T_JBV('13072026','2021/01/01'),
		T_JBV('13074663','2016/10/24'),
		T_JBV('13075179','2016/12/21'),
		T_JBV('13081881','2017/06/01'),
		T_JBV('13109912','2017/06/14'),
		T_JBV('13152302','2018/07/19')
	); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	 
    -- LOOP  -----------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('[INFO]: CAMBIAR ESTADO A PAGADO Y PONER FECHA PAGO');
   FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);

  	GPV_NUM_GASTO := TRIM(V_TMP_JBV(1));
  	
  	GDE_FECHA_PAGO := TRIM(V_TMP_JBV(2));


	V_MSQL := 'UPDATE '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR 
					  SET GPV_FECHA_EMISION = TO_DATE('''||GDE_FECHA_PAGO||''',''YYYY/MM/DD'')
					, USUARIOMODIFICAR = '''||V_USUARIO||'''
					, FECHAMODIFICAR = SYSDATE
			WHERE GPV_NUM_GASTO_HAYA = '||GPV_NUM_GASTO||'';
				
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZADO CORRECTAMENTE LA FECHA EMISION DEL GASTO '''||GPV_NUM_GASTO||''' ');

	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD GIC (GIC_ID, GPV_ID, EJE_ID, USUARIOCREAR, FECHACREAR)
					SELECT
					REM01.S_GIC_GASTOS_INFO_CONTABILIDAD.NEXTVAL AS GIC_ID,
					GPV.GPV_ID,
					EJE.EJE_ID,
					''REMVIP-9001'',
					SYSDATE
					FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV
					INNER JOIN '||V_ESQUEMA||'.ACT_EJE_EJERCICIO EJE ON EJE_ANYO = TO_CHAR(GPV.GPV_FECHA_EMISION,''YYYY'')
					WHERE GPV.USUARIOCREAR = ''MIG_BBVA''
					AND GPV.DD_EGA_ID <> (SELECT DD_EGA_ID FROM '||V_ESQUEMA||'.DD_EGA_ESTADOS_GASTO WHERE DD_EGA_CODIGO = ''05'')
					AND GPV.BORRADO = 0 AND GPV.GPV_NUM_GASTO_HAYA = '''||GPV_NUM_GASTO||'''
					AND GPV.GPV_ID NOT IN (SELECT GPV_ID FROM '||V_ESQUEMA||'.GIC_GASTOS_INFO_CONTABILIDAD)';
				
	EXECUTE IMMEDIATE V_MSQL;
	
	DBMS_OUTPUT.PUT_LINE('[INFO]: AÑADIDO CORRECTAMENTE EL REGISTRO GIC DEL GASTO '''||GPV_NUM_GASTO||'''');

	V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
			
		
    END LOOP;
    COMMIT;
   
	DBMS_OUTPUT.PUT_LINE('********************************************************************');

	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' GASTOS ');

	DBMS_OUTPUT.PUT_LINE('********************************************************************');


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
