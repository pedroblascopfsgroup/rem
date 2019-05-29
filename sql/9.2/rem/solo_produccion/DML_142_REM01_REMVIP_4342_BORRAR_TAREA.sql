--/*
--##########################################
--## AUTOR=Oscar Diestre
--## FECHA_CREACION=20190529
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4342
--## PRODUCTO=NO
--##
--## Finalidad: Borrar Tarea y cambiar estado al expediente
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
	
           
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO] ');

	
    DBMS_OUTPUT.PUT_LINE('[INFO]: BORRADO DE TAR_TAREA_NOTIFICACION ] ');
         

    V_MSQL := ' MERGE INTO '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES T1
                        USING (

				SELECT TAC.TAR_ID
				FROM '||V_ESQUEMA||'.ACT_TRA_TRAMITE TRA, 
				     '||V_ESQUEMA||'.ACT_ACTIVO ACT,
				     '||V_ESQUEMA||'.TAC_TAREAS_ACTIVOS TAC,
				     '||V_ESQUEMA||'.TEX_TAREA_EXTERNA TEX,
				     '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO TAP,
				     '||V_ESQUEMA||'.TAR_TAREAS_NOTIFICACIONES TAR
				WHERE TRA.TRA_ID = 316726
				AND ACT.ACT_ID = TRA.ACT_ID
				AND TAC.TRA_ID = TRA.TRA_ID
				AND TAC.ACT_ID = ACT.ACT_ID
				AND TAP.TAP_ID = TEX.TAP_ID
				AND TAR.TAR_ID = TAC.TAR_ID
				AND TEX.TAR_ID = TAR.TAR_ID

				AND TAP_CODIGO = ''T013_ResolucionTanteo''

				AND EXISTS ( SELECT 1
				             FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR,
				                  '||V_ESQUEMA||'.ACT_OFR ACT_OFR,
				                  '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO,
				                  '||V_ESQUEMA||'.ACT_TBJ_TRABAJO TBJ,
				                  '||V_ESQUEMA||'.ACT_TBJ ACT_TBJ
				             WHERE 1 = 1
				             AND OFR.OFR_ID = ACT_OFR.OFR_ID
				             AND ACT_OFR.ACT_ID = ACT.ACT_ID
				             AND ECO.OFR_ID = OFR.OFR_ID
				             AND ACT_TBJ.ACT_ID = ACT.ACT_ID
				             AND ACT_TBJ.TBJ_ID = TBJ.TBJ_ID
				             AND TRA.TBJ_ID = TBJ.TBJ_ID
				             AND ECO.ECO_NUM_EXPEDIENTE = ''164035''
				            ) 
                        
                            ) T2
                        ON (T1.TAR_ID = T2.TAR_ID)
                        WHEN MATCHED THEN UPDATE SET
                            T1.BORRADO 	     = 1
                          , T1.USUARIOBORRAR = ''REMVIP-4342''
                          , T1.FECHABORRAR   = SYSDATE';
                       
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('ACTUALIZADOS '||sql%rowcount||' TAR_TAREA_NOTIFICACION ');


    DBMS_OUTPUT.PUT_LINE('[INFO]: UPDATE EN ECO_EXPEDIENTE_COMERCIAL ] ');
         

    V_MSQL := ' UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL
		SET DD_EEC_ID = ( SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''11'' ),
		    USUARIOMODIFICAR = ''REMVIP-4342'',
		    FECHAMODIFICAR = SYSDATE
		WHERE ECO_NUM_EXPEDIENTE = ''164035'' 
	 ';



	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('ACTUALIZADOS '||sql%rowcount||' REGISTRO/S EN ECO_EXPEDIENTE_COMERCIAL ');
          
    	COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN]: ACTUALIZACIÓN REALIZADA ');   

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


