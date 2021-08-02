--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20210716
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-9788
--## PRODUCTO=NO
--##
--## Finalidad: Script que pone un 2 en el motivo de exclusion
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
    V_USU VARCHAR2(25 CHAR):= 'REMVIP-10181';

    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_PAC_PERIMETRO_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    
BEGIN	

    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICAMOS '||V_TEXT_TABLA||' ');

    V_MSQL:= 'MERGE INTO '||V_ESQUEMA||'.'||V_TEXT_TABLA||' T1 USING (
                            SELECT PAC.PAC_ID FROM '||V_ESQUEMA||'.ACT_aCTIVO ACT
                            JOIN '||V_ESQUEMA||'.ACT_PAC_PERIMETRO_ACTIVO PAC ON PAC.ACt_ID=ACT.ACT_ID
                            WHERE PAC.PAC_EXCLUIR_VALIDACIONES IS NULL AND ACT.BORRADO = 0
                        ) T2
						ON (T1.PAC_ID = T2.PAC_ID)
						WHEN MATCHED THEN UPDATE SET
                        T1.PAC_EXCLUIR_VALIDACIONES = (SELECT DD_SIN_ID FROM '||V_ESQUEMA_M||'.DD_SIN_SINO WHERE DD_SIN_CODIGO=''02''),
						T1.USUARIOMODIFICAR = '''||V_USU||''',
                        T1.FECHAMODIFICAR = SYSDATE';
		EXECUTE IMMEDIATE V_MSQL;
    
    DBMS_OUTPUT.PUT_LINE('[INFO] MODIFICADOS  '|| SQL%ROWCOUNT ||' REGISTROS EN '||V_TEXT_TABLA||' ');
    
    DBMS_OUTPUT.PUT_LINE('[FIN] ');
    COMMIT;

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