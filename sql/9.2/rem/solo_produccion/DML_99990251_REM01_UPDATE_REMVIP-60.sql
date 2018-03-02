--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.15
--## INCIDENCIA_LINK='REMVIP-60'
--## PRODUCTO=NO
--##
--## Finalidad: Se modifica el gestor y supervisor de la tarea Posicionamiento y firma
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
   V_COUNT NUMBER(16); -- Vble. para contar.
   ERR_NUM NUMBER(25); -- Vble. auxiliar para registrar errores en el script.
   ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
   V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-60';

BEGIN

   DBMS_OUTPUT.PUT_LINE('[INICIO]');

   V_MSQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS
		SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''02'') 
		    , USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
		WHERE OFR_NUM_OFERTA = 70287698';
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' estado oferta actualizado');
   
   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL T1
		USING '||V_ESQUEMA||'.OFR_OFERTAS T2
		ON (T1.OFR_ID = T2.OFR_ID)
		WHEN MATCHED THEN UPDATE SET
		    T1.ECO_FECHA_VENTA = NULL, T1.DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''02'')
		    , T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE
		WHERE T2.OFR_NUM_OFERTA = 70287698';
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' estado expediente y fecha de venta actualizada');

   V_MSQL := 'UPDATE '||V_ESQUEMA||'.ACT_ACTIVO 
		SET DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''02'') 
		    , USUARIOMODIFICAR = '''||V_USUARIO||''', FECHAMODIFICAR = SYSDATE
		WHERE ACT_NUM_ACTIVO = 6080965';
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' disponibilidad para la venta del activo actualizada');
   
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
   WHEN OTHERS THEN
      ERR_NUM := SQLCODE;
      ERR_MSG := SQLERRM;
      DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
      DBMS_OUTPUT.PUT_LINE(ERR_MSG);
      ROLLBACK;
      RAISE;
END;
/
EXIT;