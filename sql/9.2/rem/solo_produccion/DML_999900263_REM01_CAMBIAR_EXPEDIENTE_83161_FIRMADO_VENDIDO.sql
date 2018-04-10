--/*
--##########################################
--## AUTOR=VICENTE MARTINEZ
--## FECHA_CREACION=20180306
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-212
--## PRODUCTO=NO
--##
--## Finalidad: Script que cambia la situacion del expediente comercial 83161
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
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_USUARIOMOD VARCHAR2(50 CHAR):= 'REMVIP-212';

    V_ERE VARCHAR2(50 CHAR);
    V_EEC VARCHAR2(50 CHAR);
    
    V_NUM_EXPEDIENTE NUMBER(16);
    
BEGIN 
  
  DBMS_OUTPUT.PUT_LINE('[INICIO]: Se va a actualizar el expediente comercial 83161 a Vendido');
  
  EXECUTE IMMEDIATE 'SELECT ECO.ECO_NUM_EXPEDIENTE FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
    WHERE ECO.ECO_NUM_EXPEDIENTE = 83161' INTO V_NUM_EXPEDIENTE;

  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL 
    SET DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''08''),
      USUARIOMODIFICAR = '''||V_USUARIOMOD||''', FECHAMODIFICAR = SYSDATE
    WHERE ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'';

  EXECUTE IMMEDIATE 'SELECT EEC.DD_EEC_DESCRIPCION
    FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL ECO
    JOIN '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL EEC ON ECO.DD_EEC_ID = EEC.DD_EEC_ID
    WHERE ECO.ECO_NUM_EXPEDIENTE = '||V_NUM_EXPEDIENTE||'' INTO V_EEC;
    
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('[FIN]: Expediente comercial 83161 actualizado a '||V_EEC);

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