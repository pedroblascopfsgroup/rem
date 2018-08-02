--/*
--##########################################
--## AUTOR=VIOREL REMUS OVIDIU
--## FECHA_CREACION=20180731
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-1466
--## PRODUCTO=SI
--##
--## Finalidad: PASAR OFERTA A TRAMITADA, EXPEDIENTE EN DEVOLUCION Y LA RESERVA A PENDIENTE DE DEVOLUCION
--## VERSIONES:
--##        0.1 Version inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

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
    V_USUARIO VARCHAR2(50 CHAR):= 'REMVIP-1466';
    V_NUM_OFERTA NUMBER(16,0):= 90016313;
    V_NUM_EXPEDIENTE NUMBER(16,0):= 101994;
    V_NUM_RESERVA NUMBER(16,0):= 14346;
    V_COD_RESERVA VARCHAR2(20 CHAR):= '05';
    V_COD_OFERTA VARCHAR2(20 CHAR):= '01';
    V_COD_EXPEDIENTE VARCHAR2(20 CHAR):= '16';
        
BEGIN
	--ACTUALIZO ESTADO EXPEDIENTE
	V_SQL := 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL SET 
				 DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL  
						WHERE DD_EEC_CODIGO = '''||V_COD_EXPEDIENTE||''') 
				, ECO_FECHA_ANULACION = null 
				, USUARIOMODIFICAR  = '''||V_USUARIO||'''
				, FECHAMODIFICAR    = SYSDATE 
				WHERE ECO_NUM_EXPEDIENTE  = '||V_NUM_EXPEDIENTE||'
				';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' registro en ECO_EXPEDIENTE_COMERCIAL');


      --ACTUALIZO ESTADO OFERTA
      V_SQL := 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS
		SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = '''||V_COD_OFERTA||''') 
		, USUARIOMODIFICAR = '''||V_USUARIO||''' 
		, FECHAMODIFICAR = SYSDATE 
		WHERE OFR_NUM_OFERTA = '||V_NUM_OFERTA||'';

      EXECUTE IMMEDIATE V_SQL;
		
      DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' registro en OFR_OFERTAS');

      --ACTUALIZO ESTADO RESERVA	
      V_SQL := 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS SET
	      DD_ERE_ID = (SELECT DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = '''||V_COD_RESERVA||'''),
	      RES_IND_IMP_ANULACION = null, 
	      DD_EDE_ID = null,
	      DD_DER_ID = null, 
	      FECHAMODIFICAR = SYSDATE,
	      USUARIOMODIFICAR = '''||V_USUARIO||''' 
	      WHERE RES_NUM_RESERVA = '||V_NUM_RESERVA||' 
	      AND ECO_ID = (SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||')';

    EXECUTE IMMEDIATE V_SQL;
		
    DBMS_OUTPUT.PUT_LINE('Se han actualizado '||SQL%ROWCOUNT||' registro en RES_RESERVAS');

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
