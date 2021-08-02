--/*
--##########################################
--## AUTOR=IVAN REPISO
--## FECHA_CREACION=20210518
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9749
--## PRODUCTO=NO
--##
--## Finalidad: Script que modifica ccc y cpp de gastos en tabla auxiliar
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
    V_USU VARCHAR2(25 CHAR):= 'REMVIP-9749';

    V_TEXT_TABLA_GLD VARCHAR2(2400 CHAR) := 'GLD_GASTOS_LINEA_DETALLE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_TABLA_AUX VARCHAR2(2400 CHAR) := 'AUX_REMVIP_9749'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS '||V_TEXT_TABLA_GLD||' ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA_GLD||' T1 USING (
						SELECT DISTINCT GLD_ID FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA_GLD||' GLD 
            JOIN REM01.GPV_GASTOS_PROVEEDOR GPV ON GPV.GPV_ID = GLD.GPV_ID AND GPV.BORRADO = 0
            JOIN REM01.'||V_TEXT_TABLA_AUX||' AUX ON AUX.NUM_GASTO_HAYA = GPV.GPV_NUM_GASTO_HAYA) T2
						ON (T1.GLD_ID = T2.GLD_ID)
						WHEN MATCHED THEN UPDATE SET
            T1.GLD_CPP_BASE = ''PP051'', T1.GLD_CCC_BASE = ''6310000001'',
						T1.USUARIOMODIFICAR = '''||V_USU||''',T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA_GLD||' ');
    
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
