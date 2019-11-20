--/*
--###########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190812
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-5063
--## PRODUCTO=NO
--## 
--## Finalidad: ACTUALIZAR TAR_TAREAS_NOTIFICACIONES
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
  V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquemas
  V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_ACT NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  V_COUNT1 NUMBER(16);
  V_COUNT2 NUMBER(16);
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USUARIOMODIFICAR VARCHAR2(100 CHAR) := 'REMVIP-5063';
  
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');
	 
    DBMS_OUTPUT.PUT_LINE('[INFO]: ACTUALIZAR ACT_ACTIVO.DD_CAP_ID ' );

            
                V_MSQL := ' 							
			MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
       			 USING (

				SELECT AUX.TAREA_ID 
				FROM '||V_ESQUEMA||'.AUX_REMVIP_5063 AUX 

       				) T2 
		        ON (T1.TAR_ID = T2.TAREA_ID)
			WHEN MATCHED THEN UPDATE SET
		 	T1.TAR_FECHA_FIN = SYSDATE, 
			T1.TAR_TAREA_FINALIZADA = 1, 
			T1.BORRADO = 1,
			T1.USUARIOBORRAR = '''||V_USUARIOMODIFICAR|| ''', 
			T1.FECHABORRAR = SYSDATE
		';

	DBMS_OUTPUT.PUT_LINE( V_MSQL );

	EXECUTE IMMEDIATE V_MSQL;

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
EXIT;
