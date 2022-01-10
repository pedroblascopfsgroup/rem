--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211213
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-16362
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar tasadoras titulizadas
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
    V_TEXT_TABLA VARCHAR2(50 CHAR) := 'ACT_TAS_TASACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(25 CHAR):= 'HREOS-16362'; -- Usuario modificar

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
                SELECT
                TAS.TAS_ID
                , TCX.DD_TCX_ID
                FROM '||V_ESQUEMA||'.ACT_TAS_TASACION TAS
                JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON TAS.ACT_ID = ACT.ACT_ID AND ACT.BORRADO = 0
                JOIN '||V_ESQUEMA||'.DD_CRA_CARTERA CRA ON CRA.DD_CRA_ID = ACT.DD_CRA_ID AND CRA.BORRADO = 0 AND CRA.DD_CRA_CODIGO = ''18''
                JOIN '||V_ESQUEMA||'.DD_TCX_TASADORA_CAIXA TCX ON TCX.DD_TCX_DESCRIPCION = TAS.TAS_NOMBRE_TASADOR
                WHERE TAS.BORRADO = 0
                ) T2 ON (T1.TAS_ID = T2.TAS_ID)
                WHEN MATCHED THEN UPDATE SET
                T1.DD_TCX_ID = T2.DD_TCX_ID
                , T1.USUARIOMODIFICAR = '''||V_USUARIO||'''
                , T1.FECHAMODIFICAR = SYSDATE';
  	
	EXECUTE IMMEDIATE V_MSQL; 

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS '|| SQL%ROWCOUNT ||' PARA AÑADIR EL CAMPO TASADORA PARA TITULIZADAS EN LA TABLA '||V_TEXT_TABLA);
	
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
