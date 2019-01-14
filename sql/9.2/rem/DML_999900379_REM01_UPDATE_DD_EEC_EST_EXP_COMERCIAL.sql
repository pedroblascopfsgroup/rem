--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20181213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-5032
--## PRODUCTO=NO
--##
--## INSTRUCCIONES: cambiamos el valor de DD_EEC_ALQUILER
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
	
	-- DD_EEC_ALQUILER a 1
	MERGE INTO #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC 
	USING   (
	            SELECT EEC.DD_EEC_ID FROM #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC 
	            WHERE EEC.DD_EEC_CODIGO IN ('02','03','04','18','19','20','21','23','24','25','27','28')
	        ) TMP 
	ON (TMP.DD_EEC_ID = EEC.DD_EEC_ID)
	WHEN MATCHED THEN 
	      UPDATE SET 
	        DD_EEC_ALQUILER = 1
	        , USUARIOMODIFICAR = 'HREOS-5032'
	        , FECHAMODIFICAR = SYSDATE
	        , VERSION = VERSION + 1;
	 
	-- DD_EEC_ALQUILER a 0        
	MERGE INTO #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC 
	USING   (
	            SELECT EEC.DD_EEC_ID FROM #ESQUEMA#.DD_EEC_EST_EXP_COMERCIAL EEC 
	            WHERE EEC.DD_EEC_CODIGO NOT IN ('02','03','04','18','19','20','21','23','24','25','27','28')
	        ) TMP 
	ON (TMP.DD_EEC_ID = EEC.DD_EEC_ID)
	WHEN MATCHED THEN 
	      UPDATE SET 
	        DD_EEC_ALQUILER = 0
	        , USUARIOMODIFICAR = 'HREOS-5032'
	        , FECHAMODIFICAR = SYSDATE
	        , VERSION = VERSION + 1;

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

