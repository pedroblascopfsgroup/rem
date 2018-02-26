--/*
--##########################################
--## AUTOR=SIMEON SHOPOV 
--## FECHA_CREACION=20180222
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-117
--## PRODUCTO=NO
--##
--## Finalidad: Insertar el usuario gestor de formalización de la cartera Tango
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
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-134';

 BEGIN

  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.'||V_TABLA||' SET
	  					   DD_EEC_ID = (SELECT DD_EEC_ID FROM '||V_ESQUEMA||'.DD_EEC_EST_EXP_COMERCIAL WHERE DD_EEC_CODIGO = ''03'')
						 , USUARIOMODIFICAR = '''||V_USUARIO||'''
						 , FECHAMODIFICAR = SYSDATE
					 WHERE ECO_NUM_EXPEDIENTE = 82065
  					';
  					
            DBMS_OUTPUT.put_line('[INFO] Cambiado el estado del expediente 82065 a firmado');
            
  EXECUTE IMMEDIATE 'UPDATE '||V_ESQUEMA||'.ERE_ENTREGAS_RESERVA SET
						   BORRADO = 1
						 , USUARIOBORRAR = '''||V_USUARIO||'''
						 , FECHABORRAR = SYSDATE
					 WHERE RES_ID = (SELECT RES_ID FROM '||V_ESQUEMA||'.RES_RESERVAS
					 WHERE ECO_ID = (SELECT ECO_ID FROM '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL
					 WHERE ECO_NUM_EXPEDIENTE = 82065))
  					';
  					
            DBMS_OUTPUT.put_line('[INFO] Borrada la reserva del expediente asociado');
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

