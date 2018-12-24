--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20181213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5032
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: cambiamos los estados de los expedientes comerciales para quitar estados duplicados.
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
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

BEGIN	
	DBMS_OUTPUT.PUT_LINE('[INICIO] CAMBIOS MASIVO DE ESTADOS DEL EXPEDIENTE COMERCIAL DE ALQUILER');
	
	-- Anulado
	MERGE INTO #ESQUEMA#.ECO_EXPEDIENTE_COMERCIAL ECO
	USING   (
	            SELECT ECO_ID FROM #ESQUEMA#.ECO_EXPEDIENTE_COMERCIAL ECO
	            JOIN #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID
	            WHERE EEC.DD_EEC_CODIGO = '22'
	        ) TMP 
	ON (TMP.ECO_ID = ECO.ECO_ID)
	WHEN MATCHED THEN 
	      UPDATE SET 
	        ECO.DD_EEC_ID = (SELECT EEC.DD_EEC_ID FROM #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '02')
	        , ECO.USUARIOMODIFICAR = 'HREOS-5032'
	        , ECO.FECHAMODIFICAR = SYSDATE
	        , ECO.VERSION = VERSION + 1;
	-- Contraofertado
	MERGE INTO #ESQUEMA#.ECO_EXPEDIENTE_COMERCIAL ECO
	USING   (
	            SELECT ECO_ID FROM #ESQUEMA#.ECO_EXPEDIENTE_COMERCIAL ECO
	            JOIN #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID
	            WHERE EEC.DD_EEC_CODIGO = '26'
	        ) TMP 
	ON (TMP.ECO_ID = ECO.ECO_ID)
	WHEN MATCHED THEN 
	      UPDATE SET 
	        ECO.DD_EEC_ID = (SELECT EEC.DD_EEC_ID FROM #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '04')
	        , ECO.USUARIOMODIFICAR = 'HREOS-5032'
	        , ECO.FECHAMODIFICAR = SYSDATE
	        , ECO.VERSION = VERSION + 1;
	-- Firmado
	MERGE INTO #ESQUEMA#.ECO_EXPEDIENTE_COMERCIAL ECO
	USING   (
	            SELECT ECO_ID FROM #ESQUEMA#.ECO_EXPEDIENTE_COMERCIAL ECO
	            JOIN #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID
	            WHERE EEC.DD_EEC_CODIGO = '29'
	        ) TMP 
	ON (TMP.ECO_ID = ECO.ECO_ID)
	WHEN MATCHED THEN 
	      UPDATE SET 
	        ECO.DD_EEC_ID = (SELECT EEC.DD_EEC_ID FROM #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC WHERE EEC.DD_EEC_CODIGO = '03')
	        , ECO.USUARIOMODIFICAR = 'HREOS-5032'
	        , ECO.FECHAMODIFICAR = SYSDATE
	        , ECO.VERSION = VERSION + 1;
	
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

