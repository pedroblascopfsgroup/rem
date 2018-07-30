--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180729
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1453
--## PRODUCTO=NO
--##
--## Finalidad: Insercion act_id en ACT_TIT_TITULO, ACT_SPS_SIT_POSESORIA y actualizar cartera a activos que no la tienen
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
    V_NUM_REGISTRO NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_ID NUMBER(16);
    V_SEQ_GEH NUMBER(16);
    V_TIPO_ID NUMBER(16); --Vle para el id ACT_ID
    V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-1453';
    
BEGIN	
	
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
   		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_TIT_TITULO (TIT_ID, ACT_ID, USUARIOCREAR, FECHACREAR)  
				SELECT '||V_ESQUEMA||'.S_ACT_TIT_TITULO.NEXTVAL, ACT.ACT_ID, '''||V_USUARIO||''', SYSDATE 
				FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
				LEFT JOIN '||V_ESQUEMA||'.ACT_TIT_TITULO TIT ON TIT.ACT_ID = ACT.ACT_ID WHERE TIT.TIT_ID IS NULL';
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_TIT_TITULO');



		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA (SPS_ID, ACT_ID, USUARIOCREAR, FECHACREAR) 
				SELECT '||V_ESQUEMA||'.S_ACT_SPS_SIT_POSESORIA.NEXTVAL, ACT.ACT_ID, '''||V_USUARIO||''', SYSDATE 
				FROM '||V_ESQUEMA||'.ACT_ACTIVO ACT 
				LEFT JOIN '||V_ESQUEMA||'.ACT_SPS_SIT_POSESORIA SPS ON SPS.ACT_ID = ACT.ACT_ID WHERE SPS.SPS_ID IS NULL';
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] Se han insertado '||SQL%ROWCOUNT||' registros en la ACT_SPS_SIT_POSESORIA');



		V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO ACT SET 
			   DD_CRA_ID = 2, 
  		           USUARIOMODIFICAR = '''||V_USUARIO||''', 
             		   FECHAMODIFICAR = SYSDATE 
			   WHERE ACT_ID IN (SELECT ACT_ID FROM '||V_ESQUEMA||'.ACT_ACTIVO WHERE DD_CRA_ID IS NULL AND DD_SCR_ID = 3)';
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] Se ha actualizado la cartera de  '||SQL%ROWCOUNT||' activos');


	DBMS_OUTPUT.PUT_LINE('[FIN]');

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
