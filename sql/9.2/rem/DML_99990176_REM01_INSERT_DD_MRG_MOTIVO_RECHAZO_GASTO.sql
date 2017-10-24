--/*
--##########################################
--## AUTOR=Isidro Sotoca
--## FECHA_CREACION=20171023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3058
--## PRODUCTO=NO
--##
--## Finalidad: Script que añade en APR_AUX_GES_GASTOS_GR las select para validar el nuevo campo FECHA_ANTICIPO
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
    
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-3058'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'DD_MRG_MOTIVO_RECHAZO_GASTO';
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]: INSERCION EN '||V_TABLA||'] ');
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_MRG_CODIGO =  ''F30'' OR DD_MRG_CODIGO =  ''F31''';
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
			''F30'', 
			''Comprobar FECHA_DE_PAGO'', 
			''El nuevo campo solo puede tener contenido si el campo 36 del fichero (fecha de pago) tiene contenido'',
			1,
			''WHERE AUX.FECHA_PAGO IS NULL AND AUX.FECHA_ANTICIPO IS NOT NULL'',
			0, 
			'''||V_USUARIO||''', 
			SYSDATE, 
			0 
			FROM DUAL';
		EXECUTE IMMEDIATE V_MSQL;
		
		-- Validación 2
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
			(DD_MRG_ID, DD_MRG_CODIGO, DD_MRG_DESCRIPCION, DD_MRG_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER, VERSION, 
				USUARIOCREAR, FECHACREAR, BORRADO)' || 
			' SELECT '||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL' || ',
			''F31'', 
			''Comprobar PAGADO_POR'', 
			''El campo "pagado por" deberá estar informado obligatoriamente con el valor 01 o con el valor 02 del diccionario 8'',
			1,
			''WHERE AUX.FECHA_ANTICIPO IS NOT NULL AND (PAGADO_POR != ''01'' OR PAGADO_POR != ''02'') '',
			0, 
			'''||V_USUARIO||''', 
			SYSDATE, 
			0 
			FROM DUAL';
	 
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Datos de la tabla '||V_ESQUEMA||'.'||V_TABLA||' insertados correctamente.');
		
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