--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210625
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9828
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USU VARCHAR2(25 CHAR):= 'REMVIP-9828';

BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS ACT_TBJ_TRABAJO ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1 USING (
						SELECT TBJ.TBJ_ID, AUX.FECHA FROM '||V_ESQUEMA||'.AUX_REMVIP_9828 AUX 
            JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON AUX.TBJ_NUM_TRABAJO = TBJ.TBJ_NUM_TRABAJO
            WHERE AUX.FLAG = 1) T2
						ON (T1.TBJ_ID = T2.TBJ_ID)
						WHEN MATCHED THEN UPDATE SET
              T1.TBJ_FECHA_TOPE = T2.FECHA, 
						  T1.USUARIOMODIFICAR = '''||V_USU||''',
              T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN ACT_TBJ_TRABAJO PARA TBJ_FECHA_TOPE');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.ACT_TBJ_TRABAJO T1 USING (
						SELECT TBJ.TBJ_ID, AUX.FECHA FROM '||V_ESQUEMA||'.AUX_REMVIP_9828 AUX 
            JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON AUX.TBJ_NUM_TRABAJO = TBJ.TBJ_NUM_TRABAJO
            WHERE AUX.FLAG = 2) T2
						ON (T1.TBJ_ID = T2.TBJ_ID)
						WHEN MATCHED THEN UPDATE SET
              T1.TBJ_FECHA_FIN_COMPROMISO = T2.FECHA, 
						  T1.USUARIOMODIFICAR = '''||V_USU||''',
              T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN ACT_TBJ_TRABAJO PARA TBJ_FECHA_FIN_COMPROMISO');

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