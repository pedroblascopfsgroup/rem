--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180221
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-110
--## PRODUCTO=NO
--##
--## Finalidad: Anular el expediente de reserva, la oferta y la devolucion
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
    --V_TABLA VARCHAR2(27 CHAR) := 'ACT_GES_DIST_GESTORES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-110';
    
 BEGIN

  V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS SET
  			  DD_DER_ID = (SELECT DD_DER_ID FROM '||V_ESQUEMA||'.DD_DER_DEVOLUCION_RESERVA WHERE DD_DER_CODIGO = ''03'')
  			, DD_EDE_ID = NULL
  			, USUARIOMODIFICAR = '''||V_USUARIO||'''
  			, FECHAMODIFICAR = SYSDATE
  			WHERE ECO_ID = (SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = ''72328'')
		   ';
  
    DBMS_OUTPUT.put_line('[INFO] Se ha anulado la devolución de la reserva del expediente 72328');
  
  EXECUTE IMMEDIATE V_SQL;
  
  V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET
  			DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''02'')
  			, USUARIOMODIFICAR = '''||V_USUARIO||'''
  			, FECHAMODIFICAR = SYSDATE
  			WHERE ECO_NUM_EXPEDIENTE = ''72328''
  		   ';
    DBMS_OUTPUT.put_line('[INFO] Se ha anulado el expediente comercial 72328');
  
  EXECUTE IMMEDIATE V_SQL;
  
  V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET
  			DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''02'')
  			, USUARIOMODIFICAR = '''||V_USUARIO||'''
  			, FECHAMODIFICAR = SYSDATE
  			WHERE OFR_NUM_OFERTA = ''65826604''
  		   ';
  		   
  EXECUTE IMMEDIATE V_SQL;
  
  DBMS_OUTPUT.put_line('[INFO] Se ha anulado la oferta 65826604');
  
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

