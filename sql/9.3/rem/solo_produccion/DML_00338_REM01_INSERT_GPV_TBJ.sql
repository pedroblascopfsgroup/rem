--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20200615
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-7389
--## PRODUCTO=NO
--##
--## Finalidad: borrado relacion trabajo-gasto de gasto incompleto
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
    --V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'GPV_TBJ'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-7389';
    V_EXISTE_GASTO NUMBER(25);  
    V_COUNT_1 NUMBER(16); -- Vble. para kontar.
    V_COUNT_2 NUMBER(16); -- Vble. para kontar.

 BEGIN

	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA  = 11115840' INTO V_COUNT_1;
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO  = 916964300204' INTO V_COUNT_2;

	IF V_COUNT_1 > 0 AND V_COUNT_2 > 0 
		THEN

	V_SQL := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		GPV_TBJ_ID,
		GPV_ID,
    		TBJ_ID,
		VERSION
		)
		VALUES
		(
		'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,            		 		
		(SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA  = 11115840),											
    		(SELECT TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO  = 916964300204),
		0)'; 

	EXECUTE IMMEDIATE V_SQL ;
		
	DBMS_OUTPUT.put_line('[INFO] Se ha insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);

	ELSE

		DBMS_OUTPUT.put_line('[INFO] NO EXISTE REGISTRO');

	END IF;

	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA  = 12011002' INTO V_COUNT_1;
	EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO  = 9000302069' INTO V_COUNT_2;

	IF V_COUNT_1 > 0 AND V_COUNT_2 > 0 
		THEN

	
	V_SQL := '
        INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
		GPV_TBJ_ID,
		GPV_ID,
    		TBJ_ID,
		VERSION
		)
		VALUES
		(
		'||V_ESQUEMA||'.S_'||V_TABLA||'.NEXTVAL,            		 		
		(SELECT GPV_ID FROM '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR WHERE GPV_NUM_GASTO_HAYA  = 12011002),												
    		(SELECT TBJ_ID FROM '||V_ESQUEMA||'.ACT_TBJ_TRABAJO WHERE TBJ_NUM_TRABAJO  = 9000302069),
		0)'; 

	EXECUTE IMMEDIATE V_SQL ;
		
	DBMS_OUTPUT.put_line('[INFO] Se ha insertado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);

	ELSE

		DBMS_OUTPUT.put_line('[INFO] NO EXISTE REGISTRO');

	END IF;

 
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

