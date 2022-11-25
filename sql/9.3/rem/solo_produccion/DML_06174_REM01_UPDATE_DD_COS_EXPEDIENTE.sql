--/*
--##########################################
--## AUTOR=Juan Bautista Alfonso
--## FECHA_CREACION=20221125
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-12774
--## PRODUCTO=NO
--##
--## Finalidad: Actualizar comites expedientes
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

  V_ESQUEMA VARCHAR2(30 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(30 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
  V_SQL VARCHAR2(32000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
  V_USU VARCHAR2(50 CHAR):= 'REMVIP-12774';

BEGIN

      
		      DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza la actualización en ECO_EXPEDIENTE_COMERCIAL');
		     
		      V_SQL := 'MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL T1 USING (
SELECT distinct eco_id FROM '||V_ESQUEMA||'.ofr_ofertas ofr 
join '||V_ESQUEMA||'.act_ofr aofr on aofr.ofr_id = ofr.ofr_id
join '||V_ESQUEMA||'.act_activo act on act.act_id = aofr.act_id and dd_scr_id = 543 and act.borrado = 0
join '||V_ESQUEMA||'.eco_expediente_comercial eco on eco.ofr_id = ofr.ofr_id and eco.borrado = 0
where dd_cos_id in (346,347) and ofr.borrado = 0

                            ) T2
                        ON (T1.ECO_ID = T2.ECO_ID)
                        WHEN MATCHED THEN UPDATE SET
                        T1.DD_COS_ID = (SELECT DD_COS_ID FROM '||V_ESQUEMA||'.DD_COS_COMITES_SANCION WHERE DD_COS_CODIGO = ''55'' AND BORRADO = 0),
                        T1.USUARIOMODIFICAR = '''||V_USU||''', 
                        T1.FECHAMODIFICAR = SYSDATE';
				    
		      EXECUTE IMMEDIATE V_SQL;
		      
		      DBMS_OUTPUT.PUT_LINE('[INFO] REGISTROS  '||SQL%ROWCOUNT||' ACTUALIZADOS CORRECTAMENTE');

      COMMIT;
      DBMS_OUTPUT.PUT_LINE('[FIN]');   
       
EXCEPTION
      WHEN OTHERS THEN
            DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
            DBMS_OUTPUT.put_line('-----------------------------------------------------------');
            DBMS_OUTPUT.put_line(SQLERRM);
            ROLLBACK;
            RAISE;
END;
/
EXIT;
