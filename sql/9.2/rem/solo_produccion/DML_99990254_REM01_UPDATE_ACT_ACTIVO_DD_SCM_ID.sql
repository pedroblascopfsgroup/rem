--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180305
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-???
--## PRODUCTO=NO
--##
--## Finalidad: Poner a no comercializables los activos del script, a petición de Luis
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
    V_TABLA VARCHAR2(25 CHAR):= 'ACT_ACTIVO';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-???';
 
 BEGIN

 V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
 			  DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''01'')
 			, USUARIOMODIFICAR = '''||V_USUARIO||'''
 			, FECHAMODIFICAR = SYSDATE
 			WHERE ACT_NUM_ACTIVO IN (5925504
				,5931659
				,5942226
				,5961146
				,5936095
				,5966314
				,5944658
				,5954081
				,5951889
				,5932381
				,5926867
				,5927027
				,5927423
				,5927585
				,5927709
				,5927851
				,5929790
				,5930618
				,5931110
				,5931447
				,5931472
				,5932787
				,5933053
				,5933612
				,5935691
				,5935710
				,5936678
				,5937193
				,5938111
				,5941209
				,5941662
				,5941887
				,5942463
				,5942820
				,5944079
				,5944138
				,5944522
				,5945405
				,5946103
				,5947024
				,5948852
				,5948861
				,5949558
				,5949916
				,5951208
				,5953043
				,5953552
				,5954140
				,5954498
				,5954907
				,5955345
				,5955430
				,5956354
				,5957060
				,5957264
				,5957857
				,5958168
				,5959027
				,5959173
				,5959499
				,5961749
				,5962055
				,5962925
				,5963640
				,5964272
				,5964539
				,5964564
				,5964762
				,5965479
				,5965641
				,5966360
				,5967198
				,5967566
				,5967624
				,5967900
				,5968079
				,5969033
				,5969340
				,5969947
				,5969999
				)';

 EXECUTE IMMEDIATE V_SQL;
 
 
 DBMS_OUTPUT.PUT_LINE('[INFO] Se han puesto como no comercializables '||SQL%ROWCOUNT||' activos');
 
 COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.PUT_LINE('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------'); 
          DBMS_OUTPUT.PUT_LINE(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
