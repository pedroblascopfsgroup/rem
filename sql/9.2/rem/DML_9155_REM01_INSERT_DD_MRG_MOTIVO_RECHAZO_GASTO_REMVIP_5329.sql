--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20171023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5329
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en DD_MRG_MOTIVO_RECHAZO_GASTO 5 criterios de rechazo
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-5329'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'DD_MRG_MOTIVO_RECHAZO_GASTO';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
BEGIN	
-----------------------------------------------------------------------------------------------	

	DBMS_OUTPUT.PUT_LINE('[INICIO]: INSERCION EN '||V_TABLA||'] MOTIVO F47 - Gastos cíclicos mismo proveedor ');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_MRG_CODIGO =  ''F47'' ';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	-- Si existe la FILA
	IF V_NUM_TABLAS > 0 THEN	
	
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA||' ...no se producira ningun cambio.');
		
	ELSE
	
		-- Validación 1
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
			(DD_MRG_ID, DD_MRG_CODIGO, DD_MRG_DESCRIPCION, DD_MRG_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER, VERSION, 
				USUARIOCREAR, FECHACREAR, BORRADO)' || 
			' SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL' || ',
			''F47'', 
			''Gasto cíclico. Comprobar si tiene el mismo proveedor que el inicio de la serie'', 
			''El gasto debe tener el mismo proveedor que el de inicio de la serie'',
			1,
			''WHERE AUX.ID_PRIMER_GASTO_SERIE IS NOT NULL AND NOT EXISTS
( SELECT 1 FROM GPV_GASTOS_PROVEEDOR GPV
  JOIN ACT_PVE_PROVEEDOR PVE ON GPV.PVE_ID_EMISOR = PVE.PVE_ID 
  WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.ID_PRIMER_GASTO_SERIE AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA#
  AND PVE.PVE_DOCIDENTIF = AUX.NIF_PROVEEDOR
  AND GPV.BORRADO = 0
  AND PVE.BORRADO = 0    
)'',
			0, 
			'''||V_USUARIO||''', 
			SYSDATE, 
			0 
			FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL;

	END IF;
		

-----------------------------------------------------------------------------------------------	

	DBMS_OUTPUT.PUT_LINE('[INICIO]: INSERCION EN '||V_TABLA||'] MOTIVO F48 - Gastos cíclicos mismo destinatario ');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_MRG_CODIGO =  ''F48'' ';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	-- Si existe la FILA
	IF V_NUM_TABLAS > 0 THEN	
	
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA||' ...no se producira ningun cambio.');
		
	ELSE
	
		-- Validación 1
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
			(DD_MRG_ID, DD_MRG_CODIGO, DD_MRG_DESCRIPCION, DD_MRG_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER, VERSION, 
				USUARIOCREAR, FECHACREAR, BORRADO)' || 
			' SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL' || ',
			''F48'', 
			''Gasto cíclico. Comprobar si tiene el mismo destinatario que el inicio de la serie'', 
			''El gasto debe tener el mismo destinatario que el de inicio de la serie'',
			1,
			''WHERE TIPO_ENVIO = ''''01'''' AND AUX.ID_PRIMER_GASTO_SERIE IS NOT NULL AND NOT EXISTS
( SELECT 1 FROM GPV_GASTOS_PROVEEDOR GPV
  JOIN DD_DEG_DESTINATARIOS_GASTO DEG ON DEG.DD_DEG_ID = GPV.DD_DEG_ID
  JOIN ACT_PRO_PROPIETARIO PRO ON GPV.PRO_ID = PRO.PRO_ID 
  WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.ID_PRIMER_GASTO_SERIE AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA#
  AND PRO.PRO_DOCIDENTIF = AUX.NIF_DESTINATARIO
  AND GPV.BORRADO = 0
  AND PRO.BORRADO = 0    
  AND DD_DEG_CODIGO = ''''01''''
)'',
			0, 
			'''||V_USUARIO||''', 
			SYSDATE, 
			0 
			FROM DUAL';

		EXECUTE IMMEDIATE V_MSQL;

	END IF;

-----------------------------------------------------------------------------------------------	

	DBMS_OUTPUT.PUT_LINE('[INICIO]: INSERCION EN '||V_TABLA||'] MOTIVO F49 - Gastos cíclicos mismo concepto ');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_MRG_CODIGO =  ''F49'' ';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	-- Si existe la FILA
	IF V_NUM_TABLAS > 0 THEN	
	
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA||' ...no se producira ningun cambio.');
		
	ELSE
	
		-- Validación 1
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
			(DD_MRG_ID, DD_MRG_CODIGO, DD_MRG_DESCRIPCION, DD_MRG_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER, VERSION, 
				USUARIOCREAR, FECHACREAR, BORRADO)' || 
			' SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL' || ',
			''F49'', 
			''Gasto cíclico. Comprobar si tiene el mismo concepto que el inicio de la serie'', 
			''El gasto debe ser del mismo tipo y subtipo que el de inicio de la serie'',
			1,
			''WHERE TIPO_ENVIO = ''''01'''' AND AUX.ID_PRIMER_GASTO_SERIE IS NOT NULL AND NOT EXISTS
( SELECT 1 FROM GPV_GASTOS_PROVEEDOR GPV
  JOIN DD_TGA_TIPOS_GASTO TGA ON TGA.DD_TGA_ID = GPV.DD_TGA_ID
  JOIN DD_STG_SUBTIPOS_GASTO STG ON STG.DD_STG_ID = GPV.DD_STG_ID
  WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.ID_PRIMER_GASTO_SERIE AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA#
  AND TGA.DD_TGA_CODIGO = AUX.TIPO_GASTO
  AND STG.DD_STG_CODIGO = AUX.SUBTIPO_GASTO
  AND TGA.BORRADO = 0
  AND STG.BORRADO = 0    
  AND GPV.BORRADO = 0
)'',
			0, 
			'''||V_USUARIO||''', 
			SYSDATE, 
			0 
			FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL;

	END IF;

-----------------------------------------------------------------------------------------------	

	DBMS_OUTPUT.PUT_LINE('[INICIO]: INSERCION EN '||V_TABLA||'] MOTIVO F50 - Gastos cíclicos mismo importe ');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_MRG_CODIGO =  ''F50'' ';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	-- Si existe la FILA
	IF V_NUM_TABLAS > 0 THEN	
	
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA||' ...no se producira ningun cambio.');
		
	ELSE
	
		-- Validación 1
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
			(DD_MRG_ID, DD_MRG_CODIGO, DD_MRG_DESCRIPCION, DD_MRG_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER, VERSION, 
				USUARIOCREAR, FECHACREAR, BORRADO)' || 
			' SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL' || ',
			''F50'', 
			''Gasto cíclico. Comprobar si tiene el mismo importe que el inicio de la serie'', 
			''El gasto debe ser de la misma cuantía que el de inicio de la serie'',
			1,
			''WHERE TIPO_ENVIO = ''''01'''' AND AUX.ID_PRIMER_GASTO_SERIE IS NOT NULL AND NOT EXISTS
( SELECT 1 FROM GPV_GASTOS_PROVEEDOR GPV
  JOIN GDE_GASTOS_DETALLE_ECONOMICO GDE ON GDE.GPV_ID = GPV.GPV_ID
  WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.ID_PRIMER_GASTO_SERIE AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA#
  AND AUX.PRINCIPAL = GDE.GDE_PRINCIPAL_NO_SUJETO
  AND AUX.RECARGO = GDE.GDE_RECARGO
  AND AUX.INT_DEMORA = GDE.GDE_INTERES_DEMORA
  AND AUX.COSTAS = GDE.GDE_COSTAS
  AND AUX.OTROS_INCREMENTOS = GDE.GDE_OTROS_INCREMENTOS
  AND AUX.PROVISIONES_Y_SUPL = GDE.GDE_PROV_SUPLIDOS
  AND GPV.BORRADO = 0
  AND GDE.BORRADO = 0    
)'',
			0, 
			'''||V_USUARIO||''', 
			SYSDATE, 
			0 
			FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL;

	END IF;


-----------------------------------------------------------------------------------------------	

	DBMS_OUTPUT.PUT_LINE('[INICIO]: INSERCION EN '||V_TABLA||'] MOTIVO F51 - Gastos cíclicos misma periodicidad ');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_MRG_CODIGO =  ''F51'' ';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	-- Si existe la FILA
	IF V_NUM_TABLAS > 0 THEN	
	
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen los datos en la tabla '||V_ESQUEMA||'.'||V_TABLA||' ...no se producira ningun cambio.');
		
	ELSE
	
		-- Validación 1
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
			(DD_MRG_ID, DD_MRG_CODIGO, DD_MRG_DESCRIPCION, DD_MRG_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER, VERSION, 
				USUARIOCREAR, FECHACREAR, BORRADO)' || 
			' SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL' || ',
			''F51'', 
			''Gasto cíclico. Comprobar si tiene la misma periodicidad que el de inicio de la serie'', 
			''El gasto debe tener la misma periodicidad que el de inicio de la serie'',
			1,
			''WHERE TIPO_ENVIO = ''''01'''' AND AUX.ID_PRIMER_GASTO_SERIE IS NOT NULL AND NOT EXISTS
( SELECT 1 FROM GPV_GASTOS_PROVEEDOR GPV
  JOIN DD_TPE_TIPOS_PERIOCIDAD TPE ON TPE.DD_TPE_ID = GPV.DD_TPE_ID
  WHERE GPV.GPV_NUM_GASTO_GESTORIA = AUX.ID_PRIMER_GASTO_SERIE AND GPV.DD_GRF_ID = #TOKEN_IDGESTORIA#
  AND AUX.PERIO_REAL = TPE.DD_TPE_CODIGO
  AND GPV.BORRADO = 0
  AND TPE.BORRADO = 0    
)'',
			0, 
			'''||V_USUARIO||''', 
			SYSDATE, 
			0 
			FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL;

	END IF;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]: SE HAN INSERTADO LOS REGISTROS EN '||V_TABLA||' CORRECTAMENTE ');
   

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
EXIT;
