--/*
--##########################################
--## AUTOR=PIER GOTTA
--## FECHA_CREACION=20181029
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2396
--## PRODUCTO=NO
--##
--## Finalidad: Carga masiva de fecha y precio cartera INVICTUS.
--##
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := ''; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_USU VARCHAR2(2400 CHAR) := 'REMVIP-2396_2';

    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	
	EXECUTE IMMEDIATE 
    'MERGE INTO REM01.ACT_ACTIVO        ACT
	USING (
		SELECT DISTINCT ACT_NUM, FECHA_VENTA, PRECIO_VENTA
		FROM REM01.AUX_REMVIP_2396_2 AUX
		JOIN REM01.ACT_ACTIVO ACT
		ON AUX.ACT_NUM = ACT.ACT_NUM_ACTIVO
	) T2
	ON (T2.ACT_NUM = ACT.ACT_NUM_ACTIVO)
	WHEN MATCHED THEN UPDATE SET
	ACT.ACT_VENTA_EXTERNA_FECHA = TO_DATE(T2.FECHA_VENTA,''dd/mm/yyyy''),
	ACT.ACT_VENTA_EXTERNA_IMPORTE = TO_NUMBER(REPLACE(T2.PRECIO_VENTA,''.'','''')),
	ACT.USUARIOMODIFICAR = ''REMVIP-2396_2'',
	ACT.FECHAMODIFICAR = SYSDATE
        WHERE ACT.DD_CRA_ID = (SELECT CRA.DD_CRA_ID FROM REM01.DD_CRA_CARTERA CRA WHERE CRA.DD_CRA_CODIGO = ''08'')
    ';   
    DBMS_OUTPUT.PUT_LINE('[INFO]: Updateamos '||SQL%ROWCOUNT||' registros.');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: TABLAS ACTUALIZADA CORRECTAMENTE ');


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
