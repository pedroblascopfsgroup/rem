--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180302
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-199
--## PRODUCTO=NO
--##
--## Finalidad: Retroceder activo vendido
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
	V_USUARIO VARCHAR2(32 CHAR):= 'REMVIP-199';
    
    ACT_NUM_ACTIVO NUMBER(16):= 188223;
    
 BEGIN
 
 		V_SQL := 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
 					  DD_SCM_ID = (SELECT DD_SCM_ID FROM '||V_ESQUEMA||'.DD_SCM_SITUACION_COMERCIAL WHERE DD_SCM_CODIGO = ''02'')
 					, USUARIOMODIFICAR = '''||V_USUARIO||'''
 					, FECHAMODIFICAR   = SYSDATE
 					WHERE ACT_NUM_ACTIVO = '||ACT_NUM_ACTIVO||'
 					';

 		EXECUTE IMMEDIATE V_SQL;
		
		V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET
 					  DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''02'')
 					, ECO_FECHA_VENTA   = NULL
 					, USUARIOMODIFICAR  = '''||V_USUARIO||'''
 					, FECHAMODIFICAR    = SYSDATE
 					WHERE OFR_ID = (SELECT OFR_ID FROM '||V_ESQUEMA||'.OFR_OFERTAS
 					WHERE OFR_NUM_OFERTA = 68665008
 					)
 					';

 		EXECUTE IMMEDIATE V_SQL;
 		
 		
 		V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS SET
 					  OFR_IMPORTE_APROBADO = NULL
 					, OFR_IMPORTE 		   = NULL
 					, DD_EOF_ID 		   = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''02'')
 					, USUARIOMODIFICAR     = '''||V_USUARIO||'''
 					, FECHAMODIFICAR       = SYSDATE
 					WHERE OFR_NUM_OFERTA   = 68665008
 					';
 					
 		EXECUTE IMMEDIATE V_SQL;
		

        DBMS_OUTPUT.PUT_LINE('[INFO] 1.- Que el activo 188223 se ponga como Disponible para la venta y que se quite el importe y fecha de venta del mismo

								2.- Que se anule la oferta 68665008 sobre el activo anterior

								');
      
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
