--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180305
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-208
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
    V_TABLA VARCHAR2(25 CHAR):= 'OFR_OFERTAS';
    --V_COUNT NUMBER(16); -- Vble. para contar.
    --V_COUNT_INSERT NUMBER(16):= 0; -- Vble. para contar inserts
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-208';
 
 BEGIN

 V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
 			  DD_EOF_ID = (SELECT DD_EOF_ID FROM DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''03'')
 			, USUARIOMODIFICAR = '''||V_USUARIO||'''
 			, FECHAMODIFICAR = SYSDATE
 			WHERE OFR_NUM_OFERTA = 90032379';

 EXECUTE IMMEDIATE V_SQL;
 
 DBMS_OUTPUT.PUT_LINE('[INFO] Se ha congelado la oferta 90032379');
 
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
