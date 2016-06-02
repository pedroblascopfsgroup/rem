--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160512
--## ARTEFACTO=producto
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1130
--## PRODUCTO=SI
--##
--## Finalidad: DML que actualiza la tabla DD_MEX_MOTIVOS_EXP_MANUAL de Haya-Sareb.
--## Primero actualiza el campo borrado a 1 para todos los registros actuales.
--## Segundo añade los nuevos motivos.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
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
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de registros en una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLE_NAME VARCHAR2(50 CHAR):= 'DD_MEX_MOTIVOS_EXP_MANUAL';
    V_TABLE_EXISTS NUMBER(1); -- Vble. para validar la existencia de la tabla.
    
BEGIN
	
    -- ******** Update de la tabla DD_MEX_MOTIVOS_EXP_MANUAL *******
    DBMS_OUTPUT.PUT_LINE('******** Update de la tabla '||V_TABLE_NAME||' *******'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLE_NAME||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla.   
    V_SQL := 'SELECT COUNT(*) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLE_NAME||''' AND owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_TABLE_EXISTS;
    -- Si NO existe la tabla no hacemos nada.
    IF V_TABLE_EXISTS = 0 THEN 
    	DBMS_OUTPUT.PUT_LINE('[INFO] La tabla '||V_ESQUEMA||'.'||V_TABLE_NAME||' NO se ha encontrado. No se puede continuar..');    
    ELSE
		V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLE_NAME||' WHERE DD_MEX_CODIGO IN (''1'',''2'',''3'')';
		EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
		IF V_NUM_REG = 0 THEN
			DBMS_OUTPUT.PUT_LINE('[INFO] La tabla '||V_ESQUEMA||'.'||V_TABLE_NAME||' no contiene registros anteriores para borrar de manera logica.');
		ELSE
    		-- Borrado logico de los registros que actualmente contenga la tabla.
            V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLE_NAME||' SET BORRADO = 1 WHERE DD_MEX_CODIGO IN (''1'',''2'',''3'')';
   		    EXECUTE IMMEDIATE V_MSQL;
   		    DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado de manera logica los registros contenidos en la tabla '||V_ESQUEMA||'.'||V_TABLE_NAME||'.');
    	END IF;
   		    
    	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.'||V_TABLE_NAME||' WHERE DD_MEX_CODIGO IN (''REESPOR'', ''QUITA'', ''DACENPAG'', ''RERERE'', ''SINACCIO'', ''VENTCRED'', ''VENTDEUD'', ''PDV'', ''PASELITI'', ''LIBIPF'', ''LDVC'', ''DESPIG'', ''AMOVOL'')';
    	EXECUTE IMMEDIATE V_SQL INTO V_NUM_REG;
    	
    	IF V_NUM_REG = 0 THEN
	   		-- Insertar nuevos registros en la tabla si no existen.
	   		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''QUITA'', ''Quita'', ''Quita'', ''PRODUCTO-1130'', sysdate, ''0'')';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''DACENPAG'', ''Dación en pago'', ''Dación en pago'', ''PRODUCTO-1130'', sysdate, ''0'')';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''RERERE'', ''Reestructuración/Refinanciación/Recobro'', ''Reestructuración/Refinanciación/Recobro'', ''PRODUCTO-1130'', sysdate, ''0'')';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''SINACCIO'', ''Sin acciones'', ''Sin acciones'', ''PRODUCTO-1130'', sysdate, ''0'')';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''VENTCRED'', ''Venta de crédito'', ''Venta de crédito'', ''PRODUCTO-1130'', sysdate, ''0'')';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''VENTDEUD'', ''Venta de deuda'', ''Venta de deuda'', ''PRODUCTO-1130'', sysdate, ''0'')';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''PDV'', ''PDV'', ''PDV'', ''PRODUCTO-1130'', sysdate, ''0'')';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''PASELITI'', ''Pase a litigio'', ''Pase a litigio'', ''PRODUCTO-1130'', sysdate, ''0'')';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''LIBIPF'', ''Liberación IPF'', ''Liberación IPF'', ''PRODUCTO-1130'', sysdate, ''0'')';
				EXECUTE IMMEDIATE V_MSQL;
	   		    
				V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''LDVC'', ''Liq. deuda venta colaterales'', ''Liq. deuda venta colaterales'', ''PRODUCTO-1130'', sysdate, ''0'')';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''DESPIG'', ''Despignoraciones'', ''Despignoraciones'', ''PRODUCTO-1130'', sysdate, ''0'')';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''AMOVOL'', ''Amortizaciones voluntarias'', ''Amortizaciones voluntarias'', ''PRODUCTO-1130'', sysdate, ''0'')';
			EXECUTE IMMEDIATE V_MSQL;
			
			V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLE_NAME||' (DD_MEX_ID, DD_MEX_CODIGO, DD_MEX_DESCRIPCION, DD_MEX_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_MEX_MOTIVOS_EXP_MANUAL.NEXTVAL, ''REESPOR'', ''Recobro esporádico'', ''Recobro esporádico'', ''PRODUCTO-1130'', sysdate, ''0'')';
			EXECUTE IMMEDIATE V_MSQL;
			
	        COMMIT;	
	        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLE_NAME||' Se han actualizado los valores. Se finaliza el script.');
	     ELSE
	     	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLE_NAME||' Los registros ya estaban insertados. Se finaliza el script.');
	     END IF;
	END IF;	

    
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
