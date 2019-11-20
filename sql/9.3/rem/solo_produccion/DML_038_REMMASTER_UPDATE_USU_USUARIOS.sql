--/*
--###########################################
--## AUTOR=Adrián Molina
--## FECHA_CREACION=20190924
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-5304 
--## PRODUCTO=NO
--## 
--## Finalidad:
--##			
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--###########################################
----*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
  V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_ACT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_COUNT1 NUMBER(16);
  V_COUNT2 NUMBER(16);
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIOMODIFICAR VARCHAR2(100 CHAR) := 'REMVIP-5304';
  
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR USU_USUARIOS ' );


		V_MSQL := ' 
		UPDATE '||V_ESQUEMA_M||'.USU_USUARIOS SET USU_MAIL = ''notificaciones.rem@haya.es'', 
		USUARIOMODIFICAR = ''REMVIP-5289'', 
		FECHAMODIFICAR = SYSDATE 
		WHERE USU_MAIL IS NULL';

       EXECUTE IMMEDIATE V_MSQL;	

    DBMS_OUTPUT.PUT_LINE('[INFO] Actualizados '||SQL%ROWCOUNT||' registros en USU_USUARIOS');  


    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR USU_USUARIOS ' );

    COMMIT;
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
