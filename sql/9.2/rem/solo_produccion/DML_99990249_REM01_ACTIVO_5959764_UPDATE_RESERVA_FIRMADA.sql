--/*
--##########################################
--## AUTOR=GUSTAVO MORA
--## FECHA_CREACION=20180301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-190
--## PRODUCTO=NO
--##
--## Finalidad: Script que cambia la situacion del expediente comercial del activo 5959764 y oferta 73188176
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/


WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01';--'#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER';--'#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIOMOD VARCHAR2(50 CHAR):= 'REMVIP-190';

    V_ERE VARCHAR2(50 CHAR);
    V_EEC VARCHAR2(50 CHAR);
    
    V_NUM_EXPEDIENTE NUMBER(16);
    
BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]: Se va a actualizar el expediente comercial del activo 5927475 a Reservado con Firma');
  
  EXECUTE IMMEDIATE 'SELECT ECO.ECO_NUM_EXPEDIENTE FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
        JOIN '||V_ESQUEMA||'.ACT_OFR OFR ON ECO.OFR_ID = OFR.OFR_ID
        JOIN '||V_ESQUEMA||'.ACT_ACTIVO ACT ON OFR.ACT_ID = ACT.ACT_ID
        JOIN '||V_ESQUEMA||'.ofr_ofertas ofrs on ofr.ofr_id = ofrs.ofr_id        
        WHERE ACT.ACT_NUM_ACTIVO = 5959764
          and ofrs.ofr_num_oferta = 73188176' INTO V_NUM_EXPEDIENTE;
          
  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.OFR_OFERTAS
    SET DD_EOF_ID = (SELECT DD_EOF_ID FROM '||V_ESQUEMA||'.DD_EOF_ESTADOS_OFERTA WHERE DD_EOF_CODIGO = ''01''),
      USUARIOMODIFICAR = '''||V_USUARIOMOD||''', FECHAMODIFICAR = SYSDATE
    WHERE ofr_num_oferta = 73188176';          

  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL 
    SET DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''06''),
      USUARIOMODIFICAR = '''||V_USUARIOMOD||''', FECHAMODIFICAR = SYSDATE
      , eco_fecha_anulacion = null
      , DD_MAN_ID = null
      , ECO_FECHA_DEV_ENTREGAS = null
    WHERE ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.RES_RESERVAS
    SET DD_ERE_ID = (SELECT DD_ERE_ID FROM '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA WHERE DD_ERE_CODIGO = ''05''),
        DD_EDE_ID = (SELECT DD_EDE_ID FROM '||V_ESQUEMA||'.DD_EDE_ESTADOS_DEVOLUCION WHERE DD_EDE_CODIGO = ''04''),
        USUARIOMODIFICAR = '''||V_USUARIOMOD||''', FECHAMODIFICAR = SYSDATE
    WHERE ECO_ID = (SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL WHERE ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||')';


  EXECUTE IMMEDIATE 'SELECT ERE.DD_ERE_DESCRIPCION, EEC.DD_EEC_DESCRIPCION
    FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
    JOIN '||V_ESQUEMA||'.RES_RESERVAS RES ON ECO.ECO_ID = RES.ECO_ID
    JOIN '||V_ESQUEMA||'.DD_ERE_ESTADOS_RESERVA ERE ON RES.DD_ERE_ID = ERE.DD_ERE_ID
    JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID
    WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'' INTO V_ERE, V_EEC;
    
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: Expediente comercial del activo  5959764 y oferta 73188176 actualizado a '||V_ERE||' con la reserva '||V_EEC);

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

EXIT;