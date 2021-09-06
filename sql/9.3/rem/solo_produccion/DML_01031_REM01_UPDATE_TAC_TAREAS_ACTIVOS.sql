--/*
--##########################################
--## AUTOR=Carlos Santos Vílchez
--## FECHA_CREACION=20210906
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10402
--## PRODUCTO=NO
--##
--## Finalidad: Script que cambia el usuario de las tareas activas
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Ver1ón inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIO VARCHAR2(50 CHAR) := 'REMVIP-10402'; -- USUARIO CREAR/MODIFICAR
    V_USUARIO_ORIGEN VARCHAR2(50 CHAR) := 'lgl';
    V_USUARIO_DESTINO VARCHAR2(50 CHAR) := 'ext.lgarrido';
    
BEGIN	
	
	DBMS_OUTPUT.PUT_LINE('[INICIO] ');
    
    DBMS_OUTPUT.PUT_LINE('[INFO]: REASIGNACIÓN DE TAREAS DE USUARIO ''lgl'' A USUARIO ''ext.lgarrido''');  

    V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS T1
                USING (SELECT DISTINCT TAC.TAR_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
                        INNER JOIN '||V_ESQUEMA||'.OFR_OFERTAS OFR on ECO.OFR_ID = OFR.OFR_ID AND OFR.BORRADO=0
                        INNER JOIN '||V_ESQUEMA||'.ACT_OFR AOFR ON OFR.OFR_ID = AOFR.OFR_ID
                        INNER JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON AOFR.ACT_ID = ACT.ACT_ID AND ACT.BORRADO=0
                        INNER JOIN '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC ON TAC.ACT_ID=ACT.ACT_ID AND TAC.BORRADO=0
                        INNER JOIN '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR ON TAR.TAR_ID=TAC.TAR_ID AND TAR.BORRADO=0
                        WHERE TAR.TAR_TAREA_FINALIZADA = 0 AND TAC.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USUARIO_ORIGEN||''')) T2 
                ON (T1.TAR_ID = T2.TAR_ID)
                WHEN MATCHED THEN UPDATE SET 
                T1.USU_ID = (SELECT USU_ID FROM '||V_ESQUEMA_M||'.USU_USUARIOS WHERE USU_USERNAME = '''||V_USUARIO_DESTINO||'''), 
                T1.USUARIOMODIFICAR = '''||V_USUARIO||''', 
                T1.FECHAMODIFICAR = SYSDATE';

    EXECUTE IMMEDIATE V_MSQL;

    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTROS ACTUALIZADOS EN TAC: ' ||sql%rowcount);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('[INFO]: FIN');
   

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
