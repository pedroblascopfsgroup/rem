--/*
--###########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210122
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-8759
--## PRODUCTO=NO
--## 
--## Finalidad: Mapear estados de trabajo
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
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-8759';
  
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                USING(
                SELECT TRANSICION.TBJ_ID, EST_FINAL.DD_EST_ID
                FROM(SELECT
                DISTINCT TBJ.TBJ_ID
                , EST.DD_EST_CODIGO ANTERIOR
                , DECODE(EST.DD_EST_CODIGO
                , ''01'', ''CUR''
                , ''02'', ''CAN''
                , ''04'', ''CUR''
                , ''05'', ''13''
                , ''06'', ''CIE''
                , ''14'', ''CIE''
                , ''03'', ''CAN''
                , ''11'', ''13''
                , ''12'', ''13''
                , ''07'', ''13''
                , ''09'', ''FIN''
                , ''08'', ''REJ''
                , ''10'', ''FIN''
                ) NUEVO
                FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ
                LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST ON TBJ.DD_EST_ID = EST.DD_EST_ID AND EST.BORRADO = 0
                WHERE TBJ.BORRADO = 0 AND EST.FLAG_ACTIVO = 0) TRANSICION
                LEFT JOIN '||V_ESQUEMA||'.DD_EST_ESTADO_TRABAJO EST_FINAL ON TRANSICION.NUEVO = EST_FINAL.DD_EST_CODIGO AND EST_FINAL.BORRADO = 0
                WHERE TRANSICION.NUEVO IS NOT NULL
                ) AUX
                ON (TBJ.TBJ_ID = AUX.TBJ_ID)
                WHEN MATCHED THEN
                    UPDATE SET
                TBJ.DD_EST_ID = AUX.DD_EST_ID
                , TBJ.USUARIOMODIFICAR = '''||V_USUARIO||'''
                , TBJ.FECHAMODIFICAR = SYSDATE';
		
	EXECUTE IMMEDIATE V_MSQL;  
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ACTUALIZADOS '||SQL%ROWCOUNT||' ESTADOS EN ACT_TBJ_TRABAJO');
		
  COMMIT;

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
