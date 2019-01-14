--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180703
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1113
--## PRODUCTO=NO
--##
--## Finalidad: BORRAR TRABAJOS DUPLICADOS DE GASTOS
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
    V_TABLA VARCHAR2(25 CHAR):= 'GPV_TBJ';
    V_TABLA_2 VARCHAR2(25 CHAR):= 'GPV_GASTOS_PROVEEDOR';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-1113';
    NUM_GASTO NUMBER(16):= 9693215; --Numero de gasto
    GASTO_PROVEEDOR_ID NUMBER(16); 
    
 BEGIN

		EXECUTE IMMEDIATE 'SELECT GPV_ID FROM '||V_ESQUEMA||'.'||V_TABLA_2||' WHERE GPV_NUM_GASTO_HAYA = '||NUM_GASTO INTO GASTO_PROVEEDOR_ID;

		V_SQL := ' UPDATE '||V_ESQUEMA||'.'||V_TABLA||' TBJ1 SET 
		  USUARIOBORRAR = '''||V_USUARIO||''' 
		, FECHABORRAR   = SYSDATE 
		, BORRADO = 1  
		WHERE  EXISTS (
		SELECT 1 FROM '||V_ESQUEMA||'.'||V_TABLA||' TBJ2 WHERE TBJ_ID IN (
			SELECT TBJ_ID from '||V_ESQUEMA||'.'||V_TABLA||' WHERE GPV_ID = '||GASTO_PROVEEDOR_ID||' 
			AND TBJ_ID in (
			    SELECT TBJ_ID FROM (                 
			    SELECT GPV_TBJ_ID, GT.GPV_ID, TBJ_ID, GT.USUARIOCREAR, GT.FECHACREAR, ROW_NUMBER() OVER(PARTITION BY TBJ_ID ORDER BY GT.FECHACREAR) RN
			    FROM '||V_ESQUEMA||'.'||V_TABLA||' GT 
			    JOIN '||V_ESQUEMA||'.'||V_TABLA_2||' GPV ON GPV.GPV_ID = GT.GPV_ID 
			    WHERE GT.BORRADO = 0) 
			    WHERE RN > 1)
		) AND TBJ2.GPV_TBJ_ID = TBJ1.GPV_TBJ_ID AND GPV_ID <> '||GASTO_PROVEEDOR_ID||')';

 					
 		EXECUTE IMMEDIATE V_SQL;
    	
                DBMS_OUTPUT.PUT_LINE('[INFO] Se han borrado '||SQL%ROWCOUNT||' registros de la tabla '||V_TABLA||'');

      
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
