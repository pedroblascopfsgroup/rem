--/*
--##########################################
--## AUTOR=Luis Caballero
--## FECHA_CREACION=20180305
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.15
--## INCIDENCIA_LINK='REMVIP-207'
--## PRODUCTO=NO
--##
--## Finalidad: Modificar el estado de las ofertas que esten tramitadas pero no tengan expediente
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
   V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-207';

BEGIN

   DBMS_OUTPUT.PUT_LINE('[INICIO]');

   V_MSQL := 'MERGE INTO '||V_ESQUEMA||'.OFR_OFERTAS T1
		USING (SELECT DISTINCT OFR.OFR_ID
		    FROM '||V_ESQUEMA||'.OFR_OFERTAS OFR
		    JOIN '||V_ESQUEMA||'.ACT_OFR actofr on ofr.OFR_ID = actofr.OFR_ID
		    JOIN '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA eof on ofr.DD_EOF_ID = eof.DD_EOF_ID
		    LEFT JOIN '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL eco on ofr.OFR_ID = eco.OFR_ID
		    WHERE eof.DD_EOF_CODIGO = ''01'' AND eco.ECO_ID is null
		        ) T2
		ON (T1.OFR_ID = T2.OFR_ID)
		WHEN MATCHED THEN UPDATE SET
		    T1.DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''04'')
		    , T1.USUARIOMODIFICAR = '''||V_USUARIO||''', T1.FECHAMODIFICAR = SYSDATE';
		    
   EXECUTE IMMEDIATE V_MSQL;
   DBMS_OUTPUT.PUT_LINE('  [INFO] '||SQL%ROWCOUNT||' estado expediente actualizada');


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