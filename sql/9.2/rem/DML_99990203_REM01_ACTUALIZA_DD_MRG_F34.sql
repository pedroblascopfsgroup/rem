--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171227
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.10
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
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]: ACTUALIZACIÓN EN '||V_TABLA||'] ');
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_MRG_CODIGO =  ''F34''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
	
	-- Si existe la FILA
	IF V_NUM_TABLAS = 0 THEN	
		DBMS_OUTPUT.PUT_LINE('[INFO] No existe la validación F34 en la tabla '||V_ESQUEMA||'.'||V_TABLA);
	ELSE
		-- Validación
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||'
			SET QUERY_ITER = ''JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.COD_ACTIVO JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''''03'''' JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SBC ON SBC.DD_CRA_ID = CRA.DD_CRA_ID AND SBC.DD_SCR_CODIGO IN (''''14'''',''''15'''',''''19'''') AND ACT.DD_SCR_ID = SBC.DD_SCR_ID WHERE TO_DATE(TO_CHAR(AUX.FECHA_DEVENGO_REAL,''''DD/MM/YYYY''''),''''DD/MM/YYYY'''') > TO_DATE(''''31/12/2012'''',''''DD/MM/YYYY'''')''
				, USUARIOMODIFICAR = ''HREOS-3197'', FECHAMODIFICAR = SYSDATE
			WHERE DD_MRG_CODIGO = ''F34'' 
				AND QUERY_ITER = ''JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.COD_ACTIVO JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''''03'''' JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SBC ON SBC.DD_CRA_ID = CRA.DD_CRA_ID AND SBC.DD_SCR_CODIGO IN (''''14'''',''''15'''',''''19'''') WHERE TO_DATE(TO_CHAR(AUX.FECHA_DEVENGO_REAL,''''DD/MM/YYYY''''),''''DD/MM/YYYY'''') > TO_DATE(''''31/12/2012'''',''''DD/MM/YYYY'''')''
				AND QUERY_ITER <> ''JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON ACT.ACT_NUM_ACTIVO = AUX.COD_ACTIVO JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.DD_CRA_CODIGO = ''''03'''' JOIN '||V_ESQUEMA||'.DD_SCR_SUBCARTERA SBC ON SBC.DD_CRA_ID = CRA.DD_CRA_ID AND SBC.DD_SCR_CODIGO IN (''''14'''',''''15'''',''''19'''') AND ACT.DD_SCR_ID = SBC.DD_SCR_ID WHERE TO_DATE(TO_CHAR(AUX.FECHA_DEVENGO_REAL,''''DD/MM/YYYY''''),''''DD/MM/YYYY'''') > TO_DATE(''''31/12/2012'''',''''DD/MM/YYYY'''')''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Validación F34 en '||V_ESQUEMA||'.'||V_TABLA||' actualizada correctamente.');
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