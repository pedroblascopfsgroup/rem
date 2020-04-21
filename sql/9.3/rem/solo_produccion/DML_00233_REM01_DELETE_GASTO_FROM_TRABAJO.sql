--/*
--##########################################
--## AUTOR=José Antonio Gigante Pamplona
--## FECHA_CREACION=20200401
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-6808
--## PRODUCTO=NO
--## Finalidad: Elimina gestor e histórico del mismo vinculado a un activo.
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;
DECLARE

    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_MSQL VARCHAR2(4000 CHAR);
    V_USUARIO VARCHAR2(20 CHAR) := 'REMVIP-6808';
    V_TABLA VARCHAR2(50 CHAR) := 'GPV_TBJ';
    V_NUM_GASTO VARCHAR(30 CHAR) := '11201566';
    V_NUM_TRABAJO VARCHAR2(30 CHAR) := '9000278780';
    ERR_NUM NUMBER; -- Numero de errores
    ERR_MSG VARCHAR2(2048); -- Mensaje de error

BEGIN	
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.GAC_GESTOR_ADD_ACTIVO... ELIMINANDO datos de la tabla');
    --- Borrando gestor
    V_MSQL := 'DELETE FROM '||V_ESQUEMA||'.'||V_TABLA||' T1
            WHERE EXISTS
            (
                SELECT GPV_TBJ_ID
                FROM '||V_ESQUEMA||'.'||V_TABLA||' GT
                JOIN '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ ON TBJ.TBJ_ID = GT.TBJ_ID
                JOIN '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GT.GPV_ID
                WHERE GPV.GPV_NUM_GASTO_HAYA = '||V_NUM_GASTO||'
                AND TBJ.TBJ_NUM_TRABAJO = '||V_NUM_TRABAJO||'
                AND T1.GPV_TBJ_ID = GT.GPV_TBJ_ID
            )';
    EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] '||sql%rowcount||' registros eliminados de '||V_ESQUEMA_M||'.GAC_GESTOR_ADD_ACTIVO');
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
