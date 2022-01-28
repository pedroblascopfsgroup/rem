--/*
--##########################################
--## AUTOR=Cristian Montoya
--## FECHA_CREACION=20220126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11081
--## PRODUCTO=NO
--##
--## Finalidad: AVolcada la ECO_FECHA_FIRMA_CONT en la ECO_FECHA_VENTA
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'REMVIP-11081'; -- Usuario modificar

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
	                SELECT
	                ECO.ECO_ID
	                , ECO.ECO_FECHA_FIRMA_CONT
	                FROM '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ECO
	                WHERE ECO.ECO_FECHA_VENTA IS NULL
					AND ECO.ECO_FECHA_FIRMA_CONT IS NOT NULL
            	) T2 ON (T1.ECO_ID = T2.ECO_ID)
                WHEN MATCHED THEN UPDATE SET
	                T1.ECO_FECHA_VENTA = T2.ECO_FECHA_FIRMA_CONT
	                , T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
	                , T1.FECHAMODIFICAR = SYSDATE';
  	
	EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] VOLCADAS '|| SQL%ROWCOUNT ||' FECHAS DE VENTA EN LA TABLA '||V_TEXT_TABLA);
	
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
