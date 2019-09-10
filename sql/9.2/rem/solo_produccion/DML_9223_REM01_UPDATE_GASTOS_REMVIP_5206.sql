--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190909
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5206
--## PRODUCTO=NO
--## 
--## Finalidad: 
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF; 
DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.
    V_NUM_FILAS NUMBER(16); -- Vble. para validar la existencia de un registro.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USR VARCHAR2(30 CHAR) := 'REMVIP-5206'; -- USUARIOCREAR/USUARIOMODIFICAR.
    V_ECO_ID NUMBER(16); 
    
    NUM_GASTO NUMBER(16);
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    
    TYPE T_JBV IS TABLE OF VARCHAR2(32000);
    TYPE T_ARRAY_JBV IS TABLE OF T_JBV; 
	
	V_JBV T_ARRAY_JBV := T_ARRAY_JBV(
			T_JBV('9704265','32.56','08/10/18'),
			T_JBV('10106784','184.55','11/01/19'),
			T_JBV('9704266','32.56','08/10/18'),
			T_JBV('10106785','184.55','11/01/19'),
			T_JBV('10162943','20.00','12/12/18'),
			T_JBV('10106290','96.00','11/01/19'),
			T_JBV('10106786','15.74','11/01/19'),
			T_JBV('9704267','32.56','08/10/18'),
			T_JBV('10106787','184.55','11/01/19'),
			T_JBV('10162944','20.00','12/12/18'),
			T_JBV('9704268','32.56','08/10/18'),
			T_JBV('10106788','184.55','11/01/19'),
			T_JBV('10162920','11.97','31/01/19'),
			T_JBV('10162945','20.00','12/12/18'),
			T_JBV('10106789','15.74','11/01/19'),
			T_JBV('10010677','8.00','18/07/18'),
			T_JBV('10010678','48.00','18/07/18'),
			T_JBV('10106790','184.55','11/01/19'),
			T_JBV('10162946','20.00','12/12/18'),
			T_JBV('10106791','184.55','11/01/19'),
			T_JBV('10162947','20.00','12/12/18'),
			T_JBV('10106792','15.74','11/01/19'),
			T_JBV('10059596','26.52','31/01/19'),
			T_JBV('10059597','9.72','31/01/19'),
			T_JBV('10059839','39.65','10/10/18'),
			T_JBV('10106793','184.55','11/01/19'),
			T_JBV('10162948','20.00','12/12/18'),
			T_JBV('10162562','12.00','27/12/18'),
			T_JBV('10162887','9.72','31/01/19'),
			T_JBV('10162888','26.52','31/01/19'),
			T_JBV('10162949','20.00','12/12/18'),
			T_JBV('10162976','30.00','14/12/18'),
			T_JBV('10162977','15.00','14/12/18'),
			T_JBV('10162978','5.00','14/12/18'),
			T_JBV('10162979','5.00','14/12/18'),
			T_JBV('10162983','40.00','20/12/18')

); 
	V_TMP_JBV T_JBV;
    
BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ACTUALIZACION GASTOS');
	
	FOR I IN V_JBV.FIRST .. V_JBV.LAST
	
	LOOP
 
	V_TMP_JBV := V_JBV(I);
	
  	NUM_GASTO := TRIM(V_TMP_JBV(1));
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '||NUM_GASTO;
	
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_FILAS;
	
	IF V_NUM_FILAS = 1 THEN
	
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.GDE_GASTOS_DETALLE_ECONOMICO 
				   SET GDE_IMPORTE_PAGADO = (TO_NUMBER('''||TRIM(V_TMP_JBV(2))||''',''99999999.99'')), 
				   GDE_FECHA_PAGO = TO_DATE('''||TRIM(V_TMP_JBV(3))||''',''DD/MM/RR'')
				   WHERE GPV_ID = (SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA = '||NUM_GASTO||')';
	
		EXECUTE IMMEDIATE V_MSQL;
    
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO CON GPV_NUM_GASTO_HAYA: '||NUM_GASTO||' ACTUALIZADO');
		
		V_COUNT_UPDATE := V_COUNT_UPDATE + 1;
		
	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] REGISTRO NO EXISTE');
		
	END IF;
	
	END LOOP;

	COMMIT;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] Se han updateado en total '||V_COUNT_UPDATE||' registros');
 
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
