--/*
--#########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20191106
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5674
--## PRODUCTO=NO
--## 
--## Finalidad: cuadrar importes de trabajos
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;
alter session set NLS_NUMERIC_CHARACTERS = '.,';

DECLARE
	
    err_num NUMBER; -- Numero de error.
    err_msg VARCHAR2(2048); -- Mensaje de error.
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#';-- '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#';-- '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_USUARIOMODIFICAR VARCHAR(100 CHAR):= 'REMVIP-5674';
    V_SQL VARCHAR2(4000 CHAR);
    V_NUM_TABLAS NUMBER;
    V_COUNT NUMBER(16):= 0; -- Vble. para contar updates
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO]');

	DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR IMPORTE TARIFAS');

	V_SQL :='MERGE INTO REM01.ACT_TCT_TRABAJO_CFGTARIFA T1 USING (
		    SELECT tbj.tbj_id,TBJ_NUM_TRABAJO, 
		    SUM(TCT_MEDICION * TCT_PRECIO_UNITARIO) AS IMPORTE_CORRECTO,
		    TBJ.TBJ_IMPORTE_TOTAL AS IMPORTE_ACTUAL, 
		    CFG.CFT_ID, 
		    CFG.TCT_ID,
		    CFG.TCT_MEDICION, 
		    CFG.TCT_PRECIO_UNITARIO as IMPORTE_TARIFA_INCORRECTO, 
		    CFT.CFT_PRECIO_UNITARIO as IMPORTE_TARIFA_CORRECTO
		    FROM '||V_ESQUEMA||'.ACT_TCT_TRABAJO_CFGTARIFA CFG 
		    JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON CFG.TBJ_ID = TBJ.TBJ_ID 
		    JOIN '||V_ESQUEMA||'.ACT_CFT_CONFIG_TARIFA cft on cfg.cft_id = CFT.CFT_ID
		    WHERE CFG.BORRADO = 0 
		    AND TBJ.TBJ_NUM_TRABAJO IN (9000060406,
		    9000060473,
		    169191,
		    9000072351,
		    9000050036) 
		    GROUP BY TBJ_NUM_TRABAJO, TBJ.TBJ_IMPORTE_TOTAL, TBJ.USUARIOCREAR, CFG.TCT_MEDICION, CFG.TCT_PRECIO_UNITARIO, CFG.CFT_ID, tbj.tbj_id, CFG.TCT_PRECIO_UNITARIO, CFT.CFT_PRECIO_UNITARIO, CFG.TCT_ID
		    ORDER BY TBJ_NUM_TRABAJO ASC)   T2
		ON (T1.TCT_ID=T2.TCT_ID)
		WHEN MATCHED THEN UPDATE SET 
		T1.TCT_PRECIO_UNITARIO = T2.IMPORTE_TARIFA_CORRECTO
		,   T1.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
		,   T1.FECHAMODIFICAR = SYSDATE '; 	
                	

      EXECUTE IMMEDIATE V_SQL;
    
      DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado  '||SQL%ROWCOUNT||' registros EN ACT_TCT_TRABAJO_CFGTARIFA .');


    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR IMPORTE TOTAL TRABAJOS');

	V_SQL :='MERGE INTO REM01.ACT_TBJ_TRABAJO T1 USING (
			 SELECT TBJ_NUM_TRABAJO, IMPORTE_CORRECTO, IMPORTE_ACTUAL FROM 
		            (SELECT TBJ_NUM_TRABAJO, SUM(TCT_MEDICION * TCT_PRECIO_UNITARIO) AS IMPORTE_CORRECTO,TBJ.TBJ_IMPORTE_TOTAL AS IMPORTE_ACTUAL
		            FROM '||V_ESQUEMA||'.ACT_TCT_TRABAJO_CFGTARIFA CFG 
		            JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON CFG.TBJ_ID = TBJ.TBJ_ID 
		            WHERE CFG.BORRADO = 0 
			    AND TBJ.TBJ_NUM_TRABAJO IN (9000060406,
			    9000060473,
			    169191,
			    9000072351,
			    9000050036)
		            GROUP BY TBJ_NUM_TRABAJO, TBJ.TBJ_IMPORTE_TOTAL, TBJ.USUARIOCREAR
		            ORDER BY TBJ_NUM_TRABAJO ASC) 
		        WHERE IMPORTE_CORRECTO <> IMPORTE_ACTUAL 
		)T2
		ON (T1.TBJ_NUM_TRABAJO=T2.TBJ_NUM_TRABAJO)
		WHEN MATCHED THEN UPDATE SET 
		T1.TBJ_IMPORTE_TOTAL = T2.IMPORTE_CORRECTO
		,   T1.USUARIOMODIFICAR = '''||V_USUARIOMODIFICAR||'''
		,   T1.FECHAMODIFICAR = SYSDATE '; 	
                	

      EXECUTE IMMEDIATE V_SQL;
    
      DBMS_OUTPUT.PUT_LINE('[INFO] Se han actualizado  '||SQL%ROWCOUNT||' registros EN ACT_TBJ_TRABAJO .');

     COMMIT;

     DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
EXIT
