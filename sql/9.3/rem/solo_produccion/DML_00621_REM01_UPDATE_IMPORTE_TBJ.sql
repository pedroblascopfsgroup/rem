--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20210119
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=RREMVIP-8703
--## PRODUCTO=NO
--## 
--## Finalidad: Script que actualizar fecha alta ofertas
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_KOUNT NUMBER(16); -- Vble. para kontar.
    V_COUNT_UPDATE NUMBER(16):= 0; -- Vble. para contar updates
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    ACT_ID NUMBER(16);
    ACT_NUM_ACTIVO NUMBER(16);

    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-8703_1';    

    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
     DBMS_OUTPUT.PUT_LINE('[AJUSTAR IMPORTE PRESUPUESTO E IMPORTE TOTAL TRABAJOS] ');
    
    V_SQL := 'MERGE INTO REM01.ACT_TBJ_TRABAJO T1
		USING (
		    SELECT TBJ.TBJ_ID, TBJ.TBJ_IMPORTE_TOTAL, TBJ.TBJ_IMPORTE_PRESUPUESTO
		    FROM REM01.ACT_TBJ_TRABAJO TBJ
		    JOIN REM01.DD_EST_ESTADO_TRABAJO EST ON EST.DD_EST_ID = TBJ.DD_EST_ID
			AND EST.BORRADO = 0
		    WHERE TBJ.BORRADO = 0
			AND EST.DD_EST_CODIGO IN (''01'', ''04'', ''05'', ''09'', ''10'', ''11'', ''12'', ''13'', ''CUR'', ''SUB'', ''PCI'', ''CIE'')
		) T2
		ON (T1.TBJ_ID = T2.TBJ_ID)
		WHEN MATCHED THEN
		    UPDATE SET 
		    T1.TBJ_IMPORTE_PRESUPUESTO = DECODE(T2.TBJ_IMPORTE_TOTAL, NULL, DECODE(T2.TBJ_IMPORTE_PRESUPUESTO, NULL, 0, 0, 0, T2.TBJ_IMPORTE_PRESUPUESTO), 0, DECODE(T2.TBJ_IMPORTE_PRESUPUESTO, NULL, 0, 0, 0, T2.TBJ_IMPORTE_PRESUPUESTO), T2.TBJ_IMPORTE_TOTAL)
		  , T1.TBJ_IMPORTE_TOTAL = DECODE(T2.TBJ_IMPORTE_TOTAL, NULL, DECODE(T2.TBJ_IMPORTE_PRESUPUESTO, NULL, 0, 0, 0, T2.TBJ_IMPORTE_PRESUPUESTO), 0, DECODE(T2.TBJ_IMPORTE_PRESUPUESTO, NULL, 0, 0, 0, T2.TBJ_IMPORTE_PRESUPUESTO), T2.TBJ_IMPORTE_TOTAL)
		   ,T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
		   ,T1.FECHAMODIFICAR = SYSDATE';
		
	EXECUTE IMMEDIATE V_SQL;
		
	DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado correctamente '||SQL%ROWCOUNT||' registros');   
	
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
EXIT
