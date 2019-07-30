--/*
--##########################################
--## AUTOR=Viorel Remus Ovidiu
--## FECHA_CREACION=20190724
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-4916
--## PRODUCTO=NO
--##
--## Finalidad: Modificar estados expedientes a 'Vendido'
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    --V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(27 CHAR) := 'ECO_EXPEDIENTE_COMERCIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-4916';

 BEGIN
 
  
  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
	  					   DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''08'') 
						 , USUARIOMODIFICAR = '''||V_USUARIO||'''
						 , FECHAMODIFICAR = SYSDATE
					   WHERE ECO_NUM_EXPEDIENTE IN (136721,
									171195,
									171182,
									171192,
									136666,
									171250,
									136655,
									136763,
									136697,
									136653,
									171269,
									171183,
									136703,
									171270,
									136778,
									171179,
									171244,
									136672,
									136738,
									171191,
									171263,
									171187,
									136734,
									136687,
									136739,
									171199,
									136652,
									171248,
									136727,
									171205,
									136725,
									171260,
									171268,
									136696,
									171208,
									136684,
									171255,
									136657,
									171236,
									171247,
									171190,
									116443,
									171202,
									171238,
									136779,
									136662,
									171251,
									171177,
									171240,
									136663,
									136786,
									171266,
									136675,
									136729,
									171180,
									136674,
									171239,
									171249,
									136780,
									171201,
									171185,
									136651,
									171198,
									136716,
									171206,
									116442,
									136706,
									136723,
									136667,
									136691,
									171232,
									171203,
									136771,
									171258,
									171253,
									171233,
									136764,
									171178,
									136670,
									136648,
									116445,
									136753,
									136783,
									136650,
									136761,
									171207,
									171230,
									171246,
									171229,
									136735,
									136744,
									171265,
									171243,
									171252,
									171225,
									136682,
									171262,
									136754,
									136781,
									136647,
									136665,
									136742,
									136755,
									171234,
									171204,
									171188,
									136777,
									171181,
									171259) 
  					';
  					
	DBMS_OUTPUT.put_line('[INFO] Se ha actualizado '||SQL%ROWCOUNT||' registro en la tabla '||V_TABLA);
 
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;

