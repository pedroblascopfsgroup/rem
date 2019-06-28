--/*
--##########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20190628
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.11
--## INCIDENCIA_LINK=REMVIP-4648
--## PRODUCTO=NO
--##
--## Finalidad: 
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_USUARIO VARCHAR2(100 CHAR) := 'REMVIP-4648';
      
BEGIN   
        
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRANDO RELACION TRABAJO GASTO');

 
    V_MSQL := 'update '||V_ESQUEMA||'.gpv_tbj set 
					borrado = 1 
				, 	USUARIOBORRAR = '''||V_USUARIO||''' 
				, 	fechaborrar = SYSDATE 
				where gpv_tbj_id = ( select gtb.gpv_tbj_id 
										from '||V_ESQUEMA||'.gpv_gastos_proveedor gpv
										inner join '||V_ESQUEMA||'.gpv_tbj gtb on gpv.gpv_id = gtb.gpv_id
										inner join '||V_ESQUEMA||'.act_tbj_trabajo tbj on gtb.tbj_id = tbj.tbj_id
										where gpv.gpv_num_gasto_haya = 10631467 and tbj.tbj_num_trabajo = 9000177822)';
                                 
	EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO ['|| SQL%ROWCOUNT ||'] BORRADO CORRECTAMENTE');
    
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

EXIT;
