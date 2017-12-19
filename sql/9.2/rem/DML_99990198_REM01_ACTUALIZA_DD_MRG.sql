--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171211
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3197
--## PRODUCTO=NO
--##
--## Finalidad: Añade una validación y modifica otras en la tabla DD_MRG_MOTIVO_RECHAZO_GASTO. 
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
    V_USUARIO VARCHAR2(50 CHAR) := 'HREOS-3197'; -- USUARIO CREAR/MODIFICAR
    V_TABLA VARCHAR2(50 CHAR) := 'DD_MRG_MOTIVO_RECHAZO_GASTO';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]: INSERCION EN '||V_TABLA||'] ');
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_MRG_CODIGO =  ''F34''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	-- Si existe la FILA
	IF V_NUM_TABLAS > 0 THEN	
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la validación F34 en la tabla '||V_ESQUEMA||'.'||V_TABLA);
	ELSE
		-- Validación
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||'
			(DD_MRG_ID, DD_MRG_CODIGO, DD_MRG_DESCRIPCION, DD_MRG_DESCRIPCION_LARGA, PROCESO_VALIDAR, QUERY_ITER, VERSION, 
				USUARIOCREAR, FECHACREAR, BORRADO)
            VALUES ('||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,
			''F34'', 
			''No pueden darse alta gastos de Sareb, Sareb Pre-Ibero y Solvia (Bankia) posteriores al 31/12/2012'', 
			''No pueden darse alta gastos de Sareb, Sareb Pre-Ibero y Solvia (Bankia) posteriores al 31/12/2012'',
			1,
			''JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.COD_ACTIVO JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''''03'''' JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SBC ON SBC.DD_CRA_ID = CRA.DD_CRA_ID AND SBC.DD_SCR_CODIGO IN (''''14'''',''''15'''',''''19'''') WHERE TO_DATE(TO_CHAR(AUX.FECHA_DEVENGO_REAL,''''DD/MM/YYYY''''),''''DD/MM/YYYY'''') > TO_DATE(''''31/12/2012'''',''''DD/MM/YYYY'''')'',
			0, 
			'''||V_USUARIO||''', 
			SYSDATE, 
			0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Validación F34 en '||V_ESQUEMA||'.'||V_TABLA||' insertada correctamente.');
    END IF;
    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE, QUERY_ITER = REPLACE(QUERY_ITER,''"'','''''''') WHERE DD_MRG_CODIGO IN (''F31'',''F33'') AND QUERY_ITER LIKE ''%"%''';
    EXECUTE IMMEDIATE V_MSQL;
    IF SQL%ROWCOUNT = 2 THEN
    	DBMS_OUTPUT.PUT_LINE('[INFO] Comillas dobles reemplazadas en validaciones F31 y F33.');
    ELSE
    	IF SQL%ROWCOUNT = 1 THEN
    		DBMS_OUTPUT.PUT_LINE('[INFO] Comillas dobles reemplazadas en alguna validación.');
    	ELSE
    		DBMS_OUTPUT.PUT_LINE('[INFO] Comillas dobles no encontradas.');
    	END IF;
    END IF;

    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
   
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